import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../components/slide_image.dart';
import '../getx/my_list_controller.dart';
import '../getx/place_information_controller.dart';
import '../models/place_detail_response.dart';

class placeInformationScreen extends StatefulWidget {
  final dynamic placeDetail;
  final dynamic placeDetailImages;
  final String placeId;
  // final int  listIndex;

  const placeInformationScreen({
    Key? key,
    required this.placeDetail,
    required this.placeDetailImages,
    required this.placeId,
    // required this.listIndex,
    // required this.imageIndex
  }) : super(key: key);

  @override
  State<placeInformationScreen> createState() => _placeInformationScreenState();
}

class _placeInformationScreenState extends State<placeInformationScreen> {
  // Map<String, dynamic>? _savedAIResponse;
  final MListController = Get.put(MyListController());
  final PListController = Get.put(PlaceListController());

  Future<void> getData(placeId) async {

    final AiBox = MListController.box4.value;
    // PListController.savedAIResponse = AiBox?.get(placeId) as Map<String, dynamic>?;
    var retrievedData = AiBox?.get(placeId);
    Map<String, dynamic> formattedData = {};
    retrievedData.forEach((key, value) {
      formattedData[key.toString()] = value;
    });
    PListController.savedAIResponse = formattedData;


    // final doc = await FirebaseFirestore.instance
    //     .collection('PlacesReviewSummary')
    //     .doc(placeId)
    //     .get();
    // Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    // setState(() {
    //   _savedAIResponse = {
    //     'Cuisines/Styles': data['Cuisines/Styles'] as String,
    //     'Restaurant Type': data['Restaurant Type'] as String,
    //     'Specialty Dishes': data['Specialty Dishes'] as String,
    //     'Strengths of the Restaurant':
    //         data['Strengths of the Restaurant'] as String,
    //     'Areas for Improvement': data['Areas for Improvement'] as String,
    //     'Overall Summary of the Restaurant':
    //         data['Overall Summary of the Restaurant'] as String,
    //   };
    // });
  }

  @override
  void initState() {
    super.initState();
    getData(widget.placeId);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
          body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            child: SizedBox(
                width: 450,
                height: 350,
                child: ImageSlider(
                  images: widget.placeDetailImages,
                  height: 450,
                  width: 350,
                  showDotIndicator: false,
                  showIndexIndicator: true,
                  placeDetail: widget.placeDetail,
                  placeDetailImages: widget.placeDetailImages,
                  placeId: widget.placeId,
                  // listIndex : 0,
                )),
          ),

          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 180, // specify the width
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle button press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black
                        .withOpacity(0.7), // Dark navy color// Text color
                  ),
                  child: const Text('Share',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              const SizedBox(width: 20), // Space between the buttons
              SizedBox(
                width: 180, // specify the width
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle button press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black
                        .withOpacity(0.7), // Dark navy color// Text color
                  ),
                  child: const Text('Open Google Maps',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),

          // SizedBox(height: 10),
          // Divider(),
          // SizedBox(height: 10),

          Padding(
              padding: const EdgeInsets.all(15.0),
              // padding: const EdgeInsets.only(top : 5 , bottom : 5 , left : 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  Row(
                    children: <Widget>[
                      // const SizedBox(width: 16),
                      Text(
                        widget.placeDetail['Name'] ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      // Rating
                      if (widget.placeDetail['rating'] != null &&
                          widget.placeDetail['rating'] != '')
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.yellow, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              widget.placeDetail['rating'].toString() ?? '',
                              style:
                                  const TextStyle(color: Colors.black, fontSize: 13),
                            ),
                          ],
                        ),
                      const SizedBox(width: 4),

                      // Price Level
                      if (widget.placeDetail['priceLevel'] != null &&
                          widget.placeDetail['priceLevel'] != '')
                        Text(
                          '\$' *
                              int.parse(
                                  widget.placeDetail['priceLevel'].toString()),
                          style:
                              TextStyle(color: Colors.grey[40], fontSize: 13),
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.placeDetail['formatted_address'] ?? '',
                    style: const TextStyle(fontSize: 14),
                  ),

                  const SizedBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            PListController.savedAIResponse?['Cuisines/Styles'] ?? '',
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(width: 5.0),
                          Text(
                            PListController.savedAIResponse?['Restaurant Type'] ?? '',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black.withOpacity(0.7)),
                          ),
                        ]),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: Text(
                      widget.placeDetail['editorialSummary'] ?? '',
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Divider(),
                  const SizedBox(height: 15),

                  // Text(
                  //   widget.placeDetail['editorialSummary'] ?? '',
                  //   style: TextStyle(color: Colors.black, fontSize: 13),
                  // ),
                  const Text(
                    "AI Reivew Summary",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'lib/images/Chef_Hat_Icon.png',
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(width: 3),
                              const Text(
                                "Specialty Dishes",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                              PListController.savedAIResponse?['Specialty Dishes'] ?? '',
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Image.asset(
                                'lib/images/Star_icon2.png',
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(width: 3),
                              const Text(
                                "Strengths of the Restaurant",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                              PListController.savedAIResponse?[
                                      'Strengths of the Restaurant'] ??
                                  '',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Image.asset(
                                'lib/images/Sad_face_solid_icon.png',
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(width: 3),
                              const Text(
                                "Areas for Improvement",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                              PListController.savedAIResponse?['Areas for Improvement'] ?? '',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Image.asset(
                                'lib/images/reader_icon.png',
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(width: 3),
                              const Text(
                                "Summary",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                              PListController.savedAIResponse?[
                                      'Overall Summary of the Restaurant'] ??
                                  '',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ]),
                  ),

                  const SizedBox(height: 20),
                ],
              )),
        ]),
      )),
      // Positioned(
      //   top: 40,  // Adjust these values as needed
      //   left: 15,
      //   child: CircleAvatar(
      //     backgroundColor: Colors.white,
      //     radius: 21,
      //     child: InkWell(
      //       onTap: () {
      //         Navigator.pop(context);
      //       },
      //       child: Center(
      //         child: Icon(Icons.arrow_back, size: 21, color: Colors.black),  // Adjust the size and color as needed
      //       ),
      //     ),
      //   ),
      // )
      Positioned(
        top: 40, // Adjust these values as needed
        left: 15,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 21,
          child: Material(
            type: MaterialType.transparency, // This makes the Material visually transparent
            child: InkWell(
              onTap: () {
                // Navigator.pop(context);
                Get.back();
              },
              child: const Center(
                child: Icon(Icons.arrow_back,
                    size: 21,
                    color: Colors.black), // Adjust the size and color as needed
              ),
            ),
          ),
        ),
      )
    ]);
  }
}
