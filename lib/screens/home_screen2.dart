import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siku/theme.dart';
import '../helpers.dart';
import '../pages/messaging_page.dart';
import '../pages/my_list.dart';
import 'package:siku/screens/map_screen.dart';
import 'package:siku/screens/search_screen.dart';

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
    // SearchScreen(),
  ];

  void _onNavigationItemSelected(index) {
    // title.value = pageTitles[index];
    pageIndex.value = index;
    // _onMenuTap(index);
  }
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [

        Positioned(
          bottom: 200,
          left: 30,

          child: FloatingActionButton(
            heroTag: null,
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
          child: Padding(
          padding: const EdgeInsets.all(16.0),
            child : ElevatedButton.icon(
              onPressed: () {},
                icon : const Icon(CupertinoIcons.group),
              label: const Text('Siku'),
                style : ElevatedButton.styleFrom(
                  backgroundColor:AppColors.cardLight,
                  foregroundColor: Colors.white,
                  elevation : 0 ,
                  fixedSize:  const Size(double.infinity, 40),
                  shape : const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  )
                )
            )
          )


        ),

      ]),
    );
  }


}
//
// class _BottomNavigationButton extends StatefulWidget {
//   _BottomNavigationButton({
//     super.key,
//     required this.onItemSelected,
//   });
//
//   ValueChanged<int> onItemSelected;
//
//   @override
//   State<_BottomNavigationButton> createState() =>
//       _BottomNavigationButtonState();
// }
//
// class _BottomNavigationButtonState extends State<_BottomNavigationButton> {
//   var selectedIndex = 0;
//   bool myListDoubleTapped = false;
//
//   void handleItemSelected(int index) {
//     if ((index == 2 && selectedIndex == 2 && !myListDoubleTapped) ||
//         (index == 1 && selectedIndex == 1 && !myListDoubleTapped)) {
//       myListDoubleTapped = true;
//       index = 0;
//     } else {
//       myListDoubleTapped = false;
//     }
//
//     setState(() {
//       selectedIndex = index;
//     });
//     widget.onItemSelected(index);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       top: false,
//       bottom: true,
//       child:
//
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildRoundedRectButton(
//             index: 1,
//             label: 'Siku',
//             icon: CupertinoIcons.group,
//             isSelected: (selectedIndex == 1),
//             onTap: handleItemSelected,
//             // onDoubleTap: cancelItemSelected,
//           ),
//
//
//           _buildRoundedRectButton(
//             index: 2,
//             label: 'My List',
//             icon: CupertinoIcons.list_bullet,
//             isSelected: (selectedIndex == 2),
//             onTap: handleItemSelected,
//             // onDoubleTap: cancelItemSelected,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _buildRoundedRectButton extends StatelessWidget {
//   _buildRoundedRectButton({
//     Key? key,
//     required this.index,
//     required this.label,
//     required this.icon,
//     this.isSelected = false,
//     required this.onTap,
//     // required this.onDoubleTap,
//   }) : super(key: key);
//
//   final int index;
//   final String label;
//   final IconData icon;
//   final bool isSelected;
//   ValueChanged<int> onTap;
//
//   // ValueChanged<int>  onDoubleTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: () {
//         onTap(index);
//       },
//       onDoubleTap: () {
//         onTap(0);
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(width: 2, color: AppColors.iconLight),
//           color: AppColors.textLigth,
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               icon,
//               size: 25,
//               color: isSelected ? AppColors.secondary : null,
//             ),
//             SizedBox(width: 10),
//             Text(
//               label,
//               style: isSelected
//                   ? const TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.normal,
//                 color: AppColors.secondary,
//               )
//                   : const TextStyle(fontSize: 15),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
