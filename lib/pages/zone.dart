
import 'dart:async';

import 'package:bmapp/database/database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Zone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Localisation"),
      ),
      body: zone(),
    );
  }
}

class zone extends StatefulWidget {
  @override
  _zoneState createState() => _zoneState();
}

class _zoneState extends State<zone> {

  //
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.0472856, -12.8916414),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    //
    Future map() async{
      var _tab = await DB.initTabquery();
      var _locate = await DB.queryWherelocalite("localite",_tab[0]['locate']);
      return _locate;
    }
    final _zone = FutureBuilder(
        future: map(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List snap = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Erreur de chargement"),
            );
          }
          return GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: CameraPosition(
              target: LatLng(double.parse(snap[0]['latitude']), double.parse(snap[0]['longitude'])),
              zoom: 14.4746,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          );
        }
    );
    return _zone;
  }
  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}

