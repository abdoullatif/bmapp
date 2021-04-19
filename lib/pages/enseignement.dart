//package native
import 'package:bmapp/database/database.dart';
import 'package:flutter/material.dart';
//package jobs
import 'package:bmapp/pages/video_view.dart';
import 'package:video_thumbnail/video_thumbnail.dart';


class Enseignement extends StatefulWidget {
  @override
  _EnseignementState createState() => _EnseignementState();
}

class _EnseignementState extends State<Enseignement> {
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


    final name = ModalRoute.of(context).settings.arguments;
    int idvideo;
    String categ = "Enseignement";
    String Langue = "Français";

    Future<List<Map<String, dynamic>>> Media() async{
      var _parametre = await DB.initTabquery();
      if(_parametre[0]['langue'] != "" || _parametre[0]['langue'] != null) {
        List<Map<String, dynamic>> queryRows = await DB.queryMediaCategAll(categ,_parametre[0]['langue']);
        return queryRows;
      } else {
        List<Map<String, dynamic>> queryRows = await DB.queryMediaCategAll(categ,Langue);
        return queryRows;
      }
    }

    final _enseignement = FutureBuilder(
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
                          ),
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
          child: Column( //future builder
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/enseignement-banner.png"),
                      fit: BoxFit.cover,
                    )
                ),
              ),
              Container(
                child: Center(
                  child: Container(
                      color: Colors.black,
                      margin: EdgeInsets.only(bottom: 30.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: Text("Enseignement Technique et professionnel", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold,),),
                        ),
                      )
                  ),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 50,),
                child: Text("", style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold,),),
              ),
              Divider(
                height: 50.0,
                thickness: 3,
                //color: Colors.white70,
                indent: 50.0,
                endIndent: 50.0,
              ),
              Container(
                margin: EdgeInsets.only(left: 50.0, right: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width/2,
                      child: Card(
                        elevation: 10,
                        child: Image.asset("images/enseignement-banner.png"),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width/3,
                      child: Card(
                        elevation: 10,
                        child: ListTile(
                          //title: Text('Apprenons pour mieux vivre', style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                          subtitle: Text('l\'enseignement permet l’acquisition de compétences et de connaissances qui ne peuvent être mises en œuvre que dans des situations réelles de production, il a pour objectif central d\'élever le niveau de qualification des jeunes et de limiter leur sortie précoce du système éducatif.'
                            , style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40,),
              Center(
                child: Text("Vidéos", style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold,),),
              ),
              Divider(
                height: 50.0,
                thickness: 3,
                //color: Colors.white70,
                indent: 50.0,
                endIndent: 50.0,
              ),
              _enseignement,
              /*
              Container(
                margin: EdgeInsets.only(left: 50.0, right: 50.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        elevation: 0,
                        padding: EdgeInsets.all(0.0),
                        color: Colors.transparent,
                        disabledColor: Colors.transparent,
                        onPressed: (){
                          //Visionage de la video sur page unique
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => Visionnage(),settings: RouteSettings()),
                          );
                        },
                        child: Image.asset('images/cover.png'),
                      ),
                    ),
                    Expanded(
                      child: RaisedButton(
                        elevation: 0,
                        padding: EdgeInsets.all(0.0),
                        color: Colors.transparent,
                        disabledColor: Colors.transparent,
                        onPressed: (){
                          String video = "videos/enseignement.mp4";
                          //Visionage de la video sur page unique
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => Visionnage(),settings: RouteSettings(arguments: video)),
                          );
                        },
                        child: Image.asset('images/cover.png'),
                      ),
                    ),
                    Expanded(
                      child: RaisedButton(
                        elevation: 0,
                        padding: EdgeInsets.all(0.0),
                        color: Colors.transparent,
                        disabledColor: Colors.transparent,
                        onPressed: (){
                          String video = "videos/enseignement.mp4";
                          //Visionage de la video sur page unique
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => Visionnage(),settings: RouteSettings(arguments: video)),
                          );
                        },
                        child: Image.asset('images/cover.png'),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40,),
              Container(
                margin: EdgeInsets.only(left: 50.0, right: 50.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        elevation: 0,
                        padding: EdgeInsets.all(0.0),
                        color: Colors.transparent,
                        disabledColor: Colors.transparent,
                        onPressed: (){
                          String video = "videos/enseignement.mp4";
                          //Visionage de la video sur page unique
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => Visionnage(),settings: RouteSettings(arguments: video)),
                          );
                        },
                        child: Image.asset('images/cover.png'),
                      ),
                    ),
                    Expanded(
                      child: RaisedButton(
                        elevation: 0,
                        padding: EdgeInsets.all(0.0),
                        color: Colors.transparent,
                        disabledColor: Colors.transparent,
                        onPressed: (){
                          String video = "videos/enseignement.mp4";
                          //Visionage de la video sur page unique
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => Visionnage(),settings: RouteSettings(arguments: video)),
                          );
                        },
                        child: Image.asset('images/cover.png'),
                      ),
                    ),
                    Expanded(
                      child: RaisedButton(
                        elevation: 0,
                        padding: EdgeInsets.all(0.0),
                        color: Colors.transparent,
                        disabledColor: Colors.transparent,
                        onPressed: (){
                          String video = "videos/enseignement.mp4";
                          //Visionage de la video sur page unique
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => Visionnage(),settings: RouteSettings(arguments: video)),
                          );
                        },
                        child: Image.asset('images/cover.png'),
                      ),
                    ),
                  ],
                ),
              ),
              */
              Center(
                child: Text("", style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold,),),
              ),
              Divider(
                height: 50.0,
                thickness: 3,
                //color: Colors.white70,
                indent: 50.0,
                endIndent: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
