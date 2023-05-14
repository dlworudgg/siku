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
import 'package:flutter/material.dart';
import 'package:siku/services/network_utility.dart';

import '../components/location_list_tile.dart';
import '../models/autocomplete_prediction.dart';
import '../models/place_auto_complete_response.dart';
import '../theme.dart';
import 'home_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<AutocompletePrediction> placePredictions = [];
  Future<void> placeAutoComplete(String query) async {
    Uri uri = Uri.https(
      "maps.googleapis.com",
      'maps/api/place/autocomplete/json',
      {
        "input": query,
        "key": 'AIzaSyDIvQJfzX_91txHLSxwuPyzm-avQvGCYPo',
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
                hintText: 'Search here',
                fillColor: AppColors.cardLight,
                filled: true,
                prefixIcon: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back_ios),
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
                press: () {
                  print("1");
                },
                location: placePredictions[index].description!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
