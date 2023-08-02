
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:siku/pages/shared_list_page.dart';

import '../helpers.dart';
import '../theme.dart';
import '../widgets/avatar.dart';
import 'my_list_page.dart';



class Item {
  final String id;
  final String name;
  final bool isSavedList;

  Item({required this.id, required this.name, required this.isSavedList});
}



class ShareRoomPage extends StatefulWidget {
  @override
  _ShareRoomPageState createState() => _ShareRoomPageState();
}

class _ShareRoomPageState extends State<ShareRoomPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Item> items = [];


  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();




  // Future<List<Item>>  _addSavedRoomList() async {
    Future<void> _addSavedRoomList() async {
    Item savedPlaceItem = Item(id: FirebaseAuth.instance.currentUser!.uid , name: 'My Saved Restaurants' , isSavedList : true);

    CollectionReference collectionRef = _firestore.collection('ShareRoom').doc(_auth.currentUser!.uid).collection('ShareRoom');
    QuerySnapshot querySnapshot = await collectionRef.get();
    List<String> documentNames = querySnapshot.docs.map((doc) => doc.id).toList();

      setState(() {
        items.add(savedPlaceItem);
        _listKey.currentState?.insertItem(0);
        // print(items);
        // for (String item in documentNames) {
        //   Item sharedRoomItem = Item(id: item , name: item , isSavedList : false);
        //   items.add(sharedRoomItem);
        //   _listKey.currentState?.insertItem(n);
        //   n++;
        // }
      });
    int number = 1;
    documentNames.forEach((item) {
      print(item);
      setState(() {
        Item SharedRoomItem = Item(id: item , name: item , isSavedList : false);
        items.add(SharedRoomItem);
        _listKey.currentState?.insertItem(number);
        number++;
      });
    });
    }


  @override
  void initState() {
    super.initState();
    _addSavedRoomList() ;
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
          child : Text("Shared Restaurants",
        style: TextStyle(color: Colors.black),
        ),
        ),
      ),
      body:
      SafeArea(
        child: Stack(children: [
          AnimatedList(
            key: _listKey,
            itemBuilder: (BuildContext context, int index,
                Animation<double> animation) {
              return _buildItem(context,items[index], animation);
            },
            initialItemCount: items.length,
          ),
          Positioned(
              bottom: 40,
              left: 10,
              right: 0,
              child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 110.0, bottom: 16.0),
                  child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(CupertinoIcons.group,
                          size: 40, color: AppColors.secondary),
                      label: const Text('Siku',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          )),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.cardLight,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          fixedSize: const Size(double.infinity, 50),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          side: const BorderSide(
                            width: 1.0,
                            color: Colors.grey,
                          )))))
        ]),
      ),
    );
  }
}


Widget _buildItem(context ,Item item, Animation<double> animation) {

  void _onShareRoomTap(item) {

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        // This allows the bottom sheet to expand to its full height
        builder: (BuildContext context) {
          return SafeArea(
            top: true,
            child: Container(
                decoration: const BoxDecoration(
                  // color: Colors.transparent,
                ),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery
                      .of(context)
                      .size
                      .height * 0.9,
                  maxWidth: MediaQuery
                      .of(context)
                      .size
                      .width,
                ),
                // child: MessagesPage(),
                child:  MyListPage(id: item.id, isSavedList: item.isSavedList, name: item.name)
                // child: SharedListPage(
                //     id: item.id, isSavedList: item.isSavedList, name: item.name)
            ),
          );
        },
      );
  }


  return SizeTransition(
    sizeFactor: animation,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: InkWell(
        onTap: () {
            _onShareRoomTap(item);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => SharedListPage(id: item.id, isSavedList: item.isSavedList ,name: item.name),
          //   ),
          // );
        },
        borderRadius: BorderRadius.circular(25),
        child: Container(
          height: 100,
          margin: const EdgeInsets.symmetric(horizontal: 8),
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
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Avatar.small(url: Helpers.randomPictureUrl()),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          item.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black87,
                            letterSpacing: 0.2,
                            wordSpacing: 1.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        // child: _buildLastMessage(),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
