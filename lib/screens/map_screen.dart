import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:siku/screens/search_screen.dart';
import 'package:siku/theme.dart';
import '../models/autocomplete_prediction.dart';
import '../pages/messaging_page.dart';
import '../pages/my_list.dart';
import '../widgets/glowing_action_button.dart';
import 'dart:ui';

class MapScreen extends StatefulWidget {
  final double? lat;
  final double? lng;

  const MapScreen({Key? key, this.lat, this.lng}) : super(key: key);


  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(40.7178, -74.0431),
    zoom: 14.5,
  );


  late GoogleMapController _googleMapController;
  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;

    if (widget.lat != null && widget.lng != null) {
      _googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(widget.lat!, widget.lng!),
          14.5,
        ),
      );

      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId('selected_location'),
            position: LatLng(widget.lat!, widget.lng!),
          ),
        );
      });
    }
  }
  // @override
  // void initState() {
  //   super.initState();
  //
  //   // If lat and lng are provided, initialize the marker
  //   if (widget.lat != null && widget.lng != null) {
  //     _selectedLocationMarker = Marker(
  //       markerId: MarkerId('selectedLocation'),
  //       position: LatLng(widget.lat!, widget.lng!),
  //     );
  //   }
  // }
  //
  // @override
  // void didUpdateWidget(MapScreen oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //
  //   // If lat and lng are updated, update the marker and move the camera
  //   if (widget.lat != oldWidget.lat || widget.lng != oldWidget.lng) {
  //     _selectedLocationMarker = Marker(
  //       markerId: MarkerId('selectedLocation'),
  //       position: LatLng(widget.lat!, widget.lng!),
  //     );
  //     _googleMapController.moveCamera(
  //       CameraUpdate.newLatLng(LatLng(widget.lat!, widget.lng!)),
  //     );
  //   }
  // }

  void _resetCameraPosition() {
    _googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target:  LatLng(40.7178, -74.0431),
      zoom: 14.5,
    )
    )
    );
  }

  // void _moveCameraToSelectedPlace(double latitude, double longitude) {
  //   _googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //     target: LatLng(latitude, longitude),
  //     zoom: 15.0,
  //   )));
  // }
  // void _showLocationDetails(AutocompletePrediction selectedPlace) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Container(
  //         height: MediaQuery.of(context).size.height * 0.4,
  //         child: Column(
  //           children: [
  //             Text(selectedPlace.structuredFormatting?.mainText ?? ""),
  //             Text(selectedPlace.structuredFormatting?.secondaryText ?? ""),
  //             // TODO: Add review data
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
  //
  // void _onPlaceSelected(AutocompletePrediction selectedPlace) {
  //   // TODO: Retrieve the latitude and longitude of the selected place
  //   double latitude = 0; // replace with the actual latitude
  //   double longitude = 0; // replace with the actual longitude
  //
  //   _moveCameraToSelectedPlace(latitude, longitude);
  //   _showLocationDetails(selectedPlace);
  // }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }
  void _onSearchTap() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // This allows the bottom sheet to expand to its full height
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: SearchScreen(),
        );
      },
    );
  }


  void _onMenuTap() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // This allows the bottom sheet to expand to its full height
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child:  MessagesPage(),
        );
      },
    );
  }
  // void _onSearchTap() {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return SearchScreen();
  //     },
  //   );
  // }
  // void _onSearchTap() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => SearchScreen(),
  //     fullscreenDialog: true,
  //
  //     ),
  //   );
  // }



  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          initialCameraPosition: _initialCameraPosition,
          // onMapCreated: (controller) => _googleMapController = controller,
          onMapCreated: _onMapCreated,
          markers: _markers,
        ),
          Positioned(
            top: 60.0,
            left: 16.0,
            right: 16.0,
            child: GestureDetector(

              onTap: _onSearchTap,
              // onTap: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => SearchScreen()),
              //   );
              // },
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Search Restaurants Here',
                    fillColor: AppColors.cardLight,
                    filled: true,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // textInputAction: TextInputAction.search,
                ),
              ),
            ),
          ),
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
              bottom: 40,
              left: 0,
              right: 0,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child : ElevatedButton.icon(
                      onPressed: () {
                        _onMenuTap();
                      },
                      icon : const Icon(CupertinoIcons.group,size : 40),
                      label: const Text('Siku',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
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


          // Positioned(
          //   top: 100,
          //   left: 30,
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: TextFormField(
          //             onTap: (){
          //               // setState(() {
          //               //   pageIndex = 4;
          //               // });
          //               SearchScreen();
          //             }
          //         // ),
          //       ),
          //     ],
          //   ),
          // ),

          Positioned(
            bottom: 120,
            left: 30,

            child: FloatingActionButton(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              onPressed: _resetCameraPosition,
              // tooltip: 'Press the circle button',
              child: const Icon(Icons.center_focus_strong),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
          ),

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
      ]
      )
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

