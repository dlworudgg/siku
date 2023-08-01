import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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
  Future<Box> _openBox() async {
    return await Hive.openBox('placeDetails');
  }


  // late Stream<QuerySnapshot> roomsStream;

  // @override
  // void initState() {
  //   super.initState();
  // }
  // Assigning the stream of documents to roomsStream
  //   roomsStream = _firestore
  //       .collection('UserSavedPlace')
  //       .doc(widget.id)
  //       .collection('places')
  //       .snapshots();
  // }
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.transparent,
    appBar: AppBar(
      // leading: BackButton(),
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Container(
        padding: EdgeInsets.only(top: 12.0, bottom: 12.0, left: 100, right: 100),
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
      builder: (BuildContext context, AsyncSnapshot<Box> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          final box = snapshot.data;

          // Get the list of keys
          final keys = box!.keys.toList();

          return ListView.builder(
            itemCount: keys.length,
            itemBuilder: (context, index) {
              // Use the key to get the value from the box
              final key = keys[index];
              final placeDetail = box.get(key);

              return Container(
                              margin: const EdgeInsets.only(bottom: 10, top: 25),
                              height: 200,
                              padding:
                              const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.85),
                                      offset: Offset(
                                          0, -1), // Negative offset to simulate top border
                                      spreadRadius: 1.0,
                                      blurRadius: 0,
                                    ),
                                  ],
                                ),
                                padding : const EdgeInsets.only(left: 32, right: 50, bottom: 50),
                                child : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                Text(placeDetail?['Name'] ,
                                      style : TextStyle(color : Colors.black, fontSize :15),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(placeDetail?['editorialSummary'] ,
                                      style : TextStyle(color : Colors.black, fontSize :10),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(placeDetail!['priceLevel'].toString() ?? ' ' ,
                                      style : TextStyle(color : Colors.black, fontSize :8),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(placeDetail?['rating'].toString() ?? ' '  ,
                                      style : TextStyle(color : Colors.black, fontSize :8),
                                    ),
                                  ],
                                ),
                              )
                            // child: ListTile(
                            //   title: Text('${widget.id} - ${index + 1}'),
                            //   trailing: widget.isSavedList ? const Icon(Icons.check) : const Icon(Icons.close),
                            // ),
                          );
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

