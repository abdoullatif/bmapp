
import 'dart:io';

import 'package:bmapp/database/database.dart';
import 'package:bmapp/models/dataSearch.dart';
import 'package:bmapp/models/donnee_route.dart';
import 'package:bmapp/search/SearchUI.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';

import 'User.dart';

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
                          {"display": "Eleveur", "value": "Eleveur"}
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => UserPannel(),settings: RouteSettings(arguments: DonneeRoute(
                                '${newDataList[index]['id_personne']}', '${newDataList[index]['nom_fonction']}'
                            ))),);
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
                              subtitle: Text('${newDataList[index]['nom_fonction']}'),
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

