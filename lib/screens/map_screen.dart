import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:siku/screens/search_screen.dart';
import 'package:siku/theme.dart';
import '../helpers.dart';
import '../models/autocomplete_prediction.dart';
import '../pages/messaging_page.dart';
import '../pages/my_list.dart';
import '../services/auth_service.dart';
import '../widgets/avatar.dart';
import '../widgets/glowing_action_button.dart';
import 'dart:ui';
import 'package:hive_flutter/hive_flutter.dart';

class MapScreen extends StatefulWidget {
  final double? lat;
  final  double? lng;

  const MapScreen({Key? key, this.lat, this.lng}) : super(key: key);


  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(40.7178, -74.0431),
    zoom: 14.5,
  );


  // var imageUrl = my_list.get('googleProfileImageUrl');

  late GoogleMapController _googleMapController;
  Set<Marker> _markers = {};
  bool isMarkerOnMap = false;

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
        isMarkerOnMap = true; // set isMarkerOnMap to true when a marker is added
      });
    }
  }


  void _resetCameraPosition() {
    _googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target:  LatLng(40.7178, -74.0431),
      zoom: 14.5,
    )
    )
    );
    setState(() {
      isMarkerOnMap = false; // reset isMarkerOnMap to false when camera position is reset
    });
  }

  void _resetMarkerOnMap() {
    setState(() {
      isMarkerOnMap = false; // reset isMarkerOnMap to false when markers are reset
      _markers.clear(); // clear all markers from the set
    });
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('User Name'), // Replace 'User Name' with the actual user name
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Divider(color: Colors.grey),
                Row(
                  children: [
                    Icon(Icons.logout, color: Colors.black), // This is the prefix icon
                    SizedBox(width: 10), // Add some space between the icon and the button
                    TextButton(
                      child: Text('Sign Out'),
                      onPressed: () {
                        signUserOut();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        }
    );
  }
  /////////

  // AuthService authService = AuthService.instance;
  // String? imageUrl; // Ensure this line is present to declare imageUrl
  //
  // @override
  // void initState() {
  //   super.initState();
  //   loadProfileImage();
  // }
  // void loadProfileImage() async {
  //   imageUrl = await AuthService.instance.getProfileImageUrl();
  //   setState(() {});
  // }
  // /////////


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
            // right: 16.0,
            right: 50.0,
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
                    prefixIcon: Icon(isMarkerOnMap ? Icons.arrow_back_ios : Icons.search, color: isMarkerOnMap ? Colors.blue : Colors.grey),
                    // suffixIcon: GestureDetector(
                    //   onTap: () {
                    //     print("1");
                    //     // Action to be performed when the profile button is tapped.
                    //     // You can navigate to a new page or open a dialog/modal bottom sheet
                    //   },
                    //   child: Avatar.small(url: Helpers.randomPictureUrl()),
                    // ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      // borderSide: BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // textInputAction: TextInputAction.search,
                ),
              ),
            ),
          ),



          Positioned(
            top: 60.0,
            left: 370.0,
            right: 16.0,
            child: GestureDetector(

              onTap: _resetMarkerOnMap,
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    fillColor: AppColors.cardLight,
                    filled: true,
                    prefixIcon: Icon(isMarkerOnMap ? Icons.close : Icons.search, color: isMarkerOnMap ? Colors.grey : Colors.transparent),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      // borderSide: BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // textInputAction: TextInputAction.search,
                ),
              ),
            ),
          ),

          Positioned(
              bottom: 40,
              left: 10,
              right: 0,
              child: Padding(
                  // padding: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.only(left: 16.0, right: 110.0, bottom: 16.0),
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

          Positioned(
            bottom: 56,
            right: 30,
            child: ElevatedButton(
              onPressed: () => _showSignOutDialog(context),
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
      ]
      )
    );
  }
}

