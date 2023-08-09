
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:siku/theme.dart';
import '../getx/map_controller.dart';
import '../pages/my_list_page.dart';
import 'dart:ui';

class MapScreen extends StatelessWidget {

  final mapController = Get.find<MapController>();
  // Initialize the GetX Controller

  MapScreen({Key? key,})
      : super(key: key);


  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void showSignOutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('User Name'),
            // Replace 'User Name' with the actual user name
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Divider(color: Colors.grey),
                Row(
                  children: [
                    const Icon(Icons.logout, color: Colors.black),
                    // This is the prefix icon
                    const SizedBox(width: 10),
                    // Add some space between the icon and the button
                    TextButton(
                      child: const Text('Sign Out'),
                      onPressed: () {
                        signUserOut();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Stack(
          children: [Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: GoogleMap(
              initialCameraPosition: MapController.initialCameraPosition,
              markers: mapController.markers.toSet(),
              myLocationButtonEnabled: false,
              onMapCreated: (controller) {
                mapController.googleMapController = controller;
              },
            ),
          ),
            DraggableScrollableSheet(
              controller: mapController.dragController,
              initialChildSize: 0.15,
              minChildSize: 0.15,
              maxChildSize: 0.87,
              builder: (BuildContext context, ScrollController scrollController) {
                return Column(
                  children: [
                    // Row containing the circle button and the transparent slide menu
                    Row(
                      children: [
                        // Circle Button
                        Padding(
                          padding: const EdgeInsets.only(left : 10.0),
                          child: InkWell(
                            onTap: mapController.resetCameraPosition,
                            child: Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(Icons.center_focus_strong, color: Colors.black),
                              ),
                            ),
                          ),
                        ),

                        // Spacer for some space between button and menu
                        const SizedBox(width: 10),

                        // Transparent Slide Menu at the top
                        Expanded(
                          child: Container(
                            height: 50,
                            color: Colors.transparent,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 8,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 5.0, right: 3.0, top: 8, bottom: 8),
                                  child: Container(
                                    width: mapController.widthList[index],
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.grey, width: 1),
                                    ),
                                    child: Row(
                                      children: [
                                        // Circle with vibrant primary colors
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: mapController.primaryColors[index],
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Center(child: Text(mapController.cuisines[index], style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Blurred section starts here
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: GestureDetector(
                            onTap:  mapController.toggleSheet,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Drag Handle with GestureDetector
                                    // onDoubleTap:  mapController.toggleSheet,
                                    // onVerticalDragUpdate: (details) {
                                    //   mapController.toggleSheet();
                                    // },
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        // Drag Handle
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8, bottom: 4),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(width: 160, height: 5, color: Colors.transparent),
                                              Container(
                                                width: 40,
                                                height: 5,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                              Container(width: 160, height: 5, color: Colors.transparent),
                                            ],
                                          ),
                                        ),
                                        // Share List Text
                                        Padding(
                                          padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: GestureDetector(
                                                    onTap: mapController.toggleSheet,
                                                    child: const Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Text(" Share List",
                                                                style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold))
                                                    )
                                                ),
                                              ),
                                              // Container(width: 110, height: 36.5, color: Colors.transparent),
                                              // Icons on the right
                                              Padding(
                                                padding: const EdgeInsets.only(right : 30),
                                                child: Row(
                                                  children: [
                                                    // List with a plus
                                                    GestureDetector(
                                                      onTap: () {
                                                        // Your function here
                                                      },
                                                      child: const Icon(Icons.add, color: Colors.white),

                                                    ),
                                                    SizedBox(width: 15), // Spacer

                                                    // Person icon
                                                    GestureDetector(
                                                      onTap: () {
                                                        showSignOutDialog(context);
                                                        // Your function here
                                                      },
                                                      child: const Icon(Icons.person, color: Colors.white),
                                                    ),
                                                    const SizedBox(width: 15), // Spacer

                                                    // Settings icon
                                                    GestureDetector(
                                                      onTap: () {
                                                        // Your function here
                                                      },
                                                      child: const Icon(Icons.settings, color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                      ],
                                    ),

                                  // List Content
                                  // Container(width: 70, height: 36.5, color: Colors.white),
                                  Expanded(
                                    child: ListView.builder(
                                      controller: scrollController,
                                      itemCount:  mapController.items.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage: AssetImage( mapController.items[index].image),
                                          ),
                                          title: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,  // Aligns the content to the start
                                            children: [
                                              Text( mapController.items[index].name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),

                                              // User Icon and userNumber layout
                                              Row(
                                                children: [
                                                  Icon(Icons.person, color: Colors.grey[100], size: 15),  // User Icon
                                                  const SizedBox(width: 5),  // Some space between the icon and text
                                                  Text( mapController.items[index].userNumber, style: const TextStyle(fontSize: 15, color: Colors.white)),  // User number
                                                ],
                                              )
                                            ],
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) => MyListPage(
                                                    id:  mapController.items[index].id,
                                                    isSavedList:  mapController.items[index].isSavedList,
                                                    name:  mapController.items[index].name
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),

                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),

            Positioned(
              top: 60.0,
              left: 16.0,
              // right: 16.0,
              right: 50.0,
                child: GestureDetector(
                  onTap: mapController.onSearchTap,
                  child: AbsorbPointer(
                    // child: Container(
                    //   color: Colors.red,
                    //   width: mapController.deviceWidth.value,
                    //   height: mapController.deviceHeight.value , // 8% of device height
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Search Restaurants Here',
                          fillColor: AppColors.cardLight,
                          filled: true,
                          prefixIcon: Icon(
                              mapController.isMarkerOnMap.value ? Icons.arrow_back_ios : Icons.search,
                              color: mapController.isMarkerOnMap.value ? Colors.blue : Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 60.0,
              left: 370.0,
              right: 16.0,
              child: GestureDetector(
                onTap: mapController.resetMarkerOnMap,
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      fillColor: AppColors.cardLight,
                      filled: true,
                      prefixIcon: Icon(mapController.isMarkerOnMap.value ? Icons.close : Icons.search,
                          color: mapController.isMarkerOnMap.value ? Colors.grey : Colors.transparent),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        // borderSide: BorderSide(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // textInputAction: TextInputAction.search,
                  ),
                ),
              ),
            ),
          ]);
      }),
    );
  }
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


// onPressed: mapController.toggleSheet,