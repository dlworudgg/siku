import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:siku/screens/map_screen.dart';

import '../getx/map_controller.dart';
import '../theme.dart';
import '../widgets/avatar.dart';
import 'my_list_page.dart';

class Item {
  final String id;
  final String name;
  final String image;
  final bool isSavedList;
  final String userNumber;

  Item({
    required this.id,
    required this.name,
    required this.isSavedList,
    required this.image,
    required this.userNumber,
  });
}
class ShareRoomPage  extends StatelessWidget {
  ShareRoomPage ({Key? key}) : super(key: key);

  final mapController = Get.find<MapController>();

void getBack(){
  // Get.to(() => MapScreen(),
  //   transition: Transition.upToDown,
    // duration: Duration(seconds: 0),
  // );
  Get.back();
  // transition: Transition.downToUp,
}

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body:
      // Stack(
      //   children : [
          // Positioned(
          //   top: 60.0,
          //   left: 16.0,
          //   // right: 16.0,
          //   right: 50.0,
          //   child: GestureDetector(
          //     onTap: mapController.onSearchTap,
          //     child: AbsorbPointer(
          //       // child: Container(
          //       //   color: Colors.red,
          //       //   width: mapController.deviceWidth.value,
          //       //   height: mapController.deviceHeight.value , // 8% of device height
          //       child: TextFormField(
          //         decoration: InputDecoration(
          //           hintText: 'Search Restaurants Here',
          //           fillColor: AppColors.cardLight,
          //           filled: true,
          //           prefixIcon: Icon(
          //               mapController.isSearchMarkerOnMap.value
          //                   ? Icons.arrow_back_ios
          //                   : Icons.search,
          //               color: mapController.isSearchMarkerOnMap.value
          //                   ? Colors.blue
          //                   : Colors.grey),
          //           border: OutlineInputBorder(
          //             borderSide: BorderSide.none,
          //             borderRadius: BorderRadius.circular(10),
          //           ),
          //           // border: OutlineInputBorder(
          //           //   borderSide: const BorderSide(
          //           //     color: Colors.black12, // This is the color of the border
          //           //     width: 0.1, // This is the width of the border
          //           //   ),
          //           //   borderRadius: BorderRadius.circular(10),
          //           // ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

          // Positioned(
          //   top: 0.0,
          //   left: 0.0,
          //   right: 0.0,
          //   bottom: 0,
          //   child:
            Padding(
              padding: const EdgeInsets.only(top : 55.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.transparent,
                //   border: Border.all(
                // color: Colors.black12, // Color of the border
                //   width: 1.0,        // Width of the border
                // )),
                ),
                // child: BackdropFilter(
                //   filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: GestureDetector(
                  onTap:getBack,
                  // onTap: mapController.toggleSheet,
                  child: Padding(
                    padding: const EdgeInsets.only( top: 16.0, bottom : 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Colors.black87,
                        // color : Colors.red[100],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only( bottom : 24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // Share List Text
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: GestureDetector(
                                          onTap: getBack,
                                            // onTap: mapController.toggleSheet,
                                            child: const Align(
                                                alignment:
                                                Alignment.centerLeft,
                                                child: Text(" Share List",
                                                    // style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold))
                                                    style: TextStyle(
                                                        fontSize: 30,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight
                                                            .bold))
                                            )),
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
                                              //  need to move to page

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

                          // List Content
                          // Container(width: 70, height: 36.5, color: Colors.white),
                          Expanded(
                            child: Material(
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                // controller: scrollController,
                                itemCount: mapController.items.length,
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4.0,
                                        bottom: 16.0,
                                        left: 6,
                                        right: 16),
                                    child: Container(
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage: AssetImage(
                                              mapController
                                                  .items[index].image),
                                          radius: 35,
                                        ),
                                        title: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start, // Aligns the content to the start
                                          children: [
                                            // Text( mapController.items[index].name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                            Text(
                                                mapController
                                                    .items[index].name,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.bold)),

                                            // User Icon and userNumber layout
                                            Padding(
                                              padding: const EdgeInsets.only(top : 8.0),
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.person,
                                                      // color: Colors.grey[100],
                                                      color : Colors.brown,
                                                      size: 20), // User Icon
                                                  const SizedBox(
                                                      width:
                                                      5), // Some space between the icon and text
                                                  Text(
                                                      mapController.items[index]
                                                          .userNumber,
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          // color: Colors.white
                                                          color: Colors.black87
                                                      )), // User number
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MyListPage(
                                                      id: mapController
                                                          .items[index].id,
                                                      isSavedList:
                                                      mapController
                                                          .items[index]
                                                          .isSavedList,
                                                      name: mapController
                                                          .items[index].name),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
            ),
          // ),
        // ],
      // ),
    );
  }
}
