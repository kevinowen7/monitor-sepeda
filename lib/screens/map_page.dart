import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_task_planner_app/db/firebase-db.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/widgets/top_container.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../StateFulWrapper.dart';

class MapPage extends StatefulWidget {

  @override
  _MapPageState createState() => _MapPageState();
}
class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();

  LatLng _center ;
  Position currentLocation;

  // for my custom icons
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-5.3971, 105.2668),
    zoom: 14.4746,
  );

  double lat = 0;
  double long = 0;
  // this set will hold my markers
  Set<Marker> _markers = {}; // this will hold the generated polylines
  Set<Polyline> _polylines = {}; // this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];

  // this is the key object - the PolylinePoints
// which generates every polyline between start and finish
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPIKey = "AIzaSyBZ_zt4BTgekvNUWpDGJgKfLMYSm5MbCMI";

  @override
  void initState() {
    super.initState();
    setSourceAndDestinationIcons();
    getUserLocation();

    //update current location
    Timer.periodic(new Duration(seconds: 5), (timer) {
      _markers.clear();
      setMapPins();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    {
      return Scaffold(
        body:
        SafeArea(
          child: StreamBuilder(
            stream: FirebaseDBCustom.databaseReference.child(FirebaseDBCustom.deviceId.toString()+"/location").onValue,
            builder: (context, snap) {
              if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {
                Map data = snap.data.snapshot.value;
                List item = [];
                data.forEach(
                        (index, data) => item.add({"key": index, "data":data}));

                //get highest speed
                for( var i in item) {
                  long = i["data"]["long"];
                  lat = i["data"]["lat"];
                }
                setMapPins();
                //data
                return GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  markers: _markers,
                  polylines: _polylines,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    setMapPins();
                  },
                );
              }
              return GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                markers: _markers,
                polylines: _polylines,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  setMapPins();
                },
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: null,
          label: Text('Track My Bike'),
          icon: Icon(Icons.bike_scooter),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    }
  }


  Future<Position> locateUser() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<LatLng> getUserLocation() async {
    currentLocation = await locateUser();
    _center = LatLng(currentLocation.latitude, currentLocation.longitude);
    return _center;
  }

  Future<BitmapDescriptor> setSourceAndDestinationIcons() async {

    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/driving_pin.png');
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/destination_map_marker.png');
    return sourceIcon;
  }

  void setMapPins() {
    //this location
    setSourceAndDestinationIcons().then((value) {
      getUserLocation().then((value) {
        setState(() {
          _markers.add(Marker(
              markerId: MarkerId('source'),
              position: _center,
              icon: sourceIcon
          ));
          _markers.add(Marker(
              markerId: MarkerId('desination'),
              position: LatLng(lat.toDouble(), long.toDouble()),
              icon: destinationIcon
          ));
        });
      });
    });
  }
  /*
  setPolylines() async {
    List<PointLatLng> result = await
    polylinePoints?.getRouteBetweenCoordinates(
        googleAPIKey,
        _center.latitude,
        _center.longitude,
        lat,
        long);
    if(result.isNotEmpty){
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      result.forEach((PointLatLng point){
        polylineCoordinates.add(
            LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: PolylineId(""),
          color: Color.fromARGB(255, 40, 122, 198),
          points: polylineCoordinates
      );

      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      _polylines.add(polyline);
    });
  }
   */
}

