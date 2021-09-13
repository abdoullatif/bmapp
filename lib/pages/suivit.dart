
import 'dart:async';
import 'dart:io';

import 'package:bmapp/database/database.dart';
import 'package:bmapp/models/dataSearch.dart';
import 'package:bmapp/models/donnee_route.dart';
import 'package:bmapp/pages/userAgriculteurEleveur.dart';
import 'package:bmapp/search/SearchUI.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';

import 'userAgriculteur.dart';
import 'userEleveur.dart';

class Listsuivit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
          actions: <Widget> [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: (){
                  showSearch(context: context, delegate: SearchUI());
                }
            )
          ]
      ),
      body: Suivit(),
    );
  }
}

class Suivit extends StatefulWidget {
  @override
  _SuivitState createState() => _SuivitState();
}

class _SuivitState extends State<Suivit> {
  //
  TextEditingController searchController = new TextEditingController();
  String filter;

  @override  initState() {
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
  }

  @override  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  //
  String _type_personne = "";

  @override
  Widget build(BuildContext context) {

    FutureOr onGoBack(dynamic value) {
      setState(() {});
    }
    //
    Future<List<Map<String, dynamic>>> Userquery() async{
      List<Map<String, dynamic>> tab = await DB.queryAll("parametre");
      var _locate = await DB.queryWherelocate("localite",tab[0]["locate"]);
      List<Map<String, dynamic>> queryRows = await DB.queryUser(_locate[0]["id_localite"].toString());
      return queryRows;
    }
    //Selection via comboBox
    Future<List<Map<String, dynamic>>> UserqueryCombo(String search) async{
      List<Map<String, dynamic>> tab = await DB.queryAll("parametre");
      var _locate = await DB.queryWherelocate("localite",tab[0]["locate"]);
      if(search == "Agriculteur"){
        List<Map<String, dynamic>> queryRows = await DB.queryUserComboAG(_locate[0]["id_localite"].toString(), search);
        return queryRows;
      } else if (search == "Eleveur"){
        List<Map<String, dynamic>> queryRows = await DB.queryUserComboEl(_locate[0]["id_localite"].toString(), search);
        return queryRows;
      } else if (search == "Agriculteur et Eleveur"){
        List<Map<String, dynamic>> queryRows = await DB.queryUserComboAgEl(_locate[0]["id_localite"].toString(), search);
        return queryRows;
      }
    }
    //Si chef Agriculteurs
    //************************************************************************
    final _utilisateur = FutureBuilder(
        future: _type_personne == "" ? Userquery() : UserqueryCombo(_type_personne),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List<Map<String, dynamic>> snap = snapshot.data;
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
          int n = snap.length;
          final items = List<String>.generate(n, (i) => "Item $i");
          //search bar new list
          List<Map<String, dynamic>> newDataList = List.from(snap);
          //

          return Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    //SizedBox(height: 10.0,),
                    Container(
                      //color: Colors.indigo,
                        margin: EdgeInsets.only(bottom: 30.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            //height: 50.0,
                            child: _type_personne == "" ?
                            Text(
                              "Nombre d'agriculteurs et éléveurs : $n",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ) :
                            Text(
                              "Nombre $_type_personne : $n",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                    ),
                    //SizedBox(height: 10.0,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: DropDownFormField(
                        titleText: 'Categories',
                        hintText: 'Eleveur/Agriculteur',
                        value: _type_personne,
                        onSaved: (value) {
                          setState(() {
                            _type_personne = value;
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            _type_personne = value;
                          });
                        },
                        dataSource: [
                          {"display": "Agriculteur", "value": "Agriculteur"},
                          {"display": "Eleveur", "value": "Eleveur"},
                          {"display": "Agriculteur et Eleveur", "value": "Agriculteur et Eleveur"},
                          {"display": "tous", "value": ""}
                        ],
                        textField: 'display',
                        valueField: 'value',
                        validator: (value) {
                          if (_type_personne == "") {
                            return 'Veuiller Slectionner';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                //la liste des membre
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {

                      return RaisedButton(
                          elevation: 0,
                          padding: EdgeInsets.all(0.0),
                          color: Colors.transparent,
                          disabledColor: Colors.transparent,
                          onPressed: (){

                            if(newDataList[index]['nom_fonction'] == "E" || newDataList[index]['nom_fonction'] == "CE"){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => UserPannelEleveur(),settings: RouteSettings(arguments: DonneeRoute(
                                  '${newDataList[index]['id_personne']}', '${newDataList[index]['nom_fonction']}'
                              ))),).then(onGoBack);
                            } else if (newDataList[index]['nom_fonction'] == "AG" || newDataList[index]['nom_fonction'] == "CAG"){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => UserPannel(),settings: RouteSettings(arguments: DonneeRoute(
                                  '${newDataList[index]['id_personne']}', '${newDataList[index]['nom_fonction']}'
                              ))),).then(onGoBack);
                            } else if (newDataList[index]['nom_fonction'] == "AGE" || newDataList[index]['nom_fonction'] == "CAGCE"){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AgriculteurEleveurPannel(),settings: RouteSettings(arguments: DonneeRoute(
                                  '${newDataList[index]['id_personne']}', '${newDataList[index]['nom_fonction']}'
                              ))),).then(onGoBack);
                            } else {}

                          },
                          child: Card(
                            margin: EdgeInsets.only(top: 25.0,),
                            elevation: 2.0,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.transparent,
                                backgroundImage: FileImage(File('/storage/emulated/0/Android/data/com.tulipind.bmapp/files/Pictures/${newDataList[index]['images']}')),
                                //backgroundImage: Image.file(file),
                              ),
                              title: Text('${newDataList[index]['nom_personne']} ${newDataList[index]['prenom_personne']}'),
                              subtitle: newDataList[index]['nom_fonction'] == "E" ? Text('Membre Eleveur') :
                                        newDataList[index]['nom_fonction'] == "CE" ? Text('Chef menage Eleveur') :
                                        newDataList[index]['nom_fonction'] == "AG" ? Text('Membre Agriculteur') :
                                        newDataList[index]['nom_fonction'] == "CAG" ? Text('Chef menage Agriculteur') :
                                        newDataList[index]['nom_fonction'] == "CAGCE" ? Text('Chef menage Agriculteur et Eleveur') :
                                        newDataList[index]['nom_fonction'] == "AGE" ? Text('Membre Agriculteur et Eleveur') :
                                        Text('${newDataList[index]['nom_fonction']}'),
                            ),
                          )
                      );
                    },
                  ),
                ),
              ]
          );
        }
    );

    //
    return Container(
      child: Container(
        margin: EdgeInsets.only(left: 50.0, right: 50.0, top: 50.0, bottom: 40.0),
        child: _utilisateur,
      ),
    );
  }
}

