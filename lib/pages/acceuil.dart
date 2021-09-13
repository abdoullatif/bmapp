import 'package:bmapp/database/database.dart';
import 'package:bmapp/pages/PageViewHolder.dart';
import 'package:bmapp/pages/login.dart';
import 'package:bmapp/pages/phonecall.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';

import 'Pecheur.dart';
import 'agriculture.dart';
import 'cooperative.dart';
import 'elevage.dart';
import 'enseignement.dart';
import 'environnement.dart';



//Image List
final List<String> imgList = [
  'images/agriculture.png',
  'images/elevage.png',
  'images/peche.png',
  'images/cooperative.png',
  'images/environnement.png',
  'images/enseignement.png',
  'images/administration.png',
];



class Acceuil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //widget
    //------------------------------------------------------------------------
    final List<Widget> imageSliders = imgList.map((item) => Container(
      child: Container(
        child: ClipRRect(
          //borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Stack(
              children: <Widget>[
                InkWell(
                  child: Image.asset(item, fit: BoxFit.cover, width: 600),
                  onTap: (){
                    //verif
                    /*
                    if(item == 'images/agriculture.png'){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Agriculture()),
                      );
                    } else if (item == 'images/elevage.png') {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Elevage()),
                      );
                    } else if (item == 'images/peche.png') {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Peche()),
                      );
                    } else if (item == 'images/cooperative.png') {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Cooperative()),
                      );
                    } else if (item == 'images/environnement.png') {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Environnement()),
                      );
                    } else if (item == 'images/enseignement.png') {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Enseignement()),
                      );
                    } else if (item == 'images/administration.png') {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Login()),
                      );
                    } else {
                      //si no rien
                    }
                    */
                  },
                ),
              ],
            )
        ),
      ),
    )).toList();
    //----------------------------------------------------------------------------
    return Slider3d();
  }
}


class Slider3d extends StatefulWidget {
  @override
  _Slider3dState createState() => _Slider3dState();
}

class _Slider3dState extends State<Slider3d> {

  PageViewHolder holder;

  PageController _controller;
  double fraction = 0.50;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    holder = PageViewHolder(value: 2.0);
    _controller = PageController(initialPage: 2, viewportFraction: fraction);
    _controller.addListener(() {
      holder.setValue(_controller.page);
    });
  }

  @override
  Widget build(BuildContext context) {

    //--------------------------------------------
    final List<Widget> imageSliders = imgList.map((item) => Container(
      child: Container(
        child: ClipRRect(
          //borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Stack(
              children: <Widget>[
                InkWell(
                  child: Image.asset(item, fit: BoxFit.cover, width: 600),
                  onTap: (){
                    //verif
                    /*
                    if(item == 'images/agriculture.png'){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Agriculture()),
                      );
                    } else if (item == 'images/elevage.png') {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Elevage()),
                      );
                    } else if (item == 'images/peche.png') {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Peche()),
                      );
                    } else if (item == 'images/cooperative.png') {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Cooperative()),
                      );
                    } else if (item == 'images/environnement.png') {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Environnement()),
                      );
                    } else if (item == 'images/enseignement.png') {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Enseignement()),
                      );
                    } else if (item == 'images/administration.png') {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Login()),
                      );
                    } else {
                      //si no rien
                    }
                    */
                  },
                ),
              ],
            )
        ),
      ),
    )).toList();
    //--------------------------------------------------------------


    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height/5.0,
                child: Image.asset("images/logo.png",height: 100, width: 200,),
              ),
              Container(
                height: 130.0,
                child: RaisedButton(
                    color: Colors.transparent,
                    elevation: 0,
                    padding: EdgeInsets.all(0.0),
                    child: Image.asset("images/call.png"),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Phone()),
                      );
                    }
                ),
              ),
              SizedBox(height: 25.0,),
              Sliderhome(),
              /*
              Center(
                child: mycarous.Carousel(
                    height: 350.0,
                    width: MediaQuery.of(context).size.width / 2,
                    initialPage: 3,
                    indicatorBackgroundColor: Colors.transparent,
                    indicatorBackgroundOpacity: 0.0,
                    allowWrap: false,
                    type: mycarous.Types.slideSwiper,
                    onCarouselTap: (i) {
                      print("onTap $i");
                    },
                    //indicatorType: mycarous.IndicatorTypes.bar,
                    arrowColor: Colors.transparent,
                    axis: Axis.horizontal,
                    showArrow: false,
                    children: imageSliders,
                ),
              ),
              */
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pop(context);
        },
        tooltip: 'Quitter', backgroundColor: Colors.transparent,
        child: Image.asset("images/close.png"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}


//
/*
  SafeArea(
      child: Scaffold(
        body: Container(
          child: Center(
            child: ChangeNotifierProvider<PageViewHolder>.value(
              value: holder,
              child: PageView.builder(
                controller: _controller,
                itemCount: 6,
                physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Page(number: index,fraction: fraction,);
                },
              ),
            ),
          ),
        ),
      ),
    )
 */
class Page extends StatelessWidget {

  final int number;
  final double fraction;

  Page({this.number,this.fraction});

  @override
  Widget build(BuildContext context) {
    double value = Provider.of<PageViewHolder>(context).value;
    double diff = (number - value);
    //Si diff est negative, left page
    //si diff = 0 curent page
    //si diff est positif, right page

    //Matrix d'animation pour les element
    final Matrix4 pvMatrix = Matrix4.identity()
      ..setEntry(3, 3, 1 / 0.9) // Scale a 90%
      ..setEntry(1, 1, fraction) // change scal Y Axis
      ..setEntry(3, 0, 0.004 * -diff); // Change perspective X Axis

    //Matrix les ombrage
    final Matrix4 shadowMatrix = Matrix4.identity()
      ..setEntry(3, 3, 1/0.6) // Scale a 60%
      ..setEntry(1, 1, -0.004) // change scal Y Axis
      ..setEntry(3, 0, 0.002 * diff) // Change perspective X Axis
      ..rotateX(1.309); //rotation sur X

    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: <Widget>[
        if(diff<=1.0 && diff>=-1.0) ...[
          AnimatedOpacity(
            duration: Duration(microseconds: 100),
            opacity: 1-diff.abs(),
            child: Transform(
              transform: shadowMatrix,
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                decoration: BoxDecoration(boxShadow:[
                  BoxShadow(color: Colors.black12, blurRadius: 10.0, spreadRadius: 1.0),
                ]),
              ),
            ),
          ),
        ],
        Transform(
          transform: pvMatrix,
          alignment: FractionalOffset.center,
          child: Container(
            child: Image.asset(
              imgList[number],
              fit: BoxFit.fill,
            ),
          ),
        )
      ],
    );
  }
}

//==============================================================================

class Sliderhome extends StatefulWidget {
  @override
  _SliderhomeState createState() => _SliderhomeState();
}

class _SliderhomeState extends State<Sliderhome> {


  double x = 0.0;
  double y = 0.0;

  void _updateLocation(PointerEvent details) {
    setState(() {
      x = details.position.dx;
      y = details.position.dy;
      print('x(${x.toString()},y ${y.toString()})');
    });
  }


  @override
  Widget build(BuildContext context) {

    //flutter screen resize
    StateSetter _setState;
    String _localite;
    //localite
    Future<void> SelectLocalite() async {
      List<Map<String, dynamic>> queryLocalite = await DB.queryAll("localite");
      return queryLocalite;
    }
    final GlobalKey<FormState> _formKey2 = new GlobalKey<FormState>();

    getlocate () async {
      List<Map<String, dynamic>> tab = await DB.queryAll("parametre");
      //var _locate = await DB.queryWherelocate("localite",tab[0]["locate"]);
      if(tab[0]["locate"] == "" || tab[0]["locate"] == null){
        print(tab[0]["locate"]);
        List<Map<String, dynamic>> queryLocalite = await DB.queryAll("localite");
        if(queryLocalite.isNotEmpty){
          print(queryLocalite);
          showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  title: Text("Localite"),
                  content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState){
                      _setState = setState;
                      return SingleChildScrollView(
                        child: Form(
                          key: _formKey2,
                          child: Column(
                            children: [
                              Container(
                                //color: Colors.indigo,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      //height: 50.0,
                                      child: Text(
                                        "Selectionner une localite !",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                              Divider(),
                              SizedBox(height: 10,),
                              FutureBuilder(
                                  future: SelectLocalite(),
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
                                    return DropDownFormField(
                                      titleText: 'Localite',
                                      hintText: 'zone',
                                      value: _localite,
                                      onSaved: (value) {
                                        setState(() {
                                          _localite = value;
                                        });
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          _localite = value;
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Comfirmation de la localite"),
                                                content: Text("Je comfirme la localite : $_localite"),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text('OK'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop('oui');
                                                    },
                                                  ),
                                                ],
                                                //shape: CircleBorder(),
                                              );
                                            },
                                          );
                                        });
                                      },
                                      dataSource: snap,
                                      textField: 'descriptions',
                                      valueField: 'descriptions',
                                      validator: (value) {
                                        if (_localite == "") {
                                          return 'Veuiller Slectionner une localite';
                                        }
                                        return null;
                                      },
                                    );
                                  }
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Enregistrer'),
                      onPressed: () async {
                        //La classe est anterieur superieur ou egale
                        // Validate returns true if the form is valid, otherwise false.
                        if (_formKey2.currentState.validate()) {
                          var _parametre = await DB.initTabquery();
                          if(_parametre.isEmpty){
                            await DB.insert("parametre", {
                              "locate": _localite,
                            });
                          } else {
                            await DB.update("parametre", {
                              "locate": _localite,
                            }, _parametre[0]['id']);
                          }
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      onPressed: (){
                        Navigator.of(context).pop('non');
                      },
                      child: Text('Annuler'),
                    ),
                  ],
                  //shape: CircleBorder(),
                );
              }
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Synchronisation"),
                content: Text("Synchronisation en cours ..."),
                actions: <Widget>[
                  FlatButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop('oui');
                    },
                  ),
                ],
                //shape: CircleBorder(),
              );
            },
          );
        }
      } else if (tab.isEmpty) {
        //
        Scaffold
            .of(context)
            .showSnackBar(SnackBar(content: Text(
            'Data: Donnée de synchro non disponible')));
      } else {
        //
        /*Navigator.push(context, MaterialPageRoute(
            builder: (context) => Login()),
        );*/

        Navigator.of(context).pushNamed('/login');

      }
    }

    int _current = 0;
    int position;

    getIndex(i){
      _current = i;
    }


    return MouseRegion(
      onEnter: _updateLocation,
      child: Container(
        padding: EdgeInsets.all(0.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/3.2,
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return Image.asset(
              imgList[index],
              fit: BoxFit.fill,
            );
          },
          itemCount: 7,
          //itemHeight: MediaQuery.of(context).size.height/1.5,
          //itemWidth: MediaQuery.of(context).size.width/2,
          onIndexChanged: (index) {
            //print(index);
            setState(() {
              position = index;
              _current = index;
            });
            getIndex(index);
          },
          viewportFraction: 0.2,
          containerHeight: 0.0,
          containerWidth: 0.0,
          scale: position == _current ? -2.0 : 0.0,
          onTap: (index) {
            //print(index);
            //la pa a consulter
            switch(index){
              case 0: {
                //agriculteur
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Agriculture()),
                );
              }
              break;
              case 1: {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Elevage()),
                );
              }
              break;
              case 2: {
                //
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Peche()),
                );
              }
              break;
              case 3: {
                //
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Cooperative()),
                );
              }
              break;
              case 4: {
                //
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Environnement()),
                );
              }
              break;
              case 5: {
                //
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Enseignement()),
                );
              }
              break;
              case 6: {
                //administrateur
                getlocate();
                /*
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Login()),
                );
                */
              }
              break;
            }
          },
        ),

        /*
            Swiper(
                layout: SwiperLayout.CUSTOM,
                customLayoutOption: new CustomLayoutOption(
                    startIndex: -1,
                    stateCount: 3,
                ).addRotate([
                  0.0,
                  0.0,
                  0.0
                ]).addTranslate([
                  new Offset(-370.0, -40.0),
                  new Offset(0.0, 0.0),
                  new Offset(370.0, -40.0)
                ]).addScale([
                  1.0,
                  2.0,
                  1.0
                ], Alignment.center),
                itemWidth: 300.0,
                itemHeight: 200.0,
                itemBuilder: (context, index) {
                  return Image.asset(
                    imgList[index],
                    fit: BoxFit.fill,
                  );
                },
                itemCount: 6),
            */
      ),
    );
  }
}
