import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';

import '../components/slide_image.dart';
import '../models/place_detail_response.dart';
import '../screens/place_information_screen.dart';

class MyListPage extends StatefulWidget {
  final String id;
  final String name;
  final bool isSavedList;

  const MyListPage(
      {Key? key,
      required this.id,
      required this.isSavedList,
      required this.name})
      : super(key: key);

  @override
  State<MyListPage> createState() => _MyListPageState();
}

class _MyListPageState extends State<MyListPage> {
  Future<List<Box>> _openBox() async {
    Box box1 = await Hive.openBox('placeDetails');
    Box box2 = await Hive.openBox('placeDetails_images');
    Box box3 = await Hive.openBox('placeDetails_key_order');
    return [box1, box2, box3];
  }

  final String googleMapBrowserKey = dotenv.get('GOOGLE_MAP_BROWSER_API_KEY');

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        // backgroundColor: Colors.transparent,
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   // leading: BackButton(),
        //   automaticallyImplyLeading: false,
        //   backgroundColor: Colors.white,
        //   elevation: 0,
        //   title: Column(
        //     children: [
        //       Container(
        //         // padding: EdgeInsets.only(top: 100.0, bottom: 14.0, left: 120, right: 120),
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(15.0),
        //         ),
        //         // child: Text(
        //         //   "${widget.name}",
        //         //   overflow: TextOverflow.clip,
        //         //   style: TextStyle(color: Colors.black, fontSize: 14),
        //         // ),
        //       ),
        //     ],
        //   ),
        // ),
        body: FutureBuilder(
          future: _openBox(),
          builder: (BuildContext context, AsyncSnapshot<List<Box>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final box = snapshot.data![0];
              final imageBox = snapshot.data![1];
              final orderBox = snapshot.data![2];

              final keys = orderBox.values.toList();
              return Column(
                children: [
                  // SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 80.0, bottom: 20.0, left: 100, right: 100),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Text(
                      widget.name,
                      overflow: TextOverflow.clip,
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: ReorderableListView.builder(
                      shrinkWrap: false,
                      physics: const ClampingScrollPhysics(),
                      proxyDecorator: (child, index, animation) {
                        return Material(
                          elevation: 4.0,
                          color: Colors
                              .transparent, // setting background color to transparent
                          child: child,
                        );
                      },
                      itemCount: keys.length,
                      itemBuilder: (context, index) {
                        final key = keys[index];
                        final placeDetail = box.get(key);
                        final placeDetailImages = imageBox.get(key);
                        // final placeDetailFormated = Map<String, dynamic>.from(placeDetail );
                        return InkWell(
                          key: ValueKey(key),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => placeInformationScreen(
                                placeDetail: placeDetail,
                                placeDetailImages: placeDetailImages,
                                placeId: key)));

                            // placeInformationScreen(placeDetail: placeDetail ,placeDetailImages : placeDetailImages,
                            //     placeId: key ,listIndex: index);
                            // showModalBottomSheet(
                            //   context: context,
                            //   isScrollControlled: true,
                            //   // This allows the bottom sheet to expand to its full height
                            //   builder: (BuildContext context) {
                            //     return Container(
                            //       constraints: BoxConstraints(
                            //         maxHeight:
                            //             MediaQuery.of(context).size.height,
                            //         maxWidth: MediaQuery.of(context).size.width,
                            //       ),
                            //       child: placeInformationScreen(
                            //           placeDetail: placeDetail,
                            //           placeDetailImages: placeDetailImages,
                            //           placeId: key),
                            //     );
                            //   },
                            // );
                          },
                          child: Container(
                            // key: ValueKey(key),
                            // Provide a unique key for each item
                            // ... rest of your existing item-building logic
                            margin: const EdgeInsets.only(bottom: 0.0, top: 0),
                            height: 250,
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black
                                      .withOpacity(0.3), // Set the border color
                                  width: 0.6, // Set the border width (optional)
                                ),
                                // color: Colors.grey.withOpacity(0.05),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey
                                          .withOpacity(0.4), // Soft shadow
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 3)),
                                  BoxShadow(
                                      color: Colors.grey
                                          .withOpacity(0.4), // Soft shadow
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(5, 0)),
                                ],
                              ),
                              // padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  // Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: SizedBox(
                                      width: 400,
                                      height: 140,
                                      // child:  Hero(
                                      //   tag: 'my_list_image$index',
                                      child: ImageSlider(
                                        images: placeDetailImages,
                                        height: 140,
                                        width: 400,
                                        showDotIndicator: true,
                                        showIndexIndicator: false,
                                        placeDetail: placeDetail,
                                        placeDetailImages: placeDetailImages,
                                        placeId: key,
                                        // listIndex : index,
                                      ),
                                      // ),
                                    ),
                                  ),

                                  // Text Details
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          // Title
                                          Row(
                                            children: <Widget>[
                                              // const SizedBox(width: 16),
                                              Text(
                                                placeDetail?['Name'] ?? '',
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(width: 8),
                                              // Rating
                                              if (placeDetail?['rating'] !=
                                                      null &&
                                                  placeDetail?['rating'] != '')
                                                Row(
                                                  children: [
                                                    const Icon(Icons.star,
                                                        color: Colors.yellow,
                                                        size: 16),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      placeDetail?['rating']
                                                              .toString() ??
                                                          '',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13),
                                                    ),
                                                  ],
                                                ),
                                              const SizedBox(width: 4),

                                              // Price Level
                                              if (placeDetail?['priceLevel'] !=
                                                      null &&
                                                  placeDetail?['priceLevel'] !=
                                                      '')
                                                Text(
                                                  '\$' *
                                                      int.parse(placeDetail![
                                                              'priceLevel']
                                                          .toString()),
                                                  style: TextStyle(
                                                      color: Colors.grey[40],
                                                      fontSize: 13),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),

                                          // Editorial Summary
                                          Text(
                                            placeDetail?['editorialSummary'] ??
                                                '',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
                                          ),
                                          const SizedBox(height: 5),

                                          // Price Level and Rating
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      // onReorder: (oldIndex, newIndex) {
                      //   setState(() async {
                      //     if (newIndex > oldIndex) {
                      //       newIndex -= 1;
                      //     }
                      //     final key = keys.removeAt(oldIndex);
                      //     keys.insert(newIndex, key);
                      //
                      //     // Save reordered keys to Hive
                      //     final orderBox = await Hive.openBox('placeDetails_key_order');
                      //     await orderBox.clear();  // Remove all existing keys
                      //
                      //     for (var key in keys) {
                      //       await orderBox.add(key);
                      //     }
                      //   });
                      // },
                      onReorder: (oldIndex, newIndex) async {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        final key = keys.removeAt(oldIndex);
                        keys.insert(newIndex, key);

                        // Save reordered keys to Hive
                        final orderBox =
                            await Hive.openBox('placeDetails_key_order');
                        await orderBox.clear(); // Remove all existing keys

                        for (var key in keys) {
                          await orderBox.add(key);
                        }

                        setState(
                            () {}); // Call setState to rebuild the UI after reordering and saving
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                  child: CircularProgressIndicator()); // Loading indicator
            }
          },
        ),
      ),
      Positioned(
        top: 70, // Adjust these values as needed
        left: 15,
        child: CircleAvatar(
          backgroundColor: Colors.black.withOpacity(0.4),
          radius: 21.5,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 21,
            child: Material(
              type: MaterialType.transparency, // This makes the Material visually transparent
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Center(
                  child: Icon(Icons.arrow_back,
                      size: 21,
                      color: Colors.black), // Adjust the size and color as needed
                ),
              ),
            ),
          ),
        ),
      )

      // Positioned(
      //   top: 40, // Adjust these values as needed
      //   left: 15,
      //   child: CircleAvatar(
      //     backgroundColor: Colors.white,
      //     radius: 21,
      //     child: InkWell(
      //       onTap: () {
      //         Navigator.pop(context);
      //       },
      //       child: Center(
      //         child: Icon(Icons.arrow_back,
      //             size: 21,
      //             color: Colors.black), // Adjust the size and color as needed
      //       ),
      //     ),
      //   ),
      // )
    ]);
  }

  @override
  void dispose() {
    Hive.close(); // Close the Hive box when you're done with it
    super.dispose();
  }
}
