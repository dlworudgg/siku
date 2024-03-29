import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:siku/pages/init_loading_page.dart';

import '../components/saved_button.dart';
import '../models/open_ai_response.dart';
import '../models/place_detail_response.dart';
import '../pages/share_room_page.dart';
import '../screens/map_screen.dart';
import '../screens/search_screen.dart';
import 'my_list_controller.dart';

class MapController extends GetxController {

  MapController( );


  //Google Maps Related
  Position? current_location;


  var _initialCameraPosition = CameraPosition(
    target: LatLng(40.71918288468455, -74.0415231837935),
    zoom: 14.5,
  ).obs;

  CameraPosition get initialCameraPosition => _initialCameraPosition.value;



  // Variables
  final String googleMapKey = dotenv.get('GOOGLE_MAP_API_KEY');
  final String googleMapBrowserKey = dotenv.get('GOOGLE_MAP_BROWSER_API_KEY');
  late GoogleMapController googleMapController;
  RxSet<Marker> markers = <Marker>{}.obs; // Using RxSet<Marker> for _markers
  var isSearchMarkerOnMap = false.obs; // Making it observable

  // final RxDouble lat = null.obs;
  final RxDouble lat = (40.71918288468455).obs;
  final RxDouble lng = (-74.0415231837935).obs;

  //Search Related
  // final Rx<double?> lat = (null).obs;
  // final Rx<double?> lng = (null).obs;
  var isSeached = false.obs;
  RxDouble deviceWidth = 0.0.obs;
  RxDouble deviceHeight = 0.0.obs;

  void setDeviceSize(BuildContext context) {
    deviceWidth.value = MediaQuery.of(context).size.width;
    deviceHeight.value = MediaQuery.of(context).size.height;
  }

  //Share List Related
  // var isExpanded = false.obs; // Making it observable
  var items = [Item(
    id :'sss',
      // id:  FirebaseAuth.instance.currentUser!.uid,
      name: 'My Saved Restaurants',
      isSavedList: true,
      image: 'lib/images/jae_logo_2.png',
      userNumber: '1'),
    Item(
        id: 'hiXr7lr8IwGWAGRMuHRN',
        name: "Jae, SuHyun's List",
        isSavedList: false,
        image: 'lib/images/jae_jae_logo.png',
        userNumber: '2')
  ];
  // final dragController = ScrollController(); // Assuming you have this controller initialized
  // final DraggableScrollableController dragController = DraggableScrollableController();

  //PlaceDetail Related
  Map<String, dynamic>? savedAIResponse;

  Rx<Result?> placeDetail = (null as Result?).obs;
  var doesSummary = false.obs;


  var selectedIndexes = <int>[].obs;

  List<Color?> primaryColors = [
    Colors.red[300],
    Colors.blue[300],
    Colors.green[300],
    Colors.yellow[300],
    Colors.orange[300],
    Colors.purple[300],
    Colors.brown[300],
    Colors.teal[300]
  ];
  var cuisinesStylesSet = <String>{};
  List cuisinesStylesList = [];

  // List<String> cuisines = [
  //   "Korean", "Japanese", "Chinese", "American", "Italian", "French", "Mexican", "Mediterranean"
  // ];
  //
  // List<double> widthList = [
  //   100, 120, 110, 120, 100, 100, 110, 160
  // ];
  var buttonWidths = <double>[];
  Map<String, Color?> cuisineColorMap = {};


  // var myListBox = Rx<Box?>(null);
  // var aIListBox = Rx<Box?>(null);
  Box? myListBox;
  Box? aIListBox;
  // final ListController = Get.put(MyListController());
  // double colorToHue(Color? color) {
  //   if (color == null) {
  //     return 0.0;
  //   }
  //   HSLColor hslColor = HSLColor.fromColor(color);
  //   HSLColor hslWithNewLightness = hslColor.withLightness(0.7);
  //   return hslColor.hue;
  // }
  Color adjustLightness(Color color) {
    HSLColor hslColor = HSLColor.fromColor(color);
    HSLColor hslWithNewLightness = hslColor.withLightness(0.2);
    return hslWithNewLightness.toColor();
  }

  // BitmapDescriptor createLighterMarkerIcon(Color color) {
  //   Color lighterColor = adjustLightness(color);
  //   return BitmapDescriptor.defaultMarkerWithHue(
  //     HSLColor.fromColor(lighterColor).hue,
  //   );
  // }
  BitmapDescriptor createMarkerIconFromColor(Color color) {
    return BitmapDescriptor.defaultMarkerWithHue(
      HSLColor.fromColor(color).hue,
    );
  }

  Future<void> onInit() async {
    super.onInit();


    // Open the Hive boxes or use the existing opened boxes
    if (Hive.isBoxOpen('placeDetails')) {
      myListBox = Hive.box('placeDetails');
    } else {
      myListBox = await Hive.openBox('placeDetails');
    }
    if (Hive.isBoxOpen('placeDetails_AISummary')) {
      aIListBox = Hive.box('placeDetails_AISummary');
    } else {
      aIListBox = await Hive.openBox('placeDetails_AISummary');
    }

    String otherCategory = 'Other';
    int otherIndex = -1;

    final placeDetailKeys = myListBox?.keys.toList() ?? [];

    for (var key in placeDetailKeys) {
      var markwrAiDetails = aIListBox?.get(key);
      var markerplaceDetail = myListBox?.get(key);

      String? cuisinesStyles = markerplaceDetail?['cuisines/styles'];

      if (cuisinesStyles == null) {
        cuisinesStyles = markwrAiDetails?['Cuisines/Styles'];
      }

      if (cuisinesStyles == "N/A") {
        cuisinesStyles = "Other";
      }

      if (cuisinesStyles != null) {
        cuisinesStylesSet.add(cuisinesStyles);
      }
    }

    // Populate cuisineColorMap and selectedIndexes based on cuisinesStylesSet
    cuisinesStylesList = cuisinesStylesSet.toList();

    for (int i = 0; i < cuisinesStylesList.length; i++) {
      if (cuisinesStylesList[i] == otherCategory) {
        otherIndex = i; // Save the index of "Other" category
        continue; // Skip the "Other" category for now
      }

      cuisineColorMap[cuisinesStylesList[i]] = primaryColors[i % primaryColors.length]; // Use modulo to avoid index out of bounds
      selectedIndexes.add(i);
    } if (otherIndex != -1) {
      // Move "Other" category and corresponding values to the end
      cuisinesStylesList.add(cuisinesStylesList.removeAt(otherIndex));
      selectedIndexes.add(otherIndex);
      cuisineColorMap[otherCategory] = primaryColors[otherIndex % primaryColors.length]; // Use modulo to avoid index out of bounds
    }

    // for (int i = 0; i < cuisinesStylesList.length; i++) {
    //   cuisineColorMap[cuisinesStylesList[i]] = primaryColors[i];
    //   selectedIndexes.add(i);
    // }

    // Populate buttonWidths based on cuisinesStylesList
    for (String style in cuisinesStylesList) {
      double width = 100; // Default value
      if (style.length > 5) {
        width = 100 + ((style.length - 5) * 10);
      }
      buttonWidths.add(width);
    }

    // Create markers
    for (var key in placeDetailKeys) {
      var markerplaceDetail = myListBox?.get(key);
      var markwrAiDetails = aIListBox?.get(key);

      final lat = markerplaceDetail['geometry']['lat'];
      final lng = markerplaceDetail['geometry']['lng'];
      // final cuisinesStyles = markwrAiDetails['Cuisines/Styles'];
      String? cuisinesStyles = markerplaceDetail?['cuisines/styles'];

      cuisinesStyles ??= markwrAiDetails?['Cuisines/Styles'];

      if (cuisinesStyles == "N/A") {
        cuisinesStyles = "Other";
      }

      final markerColor = cuisineColorMap[cuisinesStyles];

      // final markerHue = adjustLightness(colorToHue(markerColor));
      // final markerHue = adjustLightness(markerColor);
      //
      // print(" ");
      // print(cuisinesStyles);
      // print(markerColor);
      // print(adjustLightness(markerColor!));

      final markerId = key + '_' + cuisinesStyles;
      if (markerColor != null) {
        final marker = Marker(
          markerId: MarkerId(markerId),
          position: LatLng(lat, lng),
          icon: createMarkerIconFromColor(markerColor),
          infoWindow: InfoWindow(
            title: (markerplaceDetail?["Name"] ?? "Unknown Name") + ": " + (cuisinesStyles ?? "Unknown Style"),
          ),
          // icon: createLighterMarkerIcon(markerColor),
        );
        markers.add(marker);
        allMarkers.add(marker);
      }
    }
  }



  //
  // void toggleSelection(int index) {
  //   if (selectedIndexes.contains(index)) {
  //     selectedIndexes.remove(index);
  //   } else {
  //     selectedIndexes.add(index);
  //   }
  // }
  void toggleSelection(int index) {
    if (selectedIndexes.contains(index)) {
      selectedIndexes.remove(index);
      // removeMarkersForCuisine(cuisines[index]);
      removeMarkersForCuisine(cuisinesStylesList[index]);
    } else {
      selectedIndexes.add(index);
      // addMarkersForCuisine(cuisines[index]);
      addMarkersForCuisine(cuisinesStylesList[index]);
    }
  }

  void removeMarkersForCuisine(String cuisine) {
    // print(cuisine);
    var idsToRemove = markers
        .where((marker) => marker.markerId.value.contains(cuisine))
        .map((marker) => marker.markerId)
        .toList();

    idsToRemove.forEach((id) {
      markers.removeWhere((marker) => marker.markerId == id);
    });
  }
  final allMarkers = <Marker>[]; // This list holds all the markers

  void addMarkersForCuisine(String cuisine) {
    var markersToAdd = allMarkers
        .where((marker) => marker.markerId.value.contains(cuisine))
        .toList();

    markers.addAll(markersToAdd);
  }
  //sign-in and out
  void showSignOutDialog(BuildContext context) {
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
                          FirebaseAuth.instance.signOut();
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


  //Searchingn


  void onSearchTap() {
    Get.to(() => const SearchScreen(),
        // transition: Transition.downToUp
    );
    // Get.bottomSheet(
    //   Container(
    //     constraints: BoxConstraints(
    //       maxHeight: Get.size.height,  // using Get.size.height instead of MediaQuery
    //       maxWidth: Get.size.width,    // using Get.size.width instead of MediaQuery
    //     ),
    //     child: const SearchScreen(),
    //   ),
    //   isScrollControlled: true,
    // );
  }

  void onShareListTap(){
    Get.to(() => ShareRoomPage(),
        transition: Transition.downToUp,
        // duration: Duration(seconds: 0),
    );
  }

  void resetMarkerOnMap() {
      isSearchMarkerOnMap.value = false; // reset isMarkerOnMap to false when markers are reset
      markers.removeWhere((marker) => marker.markerId.value == 'selected_location');
      // markers.clear(); // clear all markers from the set
      doesSummary.value = false;
  }


  void showPlaceDetail() {
    showModalBottomSheet(
      context: Get.context!,
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
                      Tab(text: 'Info'), // name the tabs as you wish
                      Tab(text: 'Summary'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        buildInfoTab(),
                        // function that returns the widget for Info tab
                        buildSummaryTab(),
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

  void afterSearched(Result selectedDetail) {
    Get.back();
    // Get.to(() => MapScreen(),);
    lat.value = selectedDetail.geometry?.location?.lat ?? 40.71918288468455;
    lng.value = selectedDetail.geometry?.location?.lng ?? (-74.0415231837935);

    _onSearchToMap(googleMapController);
    // _processDataInBackground();
    showPlaceDetail();
  }


  Widget buildInfoTab() {
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
                        placeDetail.value?.name ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      // Rating
                      if (placeDetail.value?.rating != null &&
                          placeDetail.value?.rating != '')
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.yellow, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              placeDetail.value?.rating.toString() ?? '',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 13),
                            ),
                          ],
                        ),
                      const SizedBox(width: 4),

                      // Price Level
                      if (placeDetail.value?.priceLevel != null &&
                          placeDetail.value?.priceLevel != '')
                        Text(
                          '\$' *
                              int.parse(placeDetail.value!.priceLevel.toString()),
                          style: TextStyle(color: Colors.grey[40], fontSize: 13),
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    placeDetail.value?.formattedAddress ?? '',
                    style: const TextStyle(fontSize: 14),
                  ),

                  const SizedBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                        ]),
                  ),
                  // const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: Text(
                      placeDetail.value?.editorialSummary?.overview ?? '',
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SaveButton(),
                  const SizedBox(height: 15),
                  const Divider(),
                ],
              ),
            ),
          ),
          // if (widget.placeDetail != null)
          //   SaveButton(placeDetail: widget.placeDetail!),
        ]));
  }

  Widget buildSummaryTab() {
    return Obx(
          () {
        if (doesSummary.isTrue) {
          return buildResponseWidgets(savedAIResponse!);
        } else {
          _processDataInBackground();

        }
        return const Center(
          // child: SizedBox(
          //   width: 200,
          //   height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, // This centers the content inside the stack
              children: [
                CircularProgressIndicator(),
                Text('AI is Summarizing...'), // Your desired text
              ],
            ),
          // ),
        );
      },
    );
  }


  Widget buildResponseWidgets(Map<String, dynamic> _savedAIResponse) {
    // final mapController = Get.find<MapController>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          Row(
            children: <Widget>[
              // const SizedBox(width: 16),
              Text(
                placeDetail.value?.name ?? '',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              // Rating
              if (placeDetail.value?.rating != null &&
                  placeDetail.value?.rating != '')
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.yellow, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      placeDetail.value?.rating.toString() ?? '',
                      style: const TextStyle(color: Colors.black, fontSize: 13),
                    ),
                  ],
                ),
              const SizedBox(width: 4),

              // Price Level
              if (placeDetail.value?.priceLevel != null &&
                  placeDetail.value?.priceLevel != '')
                Text(
                  '\$' *
                      int.parse(
                          placeDetail.value!.priceLevel.toString()),
                  style: TextStyle(color: Colors.grey[40], fontSize: 13),
                ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            placeDetail.value?.formattedAddress ?? '',
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
                        fontSize: 14, color: Colors.black.withOpacity(0.7)),
                  ),
                ]),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              placeDetail.value?.editorialSummary?.overview ?? '',
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
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
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
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  _savedAIResponse['Strengths of the Restaurant'] ?? '',
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
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
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
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  _savedAIResponse['Overall Summary of the Restaurant'] ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ]),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }



  void _onSearchToMap(GoogleMapController controller) {
    double? currentLatitude = lat.value;
    double? currentLongitude = lng.value;

    googleMapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(currentLatitude! - 0.012, currentLongitude!),
        14.5,
      ),
    );

    markers.add(
      Marker(
        markerId: const MarkerId('selected_location'),
        position: LatLng(currentLatitude , currentLongitude),
      ),
    );
    isSearchMarkerOnMap.value = true;
    // showPlaceDetail();
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      lat.value = position.latitude;
      lng.value = position.longitude;

      // Update _initialCameraPosition using current location
      _initialCameraPosition.value = CameraPosition(
        target: LatLng(lat.value, lng.value),
        zoom: 14.5,
      );

    } catch (error) {
      print("Error getting location: $error");
    }
  }
  Future<void> resetCameraPosition() async {
    await getCurrentLocation();
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat.value, lng.value),
      zoom: 14.5,
    )));
    // isMarkerOnMap.value = false;
  }



  //processing OPEN AI Review Summary



  Future<void> _processDataInBackground() async {

      Result? currentPlaceDetail = placeDetail.value;
      var result = await processPlaceDetailAI(currentPlaceDetail!);
      if (result.choices.isNotEmpty) {
        savedAIResponse = processText(result.choices[0].message.content ?? '');
        await FirebaseFirestore.instance
            .collection('PlacesReviewSummary')
            .doc(currentPlaceDetail.placeId)
            .set(savedAIResponse!);
      }
      doesSummary.value = true;
  }


  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }


  // void toggleSheet() {
  //   if (isExpanded.value) {
  //     dragController.animateTo(0.01,
  //         duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  //   } else {
  //     dragController.animateTo(0.9,
  //         duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  //   }
  //
  //   isExpanded.value = !isExpanded.value;
  //   // update();  // This will refresh any widgets that are bound to _isExpanded
  // }

}
