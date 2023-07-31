import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siku/theme.dart';
import '../helpers.dart';
import '../widgets/avatar.dart';

class Item {
  final int id;
  final String name;

  Item({required this.id, required this.name});
}

Future<List<Item>> fetchData() async {
  // Replace this with your actual database fetch logic
  await Future.delayed(Duration(seconds: 0)); // Simulate a delay for fetching data
  return List<Item>.generate(20, (index) => Item(id: index, name: 'Item $index'));
}


class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  List<Item> items = [];
  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    List<Item> fetchedItems = await fetchData();
    fetchedItems.forEach((item) {
      setState(() {
        items.add(item);
        _listKey.currentState!.insertItem(items.length - 1);
      });
    });
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        // backgroundColor: Colors.transparent,
        backgroundColor: Colors.grey[700],
        elevation: 0,
      ),
      body: Stack(
        children: [
          SafeArea(
            top : true,
              child: AnimatedList(
            key: _listKey,
            itemBuilder: (BuildContext context, int index,
                Animation<double> animation) {
              return _buildItem(items[index], animation);
            },
            initialItemCount: items.length,
          )
          ),
      Positioned(
          bottom: 40,
          left: 10,
          right: 0,
          child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 110.0, bottom: 16.0),
              child : ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon : const Icon(CupertinoIcons.group,size : 40, color: AppColors.secondary),
                  label: const Text('Siku',
                      style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold,
                        color: AppColors.secondary,)
                  ),
                  style : ElevatedButton.styleFrom(
                      backgroundColor:AppColors.cardLight,
                      foregroundColor: Colors.black,

                      elevation : 0 ,
                      fixedSize:  const Size(double.infinity, 50),
                      shape : const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      side: const BorderSide(
                        width: 1.0,
                        color: Colors.grey,)
                  )
              )
          )
          ),

          Positioned(
            bottom: 56,
            right: 30,
            child: ElevatedButton(
              onPressed: signUserOut,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: AppColors.cardLight, // foreground color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                side: BorderSide(
                  width: 1.0,
                  color: Colors.grey,
                ),
                elevation: 0,
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 7.3, top : 7.3), // Padding for the child widget
                child: Avatar.small(url: Helpers.randomPictureUrl()),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildItem(Item item, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: InkWell(
          onTap: () {
            // Navigator.of(context).push(ChatScreen.routeWithChannel(channel));
          },
          borderRadius: BorderRadius.circular(25),
          child: Container(
            height: 100,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(25),
              border: Border(
                bottom: BorderSide(
                  color: Theme
                      .of(context)
                      .dividerColor,
                  width: 0.5,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Avatar.small(url:Helpers.randomPictureUrl()),
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
}
