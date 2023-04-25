import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:siku/theme.dart';
import '../pages/messaging_page.dart';
import '../pages/my_list.dart';
import '../widgets/glowing_action_button.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(40.7178, -74.0431),
    zoom: 11.5,
  );


  late GoogleMapController _googleMapController;

  //
  // final LatLng southwestBound = const LatLng(40.7, -74.1); // Set your southwest bound
  // final LatLng northeastBound = const LatLng(40.8, -74.2); // Set your northeast bound





  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          initialCameraPosition: _initialCameraPosition,
          onMapCreated: (controller) => _googleMapController = controller,
        ),
        // Positioned(
        //   bottom: 16,
        //   left: 0,
        //   right: 0,
        //   child: _BottomNavigationButton(
        //     onItemSelected: _onNavigationItemSelected,
        //   ),
        // ),
        // Positioned(bottom: 130,
        //   left: 270,
        //   right: 0, child:  FloatingActionButton(
        //           // backgroundColor: Theme.of(context).primaryColor,
        //
        //           backgroundColor: Colors.white,
        //           foregroundColor: Colors.black,
        //           onPressed: () => _googleMapController.animateCamera(
        //               CameraUpdate.newCameraPosition(_initialCameraPosition)),
        //           child: const Icon(Icons.center_focus_strong),
        // )
        // )
      // ]),
      // bottomNavigationBar: Container(
      //   padding: EdgeInsets.symmetric(vertical: 8.0),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: [
      //       _buildBubblyButton(Icons.home, 'Home', () {
      //         print('Home button tapped');
      //       }),
      //       _buildBubblyButton(Icons.search, 'Search', () {
      //         print('Search button tapped');
      //       }),
      //       _buildBubblyButton(Icons.person, 'Profile', () {
      //         print('Profile button tapped');
      //       }),
      //     ],
      //   ),
      // ),
      // Positioned(top: 12,
      //   left: 0,
      //   right: 0, child: null,
      // child: floatingActionButton: FloatingActionButton(
      //     // backgroundColor: Theme.of(context).primaryColor,
      //
      //     backgroundColor: Colors.white,
      //     foregroundColor: Colors.black,
      //     onPressed: () => _googleMapController.animateCamera(
      //         CameraUpdate.newCameraPosition(_initialCameraPosition)),
      //     child: const Icon(Icons.center_focus_strong)),
    );
  }
}


//
// class _BottomNavigationButton extends StatefulWidget {
//    _BottomNavigationButton({
//     super.key,
//     required this.onItemSelected,
//   });
//
//   ValueChanged<int> onItemSelected;
//
//   @override
//   State<_BottomNavigationButton> createState() => _BottomNavigationButtonState();
// }
//
// class _BottomNavigationButtonState extends State<_BottomNavigationButton> {
//   var selectedIndex = 0;
//   void handleItemSelected(int index) {
//     setState(() {
//       selectedIndex = index;
//     });
//     widget.onItemSelected(index);
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(top : false,
//         bottom : true,
//         child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildRoundedRectButton(index:1,
//             label: 'Sicku',
//             icon: CupertinoIcons.group,
//             isSelected: (selectedIndex == 1),
//             onTap : handleItemSelected,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 8.0, right:8.0, top: 10),
//             child: GlowingActionButton(
//               color: AppColors.textDark,
//               icon: CupertinoIcons.map,
//               // onPressed: () => _googleMapController2?.animateCamera(CameraUpdate.newCameraPosition(_initialCameraPosition)
//             ),
//           ),
//           _buildRoundedRectButton(index:2,
//             label: 'My List',
//             icon: CupertinoIcons.list_bullet,
//             isSelected: (selectedIndex == 2),
//             onTap : handleItemSelected,
//           ),
//         ],),
//     );
//   }
// }
//
//
//
// class _buildRoundedRectButton extends StatelessWidget {
//   _buildRoundedRectButton({Key? key,
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
//       },
//       child:  Container(
//         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(25),
//           border: Border.all(width : 2, color:AppColors.iconLight ),
//           color: AppColors.textLigth,
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon,
//               size:25,
//               color : isSelected ? AppColors.secondary : null,
//             ),
//             SizedBox(width: 10),
//             Text(label, style: isSelected ?  const TextStyle(fontSize: 13, fontWeight: FontWeight.normal,
//               color:AppColors.secondary,)
//                 : const TextStyle(fontSize: 13),
//             ),
//           ],
//
//         ),
//       ),
//     );
//   }
// }

