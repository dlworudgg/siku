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

  MapScreen({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Stack(children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: GoogleMap(
              initialCameraPosition: mapController.initialCameraPosition,
              markers: mapController.markers.toSet(),
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              onMapCreated: (controller) {
                mapController.googleMapController = controller;
              },
            ),
          ),



          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.15,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                // borderRadius: BorderRadius.circular(35),
              ),
              child :Column(
                children: [ Row(
                  children: [
                    // Circle Button
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
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
                            child: Icon(Icons.center_focus_strong,
                                color: Colors.black),
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
                  itemCount: mapController.widthList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 3.0, top: 8, bottom: 8),
                      child: GestureDetector(
                        onTap: () {
                          mapController.toggleSelection(index);
                        },
                        child: Obx(() { // Rebuilds this widget when selectedIndexes changes
                          return Container(
                            width: mapController.widthList[index],
                            height: 10,
                            decoration: BoxDecoration(
                              color: mapController.selectedIndexes.contains(index)
                                  ? Colors.lightBlue[100]
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey, width: 1),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: mapController.primaryColors[index],
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.black.withOpacity(0.3),
                                        width: 0.6,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Center(
                                  child: Text(
                                    mapController.cuisines[index],
                                    style: TextStyle(
                                        color: mapController.selectedIndexes.contains(index)
                                            ? Colors.blue[900]
                                            : Colors.black,
                                        fontWeight: FontWeight.bold
                                    ),
                                  )
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    );
                  },
                ),
              ),
            ),

                    // Expanded(
                    //   child: Container(
                    //     height: 50,
                    //     color: Colors.transparent,
                    //     child: ListView.builder(
                    //       scrollDirection: Axis.horizontal,
                    //       itemCount: 8,
                    //       itemBuilder: (BuildContext context, int index) {
                    //         return Padding(
                    //           padding: const EdgeInsets.only(
                    //               left: 5.0, right: 3.0, top: 8, bottom: 8),
                    //           child: Container(
                    //             width: mapController.widthList[index],
                    //             height: 10,
                    //             decoration: BoxDecoration(
                    //               color: Colors.grey[100],
                    //               borderRadius: BorderRadius.circular(15),
                    //               border: Border.all(
                    //                   color: Colors.grey, width: 1),
                    //             ),
                    //             child: Row(
                    //               children: [
                    //                 // Circle with vibrant primary colors
                    //                 Padding(
                    //                   padding: const EdgeInsets.all(3.0),
                    //                   // child: RepaintBoundary(
                    //                   child: Container(
                    //                     width: 20,
                    //                     height: 20,
                    //                     decoration: BoxDecoration(
                    //                       color: mapController.primaryColors[index],
                    //                       shape: BoxShape.circle,
                    //                       border:Border.all(
                    //                         color: Colors.black
                    //                             .withOpacity(0.3), // Set the border color
                    //                         width: 0.6,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   // ),
                    //                 ),
                    //                 const SizedBox(width: 10),
                    //                 Center(
                    //                     child: Text(
                    //                         mapController.cuisines[index],
                    //                         style: const TextStyle(
                    //                             color: Colors.black,
                    //                             fontWeight:
                    //                             FontWeight.bold))),
                    //               ],
                    //             ),
                    //           ),
                    //         );
                    //       },
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          mapController.onShareListTap();
                        },
                        child : Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(35),
                          ),
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Drag Handle
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, bottom: 4),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Container(
                                      width: 160,
                                      height: 5,
                                      color: Colors.transparent),
                                  Container(
                                    width: 40,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                  ),
                                  Container(
                                      width: 160,
                                      height: 5,
                                      color: Colors.transparent),
                                ],
                              ),
                            ),
                            // Share List Text
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, top: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  const Flexible(
                                        child: Align(
                                            alignment:
                                            Alignment.centerLeft,
                                            child: Text(" Share List",
                                                // style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold))
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight
                                                        .bold))
                                        ),
                                  ),
                                  // Container(width: 110, height: 36.5, color: Colors.transparent),
                                  // Icons on the right
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(right: 30),
                                    child: Row(
                                      children: [
                                        // List with a plus
                                        GestureDetector(
                                          onTap: () {
                                            // Your function here
                                          },
                                          child: const Icon(Icons.add,
                                              // color: Colors.white
                                              color: Colors.black87
                                          ),
                                        ),
                                        SizedBox(width: 15), // Spacer

                                        // Person icon
                                        GestureDetector(
                                          onTap: () {
                                            mapController.showSignOutDialog(context);
                                            // Your function here
                                          },
                                          child: const Icon(Icons.person,
                                              // color: Colors.white
                                              color: Colors.black87
                                          ),
                                        ),
                                        const SizedBox(
                                            width: 15), // Spacer

                                        // Settings icon
                                        GestureDetector(
                                          onTap: () {
                                            // Your function here
                                          },
                                          child: const Icon(
                                              Icons.settings,
                                              // color: Colors.white
                                              color: Colors.black87
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                ),
                        ),
                      ),
                    ),
                  // ),
              ]),
            ),
          ),

          Positioned(
            top: 60.0,
            left: 16.0,
            // right: 16.0,
            right: 16.0,
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
                        mapController.isSearchMarkerOnMap.value
                            ? Icons.arrow_back_ios
                            : Icons.search,
                        color: mapController.isSearchMarkerOnMap.value
                            ? Colors.blue
                            : Colors.grey),
                    suffixIcon: mapController.isSearchMarkerOnMap.value
                        ? IconButton(
                      icon: Icon(Icons.close, color: Colors.grey),
                      onPressed: () {
                        // Reset the marker logic
                        mapController.resetMarkerOnMap();
                      },
                    )
                        : null,
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
                    prefixIcon: Icon(
                        mapController.isSearchMarkerOnMap.value
                            ? Icons.close
                            : Icons.search,
                        color: mapController.isSearchMarkerOnMap.value
                            ? Colors.grey
                            : Colors.transparent),
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


// onPressed: mapController.toggleSheet,
