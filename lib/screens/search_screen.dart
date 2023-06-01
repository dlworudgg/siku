// import 'package:flutter/material.dart';
// import 'package:siku/services/network_utility.dart';
//
// import '../components/location_list_tile.dart';
// import '../models/autocomplete_prediction.dart';
// import '../models/place_auto_complete_response.dart';
// import '../theme.dart';
// import 'home_screen.dart';
//
// class SearchScreen extends StatefulWidget {
//   const SearchScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//
//   List<AutocompletePrediction> placePredictions = [];
//   Future<void> placeAutoComplete(String query) async {
//     Uri uri = Uri.https(
//        "maps.googleapis.com",
//         'maps/api/place/autocomplete/json',
//       {
//         "input" : query,
//         "key" : 'AIzaSyDIvQJfzX_91txHLSxwuPyzm-avQvGCYPo',
//       }
//     );
//     String? response = await NetworkUtility.fetchUrl(uri);
//     if (response!= null){
//       PlaceAutocompleteResponse result =
//           PlaceAutocompleteResponse.parseAutocompleteResult(response);
//       if (result.predictions != null){
//         setState(() {
//           placePredictions = result.predictions!;
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Stack(children: [
//       Positioned(
//         top: 60.0,
//         left: 16.0,
//         right: 16.0,
//         child: TextFormField(
//
//           decoration: InputDecoration(
//             hintText: 'Search here',
//             fillColor: AppColors.cardLight,
//             filled: true,
//             prefixIcon: InkWell(
//               onTap: () {
//                 Navigator.pop(context);
//                 // Navigator.push(
//                   // context,
//                   // MaterialPageRoute(builder: (context) => HomeScreen()),
//                 // );
//               },
//               child: const Icon(Icons.arrow_back_ios),
//             ),
//
//             border: OutlineInputBorder(
//               borderSide: BorderSide.none,
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//           // textInputAction: TextInputAction.search,
//         ),
//       ),
//       Positioned(
//         top: 60.0,
//         left: 16.0,
//         right: 16.0,
//         child: Column(
//           Expanded(
//             child: ListView.builder (
//               itemCount: placePredictions.length,
//               itemBuilder: (context, index) =>
//                 LocationListTile(
//                   press () {print("1")},
//                   location : placePredictions[index].description!,
//                 ),
//             ),
//           )
//
//           // const Divider(
//           //   height:4,
//           //   thickness: 4,
//           //   color : Colors.grey[300].
//           // ),
//         ),
//       ),
//     ]
//         )
//     );
//   }
// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:siku/services/network_utility.dart';

import '../components/location_list_tile.dart';
import '../constants.dart';
import '../models/autocomplete_prediction.dart';
import '../models/open_ai_response.dart';
import '../models/place_auto_complete_response.dart';
import '../models/place_detail_response.dart';
import '../theme.dart';
import 'home_screen.dart';
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

  //
  // Future<void> placeDetailResponse(String placeId) async {
  //   Uri uri = Uri.https(
  //     "maps.googleapis.com",
  //     'maps/api/place/details/json',
  //     {
  //       "input": placeId,
  //       "key": 'AIzaSyDIvQJfzX_91txHLSxwuPyzm-avQvGCYPo',
  //     },
  //   );
  //   String? response = await NetworkUtility.fetchUrl(uri);
  //   if (response != null) {
  //     PlaceDetailResponse placeDetailResponse = PlaceDetailResponse.fromJson(jsonDecode(response));
  //     if (placeDetailResponse.result != null) {
  //       setState(() {
  //         placeDetails = placeDetailResponse.result as List<PlaceDetailResponse>;
  //       });
  //     }
  //   }
  // }
  Future<Result> placeDetailResponse(String placeId) async {
    Uri uri = Uri.https(
      "maps.googleapis.com",
      'maps/api/place/details/json',
      {
        "placeid": placeId, // placeid instead of input
        "key": googleMapKey,
      },
    );
    String? response = await NetworkUtility.fetchUrl(uri);
    if (response != null) {
      PlaceDetailResponse placeDetailResponse =
          PlaceDetailResponse.fromJson(jsonDecode(response));
      return placeDetailResponse.result; // return the result
    }
    throw Exception(
        "Failed to fetch place details"); // throw an exception if the request fails
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
              onChanged: (value) {
                placeAutoComplete(value);
              },
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
                    AutocompletePrediction selectedPrediction =
                    placePredictions[index];
                    String? placeId = selectedPrediction.placeId;
                    if (placeId != null) {
                      DocumentSnapshot snapshot = await firestore.collection('PlacesInformation').doc(placeId).get();
                      if (snapshot.exists) {
                        // Document exists in Firestore. Use the saved data.
                        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
                        selectedDetail = Result.fromMap(data); // Don't use await here, it's not a Future
                        // additionalDetail = await placeDetailResponse(placeId);
                        additionalDetail = await placeDetailResponse(placeId);
                        print(additionalDetail.photosList?.photos?[0].width);
                        print(additionalDetail.reviewList?.review?[0].rating);
                        for (var review in additionalDetail.reviewList!.review!) {
                          print(review);
                        }
                        Map<String, dynamic> additionalDetailMap = additionalDetail.toMap();


                      } else {
                        // Document does not exist in Firestore. Fetch data from API and save it in Firestore
                        selectedDetail = await placeDetailResponse(placeId);
                        // ChatCompletionResponse GPTResponse = await processPlaceDetailAI(selectedDetail);
                        // Save the data in Firestore for future use

                        await firestore.collection('PlacesInformation')
                            .doc(placeId)
                            .set(selectedDetail.toMap());
                      }
                      // This is assuming processPlaceDetailAI only needs selectedDetail, you might need to adjust it as per your needs
                      // ChatCompletionResponse GPTResponse = await processPlaceDetailAI(selectedDetail);
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


