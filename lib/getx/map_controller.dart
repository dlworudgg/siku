import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';

import '../models/open_ai_response.dart';
import '../models/place_detail_response.dart';
import '../pages/share_room_page.dart';

class MapController extends GetxController {

  final Function(BuildContext context) showPlaceDetailCallback;
  // final Function buildInfoTabCallback;
  // final Function buildSummaryTabCallback;

  MapController(this.showPlaceDetailCallback,
      // required this.buildInfoTabCallback,
      // required this.buildSummaryTabCallback
      );


  static const _initialCameraPosition = CameraPosition(
    target: LatLng(40.71918288468455, -74.0415231837935),
    zoom: 14.5,
  );

  static CameraPosition get initialCameraPosition => _initialCameraPosition;

  // Variables
  final String googleMapKey = dotenv.get('GOOGLE_MAP_API_KEY');
  final String googleMapBrowserKey = dotenv.get('GOOGLE_MAP_BROWSER_API_KEY');
  late GoogleMapController googleMapController;
  RxSet<Marker> markers = <Marker>{}.obs; // Using RxSet<Marker> for _markers
  var isMarkerOnMap = false.obs; // Making it observable
  var isExpanded = false.obs; // Making it observable
  var items = [].obs;
  final RxDouble lat = (40.71918288468455).obs;
  final RxDouble lng = (-74.0415231837935).obs;




  Map<String, dynamic>? savedAIResponse;

  Rx<Result?> placeDetail = (null as Result?).obs;


  @override
  void onInit() {
    super.onInit();
    _addSavedRoomList();

    ever(lat, (_) => _onSearchToMap(googleMapController));
    ever(lng, (_) => _onSearchToMap(googleMapController));

    ever(placeDetail, (_) => _processDataInBackground());

  }


  //Initiating Share List for just now. This should be replaced with process of getting data from firebase
  Future<void> _addSavedRoomList() async {
    Item savedPlaceItem = Item(
        id: FirebaseAuth.instance.currentUser!.uid,
        name: 'My Saved Restaurants',
        isSavedList: true,
        image: 'lib/images/jae_logo_2.png',
        userNumber: '1');

    final share_box = await Hive.openBox('ShareRoom');
    var value = share_box.get(0);

    items.add(savedPlaceItem);
    items.add(Item(
        id: 'hiXr7lr8IwGWAGRMuHRN',
        name: "Jae, SuHyun's List",
        isSavedList: false,
        image: 'lib/images/jae_jae_logo.png',
        userNumber: '2'));
  }


  void _onSearchToMap(GoogleMapController controller) {
    double currentLatitude = lat.value;
    double currentLongitude = lat.value;

    googleMapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(currentLatitude  - 0.012, currentLongitude),
        14.5,
      ),
    );

    markers.add(
      Marker(
        markerId: const MarkerId('selected_location'),
        position: LatLng(currentLatitude , currentLongitude),
      ),
    );
    isMarkerOnMap.value = true;
    showPlaceDetailCallback(Get.context!);
  }


  //processing OPEN AI Review Summary
  Future<void> _processDataInBackground() async {
    Result? currentPlaceDetail = placeDetail.value;
      final doc = await FirebaseFirestore.instance
          .collection('PlacesReviewSummary')
          .doc(currentPlaceDetail!.placeId)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        savedAIResponse = {
          'Cuisines/Styles': data['Cuisines/Styles'] as String,
          'Restaurant Type': data['Restaurant Type'] as String,
          'Specialty Dishes': data['Specialty Dishes'] as String,
          'Strengths of the Restaurant':
          data['Strengths of the Restaurant'] as String,
          'Areas for Improvement': data['Areas for Improvement'] as String,
          'Overall Summary of the Restaurant':
          data['Overall Summary of the Restaurant'] as String,
        };
      } else {
        var result = await processPlaceDetailAI(currentPlaceDetail);
        if (result.choices.isNotEmpty) {
          savedAIResponse = processText(result.choices[0].message.content ?? '');
          await FirebaseFirestore.instance
              .collection('PlacesReviewSummary')
              .doc(currentPlaceDetail.placeId)
              .set(savedAIResponse!);
        }
      }
  }




}