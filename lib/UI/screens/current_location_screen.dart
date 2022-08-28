import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:geocoding/geocoding.dart';
import '../../constant/colors.dart';
import '../../constant/strings.dart';
import '../widgets/text_button.dart';

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({Key? key}) : super(key: key);

  @override
  _CurrentLocationScreenState createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  late GoogleMapController googleMapController;

  static const CameraPosition initialCameraPosition = CameraPosition(target: LatLng(30.033333, 31.233334), zoom: 14);

  Set<Marker> markers = {};

  Position? position;

  String? address;

  Placemark? location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User current location"),
        centerTitle: true,
        backgroundColor: textColor,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialCameraPosition,
            markers: markers,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0,top: 18),
            child: MyButtonWidget(
                btnTxt: 'Get Location Weather',
                btnWidth: 90.w,
                btnHeight: 6.h,
                onPressed: () {
                  Navigator.pushNamed(context, weather, arguments: position == null ? 'cairo' : location!.country);
                },
                color: buttonColor,
                borderColor: buttonColor,
                weight: FontWeight.w600,
                textSize: 14.sp,
                textColor: whiteColor),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          position = await _determinePosition();

          googleMapController
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position!.latitude, position!.longitude), zoom: 14)));


          markers.clear();

          markers.add(Marker(markerId: const MarkerId('currentLocation'),position: LatLng(position!.latitude, position!.longitude)));

          location = await getCountry();

          setState(() {});

        },
        label: const Text("Current Location"),
        icon: const Icon(Icons.location_history),
      ),
    );
  }

  Future<Placemark> getCountry() async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(
        position!.latitude, position!.longitude);
    Placemark placeMark = placeMarks[0];
    return placeMark;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }
}