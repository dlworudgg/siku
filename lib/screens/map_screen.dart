import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:siku/screens/search_screen.dart';
import 'package:siku/theme.dart';
import '../constants.dart';
import '../helpers.dart';
import '../models/open_ai_response.dart';
import '../pages/messaging_page.dart';
import '../widgets/avatar.dart';
import 'dart:ui';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/place_detail_response.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MapScreen extends StatefulWidget {
  final double? lat;
  final double? lng;
  final Result? placeDetail;
  final ChatCompletionResponse? summary;

  const MapScreen(
      {Key? key, this.lat, this.lng, this.placeDetail
        , this.summary
      })
      : super(key: key);

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
          LatLng(widget.lat! - 0.012, widget.lng!),
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
        isMarkerOnMap =
            true; // set isMarkerOnMap to true when a marker is added
      });
      _showPlaceDetail();
    }
  }

  void _resetCameraPosition() {
    _googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(40.7178, -74.0431),
      zoom: 14.5,
    )));
    setState(() {
      isMarkerOnMap =
          false; // reset isMarkerOnMap to false when camera position is reset
    });
  }

  void _resetMarkerOnMap() {
    setState(() {
      isMarkerOnMap =
          false; // reset isMarkerOnMap to false when markers are reset
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
            title: Text('User Name'),
            // Replace 'User Name' with the actual user name
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Divider(color: Colors.grey),
                Row(
                  children: [
                    Icon(Icons.logout, color: Colors.black),
                    // This is the prefix icon
                    SizedBox(width: 10),
                    // Add some space between the icon and the button
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
        });
  }

  void _onSearchTap() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // This allows the bottom sheet to expand to its full height
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
      isScrollControlled: true,
      // This allows the bottom sheet to expand to its full height
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: MessagesPage(),
        );
      },
    );
  }

  void _showPlaceDetail() {
    // ChatCompletionResponse GPTResponse = await processPlaceDetailAI(placeDetail);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // This allows you to control the size of the bottom sheet
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          // This allows the bottom sheet to take up 60% of the screen
          child: DefaultTabController(
            length: 2, // number of tabs
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  TabBar(
                    indicatorColor: Colors.black,
                    tabs: [
                      Tab(text:'Info'), // name the tabs as you wish
                      Tab(text: 'Summary'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildInfoTab(),
                        // function that returns the widget for Info tab
                        _buildSummaryTab(),
                        // function that returns the widget for Summary tab
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // String restaurantInfo = processText(widget.summary.choices?[0].message.content);
        // return FractionallySizedBox(
        //   heightFactor: 0.7,
        //   // This allows the bottom sheet to take up 60% of the screen
        //   child: Container(
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.only(
        //         topLeft: Radius.circular(25),
        //         topRight: Radius.circular(25),
        //       ),
        //     ),
        //     padding: EdgeInsets.all(20),
        //     child: SingleChildScrollView( // wrap your Column in a SingleChildScrollView
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Text(
        //             widget.placeDetail!.name ?? '',
        //             // If name is null, use empty string
        //             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        //           ),
        //
        //           SizedBox(height: 10),
        //           Text(
        //             widget.placeDetail!.formattedAddress ?? '',
        //             style: TextStyle(fontSize: 18),
        //           ),
        //           SizedBox(height: 10),
        //           // for (var text in widget.placeDetail!.weekdayText ?? [])
        //           //   Text(
        //           //     text,
        //           //     style: TextStyle(fontSize: 16),
        //           //   ),
        //           Text(
        //             processText(widget.summary?.choices?[0].message.content ?? ''),
        //                 style: TextStyle(fontSize: 16),
        //           ),
        //           SizedBox(height: 10),
        //           Row(
        //             children: [
        //               Text(
        //                 widget.placeDetail!.rating != null
        //                     ? widget.placeDetail!.rating!.toStringAsFixed(1)
        //                     : "0", // Or any default value you'd like
        //                 style: TextStyle(fontSize: 18),
        //               ),
        //
        //               SizedBox(width: 10),
        //               ...List<Widget>.generate(5, (index) {
        //                 return Icon(
        //                   widget.placeDetail!.rating != null &&
        //                       index < widget.placeDetail!.rating!.round()
        //                       ? Icons.star
        //                       : Icons.star_border,
        //                   // choose the icon based on the rating
        //                   color: Colors.pink,
        //                 );
        //               }),
        //             ],
        //           ),
        //           SizedBox(height: 10),
        //           // if (widget.place_detail!.photos.isNotEmpty)
        //           //   Image.network(
        //           //     'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${widget.place_detail!.photos[0]}&key=$googleMapKey',
        //           //     fit: BoxFit.cover,
        //           //   ),
        //           // if (widget.place_detail!.photosList?.photos?.isNotEmpty ?? false)
        //           //   SizedBox(
        //           //     height: 200,  // You can adjust the size of the image slider here
        //           //     child: PageView.builder(
        //           //       itemCount: widget.place_detail!.photosList?.photos?.length ?? 0,
        //           //       itemBuilder: (context, index) {
        //           //         return widget.place_detail!.photosList?.photos?[index] != null
        //           //             ? Image.network(
        //           //           'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${widget.place_detail!.photosList?.photos?[index]}&key=$googleMapKey',
        //           //           fit: BoxFit.cover,
        //           //         )
        //           //             : Container(); // or any placeholder widget
        //           //       },
        //           //     ),
        //           //   ),
        //           if (widget.placeDetail!.photosList?.photos?.isNotEmpty ??
        //               false)
        //             SizedBox(
        //                 height: 400,
        //                 // You can adjust the size of the image slider here
        //                 child: GridView.custom(
        //                   gridDelegate: SliverQuiltedGridDelegate(
        //                     crossAxisCount: 4,
        //                     mainAxisSpacing: 4,
        //                     crossAxisSpacing: 2,
        //                     repeatPattern: QuiltedGridRepeatPattern.inverted,
        //                     pattern: [
        //                       QuiltedGridTile(2, 2),
        //                       QuiltedGridTile(1, 1),
        //                       QuiltedGridTile(1, 1),
        //                       QuiltedGridTile(1, 2),
        //                       QuiltedGridTile(2, 2),
        //                       QuiltedGridTile(1, 1),
        //                       QuiltedGridTile(1, 1),
        //                     ],
        //                   ),
        //                   //       itemBuilder:
        //                   childrenDelegate: SliverChildBuilderDelegate(
        //                         (context, index) {
        //                       if (index < widget.placeDetail!.photosList!.photos!.length) {
        //                         final photo = widget.placeDetail!.photosList!.photos![index].photoReference;
        //                         final height = widget.placeDetail!.photosList!.photos![index].height;
        //                         final width = widget.placeDetail!.photosList!.photos![index].width;
        //                         return Image.network(
        //                           // 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=$width&maxheight=$height&photoreference=$photo&key=$googleMapKey',
        //                           'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photo&key=$googleMapKey',
        //                           fit: BoxFit.cover,
        //                         );
        //                       }
        //                     },
        //                   ),
        //                 )
        //               // child: PageView.builder(
        //               //   itemCount: widget.place_detail!.photosList!.photos!.length,
        //               //   itemBuilder: (context, index) {
        //               //     final photo = widget.place_detail!.photosList!.photos![index].photoReference;
        //               //     final height = widget.place_detail!.photosList!.photos![index].height;
        //               //     final width = widget.place_detail!.photosList!.photos![index].width;
        //               //     return Image.network(
        //               //       'https://maps.googleapis.com/maps/api/place/photo?maxwidth=$width&maxheight=$height&photoreference=$photo&key=$googleMapKey',
        //               //       fit: BoxFit.cover,
        //               //     );
        //               //   },
        //               // ),
        //             ),
        //
        //         ],
        //       ),
        //     ),
        //   ),
        // );
      },
    );
  }

  Widget _buildInfoTab() {
    // You can move the content you want for the Info tab from _showPlaceDetail method here
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          // wrap your Column in a SingleChildScrollView
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.placeDetail!.name ?? '',
                // If name is null, use empty string
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                widget.placeDetail!.formattedAddress ?? '',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              for (var text in widget.placeDetail!.weekdayText ?? [])
                Text(
                  text,
                  style: TextStyle(fontSize: 16),
                ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    widget.placeDetail!.rating != null
                        ? widget.placeDetail!.rating!.toStringAsFixed(1)
                        : "0", // Or any default value you'd like
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(width: 10),
                  ...List<Widget>.generate(5, (index) {
                    return Icon(
                      widget.placeDetail!.rating != null &&
                              index < widget.placeDetail!.rating!.round()
                          ? Icons.star
                          : Icons.star_border,
                      // choose the icon based on the rating
                      color: Colors.pink,
                    );
                  }),
                ],
              ),
              SizedBox(height: 10),
              if (widget.placeDetail!.photosList?.photos?.isNotEmpty ?? false)
                SizedBox(
                    height: 400,
                    // You can adjust the size of the image slider here
                    child: GridView.custom(
                      gridDelegate: SliverQuiltedGridDelegate(
                        crossAxisCount: 4,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 2,
                        repeatPattern: QuiltedGridRepeatPattern.inverted,
                        pattern: [
                          QuiltedGridTile(2, 2),
                          QuiltedGridTile(1, 1),
                          QuiltedGridTile(1, 1),
                          QuiltedGridTile(1, 2),
                          QuiltedGridTile(2, 2),
                          QuiltedGridTile(1, 1),
                          QuiltedGridTile(1, 1),
                        ],
                      ),
                      //       itemBuilder:
                      childrenDelegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index <
                              widget.placeDetail!.photosList!.photos!.length) {
                            final photo = widget.placeDetail!.photosList!
                                .photos![index].photoReference;
                            final height = widget
                                .placeDetail!.photosList!.photos![index].height;
                            final width = widget
                                .placeDetail!.photosList!.photos![index].width;
                            return Image.network(
                              // 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=$width&maxheight=$height&photoreference=$photo&key=$googleMapKey',
                              'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photo&key=$googleMapKey',
                              fit: BoxFit.cover,
                            );
                          }
                        },
                      ),
                    )),
            ],
          ),
        ),
      ),
    ]));
  }

  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            processText(widget.summary?.choices[0].message.content ?? ''),
            style: TextStyle(fontSize: 16),
          ),
          // add more widgets here if needed
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      GoogleMap(
        mapType: MapType.normal,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: _initialCameraPosition,
        // onMapCreated: (controller) => _googleMapController = controller,
        onMapCreated: _onMapCreated,
        markers: _markers,
        // onMarkerTapped: _onMarkerTapped,
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
                prefixIcon: Icon(
                    isMarkerOnMap ? Icons.arrow_back_ios : Icons.search,
                    color: isMarkerOnMap ? Colors.blue : Colors.grey),
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
                prefixIcon: Icon(isMarkerOnMap ? Icons.close : Icons.search,
                    color: isMarkerOnMap ? Colors.grey : Colors.transparent),
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
              padding:
                  const EdgeInsets.only(left: 16.0, right: 110.0, bottom: 16.0),
              child: ElevatedButton.icon(
                  onPressed: () {
                    _onMenuTap();
                  },
                  icon: const Icon(CupertinoIcons.group, size: 40),
                  label: const Text('Siku',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                      ))))),
      Positioned(
        bottom: 56,
        right: 30,
        child: ElevatedButton(
          onPressed: () => _showSignOutDialog(context),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: AppColors.cardLight,
            // foreground color
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
            padding: const EdgeInsets.only(bottom: 7.3, top: 7.3),
            // Padding for the child widget
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
    ]));
  }
}
