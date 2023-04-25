import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:siku/theme.dart';



class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);



  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _initialCameraPosition = CameraPosition(target: LatLng(40.7178, -74.0431),
    zoom : 11.5,
  );

  late GoogleMapController _googleMapController;
  @override
  void dispose(){
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const white = Color(0xFFB1B4C0);
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (controller) => _googleMapController = controller,
      ),
      floatingActionButton: FloatingActionButton(
          // backgroundColor: Theme.of(context).primaryColor,
          backgroundColor:Colors.white,
          foregroundColor: Colors.black,
          onPressed: () => _googleMapController.animateCamera(CameraUpdate.newCameraPosition(_initialCameraPosition)
          ),
          child : const Icon(Icons.center_focus_strong)
      ),
    );
  }
}
