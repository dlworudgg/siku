
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

import '../widgets/avatar.dart';
import 'my_list_page.dart';



class Item {
  final String id;
  final String name;
  final String image;
  final bool isSavedList;

  Item({required this.id, required this.name, required this.isSavedList,required this.image,});
}



class ShareRoomPage extends StatefulWidget {
  const ShareRoomPage({super.key});

  @override
  _ShareRoomPageState createState() => _ShareRoomPageState();
}

class _ShareRoomPageState extends State<ShareRoomPage> {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Item> items = [];
  // List<String> url_list = ['lib/images/jae_logo.png','lib/images/jae_jae_logo.png' ];

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  // final share_box = await Hive.openBox('ShareRoom');


  // Future<List<Item>>  _addSavedRoomList() async {
    Future<void> _addSavedRoomList() async {
    Item savedPlaceItem = Item(id: FirebaseAuth.instance.currentUser!.uid , name: 'My Saved Restaurants' , isSavedList : true , image: 'lib/images/jae_logo_2.png');

    final share_box = await Hive.openBox('ShareRoom');
    var value = share_box.get(0);

    // share_box[0][]
    // CollectionReference collectionRef = _firestore.collection('ShareRoom').doc(_auth.currentUser!.uid).collection('ShareRoom');
    // QuerySnapshot querySnapshot = await collectionRef.get();
    // List<String> documentNames = querySnapshot.docs.map((doc) => doc.id).toList();

      setState(() {
        items.add(savedPlaceItem);
        _listKey.currentState?.insertItem(0);

        // items.add(Item(id: 'hiXr7lr8IwGWAGRMuHRN' , name: value['hiXr7lr8IwGWAGRMuHRN']['Name'] , isSavedList : false, image: 'lib/images/jae_jae_logo.png'));
        items.add(Item(id: 'hiXr7lr8IwGWAGRMuHRN' , name: "Jae, SuHyun's List" , isSavedList : false, image: 'lib/images/jae_jae_logo.png'));

        _listKey.currentState?.insertItem(1);
      });
    // int number = 1;
    // documentNames.forEach((item) {
    //   print(item);
    //   setState(() {
    //     Item SharedRoomItem = Item(id: item , name: item , isSavedList : false);
    //     items.add(SharedRoomItem);
    //     _listKey.currentState?.insertItem(number);
    //     number++;
    //   });
    // });
    }

  @override
  void initState() {
    super.initState();
    _addSavedRoomList() ;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [Scaffold(
        // backgroundColor: Colors.transparent ,
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   backgroundColor: Colors.white,
        // ),
        //   automaticallyImplyLeading: false,
        //   backgroundColor: Colors.grey[500],
        //   elevation: 0,
        //   title: Container(
        //     padding: const EdgeInsets.only(top :12.0, bottom: 12.0, left: 100, right: 100),
        //     // margin: const EdgeInsets.symmetric(horizontal: 10),
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(15.0),
        //       // boxShadow: [
        //       //   BoxShadow(
        //       //     color: Colors.white.withOpacity(0.85),
        //       //     offset: Offset(0, -1),  // Negative offset to simulate top border
        //       //     spreadRadius: 1.0,
        //       //     blurRadius: 0,
        //       //   )
        //       // ],
        //     ),
        //     child : const Text("Shared Restaurants",
        //   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        //   ),
        //   ),
        // ),
        body:
      Column (children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(
              top: 80.0, bottom: 20.0,left: 100, right: 100 ),
          decoration: const BoxDecoration(
            // color: Colors.white,
            // borderRadius: BorderRadius.circular(15.0),
          ),
            child: const Center(
              child:  Text(
                "Share List",
                  // textAlign: TextAlign.left,
                overflow: TextOverflow.clip,
                style: TextStyle(color: Colors.black, fontSize: 20,)),
            ),
          ),
            Expanded(
              child: AnimatedList(
                key: _listKey,
                itemBuilder: (BuildContext context, int index,
                    Animation<double> animation) {
                  return _buildItem(context,items[index], animation);
                },
                initialItemCount: items.length,
              ),
            ),
          ]),

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
      ]
    );
  }
}


Widget _buildItem(context ,Item item, Animation<double> animation) {

  return SizeTransition(
    sizeFactor: animation,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () {
            // MyListPage(id: item.id, isSavedList: item.isSavedList, name: item.name);
              // _onShareRoomTap(item);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyListPage(id: item.id, isSavedList: item.isSavedList ,name: item.name),
              ),
            );
          },
          borderRadius: BorderRadius.circular(25),
          child: Container(
            height: 70,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black
                    .withOpacity(0.3), // Set the border color
                width: 0.6, // Set the border width (optional)
              ),
              // color: Colors.grey.withOpacity(0.05),
              color: Colors.white.withOpacity(0.9),
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
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(15.0),
            //   boxShadow: [
            //     BoxShadow(
            //       color: Colors.white.withOpacity(0.85),
            //       offset: const Offset(0, -1),  // Negative offset to simulate top border
            //       spreadRadius: 1.0,
            //       blurRadius: 0,
            //     )
            //   ],
            // ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Avatar.medium(url: item.image ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top : 15,left: 5),
                          child: Text(
                            item.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black87,
                              letterSpacing: 0.2,
                              wordSpacing: 1.5,
                              fontWeight: FontWeight.w600,
                              fontSize: 15
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                          // child: _buildLastMessage(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
