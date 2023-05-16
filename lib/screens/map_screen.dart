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
import '../widgets/avatar.dart';
import '../widgets/glowing_action_button.dart';
import 'dart:ui';

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


  void _resetCameraPosition() {
    _googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target:  LatLng(40.7178, -74.0431),
      zoom: 14.5,
    )
    )
    );
  }


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


  // @override

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

