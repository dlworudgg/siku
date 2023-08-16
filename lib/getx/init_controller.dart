import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../screens/map_screen.dart';


class initController extends GetxController {
  final String googleMapBrowserKey = dotenv.get('GOOGLE_MAP_BROWSER_API_KEY');



  String convertToString(dynamic value) {
    if (value == null) {
      return "Not Available";
    }

    if (value is double && value.isNaN) {
      return "Not Available";
    }

    return value.toString();
  }
  Future<void> onInit() async {
    super.onInit();
    // print("starting Oninit");
    final box1 = await Hive.openBox('placeDetails');
    final box2 = await Hive.openBox('placeDetails_images');
    final box3 = await Hive.openBox('placeDetails_key_order');
    final box4 = await Hive.openBox('placeDetails_AISummary');

    // final boxExist = await Hive.boxExists('placeDetails');
    List placeIDList;

    // print(box1.get("ChIJs8MdNo9ZwokRTPUHiArLC-o")['cuisines/styles']);
    if (box1.isEmpty ||box2.isEmpty  || box3.isEmpty ||box4.isEmpty  ) {
      await box1.clear();
      await box2.clear();
      await box3.clear();
      await box4.clear();

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('UserSavedPlace')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('places')
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        String placeID = doc.id;
        final placeDoc = await FirebaseFirestore.instance
            .collection('PlacesInformation')
            .doc(placeID)
            .get();

        Map<String, dynamic> placeData = placeDoc.data() as Map<String, dynamic>;

        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<Uint8List> photoReferences = [];
        if (data['photos'] != null) {
          for (var photo in data['photos']) {
            if (photo["photo_reference"] != null) {
              // photoReferences.add(photo["photo_reference"]);
              final response = await http.get(Uri.parse( 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${photo["photo_reference"]}&key=$googleMapBrowserKey',));
              photoReferences.add(response.bodyBytes);
            }
          }
        }
        final summaryDoc = await FirebaseFirestore.instance
            .collection('PlacesReviewSummary')
            .doc(placeID)
            .get();
        Map<String, dynamic>? savedAIResponse;
        Map<String, dynamic> suumayData = summaryDoc.data() as Map<String, dynamic>;

        String cuisinesStyles = convertToString(suumayData['Cuisines/Styles']);
        String restaurantType = convertToString(suumayData['Restaurant Type']);
        String specialtyDishes = convertToString(suumayData['Specialty Dishes']);
        String strengthsOfTheRestaurant = convertToString(suumayData['Strengths of the Restaurant']);
        String areasForImprovement = convertToString(suumayData['Areas for Improvement']);
        String overallSummaryOfTheRestaurant = convertToString(suumayData['Overall Summary of the Restaurant']);

        savedAIResponse = {
          'Cuisines/Styles': cuisinesStyles,
          'Restaurant Type': restaurantType,
          'Specialty Dishes': specialtyDishes,
          'Strengths of the Restaurant':strengthsOfTheRestaurant,
          'Areas for Improvement': areasForImprovement,
          'Overall Summary of the Restaurant': overallSummaryOfTheRestaurant,
        };


        // await box1.put( placeID, data);


        await box1.put( placeID, placeData);
        await box2.put( placeID, photoReferences);
        await box3.add( placeID);
        await box4.put( placeID,  savedAIResponse);
      }
    }

    Get.to(() => MapScreen());
  }
}

