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

  Future<void> onInit() async {
    super.onInit();
    print("starting Oninit");
    final box1 = await Hive.openBox('placeDetails');
    final box2 = await Hive.openBox('placeDetails_images');
    final box3 = await Hive.openBox('placeDetails_key_order');
    final box4 = await Hive.openBox('placeDetails_AISummary');

    if (box1.isEmpty) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('UserSavedPlace')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('places')
          .get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        String placeID = doc.id;
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

        savedAIResponse = {
          'Cuisines/Styles': suumayData['Cuisines/Styles'] as String,
          'Restaurant Type': suumayData['Restaurant Type'] as String,
          'Specialty Dishes': suumayData['Specialty Dishes'] as String,
          'Strengths of the Restaurant':
          suumayData['Strengths of the Restaurant'] as String,
          'Areas for Improvement': suumayData['Areas for Improvement'] as String,
          'Overall Summary of the Restaurant':
          suumayData['Overall Summary of the Restaurant'] as String,
        };



        await box1.put( placeID, data);
        await box2.put( placeID, photoReferences);
        await box3.add( placeID);
        await box4.put( placeID,  savedAIResponse);
      }
    }

    Get.to(MapScreen());
  }
}

