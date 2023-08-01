import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/place_detail_response.dart';

class SaveButton extends StatefulWidget {
  final Result placeDetail;

  SaveButton({required this.placeDetail});

  @override
  _SaveButtonState createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    _checkIfSaved();      // Existing Firebase check
    _checkIfSavedInHive();  // New Hive check
  }

  Future<void> _saveToHive() async {
    final box = await Hive.openBox('placeDetails');
    final new_data = widget.placeDetail.toFirestoreMap();

    await box.put( widget.placeDetail.placeId!, new_data);
    // print(box.get(widget.placeDetail.placeId!).name);
  }
// This function will check if the placeDetail is saved in Hive
  Future<void> _checkIfSavedInHive() async {
    final box = await Hive.openBox('placeDetails');
    setState(() {
      isSaved = box.containsKey(widget.placeDetail.placeId!);
    });
    // print(box.get(widget.placeDetail.placeId!).name);
    // print(box.get('ChIJQXY5d3dZwokROz4N4S6oh0M') );
    // print(box.getAt[0]);
  }

  Future<void> _checkIfSaved() async {
    var collection = FirebaseFirestore.instance.collection('UserSavedPlace');
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String placeId = widget.placeDetail.placeId!;
    var doc = await collection.doc(userId).collection('places').doc(placeId).get();
    setState(() {
      isSaved = doc.exists;
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
