import 'dart:async';
import 'dart:convert';
import 'package:bmapp/main.dart';
import 'package:bmapp/pages/administrateur.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import 'package:get_version/get_version.dart';
import 'package:ota_update/ota_update.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;



class Sliders extends StatefulWidget {
  @override
  _SlidersState createState() => _SlidersState();
}

class _SlidersState extends State<Sliders> {
  //
  var _uid_home = "";
  OtaEvent currentEvent;
  List version = [];

  @override
  void initState() {
    super.initState();
    //fetchVersionApp();
    tryOtaUpdate();
    //checkForUpdate();
  }

  Future<void> tryOtaUpdate() async {
    final response = await http.get('http://ad.tulipcrmsupport.com/DeployApp/PdaigAPK/version.json');
    if (response.statusCode == 200) {
      setState(() {
        version = json.decode(response.body);
      });
    }
    var connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult);
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      String versionLocal = "0";
      var v = version;
      String versionOnline = v[0]['version'];
      //
      try {
        versionLocal = await GetVersion.projectVersion;
        //print(versionApp);
      } on PlatformException {
        print('Failed to get project version.');
      }

      if(versionOnline.toString().compareTo(versionLocal) > 0){
        showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Nouvelle mise à jour dispaunible !!!"),
              content: Text("Une nouvelle mise à jour a été deployer, Version : $versionOnline !"),
              actions: <Widget>[
                FlatButton(
                  child: Text('ok'),
                  onPressed: () {
                    Navigator.of(context).pop('oui');
                  },
                ),
              ],
              //shape: CircleBorder(),
            );
          },
        );
        try {
          //LINK CONTAINS APK
          OtaUpdate()
              .execute(
            'http://ad.tulipcrmsupport.com/DeployApp/PdaigAPK/pdaig.apk',
            destinationFilename: 'pdaig.apk',
            //FOR NOW ANDROID ONLY - ABILITY TO VALIDATE CHECKSUM OF FILE:
            //sha256checksum: "d6da28451a1e15cf7a75f2c3f151befad3b80ad0bb232ab15c20897e54f21478",
          )
              .listen(
                (OtaEvent event) {
              setState(() => currentEvent = event);
            },
          );
        } catch (e) {
          print('Probleme. Details: $e');
        }
      } else { print("A jour !!!");}
    }
  }

  @override
  Widget build(BuildContext context) {

    for(int i=1; i<60; i++)
    {
      if(i%i == 1)
      {
        print("Le i eme nombre premier est : $i");
      }
    }

    //Rechargement automatique
    FutureOr onGoBack(dynamic value) {
      setState(() {});
    }
    //
    Future getUid(uid) async {
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => Acceuil()),
      );
    }
    //**********************nfc****************************************
    FlutterNfcReader.read().then((response) {
      //print(response.id.substring(2));
      _uid_home = response.id.substring(2);
      String _uid = _uid_home.toUpperCase();
      if(mounted){
        setState((){
          if(_uid_home != ""){
            Navigator.popUntil(context, (currentRoute) {
              if (currentRoute.settings.name == "/") {
                print(currentRoute.settings.name);
                getUid(_uid);
                print(_uid);
                _uid_home;
                //currentRouteIsHome = true;
              }
              return true;
            });

          } else if (_uid_home.isNotEmpty) {
            //
          }
        });
      } else {
        setState((){
          if(_uid_home != ""){
            Navigator.popUntil(context, (currentRoute) {
              if (currentRoute.settings.name == "/") {
                print(currentRoute.settings.name);
                getUid(_uid);
                print(_uid);
                _uid_home;
                //currentRouteIsHome = true;
              }
              // Return true so popUntil() pops nothing.
              return true;
            });
          }
        });
      }
    });

    //-----------------------------------------------------------------
    Duration temps = new Duration(hours:0, minutes:0, seconds:30);
    String superAdminpassword = "";


    if (currentEvent == null) {
      return SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Carousel(
                      images: [
                        AssetImage('images/slider1.png'),
                        AssetImage('images/slider1.png'),
                        AssetImage('images/slider1.png'),
                      ],
                      autoplay: false,
                      dotSize: 4.0,
                      dotSpacing: 15.0,
                      dotColor: Colors.white10,
                      indicatorBgPadding: 5.0,
                      dotBgColor: Colors.black87.withOpacity(0.5),
                      autoplayDuration: temps,
                      borderRadius: false,
                      showIndicator: false,
                      onImageTap: (index) {
                        //
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => Acceuil()),
                        );
                      },
                    )
                ),
              ],
            ),
            ////les boutton administrateurs
            Positioned(
              top: 25,
              //bottom: 2,
              child: GestureDetector(
                child: SizedBox(width: 150, height: 150, child: Text(""),),
                onTap: (){
                  superAdminpassword = "";
                  superAdminpassword += "super";
                  print(superAdminpassword);
                },
              ),
            ),
            Positioned(
              top: 25,
              right: 0,
              //bottom: 2,
              child: GestureDetector(
                child: SizedBox(width: 150, height: 150, child: Text(""),),
                onDoubleTap: (){
                  superAdminpassword += "word";
                  if(superAdminpassword == "superAdminpassword") {
                    //
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Login()),
                    );
                  }
                  print(superAdminpassword);
                },
              ),
            ),
            Positioned(
              bottom: 0,
              //bottom: 2,
              child: GestureDetector(
                child: SizedBox(width: 150, height: 150, child: Text(""),),
                onTap: (){
                  superAdminpassword += "Admin";
                  print(superAdminpassword);
                },
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              //bottom: 2,
              child: GestureDetector(
                child: SizedBox(width: 150, height: 150, child: Text(""),),
                onTap: (){
                  superAdminpassword += "pass";
                  print(superAdminpassword);
                },
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Carousel(
                    images: [
                      AssetImage('images/slider1.png'),
                      AssetImage('images/slider1.png'),
                      AssetImage('images/slider1.png'),
                    ],
                    autoplay: false,
                    dotSize: 4.0,
                    dotSpacing: 15.0,
                    dotColor: Colors.white10,
                    indicatorBgPadding: 5.0,
                    dotBgColor: Colors.black87.withOpacity(0.5),
                    autoplayDuration: temps,
                    borderRadius: false,
                    showIndicator: false,
                    onImageTap: (index) {
                      //
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Acceuil()),
                      );
                    },
                  )
              ),
            ],
          ),
          ////les boutton administrateurs
          Positioned(
            top: 25,
            //bottom: 2,
            child: GestureDetector(
              child: SizedBox(width: 150, height: 150, child: Text(""),),
              onTap: (){
                superAdminpassword = "";
                superAdminpassword += "super";
                print(superAdminpassword);
              },
            ),
          ),
          Positioned(
            top: 25,
            right: 0,
            //bottom: 2,
            child: GestureDetector(
              child: SizedBox(width: 150, height: 150, child: Text(""),),
              onDoubleTap: (){
                superAdminpassword += "word";
                if(superAdminpassword == "superAdminpassword") {
                  //
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Login()),
                  );
                }
                print(superAdminpassword);
              },
            ),
          ),
          Positioned(
            bottom: 0,
            //bottom: 2,
            child: GestureDetector(
              child: SizedBox(width: 150, height: 150, child: Text(""),),
              onTap: (){
                superAdminpassword += "Admin";
                print(superAdminpassword);
              },
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            //bottom: 2,
            child: GestureDetector(
              child: SizedBox(width: 150, height: 150, child: Text(""),),
              onTap: (){
                superAdminpassword += "pass";
                print(superAdminpassword);
              },
            ),
          ),
        ],
      ),
    );
  }
}
