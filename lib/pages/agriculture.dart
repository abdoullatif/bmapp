//package native
import 'package:bmapp/database/database.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//package abdoulatif sooba
import 'package:bmapp/pages/video_view.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'flick_video_player.dart';

//Agriculture
class Agriculture extends StatefulWidget {
  @override
  _AgricultureState createState() => _AgricultureState();
}
//Image List
final List<String> imgList = [
  'images/riz culture.png',
  'images/mais culture.png',
  'images/maraicher.png',
  'images/pommesTerre.png',
];

class _AgricultureState extends State<Agriculture> {
  @override
  Widget build(BuildContext context) {
    //var
    String name;
    //widget
    final List<Widget> imageSliders = imgList.map((item) => Container(
      child: Container(
        //margin: EdgeInsets.all(5.0),
        margin: EdgeInsets.only(top: 100.0),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Stack(
              children: <Widget>[
                InkWell(
                  child: Image.asset(item, fit: BoxFit.cover, width: 500),
                  onTap: (){
                    //verif
                    if(item == 'images/riz culture.png'){
                      name = "Riziculture";
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Categories(),settings: RouteSettings(arguments: name)),
                      );
                    } else if (item == 'images/mais culture.png') {
                      name = "Mais culture";
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Categories(),settings: RouteSettings(arguments: name)),
                      );
                    } else if (item == 'images/maraicher.png') {
                      name = "Maraichage";
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Categories(),settings: RouteSettings(arguments: name)),
                      );
                    }else if (item == 'images/pommesTerre.png') {
                      name = "Pomme de terre";
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Categories(),settings: RouteSettings(arguments: name)),
                      );
                    } else {
                      //si no rien
                    }
                  },
                ),
              ],
            )
        ),
      ),
    )).toList();
    //var mediaquery
    double defaultScreenWidth = MediaQuery.of(context).size.width;
    double defaultScreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Agriculture"),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(top: 50.0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/backgroundempty.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: false,
                    //aspectRatio: 2.0,
                    //enlargeCenterPage: false,
                    enableInfiniteScroll: true,
                    reverse: false,
                    viewportFraction: 0.8,
                    //autoPlayInterval: Duration(seconds: 600),
                    //autoPlayAnimationDuration: Duration(milliseconds: 800),
                  ),
                  items: imageSliders,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//**************************************************************************

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {

    getThumbnail(String videoPath) async{
      var uint8list = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 640,
        quality: 25,
      );
      return uint8list;
    }

    //

    final name = ModalRoute.of(context).settings.arguments;
    int idvideo;
    String categ = "Agriculture";
    String Langue = "Français";

    Future<List<Map<String, dynamic>>> MediaAgriculture() async{
      var _parametre = await DB.initTabquery();
      if(_parametre[0]['langue'] != "" || _parametre[0]['langue'] != null) {
        List<Map<String, dynamic>> queryRows = await DB.queryMediaScateg(categ,name,_parametre[0]['langue']);
        return queryRows;
      } else {
        List<Map<String, dynamic>> queryRows = await DB.queryMediaScateg(categ,name,Langue);
        return queryRows;
      }
    }

    final _agriculture = FutureBuilder(
        future: MediaAgriculture(),
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
              child: Text("Erreur de chargement !"),
            );
          }
          if(snap.isNotEmpty){
            return Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 50.0, right: 50.0),
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    //physics: ,
                    //mainAxisSpacing: 40.0,
                    crossAxisSpacing: 50.0,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(snap.length, (index) {
                      return Center(
                        child: RaisedButton(
                          elevation: 0,
                          padding: EdgeInsets.all(0.0),
                          color: Colors.transparent,
                          disabledColor: Colors.transparent,
                          onPressed: (){
                            //print(snap[index]['id']);
                            idvideo = snap[index]['id'];
                            //Visionage de la video sur page unique
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => Visionnage(),settings: RouteSettings(arguments: idvideo,)),
                            );
                          },
                          child: Column(
                            children: [
                              new Card(
                                elevation: 10.0,
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: FutureBuilder(
                                    future: getThumbnail("/storage/emulated/0/Android/data/com.tulipind.bmapp/files/Video/${snap[index]['media_file']}"),
                                    builder: (BuildContext context, AsyncSnapshot snapshot){
                                      var imgThumbnail = snapshot.data;
                                      if(snapshot.connectionState == ConnectionState.waiting){
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      //
                                      if(snapshot.hasError){
                                        return Center(
                                          child: Text("Erreur de chargement"),
                                        );
                                      }
                                      return Image.memory(imgThumbnail);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Text(snap[index]['media_title'] != null ? snap[index]['media_title'] : "", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                            ],
                          ), //Image.asset('images/cover.png')
                        ),
                      );
                    }),
                  ),
                ),
              ],
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


    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/backgroundempty.png"),
              fit: BoxFit.cover,
            )
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/banner1.png"),
                      fit: BoxFit.cover,
                    )
                ),
              ),
              new Container(
                child: Center(
                  child: Container(
                      color: Colors.black,
                      margin: EdgeInsets.only(bottom: 30.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: Text(name, style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold,),),
                        ),
                      )
                  ),
                ),
              ),
              // Listview horizontal start
              _agriculture,
            ],
          ),
        ),
      ),
    );
  }
}

