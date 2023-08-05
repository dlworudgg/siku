
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:siku/services/network_utility.dart';

import '../components/location_list_tile.dart';
import '../models/autocomplete_prediction.dart';
import '../models/place_auto_complete_response.dart';
import '../models/place_detail_response.dart';
import '../theme.dart';
import 'map_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}


class _SearchScreenState extends State<SearchScreen> {
  List<AutocompletePrediction> placePredictions = [];
  List<PlaceDetailResponse> placeDetails = [];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String googleMapKey = dotenv.get('GOOGLE_MAP_BROWSER_API_KEY');
  Timer? _debounce;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }


  @override
  void dispose() {
    _focusNode.dispose(); // Important to prevent memory leaks
    super.dispose();
  }

  Future<void> placeAutoComplete(String query) async {
    Uri uri = Uri.https(
      "maps.googleapis.com",
      'maps/api/place/autocomplete/json',
      {
        "input": query,
        "key": googleMapKey,
      },
    );
    String? response = await NetworkUtility.fetchUrl(uri);
    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        setState(() {
          placePredictions = result.predictions!;
        });
      }
    }
  }

  void onSearchTextChanged(String searchText) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      placeAutoComplete(searchText);
    });
  }



  Future<Result> placeDetailResponse(String placeId, {bool sortByNewest = false}) async {
    Map<String, String> parameters = {
      "placeid": placeId,
      "key": googleMapKey,
    };

    if (sortByNewest) {
      parameters['reviews_sort'] = 'newest';
    }

    Uri uri = Uri.https(
      "maps.googleapis.com",
      'maps/api/place/details/json',
      parameters,
    );

    String? response = await NetworkUtility.fetchUrl(uri);
    if (response != null) {
      PlaceDetailResponse placeDetailResponse =
      PlaceDetailResponse.fromJson(jsonDecode(response));
      return placeDetailResponse.result;
    }
    throw Exception("Failed to fetch place details");
  }


  List<Reviews> mergeReviews(List<Reviews>? a, List<Reviews>? b) {
    if (a == null) return b ?? [];
    if (b == null) return a;

    var mergedReviews = List<Reviews>.from(a);  // Make a copy of a

    var aUrls = a.map((review) => review.authorUrl).toSet();
    for (var review in b) {
      if (!aUrls.contains(review.authorUrl)) {
        mergedReviews.add(review);
      }
    }

    return mergedReviews;
  }

  bool areReviewsDifferent(List<Reviews>? a, List<Reviews>? b) {
    if (a == null && b == null) return false;
    if (a == null || b == null) return true;

    var aUrls = a.map((review) => review.authorUrl).toSet();
    for (var review in b) {
      if (!aUrls.contains(review.authorUrl)) {
        return true;
      }
    }

    return false;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 60.0,
            left: 16.0,
            right: 16.0,
       child: TextFormField(
         focusNode: _focusNode,
          onChanged: onSearchTextChanged,
              decoration: InputDecoration(
                hintText: 'Search Restaurants Here',
                fillColor: AppColors.cardLight,
                filled: true,
                prefixIcon: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back_ios, color: Colors.blue),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Positioned(
            top: 100.0,
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: ListView.builder(
              itemCount: placePredictions.length,
              itemBuilder: (context, index) => LocationListTile(
                  press: () async {
                    Result selectedDetail; // Declare here
                    Result additionalDetail; // Declare here
                    Result selectedDetailCombined;
                    AutocompletePrediction selectedPrediction =
                    placePredictions[index];
                    String? placeId = selectedPrediction.placeId;
                    if (placeId != null) {
                      DocumentSnapshot snapshot = await firestore.collection('PlacesInformation').doc(placeId).get();
                      if (snapshot.exists) {
                        // Document exists in Firestore. Use the saved data.
                        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
                        selectedDetail = Result.fromFirestoreMap(data); // Don't use await here, it's not a Future
                        // additionalDetail = await placeDetailResponse(placeId);
                        additionalDetail = await placeDetailResponse(placeId, sortByNewest: true);
                        if (areReviewsDifferent(selectedDetail.reviews, additionalDetail.reviews)) {
                          selectedDetail = selectedDetail.withReviews(mergeReviews(selectedDetail.reviews, additionalDetail.reviews));
                          await firestore.collection('PlacesInformation').doc(placeId).update({'reviews': selectedDetail.reviews?.map((review) => review.toMap()).toList()});
                        }
                      } else {
                        selectedDetail = await placeDetailResponse(placeId);
                        Result selectedNewestDetail = await placeDetailResponse(placeId, sortByNewest: true);
                        selectedDetailCombined = selectedDetail.withReviews(mergeReviews(selectedDetail.reviews, selectedNewestDetail.reviews));

                        await firestore.collection('PlacesInformation')
                            .doc(placeId)
                            .set(selectedDetailCombined.toFirestoreMap());
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapScreen(
                            lat: selectedDetail.geometry?.location?.lat,
                            lng: selectedDetail.geometry?.location?.lng,
                            placeDetail: selectedDetail,
                            // summary: GPTResponse,
                          ),
                        ),
                      );
                    }
                  },
                  location: placePredictions[index]
                      .structuredFormatting
                      ?.secondaryText ??
                      "",
                  mainText:
                  placePredictions[index].structuredFormatting?.mainText ??
                      "",
                ),
            ),
          ),
        ],
      ),
    );
  }
}


