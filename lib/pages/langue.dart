//
import 'package:bmapp/database/database.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';

class Langues extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: langue(),
    );
  }
}

class langue extends StatefulWidget {
  @override
  _langueState createState() => _langueState();
}

class _langueState extends State<langue> {
  //var
  String _langue;
  String _localite;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
    final GlobalKey<FormState> _formKey1 = new GlobalKey<FormState>();


    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);


    //Langue
    Future<void> SelectLangue() async {
      List<Map<String, dynamic>> querylangue = await DB.queryAll("langues");
      return querylangue;
    }
    final _Langues = FutureBuilder(
        future: SelectLangue(),
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
            titleText: 'Langues',
            hintText: 'langues du contenu de l\'application',
            value: _langue,
            onSaved: (value) {
              setState(() {
                _langue = value;
              });
            },
            onChanged: (value) {
              setState(() {
                _langue = value;
              });
            },
            dataSource: snap,
            textField: 'description',
            valueField: 'description',
            validator: (value) {
              if (_langue == "") {
                return 'Veuiller Slectionner une localite';
              }
              return null;
            },
          );
        }
    );
    //-----------------------------LOCALITE---------------------------------------
    //localite
    Future<void> SelectLocalite() async {
      List<Map<String, dynamic>> queryLocalite = await DB.queryAll("localite");
      return queryLocalite;
    }
    final _Localites = FutureBuilder(
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
    );
    //--------------------------------------------------------------------------------
    Future<void> langueActuel() async {
      var _parametre = await DB.initTabquery();
      return _parametre;
    }
    final Actuel_Langue = FutureBuilder(
        future: langueActuel(),
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
          return snap.isNotEmpty ?
          Container(
              color: Colors.indigo,
              margin: EdgeInsets.only(bottom: 30.0),
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  //height: 50.0,
                  child: snap[0]['langue'] != null ? Text("Langues : ${snap[0]['langue']}", style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold,),) :
                  Text("Langues : Choississez une langue", style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold,),),
                ),
              )
          ):
          Container(
              color: Colors.indigo,
              margin: EdgeInsets.only(bottom: 30.0),
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  //height: 50.0,
                  child: Text("Langues", style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold,),),
                ),
              )
          );
        }
    );
    //-------------------------------SELECTION DE LA LOCALITE---------------------
    Future<void> localiteActuel() async {
      var _parametre = await DB.initTabquery();
      return _parametre;
    }
    final Actuel_Localite = FutureBuilder(
        future: localiteActuel(),
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
          return snap.isNotEmpty ?
          Container(
              color: Colors.indigo,
              margin: EdgeInsets.only(bottom: 30.0),
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  //height: 50.0,
                  child: snap[0]['locate'] != null ? Text("Localite : ${snap[0]['locate']}", style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold,),) :
                  Text("Langues : Choississez une localite", style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold,),),
                ),
              )
          ):
          Container(
              color: Colors.indigo,
              margin: EdgeInsets.only(bottom: 30.0),
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  //height: 50.0,
                  child: Text("Localite", style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold,),),
                ),
              )
          );
        }
    );


    //**********************************************************************//
    return Padding(
      padding: EdgeInsets.only(left: 100.0, right: 100.0, top: 30, bottom: 30.0,),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                  children: <Widget>[
                    // Add TextFormFields and RaisedButton here.
                    //CardSettingsHeader(label: "Ajouter des membres",),
                    //les champs et boutton
                    Actuel_Langue,
                    _Langues,
                    SizedBox(height: 25.0),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(30.0),
                      color: Color(0xff01A0C7),
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        onPressed: () async  {
                          // Validate returns true if the form is valid, otherwise false.
                          if (_formKey.currentState.validate()) {
                            var _parametre = await DB.initTabquery();
                            if(_parametre.isEmpty){
                              await DB.insert("parametre", {
                                "langue": _langue
                              });
                            } else {
                              await DB.update("parametre", {
                                "langue": _langue
                              }, _parametre[0]['id']);
                            }
                            setState(() {
                              Actuel_Langue;
                            });
                            Scaffold
                                .of(context)
                                .showSnackBar(SnackBar(content: Text('Changement de langue effectuer avec succes !')));
                          }
                        },
                        child: Text("Appliquer",
                            textAlign: TextAlign.center,
                            style: style.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    //CardSettingsListPicker(label: "nom",contentAlign: TextAlign.left, )
                  ]
              ),
            ),
            Form(
              key: _formKey1,
              child: Column(
                children: [
                  Divider(),
                  SizedBox(height: 25.0),
                  Actuel_Localite,
                  _Localites,
                  SizedBox(height: 25.0),
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Color(0xff01A0C7),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      onPressed: () async  {
                        // Validate returns true if the form is valid, otherwise false.
                        if (_formKey1.currentState.validate()) {
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
                          setState(() {
                            Actuel_Localite;
                          });
                          Scaffold
                              .of(context)
                              .showSnackBar(SnackBar(content: Text('Changement de localite effectuer avec succes !')));
                        }
                      },
                      child: Text("Appliquer",
                          textAlign: TextAlign.center,
                          style: style.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

