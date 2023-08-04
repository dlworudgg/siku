import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:siku/screens/search_screen.dart';
import 'package:siku/theme.dart';
import '../components/saved_button.dart';
import '../models/open_ai_response.dart';
import '../pages/share_room_page.dart';
import '../widgets/avatar.dart';
import 'dart:ui';
import '../models/place_detail_response.dart';

class MapScreen extends StatefulWidget {
  final double? lat;
  final double? lng;
  final Result? placeDetail;
  // final ChatCompletionResponse? summary;


  const MapScreen(
      {Key? key, this.lat, this.lng, this.placeDetail
        // , this.summary
      })
      : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(40.71918288468455, -74.0415231837935),
    zoom: 14.5,
  );



  // var imageUrl = my_list.get('googleProfileImageUrl');
  final String googleMapKey = dotenv.get('GOOGLE_MAP_API_KEY');
  final String googleMapBrowserKey = dotenv.get('GOOGLE_MAP_BROWSER_API_KEY');
  late GoogleMapController _googleMapController;
  final Set<Marker> _markers = {};
  // Set<Marker> _markers = {};
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
            markerId: const MarkerId('selected_location'),
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
        .animateCamera(CameraUpdate.newCameraPosition(const CameraPosition(
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
            title: const Text('User Name'),
            // Replace 'User Name' with the actual user name
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Divider(color: Colors.grey),
                Row(
                  children: [
                    const Icon(Icons.logout, color: Colors.black),
                    // This is the prefix icon
                    const SizedBox(width: 10),
                    // Add some space between the icon and the button
                    TextButton(
                      child: const Text('Sign Out'),
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
          child: const SearchScreen(),
        );
      },
    );
  }

  void _onMenuTap() {

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // This allows the bottom sheet to expand to its full height
      builder: (BuildContext context) {
        return SafeArea(
          top: true,
          child: Container(
            decoration: const BoxDecoration(
              // color: Colors.transparent,
            ),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          // child: MessagesPage(),
          child: ShareRoomPage(),
        ),)
        ;
      },
    );
  }

  void _showPlaceDetail() {
    // ChatCompletionResponse GPTResponse = await processPlaceDetailAI(placeDetail);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // This allows you to control the size of the bottom sheet
      shape: const RoundedRectangleBorder(
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
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const TabBar(
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
                        // _buildInfoTab(),
                        // function that returns the widget for Summary tab
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

      },
    );
  }

  Widget _buildInfoTab() {
    // You can move the content you want for the Info tab from _showPlaceDetail method here
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          // wrap your Column in a SingleChildScrollView
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              Row(
                children: <Widget>[
                  // const SizedBox(width: 16),
                  Text(
                    widget.placeDetail?.name ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  // Rating
                  if (widget.placeDetail?.rating != null &&
                      widget.placeDetail?.rating != '')
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          widget.placeDetail?.rating.toString() ?? '',
                          style:
                          const TextStyle(color: Colors.black, fontSize: 13),
                        ),
                      ],
                    ),
                  const SizedBox(width: 4),

                  // Price Level
                  if (widget.placeDetail?.priceLevel != null &&
                      widget.placeDetail?.priceLevel != '')
                    Text(
                      '\$' *
                          int.parse(
                              widget.placeDetail!.priceLevel.toString()),
                      style:
                      TextStyle(color: Colors.grey[40], fontSize: 13),
                    ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                widget.placeDetail?.formattedAddress ?? '',
                style: const TextStyle(fontSize: 14),
              ),

              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      // Text(
                      //   _savedAIResponse['Cuisines/Styles'] ?? '',
                      //   style: const TextStyle(
                      //       fontSize: 17, fontWeight: FontWeight.normal),
                      // ),
                      // const SizedBox(width: 5.0),
                      // Text(
                      //   _savedAIResponse['Restaurant Type'] ?? '',
                      //   style: TextStyle(
                      //       fontSize: 14,
                      //       color: Colors.black.withOpacity(0.7)),
                      // ),
                    ]),
              ),
              // const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: Text(
                  widget.placeDetail?.editorialSummary?.overview ?? '',
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              const SizedBox(height: 15),
              const Divider(),

              //   if (widget.placeDetail != null)
            //     Row(
            //       children: [
            //         Expanded( // Make sure the Text widget does not overflow
            //           child: Text(
            //             widget.placeDetail!.name ?? '', // If name is null, use empty string
            //             style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            //           ),
            //         ),
            //         const SizedBox(width: 10), // Adds some spacing between the button and the name
            //         SaveButton(placeDetail: widget.placeDetail!),
            //       ],
            //     ),
            //   const SizedBox(height: 10),
            //   Text(
            //     widget.placeDetail!.formattedAddress ?? '',
            //     style: const TextStyle(fontSize: 18),
            //   ),
            // //   SizedBox(height: 10),
            // // for ( var review in widget.placeDetail!.reviews! ?? [])
            // //   Text(
            // //    review.text,
            // //     style: TextStyle(fontSize: 18),
            // //   ),
            //   const SizedBox(height: 10),
            //   for (var text in widget.placeDetail!.weekdayText ?? [])
            //     Text(
            //       text,
            //       style: const TextStyle(fontSize: 16),
            //     ),
            //   const SizedBox(height: 10),
            //   Row(
            //     children: [
            //       Text(
            //         widget.placeDetail!.rating != null
            //             ? widget.placeDetail!.rating!.toStringAsFixed(1)
            //             : "0", // Or any default value you'd like
            //         style: const TextStyle(fontSize: 18),
            //       ),
            //       const SizedBox(width: 10),
            //       ...List<Widget>.generate(5, (index) {
            //         return Icon(
            //           widget.placeDetail!.rating != null &&
            //                   index < widget.placeDetail!.rating!.round()
            //               ? Icons.star
            //               : Icons.star_border,
            //           // choose the icon based on the rating
            //           color: Colors.pink,
            //         );
            //       }),
            //     ],
            //   ),
            //   const SizedBox(height: 10),
            //   if (widget.placeDetail!.photosList?.photos?.isNotEmpty ?? false)
            //     SizedBox(
            //       height: 300,  // Adjust the height as required
            //       child: ListView.builder(
            //         scrollDirection: Axis.horizontal,
            //         itemCount: widget.placeDetail!.photosList!.photos!.length,
            //         itemBuilder: (context, index) {
            //           return Padding(
            //             padding: const EdgeInsets.only(right: 10),  // Adjust the spacing between images as required
            //             child: Image.network(
            //               'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${widget.placeDetail!.photosList!.photos![index].photoReference}&key=$googleMapBrowserKey',
            //               fit: BoxFit.cover,
            //             ),
            //           );
            //         },
            //       ),
            //     ),
            ],
          ),
        ),
      ),
          // if (widget.placeDetail != null)
          //   SaveButton(placeDetail: widget.placeDetail!),
        ]));
  }


  final _summaryTabVisited = ValueNotifier<bool>(false);
  Map<String, dynamic>? _savedAIResponse;

  @override
  void initState() {
    super.initState();
    _processDataInBackground();
  }
  void _processDataInBackground() async {

    if (widget.placeDetail == null) {
      return;
    }

    final doc = await FirebaseFirestore.instance.collection('PlacesReviewSummary').doc(widget.placeDetail!.placeId).get();
    if (doc.exists) {
      Map<String, dynamic> data  = doc.data() as Map<String, dynamic>;
      _savedAIResponse = {
        'Cuisines/Styles': data['Cuisines/Styles'] as String,
        'Restaurant Type': data['Restaurant Type'] as String,
        'Specialty Dishes': data['Specialty Dishes'] as String,
        'Strengths of the Restaurant': data['Strengths of the Restaurant'] as String,
        'Areas for Improvement': data['Areas for Improvement'] as String,
        'Overall Summary of the Restaurant': data['Overall Summary of the Restaurant'] as String,
              };
      _summaryTabVisited.value = true;
    } else {
      var result = await processPlaceDetailAI(widget.placeDetail!);
      if (result.choices.isNotEmpty) {
        _savedAIResponse = processText(result.choices[0].message.content ?? '');
        // print(widget.placeDetail!.placeId);
        FirebaseFirestore.instance.collection('PlacesReviewSummary').doc(widget.placeDetail!.placeId).set(_savedAIResponse!);

      }
    }
    _summaryTabVisited.value = true;
  }
  @override
  void dispose() {
    _summaryTabVisited.dispose();  // Dispose the ValueNotifier when not needed
    super.dispose();
  }

  Widget _buildSummaryTab() {
    return ValueListenableBuilder<bool>(
      valueListenable: _summaryTabVisited,
      builder: (context, value, child) {
        if (_savedAIResponse != null) {
          return buildResponseWidgets(_savedAIResponse!);
        }

        return const Center(
          child : SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              alignment: Alignment.center, // This centers the content inside the stack
              children: [
                CircularProgressIndicator(),
                Text('AI is Summarizing...'), // Your desired text
              ],
            )
          ),
        );
      },
    );
  }


  Widget buildResponseWidgets(Map<String, dynamic> _savedAIResponse) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          Row(
            children: <Widget>[
              // const SizedBox(width: 16),
              Text(
                widget.placeDetail?.name ?? '',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              // Rating
              if (widget.placeDetail?.rating != null &&
                  widget.placeDetail?.rating != '')
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.yellow, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      widget.placeDetail?.rating.toString() ?? '',
                      style:
                      const TextStyle(color: Colors.black, fontSize: 13),
                    ),
                  ],
                ),
              const SizedBox(width: 4),

              // Price Level
              if (widget.placeDetail?.priceLevel != null &&
                  widget.placeDetail?.priceLevel != '')
                Text(
                  '\$' *
                      int.parse(
                          widget.placeDetail!.priceLevel.toString()),
                  style:
                  TextStyle(color: Colors.grey[40], fontSize: 13),
                ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            widget.placeDetail?.formattedAddress ?? '',
            style: const TextStyle(fontSize: 14),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    _savedAIResponse['Cuisines/Styles'] ?? '',
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    _savedAIResponse['Restaurant Type'] ?? '',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.7)),
                  ),
                ]),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              widget.placeDetail?.editorialSummary?.overview ?? '',
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
          const SizedBox(height: 15),
          const Divider(),
          const SizedBox(height: 15),

          // Text(
          //   widget.placeDetail['editorialSummary'] ?? '',
          //   style: TextStyle(color: Colors.black, fontSize: 13),
          // ),
          const Text(
            "AI Reivew Summary",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'lib/images/Chef_Hat_Icon.png',
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(width: 3),
                      const Text(
                        "Specialty Dishes",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      _savedAIResponse['Specialty Dishes'] ?? '',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Image.asset(
                        'lib/images/Star_icon2.png',
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(width: 3),
                      const Text(
                        "Strengths of the Restaurant",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      _savedAIResponse[
                      'Strengths of the Restaurant'] ??
                          '',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Image.asset(
                        'lib/images/Sad_face_solid_icon.png',
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(width: 3),
                      const Text(
                        "Areas for Improvement",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      _savedAIResponse['Areas for Improvement'] ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Image.asset(
                        'lib/images/reader_icon.png',
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(width: 3),
                      const Text(
                        "Summary",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      _savedAIResponse[
                      'Overall Summary of the Restaurant'] ??
                          '',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ]),
          ),

          const SizedBox(height: 20),
        ],


          // const SizedBox(height: 10),
          // Text(
          //   widget.placeDetail!.name ?? '',
          //   // If name is null, use empty string
          //   style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          // ),
          //
          //       Text(
          //   _savedAIResponse['Cuisines/Styles']! ,
          //   style: TextStyle(fontSize: 18,color: Colors.black.withOpacity(0.8)),
          // ),
          // const SizedBox(height: 2),
          //           Text(
          //     _savedAIResponse['Restaurant Type']!,
          //     style: TextStyle(fontSize: 14,color: Colors.black.withOpacity(0.7)),
          //           ),
          //
          // const SizedBox(height: 10),
          // const Text(
          //   "Summary",
          //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          // ),
          // const SizedBox(height: 4),
          // Text(
          //   _savedAIResponse['Overall Summary of the Restaurant']!,
          //   style: TextStyle(fontSize: 16),
          // ),
          //
          // const SizedBox(height: 10),
          // const Text(
          //   "Specialty Dishes",
          //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          // ),
          // const SizedBox(height: 4),
          // Text(
          //   _savedAIResponse['Specialty Dishes']!,
          //   style: const TextStyle(fontSize: 16),
          // ),
          // const SizedBox(height: 10),
          // const Text(
          //   "Strengths of the Restaurant",
          //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          // ),
          // const SizedBox(height: 4),
          // Text(
          //   _savedAIResponse['Strengths of the Restaurant']!,
          //   style: TextStyle(fontSize: 16),
          // ),
          // const SizedBox(height: 10),
          // const Text(
          //   "Areas for Improvement",
          //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          // ),
          // const SizedBox(height: 4),
          // Text(
          //   _savedAIResponse['Areas for Improvement']!,
          //   style: const TextStyle(fontSize: 16),
          // ),
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
          child: AbsorbPointer(
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Search Restaurants Here',
                fillColor: AppColors.cardLight,
                filled: true,
                prefixIcon: Icon(
                    isMarkerOnMap ? Icons.arrow_back_ios : Icons.search,
                    color: isMarkerOnMap ? Colors.blue : Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
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
                    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ShareRoomPage()));

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
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            side: const BorderSide(
              width: 1.0,
              color: Colors.grey,
            ),
            elevation: 0,
          ),
          child: const Padding(
            padding: EdgeInsets.only(bottom: 7.3, top: 7.3),
            // Padding for the child widget
            child: Avatar.small(url : "lib/images/jae_logo_2.png",
            ),
                // url: Helpers.randomPictureUrl()
              // ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          // tooltip: 'Press the circle button',
          child: const Icon(Icons.center_focus_strong),
        ),
      ),
    ]));
  }

}
