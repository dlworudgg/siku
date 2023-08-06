import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:siku/screens/search_screen.dart';
import 'package:siku/theme.dart';
import '../components/saved_button.dart';
import '../getx/map_controller.dart';
import '../models/open_ai_response.dart';
import '../pages/my_list_page.dart';
import '../pages/share_room_page.dart';
import '../widgets/avatar.dart';
import 'dart:ui';
import '../models/place_detail_response.dart';

class MapScreen extends StatelessWidget {
  final double? lat;
  final double? lng;
  final Result? placeDetail;

  final mapController = Get.put(MapController((context) => showPlaceDetail(context)));
  // Initialize the GetX Controller

  MapScreen({Key? key, this.lat, this.lng, this.placeDetail})
      : super(key: key);





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return GoogleMap(
          initialCameraPosition: MapController.initialCameraPosition,
          markers: mapController.markers.toSet(),
          onMapCreated: (controller) {
            mapController.googleMapController = controller;
          },
        );
      }),
    );
  }
}




void showPlaceDetail(BuildContext context) {

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    // This allows you to control the size of the bottom sheet
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25),
      ),
    ),
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.7,
        // This allows the bottom sheet to take up 60% of the screen
        child: DefaultTabController(
          length: 2, // number of tabs
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const TabBar(
                  indicatorColor: Colors.black,
                  tabs: [
                    Tab(text: 'Info'), // name the tabs as you wish
                    Tab(text: 'Summary'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildInfoTab(),
                      _buildSummaryTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}


Widget _buildInfoTab() {
  final mapController = Get.find<MapController>();
  return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            // wrap your Column in a SingleChildScrollView
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                Row(
                  children: <Widget>[
                    // const SizedBox(width: 16),
                    Text(
                      mapController.placeDetail.value?.name ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    // Rating
                    if (mapController.placeDetail.value?.rating != null &&
                        mapController.placeDetail.value?.rating != '')
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.yellow, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            mapController.placeDetail.value?.rating.toString() ?? '',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 13),
                          ),
                        ],
                      ),
                    const SizedBox(width: 4),

                    // Price Level
                    if (mapController.placeDetail.value?.priceLevel != null &&
                        mapController.placeDetail.value?.priceLevel != '')
                      Text(
                        '\$' *
                            int.parse(mapController.placeDetail.value!.priceLevel.toString()),
                        style: TextStyle(color: Colors.grey[40], fontSize: 13),
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  mapController.placeDetail.value?.formattedAddress ?? '',
                  style: const TextStyle(fontSize: 14),
                ),

                const SizedBox(height: 8),

                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                      ]),
                ),
                // const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.only(left: 18),
                  child: Text(
                    mapController.placeDetail.value?.editorialSummary?.overview ?? '',
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 15),
                const Divider(),
              ],
            ),
          ),
        ),
        // if (widget.placeDetail != null)
        //   SaveButton(placeDetail: widget.placeDetail!),
      ]));
}


Widget _buildSummaryTab() {
  final mapController = Get.find<MapController>();

  if (mapController.savedAIResponse != null) {
    return buildResponseWidgets(mapController.savedAIResponse!);
  }
  return const Center(
    child: SizedBox(
      width: 50,
      height: 50,
      child: Stack(
        alignment: Alignment.center, // This centers the content inside the stack
        children: [
          CircularProgressIndicator(),
          Text('AI is Summarizing...'), // Your desired text
        ],
      ),
    ),
  );
}


Widget buildResponseWidgets(Map<String, dynamic> _savedAIResponse) {
  final mapController = Get.find<MapController>();

  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 25),
        Row(
          children: <Widget>[
            // const SizedBox(width: 16),
            Text(
              mapController.placeDetail.value?.name ?? '',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            // Rating
            if (mapController.placeDetail.value?.rating != null &&
                mapController.placeDetail.value?.rating != '')
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.yellow, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    mapController.placeDetail.value?.rating.toString() ?? '',
                    style: const TextStyle(color: Colors.black, fontSize: 13),
                  ),
                ],
              ),
            const SizedBox(width: 4),

            // Price Level
            if (mapController.placeDetail.value?.priceLevel != null &&
                mapController.placeDetail.value?.priceLevel != '')
              Text(
                '\$' * int.parse(mapController.placeDetail.value!.priceLevel.toString()),
                style: TextStyle(color: Colors.grey[40], fontSize: 13),
              ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          mapController.placeDetail.value?.formattedAddress ?? '',
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
                  _savedAIResponse['Cuisines/Styles'] ?? '',
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.normal),
                ),
                const SizedBox(width: 5.0),
                Text(
                  _savedAIResponse['Restaurant Type'] ?? '',
                  style: TextStyle(
                      fontSize: 14, color: Colors.black.withOpacity(0.7)),
                ),
              ]),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Text(
            mapController.placeDetail.value?.editorialSummary?.overview ?? '',
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
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                _savedAIResponse['Specialty Dishes'] ?? '',
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
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                _savedAIResponse['Strengths of the Restaurant'] ?? '',
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
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                _savedAIResponse['Areas for Improvement'] ?? '',
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
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                _savedAIResponse['Overall Summary of the Restaurant'] ?? '',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ]),
        ),

        const SizedBox(height: 20),
      ],
    ),
  );
}


