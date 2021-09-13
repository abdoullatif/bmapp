//package native
import 'package:bmapp/database/database.dart';
import 'package:bmapp/database/storageUtil.dart';
import 'package:bmapp/pages/PageViewHolder.dart';
import 'package:bmapp/pages/Pecheur.dart';
import 'package:bmapp/pages/acceuil.dart';
import 'package:bmapp/pages/enseignement.dart';
import 'package:bmapp/pages/login.dart';
import 'package:bmapp/pages/phonecall.dart';
import 'package:bmapp/pages/slider.dart';
//Synchro
import 'package:bmapp/synchro/server_to_local1.dart';
import 'package:bmapp/synchro/records.dart';
import 'package:bmapp/synchro/Videos.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
//pakage importer pub get
import 'dart:async';
import 'package:provider/provider.dart';
//****package lass prince
import 'package:bmapp/pages/agriculture.dart';
import 'package:bmapp/pages/elevage.dart';
import 'package:bmapp/pages/cooperative.dart';
import 'package:bmapp/pages/environnement.dart';
import 'package:bmapp/pages/administrateur.dart';

//
var synchronisation;
var records;
var videos;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init();
  await StorageUtil.getInstance();
  //Recuperation des donnees dans la tablette
  List<Map<String, dynamic>> tab = await DB.queryAll("parametre");
  if(tab.isNotEmpty){
    //Synchronisation des donnees
    synchronisation = Synchro("/data/user/0/com.tulipind.bmapp/databasesbmdb",
        "/storage/emulated/0/Android/data/com.tulipind.bmapp/files/Pictures/"
        ,"uploads/",tab[0]['user'],tab[0]['mdp'],tab[0]['dbname'],tab[0]['ip_server'],tab[0]['adresse_server']);
    //Synchronisation des records
    records = Records("/data/user/0/com.tulipind.bmapp/databasesbmdb",
        "/storage/emulated/0/Android/data/com.tulipind.bmapp/files/"
        ,"uploads/",tab[0]['user'],tab[0]['mdp'],tab[0]['dbname'],tab[0]['ip_server'],tab[0]['adresse_server']);
    //Synchronisation des videos
    videos = Videos("/data/user/0/com.tulipind.bmapp/databasesbmdb",
        "/storage/emulated/0/Android/data/com.tulipind.bmapp/files/Video/"
        ,"uploads/",tab[0]['user'],tab[0]['mdp'],tab[0]['dbname'],tab[0]['ip_server'],tab[0]['adresse_server']);
    //
    synchronisation.synchronize();
    records.synchronize();
    videos.synchronize();
  } else {}
  //
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]).then((_){
    runApp(BmApp());
  });
}

class BmApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDAIG App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      //home: MyHomePage(title: 'PDAIG App'),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/' : (BuildContext context) => SafeArea(child: MyHomePage(title: 'PDAIG App')),
        '/admin' : (BuildContext context) => SafeArea(child: Administrateur()),
        '/login' : (BuildContext context) => SafeArea(child: Login()),
        '/Acceuil' : (BuildContext context) => SafeArea(child: Acceuil()),
      },
    );
  }
}














