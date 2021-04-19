import 'dart:io';

import 'package:bmapp/database/database.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';


class GroupementSelect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adherer a un groupement"),
      ),
      body: pannelGroupementSelect(),
    );
  }
}

class pannelGroupementSelect extends StatefulWidget {
  @override
  _pannelGroupementSelectState createState() => _pannelGroupementSelectState();
}

class _pannelGroupementSelectState extends State<pannelGroupementSelect> {
  @override
  Widget build(BuildContext context) {
    //
    final idpersonne = ModalRoute.of(context).settings.arguments;

    //LISTE DES GROUPEMENT
    Future<void> SelectAllGroupement() async {
      List<Map<String, dynamic>> queryGroup = await DB.querygroupunion();
      return queryGroup;
    }
    //Si chef Agriculteurs
    //************************************************************************
    final _groupement = FutureBuilder(
        future: SelectAllGroupement(),
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

          return Container(
            width: MediaQuery.of(context).size.width / 1.5,
            margin: EdgeInsets.only(left: 50.0, right: 50.0),
            child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[],
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
                            onPressed: () async{
                              //
                              var confirm = await showDialog<String>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Groupement"),
                                    content: Text(
                                      'Voulez vous Adhere a ce groupement "${newDataList[index]['nom_groupement']}" ?', style: TextStyle(color: Colors.indigo,),),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Adherer'),
                                        onPressed: () {
                                          Navigator.of(context).pop('oui');
                                        },
                                      ),
                                      FlatButton(
                                        child: Text('Non'),
                                        onPressed: () {
                                          Navigator.of(context).pop('non');
                                        },
                                      ),
                                    ],
                                    //shape: CircleBorder(),
                                  );
                                },
                              );
                              if (confirm == 'oui'){
                                //Verification
                                List<Map<String, dynamic>> _tab = await DB.queryAll("parametre");
                                List<Map<String, dynamic>> _groupmnt = await DB.queryverifgroupmnt(idpersonne,snap[index]['id_groupement']);
                                //List<Map<String, dynamic>> _groupmnt = await DB.queryverifgroupmnt(idpersonne);
                                if(_tab.isNotEmpty){
                                  //id genere
                                  String idmbgroupgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                                  //Insertion
                                  if(_groupmnt.isEmpty){
                                    //
                                    await DB.insert("membre_groupement", {
                                      "id_mb_groupement": idmbgroupgen,
                                      "id_personne": idpersonne,
                                      "id_groupement": snap[index]['id_groupement'],
                                      "statu": "membre",
                                      "flagtransmis": "",
                                    });
                                    Scaffold
                                        .of(context)
                                        .showSnackBar(SnackBar(content: Text('Adherer au groupement !')));
                                  } else {
                                    //
                                    Scaffold
                                        .of(context)
                                        .showSnackBar(SnackBar(content: Text('Vous avez deja ete ajouter a ce groupement !')));
                                  }

                                  // keytool -genkey -v -keystore c:\Users\assooba\key.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias key
                                  /*
                                        if (_groupmnt.isNotEmpty) {
                                          if(_groupmnt[0]['statu'] == "Chef"){
                                            if(_groupmnt[0]['id_groupement'] == id_mb_groupement) {
                                              Scaffold
                                                  .of(context)
                                                  .showSnackBar(SnackBar(content: Text('Vous avez deja ete ajouter a un groupement !')));
                                            }
                                          } else if (_groupmnt[0]['statu'] == "membre") {
                                            if(_groupmnt[0]['id_groupement'] == id_mb_groupement) {
                                              Scaffold
                                                  .of(context)
                                                  .showSnackBar(SnackBar(content: Text('Vous avez deja ete ajouter a un groupement !')));
                                            }
                                          } else {
                                            await DB.insert("membre_groupement", {
                                              "id_mb_groupement": idmbgroupgen,
                                              "id_personne": snap[0]["id_personne"],
                                              "id_groupement": id_mb_groupement,
                                              "statu": "membre",
                                              "flagtransmis": "",
                                            });
                                            Scaffold
                                                .of(context)
                                                .showSnackBar(SnackBar(content: Text('Adherer au groupement !')));
                                          }
                                        } else {
                                          await DB.insert("membre_groupement", {
                                            "id_mb_groupement": idmbgroupgen,
                                            "id_personne": snap[0]["id_personne"],
                                            "id_groupement": id_mb_groupement,
                                            "statu": "membre",
                                            "flagtransmis": "",
                                          });
                                          Scaffold
                                              .of(context)
                                              .showSnackBar(SnackBar(content: Text('Adherer au groupement !')));
                                        }
                                        */
                                } else {
                                  Scaffold
                                      .of(context)
                                      .showSnackBar(SnackBar(content: Text('La tablette n\'a pas d\'identifiant !')));
                                }
                              }
                            },
                            child: Card(
                              margin: EdgeInsets.only(top: 25.0,),
                              elevation: 2.0,
                              child: ListTile(
                                title: Text('Groupement: ${newDataList[index]['nom_groupement']} \nActivites: ${newDataList[index]['activite_groupement']} \nUnion: ${newDataList[index]['description_un']}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                //subtitle: Text('------------------------- Adherer --------------------------'),
                              ),
                            )
                        );
                      },
                    ),
                  ),
                ]
            ),
          );
        }
    );

    //LISTE DE MES GROUPEMENT
    Future<void> SelectGroup() async {
      List<Map<String, dynamic>> queryGroup = await DB.querygroupunionuser(idpersonne);
      return queryGroup;
    }
    //
    //************************************************************************
    final _mes_groupement = FutureBuilder(
        future: SelectGroup(),
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

          return Container(
            width: MediaQuery.of(context).size.width / 1.5,
            margin: EdgeInsets.only(left: 50.0, right: 50.0),
            child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[],
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
                            onPressed: (){},
                            child: Card(
                              margin: EdgeInsets.only(top: 25.0,),
                              elevation: 2.0,
                              child: ListTile(
                                title: newDataList[index]['statu'] == "Chef" ?
                                Text('Groupement: ${newDataList[index]['nom_groupement']} \nActivites: ${newDataList[index]['activite_groupement']} \nStatus: President \nUnion: ${newDataList[index]['description_un']}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ) :
                                Text('Groupement: ${newDataList[index]['nom_groupement']} \nActivites: ${newDataList[index]['activite_groupement']} \nStatus: ${newDataList[index]['statu']} \nUnion: ${newDataList[index]['description_un']}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                //subtitle: Text('------------------------- Adherer --------------------------'),
                              ),
                            )
                        );
                      },
                    ),
                  ),
                ]
            ),
          );
        }
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: TabBar(
              unselectedLabelColor: Colors.indigo,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.indigo),
              tabs: [
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.indigo, width: 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("LISTES DES GROUPEMENTS"),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.indigo, width: 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("GROUPEMENT ADHERER"),
                    ),
                  ),
                ),
              ]),
        ),
        body: TabBarView(children: [
          _groupement,
          _mes_groupement,
        ]),
      ),
    );
  }
}

