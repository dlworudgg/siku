import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siku/theme.dart';
import '../helpers.dart';
import '../pages/messaging_page.dart';
import '../pages/my_list.dart';
import 'package:siku/screens/map_screen.dart';
import '../widgets/avatar.dart';
import '../widgets/glowing_action_button.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);



  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<int> pageIndex = ValueNotifier(0);
  final ValueNotifier<String> title = ValueNotifier('Map');
  final pages = const [
    MapScreen(),
    MessagesPage(),
    MyListPage(),
  ];

  // final pageTitles = const [
  //   'Map',
  //   'Sicku',
  //   'My List',
  // ];

  void _onNavigationItemSelected(index) {
    // title.value = pageTitles[index];
    pageIndex.value = index;
  }
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   title: ValueListenableBuilder(
      //     valueListenable: title,
      //     builder : (BuildContext context, String value, _) {
      //       return Text(
      //         value,
      //           style : const TextStyle(
      //           fontWeight: FontWeight.bold,
      //           fontSize: 16,
      //           color: AppColors.textDark
      //       ),
      //       );
      //     },
      //   ),
      //   actions: [Padding(
      //     padding: const EdgeInsets.only(right: 24.0),
      //     child: Avatar.small(url:Helpers.randomPictureUrl()),
      //   ),
      //   ],
      // ),
      body: Stack(children: [
        ValueListenableBuilder(
          valueListenable: pageIndex,
          builder: (BuildContext context, int value, _) {
            return pages[value];
          },
        ),
        // bottomNavigationBar: _BottomNavigationBar(
        //     onItemSelected: _onNavigationItemSelected,
        // ),
        Positioned(
          top: 50,
          left: 30,

          child: FloatingActionButton(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            onPressed: signUserOut,
            // tooltip: 'Press the circle button',
            child: const Icon(Icons.logout),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
        ),

        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: _BottomNavigationButton(
            onItemSelected: _onNavigationItemSelected,
          ),
        ),

      ]),
    );
  }
}

// class _BottomNavigationBar extends StatefulWidget {
//   _BottomNavigationBar({
//     super.key,
//     required this.onItemSelected
//   });
//   ValueChanged<int> onItemSelected;
//
//   @override
//   State<_BottomNavigationBar> createState() => _BottomNavigationBarState();
// }
//
// class _BottomNavigationBarState extends State<_BottomNavigationBar> {
//   var selectedIndex = 0;
//   void handleItemSelected(int index) {
//   setState(() {
//     selectedIndex = index;
//   });
//     widget.onItemSelected(index);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         top : false,
//         bottom : true,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             // Padding(
//             //   padding: const EdgeInsets.only(top: 12.0),
//             //   child: _NavigationBarItem(
//             //     index:0,
//             //     label: 'Map',
//             //     // icon: Icons.people,
//             //     //   icon: CupertinoIcons.bubble_left_bubble_right_fill,
//             //     icon: CupertinoIcons.map,
//             //     isSelected: (selectedIndex == 0),
//             //     onTap : handleItemSelected,
//             //   ),
//             // ),
//             Padding(
//               padding: const EdgeInsets.only( top: 30.0, left:40 ),
//               child: _NavigationBarItem(
//                               index:1,
//                               label: 'Sicku',
//                               // icon: Icons.people,
//                               //   icon: CupertinoIcons.bubble_left_bubble_right_fill,
//                               icon: CupertinoIcons.group,
//                               isSelected: (selectedIndex == 1),
//                               onTap : handleItemSelected,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 8.0, right:8.0, top: 10),
//               child: GlowingActionButton(
//                 color: AppColors.textDark,
//                 icon: CupertinoIcons.map,
//                 onPressed: () {
//                   setState(() {
//                     selectedIndex = 0;
//                   });
//                   widget.onItemSelected(0);
//
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top:30.0, right:40),
//               child: _NavigationBarItem(
//                         index:2,
//                         label: 'My list',
//                 // icon: Icons.view_list,
//                 // icon: CupertinoIcons.bubble_left_bubble_right_fill,
//                 icon: CupertinoIcons.list_bullet,
//                 isSelected: (selectedIndex == 2),
//                 onTap : handleItemSelected,
//               ),
//             ),
//           ],
//         )
//     );
//   }
// }
//
// class _NavigationBarItem extends StatelessWidget {
//   _NavigationBarItem({Key? key,
//     required this.index,
//     required this.label,
//     required this.icon,
//     this.isSelected = false,
//     required this.onTap,
//   }) : super(key: key);
//
//
//
//   final int index;
//   final String label;
//   final IconData icon;
//   final bool isSelected;
//   ValueChanged<int> onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: () {onTap(index);
//         },
//       child: SizedBox(
//         height: 70,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon,
//               size:25,
//               color : isSelected ? AppColors.secondary : null,
//             ),
//             Text(label, style: isSelected ?  const TextStyle(fontSize: 13, fontWeight: FontWeight.normal,
//               color:AppColors.secondary,)
//             : const TextStyle(fontSize: 13),
//             ),
//           ],
//
//         ),
//       ),
//     );
//   }
// }

class _BottomNavigationButton extends StatefulWidget {
  _BottomNavigationButton({
    super.key,
    required this.onItemSelected,
  });

  ValueChanged<int> onItemSelected;

  @override
  State<_BottomNavigationButton> createState() =>
      _BottomNavigationButtonState();
}

class _BottomNavigationButtonState extends State<_BottomNavigationButton> {
  var selectedIndex = 0;
  bool myListDoubleTapped = false;

  void handleItemSelected(int index) {
    if ((index == 2 && selectedIndex == 2 && !myListDoubleTapped) ||
        (index == 1 && selectedIndex == 1 && !myListDoubleTapped)) {
      myListDoubleTapped = true;
      index = 0;
    } else {
      myListDoubleTapped = false;
    }

    setState(() {
      selectedIndex = index;
    });
    widget.onItemSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildRoundedRectButton(
            index: 1,
            label: 'Siku',
            icon: CupertinoIcons.group,
            isSelected: (selectedIndex == 1),
            onTap: handleItemSelected,
            // onDoubleTap: cancelItemSelected,
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 8.0, right:8.0, top: 10),
          //   child: GlowingActionButton(
          //     color: AppColors.textDark,
          //     icon: CupertinoIcons.map,
          //     onPressed: () {
          //       setState(() {
          //         selectedIndex = 0;
          //       });
          //       widget.onItemSelected(0);
          //
          //     },
          //   ),
          // ),
          // _

          _buildRoundedRectButton(
            index: 2,
            label: 'My List',
            icon: CupertinoIcons.list_bullet,
            isSelected: (selectedIndex == 2),
            onTap: handleItemSelected,
            // onDoubleTap: cancelItemSelected,
          ),
        ],
      ),
    );
  }
}

class _buildRoundedRectButton extends StatelessWidget {
  _buildRoundedRectButton({
    Key? key,
    required this.index,
    required this.label,
    required this.icon,
    this.isSelected = false,
    required this.onTap,
    // required this.onDoubleTap,
  }) : super(key: key);

  final int index;
  final String label;
  final IconData icon;
  final bool isSelected;
  ValueChanged<int> onTap;

  // ValueChanged<int>  onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap(index);
      },
      onDoubleTap: () {
        onTap(0);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 2, color: AppColors.iconLight),
          color: AppColors.textLigth,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 25,
              color: isSelected ? AppColors.secondary : null,
            ),
            SizedBox(width: 10),
            Text(
              label,
              style: isSelected
                  ? const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: AppColors.secondary,
                    )
                  : const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
