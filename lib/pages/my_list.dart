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

//
// class MyListPage extends StatefulWidget {
//   const MyListPage({Key? key}) : super(key: key);
//
//   @override
//   State<MyListPage> createState() => _MyListPageState();
// }
//
// class _MyListPageState extends State<MyListPage> {
//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child : Text('MyListPage')
//     );
//   }
// }

class MyListPage extends StatefulWidget {
  const MyListPage({Key? key}) : super(key: key);
  @override
  State<MyListPage> createState() => _MyListPageState();
}


class _MyListPageState extends State<MyListPage>  with SingleTickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'My List',
          style : TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.textDark
          ),
        ),
        actions: [Padding(
          padding: const EdgeInsets.only(right: 24.0),
          child: Avatar.small(url:Helpers.randomPictureUrl()),
        ),
        ],
      ),
      body: AnimatedList(
        key: _listKey,
        itemBuilder: (BuildContext context, int index,
            Animation<double> animation) {
          return _buildItem(items[index], animation);
        },
        initialItemCount: items.length,
      ),
    );
  }

//   Widget _buildItem(Item item, Animation<double> animation) {
//     return SizeTransition(
//       sizeFactor: animation,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
//         child: InkWell(
//           onTap: () {},
//           borderRadius: BorderRadius.circular(25),
//         child: Container(
//         height: 100,
//         margin: const EdgeInsets.symmetric(horizontal: 8),
//         decoration: BoxDecoration(
//         border: Border(
//         bottom: BorderSide(
//         color: Theme.of(context).dividerColor,
//         width: 0.5,
//         ),
//         ),
//
//         ),
//           // child: Container(
//           //   padding: EdgeInsets.all(16),
//           //   decoration: BoxDecoration(
//           //     borderRadius: BorderRadius.circular(25),
//           //     color: Colors.blue.shade200,
//           child: Text(
//             item.name,
//             style: TextStyle(fontSize: 18, color: Colors.black),
//           ),
//             ),
//
//           // ),
//         ),
//       ),
//     );
//   }
// }


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
