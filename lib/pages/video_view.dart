import 'dart:io';

import 'package:bmapp/database/database.dart';
import 'package:flutter/material.dart';
//pakage importer pub get
import 'package:bmapp/pages/chewieItem.dart';
import 'package:flutter/services.dart';
import 'package:neeko/neeko.dart';
import 'package:video_player/video_player.dart';

//Page pour visionner les video sur l'app
class Visionnage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Video_view(),
    );
  }
}
//****************************************************************************

class Video_view extends StatefulWidget {
  @override
  _Video_viewState createState() => _Video_viewState();
}

class _Video_viewState extends State<Video_view> {

  /*
  final VideoControllerWrapper videoControllerWrapper = VideoControllerWrapper(
      DataSource.asset(
          "",
          displayName: "Video Formation"));

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
  }

  @override
  void dispose() {
    SystemChrome.restoreSystemUIOverlays();
    super.dispose();
  }
  */

  @override
  Widget build(BuildContext context) {
    //
    final video = ModalRoute.of(context).settings.arguments;

    Future<List<Map<String, dynamic>>> Media() async{
      List<Map<String, dynamic>> queryRows = await DB.queryMedia(video);
      print(queryRows);
      return queryRows;
    }

    return FutureBuilder(
        future: Media(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List snap = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          //si il ya une eurreur lor du chargement
          if (snapshot.hasError) {
            return Center(
              child: Text("Erreur de chargement"),
            );
          }
          if(snap.isNotEmpty){
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      //margin: EdgeInsets.only(left: 50.0, right: 50.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              elevation: 10,
                              child: ChewieItem(
                                videoPlayerController: VideoPlayerController.file(File("/storage/emulated/0/Android/data/com.tulipind.bmapp/files/Video/${snap[0]['media_file']}")),
                                looping: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Column(
              children: <Widget>[
                Center(
                  //margin: EdgeInsets.only(left: 50.0, right: 50.0),
                  child: Card(
                    child: Text("Video non disponible !"),
                  ),
                ),
              ],
            );
          }
        }
    );

    NeekoPlayerWidget(
      videoControllerWrapper: VideoControllerWrapper(
          DataSource.asset(
              video,
              displayName: "Video Formation")),
    );


  }
}
