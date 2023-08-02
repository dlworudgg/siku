import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../models/place_detail_response.dart';

class SaveButton extends StatefulWidget {
  final Result placeDetail;

  SaveButton({required this.placeDetail});

  @override
  _SaveButtonState createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  bool isSaved = false;
  bool isSavedInHive = false;
  bool isSavedInFirestore = false;

  @override
  void initState() {
    super.initState();
    _checkIfSaved();      // Existing Firebase check
    _checkIfSavedInHive();  // New Hive check

    if (!isSavedInHive && isSavedInFirestore) {
      _saveToHive();
    } else if (!isSavedInFirestore && isSavedInHive) {
      // Your Firestore saving logic here
      var collection = FirebaseFirestore.instance.collection('UserSavedPlace');
      String userId = FirebaseAuth.instance.currentUser!.uid;
      String placeId = widget.placeDetail.placeId!;
      collection.doc(userId).collection('places').doc(placeId).set(widget.placeDetail.toFirestoreMap());
    }
  }

  final String googleMapBrowserKey = dotenv.get('GOOGLE_MAP_BROWSER_API_KEY');

  Future<void> _saveToHive() async {
    final box = await Hive.openBox('placeDetails');
    final image_box = await Hive.openBox('placeDetails_images');
    final order_box = await Hive.openBox('placeDetails_key_order');

    final new_data = widget.placeDetail.toFirestoreMap();

    List<Uint8List> photoReferences = [];
    if (new_data['photos'] != null) {
      for (var photo in new_data['photos']) {
        if (photo["photo_reference"] != null) {
          // photoReferences.add(photo["photo_reference"]);
          final response = await http.get(Uri.parse( 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${photo["photo_reference"]}&key=$googleMapBrowserKey',));
          photoReferences.add(response.bodyBytes);
        }
      }
    }

    await box.put( widget.placeDetail.placeId!, new_data);
    await image_box.put( widget.placeDetail.placeId!, photoReferences);
    await order_box.add( widget.placeDetail.placeId!);
  }

// This function will check if the placeDetail is saved in Hive
  Future<void> _checkIfSavedInHive() async {
    final box = await Hive.openBox('placeDetails');
    setState(() {
      isSaved = box.containsKey(widget.placeDetail.placeId!);
      isSavedInHive = box.containsKey(widget.placeDetail.placeId!);
    });

  }

  Future<void> _checkIfSaved() async {
    var collection = FirebaseFirestore.instance.collection('UserSavedPlace');
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String placeId = widget.placeDetail.placeId!;
    var doc = await collection.doc(userId).collection('places').doc(placeId).get();
    setState(() {
      isSaved = doc.exists;
      isSavedInFirestore = doc.exists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (isSaved) return Colors.blue;
            return Colors.white; // Use the component's default.
          },
        ),
      ),
      onPressed: () async {
        if (!isSaved) {
          var collection = FirebaseFirestore.instance.collection('UserSavedPlace');
          String userId = FirebaseAuth.instance.currentUser!.uid;
          String placeId = widget.placeDetail.placeId!;
          await collection.doc(userId).collection('places').doc(placeId).set(widget.placeDetail.toFirestoreMap());
          await _saveToHive();  // New Hive save

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Place was saved!')),
          );
          setState(() {
            isSaved = true;
          });
        }
      },
      child: Row(
        children: [
          if (isSaved) Icon(Icons.check), // Show check icon if the place is saved
          Text(
            isSaved ? 'Saved' : 'Save',
            style: TextStyle(
              color: isSaved ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
