import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';

import '../components/slide_image.dart';
import '../models/place_detail_response.dart';


class MyListPage extends StatefulWidget {
  final String id;
  final String name;
  final bool isSavedList;

  const MyListPage({Key? key, required this.id, required this.isSavedList, required this.name})
      : super(key: key);



  @override
  State<MyListPage> createState() => _MyListPageState();
}


class _MyListPageState extends State<MyListPage> {

  //
  // Future<Box> _openBox() async {
  //   return await Hive.openBox('placeDetails');
  // }
  Future<List<Box>> _openBox() async {
    Box box1 = await Hive.openBox('placeDetails');
    Box box2 = await Hive.openBox('placeDetails_images');
    return [box1, box2];
  }
  final String googleMapBrowserKey = dotenv.get('GOOGLE_MAP_BROWSER_API_KEY');


@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.transparent,
    // backgroundColor: Colors.white,
    appBar: AppBar(
      // leading: BackButton(),
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Container(
        padding: EdgeInsets.only(top: 14.0, bottom: 14.0, left: 120, right: 120),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.85),
              offset: Offset(0, -1),
              spreadRadius: 1.0,
              blurRadius: 0,
            ),
          ],
        ),
        child: Text(
          "${widget.name}",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    ),
    body: FutureBuilder(
      future: _openBox(),
      builder: (BuildContext context, AsyncSnapshot<List<Box>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          final box = snapshot.data![0];
          final image_box = snapshot.data![1];
          // Get the list of keys
          final keys = box.keys.toList();

          // return ListView.builder(
          //   itemCount: keys.length,
          //   itemBuilder: (context, index) {
          //     // Use the key to get the value from the box
          //     final key = keys[index];
          //     final placeDetail = box.get(key);
          //     final placeDetailImages = image_box.get(key);
          //     return Container(
          //       margin: const EdgeInsets.only(bottom: 0, top: 4.0),
          //       height: 350,
          //       padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          //       child: Container(
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           // color: Colors.grey[100],
          //           borderRadius: BorderRadius.circular(15.0),
          //           boxShadow: [
          //             BoxShadow(
          //               color: Colors.white.withOpacity(0.85),
          //               offset: Offset(0, -1),
          //               spreadRadius: 1.0,
          //               blurRadius: 0,
          //             ),
          //           ],
          //         ),
          //         // padding: const EdgeInsets.all(16),
          //         child: Column(
          //           children: [
          //             // Image
          //             ClipRRect(
          //               borderRadius: BorderRadius.circular(15.0),
          //               child:
          //               SizedBox(
          //                 width: 400,
          //                 height: 230,
          //                 child: ImageSlider(images: placeDetailImages,width: 400,
          //                   height: 250),
          //               ),
          //             ),
          //
          //
          //
          //             // Text Details
          //             Expanded(
          //               child: Padding(
          //                 padding: const EdgeInsets.all(12.0),
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: <Widget>[
          //
          //                     // Title
          //                     Row(
          //                       children: <Widget>[
          //                         // const SizedBox(width: 16),
          //                         Text(
          //                           placeDetail?['Name'] ?? '',
          //                           overflow: TextOverflow.ellipsis,
          //                           style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          //                         ),
          //                         const SizedBox(width: 8),
          //                         // Rating
          //                         if (placeDetail?['rating'] != null && placeDetail?['rating'] != '')
          //                           Row(
          //                             children: [
          //                               Icon(Icons.star, color: Colors.yellow, size: 16),
          //                               const SizedBox(width: 4),
          //                               Text(
          //                                 placeDetail?['rating'].toString() ?? '',
          //                                 style: TextStyle(color: Colors.black, fontSize: 13),
          //                               ),
          //                             ],
          //                           ),
          //                         const SizedBox(width: 4),
          //
          //                         // Price Level
          //                         if (placeDetail?['priceLevel'] != null && placeDetail?['priceLevel'] != '')
          //                           Text(
          //                             '\$' * int.parse(placeDetail!['priceLevel'].toString()),
          //                             style: TextStyle(color: Colors.grey[40], fontSize: 13),
          //                           ),
          //                       ],
          //                     ),
          //                     const SizedBox(height: 5),
          //
          //                     // Editorial Summary
          //                     Text(
          //                       placeDetail?['editorialSummary'] ?? '',
          //                       style: TextStyle(color: Colors.black, fontSize: 12),
          //                     ),
          //                     const SizedBox(height: 5),
          //
          //                     // Price Level and Rating
          //
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     );
          //   },
          // );


          return ReorderableListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: keys.length,
            itemBuilder: (context, index) {
              final key = keys[index];
              final placeDetail = box.get(key);
              final placeDetailImages = image_box.get(key);
              return Container(
                key: ValueKey(key),  // Provide a unique key for each item
                // ... rest of your existing item-building logic
                    margin: const EdgeInsets.only(bottom: 0, top: 4.0),
                    height: 350,
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.85),
                            offset: Offset(0, -1),
                            spreadRadius: 1.0,
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      // padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child:
                            SizedBox(
                              width: 400,
                              height: 230,
                              child: ImageSlider(images: placeDetailImages,width: 400,
                                height: 250),
                            ),
                          ),



                          // Text Details
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  // Title
                                  Row(
                                    children: <Widget>[
                                      // const SizedBox(width: 16),
                                      Text(
                                        placeDetail?['Name'] ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 8),
                                      // Rating
                                      if (placeDetail?['rating'] != null && placeDetail?['rating'] != '')
                                        Row(
                                          children: [
                                            Icon(Icons.star, color: Colors.yellow, size: 16),
                                            const SizedBox(width: 4),
                                            Text(
                                              placeDetail?['rating'].toString() ?? '',
                                              style: TextStyle(color: Colors.black, fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      const SizedBox(width: 4),

                                      // Price Level
                                      if (placeDetail?['priceLevel'] != null && placeDetail?['priceLevel'] != '')
                                        Text(
                                          '\$' * int.parse(placeDetail!['priceLevel'].toString()),
                                          style: TextStyle(color: Colors.grey[40], fontSize: 13),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),

                                  // Editorial Summary
                                  Text(
                                    placeDetail?['editorialSummary'] ?? '',
                                    style: TextStyle(color: Colors.black, fontSize: 12),
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
                  );
            },
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final key = keys.removeAt(oldIndex);
                keys.insert(newIndex, key);
              });
            },
          );

        } else {
          return Center(child: CircularProgressIndicator()); // Loading indicator
        }
      },
    ),
  );
}
@override
void dispose() {
  Hive.close(); // Close the Hive box when you're done with it
  super.dispose();
}
  }

