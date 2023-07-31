import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SharedListPage extends StatefulWidget {
  final String id;
  final String name;
  final bool isSavedList;

  const SharedListPage({Key? key, required this.id, required this.isSavedList, required this.name})
      : super(key: key);

  @override
  State<SharedListPage> createState() => _SharedListPageState();
}

class _SharedListPageState extends State<SharedListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //
  // if (isSavedList == true){
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // leading: BackButton(),
        automaticallyImplyLeading: false,
        // backgroundColor: Colors.grey[700],
        // backgroundColor: Colors.white.withOpacity(0.85),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Container(
          padding: EdgeInsets.only(top :12.0, bottom: 12.0, left: 100, right: 100),
          // margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.85),
                offset: Offset(0, -1),  // Negative offset to simulate top border
                spreadRadius: 1.0,
                blurRadius: 0,
              )
            ],
          ),
          child : Text("${widget.name}",
            style: TextStyle(color: Colors.black,  fontSize :16),
          ),
        ),
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            itemCount: 10, // Change this for the desired number of cards
            itemBuilder: (context, index) {
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
                        Text('${widget.id} - ${index + 1}',
                      style : TextStyle(color : Colors.black, fontSize :12),
                    ),
                        const SizedBox(height: 2),
                    Text("The Best",
                      style : TextStyle(color : Colors.black, fontSize :22),
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
          ),
        )
      ]),
    );
  }
}
