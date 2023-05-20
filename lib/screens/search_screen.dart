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
import '../models/place_auto_complete_response.dart';
import '../models/place_detail_response.dart';
import '../theme.dart';
import 'home_screen.dart';
import 'map_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<AutocompletePrediction> placePredictions = [];
  List<PlaceDetailResponse> placeDetails = [];

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
      PlaceDetailResponse placeDetailResponse = PlaceDetailResponse.fromJson(jsonDecode(response));
      return placeDetailResponse.result; // return the result
    }
    throw Exception("Failed to fetch place details"); // throw an exception if the request fails
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
                  child: const Icon(Icons.arrow_back_ios, color : Colors.blue),
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
                  AutocompletePrediction selected_prediction = placePredictions[index];
                  String? placeId = selected_prediction.placeId;
                  if (placeId != null) {
                    Result selected_detail = await placeDetailResponse(placeId);

                  // print(selected_detail.geometry.location.lat);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapScreen(
                            lat: selected_detail.geometry.location.lat,
                            lng: selected_detail.geometry.location.lng,
                            place_detail: selected_detail,
                        ),
                      ),
                    );
                  }
                },
                // location: placePredictions[index].description!,
                location: placePredictions[index].structuredFormatting?.secondaryText ?? "",
                mainText : placePredictions[index].structuredFormatting?.mainText ?? "",

              ),
            ),
          ),
        ],
      ),
    );
  }
}
