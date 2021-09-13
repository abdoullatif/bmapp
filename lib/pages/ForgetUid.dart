import 'dart:io';
import 'package:bmapp/database/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';

class ForgetUid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: searchUid(),
    );
  }
}

class searchUid extends StatefulWidget {
  @override
  _searchUidState createState() => _searchUidState();
}

class _searchUidState extends State<searchUid> {

  //
  String _uid_home;
  String _uid = "";

  @override
  Widget build(BuildContext context) {

    getUser (String uid) async{
      //Recherche les info des user en fonction du scannage de bracelet
      List<Map<String, dynamic>> queryPersonne = await DB.queryWhereUid("personne", uid);
      //return querypersonne;
      if(queryPersonne.isNotEmpty){
        List<Map<String, dynamic>> queryPersonne_adresse = await DB.queryWhereidpersonne("personne_adresse", queryPersonne[0]['id_personne']);
        List<Map<String, dynamic>> querylocalite = await DB.queryWhere("localite", queryPersonne_adresse[0]['id_localite']);
        List<Map<String, dynamic>> queryPersonne_fonction = await DB.queryWhereidpersonne("personne_fonction", queryPersonne[0]['id_personne']);
        if(queryPersonne_adresse.isNotEmpty && queryPersonne_fonction.isNotEmpty){
          //dataUser;
          Map<String, dynamic> dataUser = {'idpersonne_BP': queryPersonne[0]['id_personne'], 'nom_BP': queryPersonne[0]['nom_personne'],
            'prenom_BP': queryPersonne[0]['prenom_personne'], 'idgenre_BP': queryPersonne[0]['genre'],
            'iud_BP': queryPersonne[0]['uids'], 'image_BP': queryPersonne[0]['images'], 'idlocalite_BP': querylocalite[0]['descriptions'],
            'idpersonne_fonction_BP': queryPersonne_fonction[0]['id_prs_fonction'], 'idtypefonction_BP': queryPersonne_fonction[0]['nom_fonction']
          };
          return dataUser;
        }
      }
    }

    //
    FlutterNfcReader.read().then((response) {
      //print(response.id.substring(2));
      _uid_home = response.id.substring(2);
      _uid = _uid_home.toUpperCase();
      if(mounted){
        setState((){
          print(_uid);
          getUser (_uid);
          _uid;
        });
      }
    });

    return _uid != "" ?
    FutureBuilder(
        future: getUser(_uid),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          var snap = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Erreur de chargement"),
            );
          }

          return snap != null ?
          Center(
            child: Container(
              padding: EdgeInsets.all(20.0),
              width: MediaQuery.of(context).size.width/3,
              child: Card(
                elevation: 10.0,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      //widget
                      Container(
                        padding: EdgeInsets.all(10),
                        child: CircleAvatar(
                          radius: 80,
                          backgroundImage: FileImage(File('/storage/emulated/0/Android/data/com.tulipind.bmapp/files/Pictures/${snap["image_BP"]}')),
                        ),
                      ),
                      Divider(),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "${snap["nom_BP"]} ${snap["prenom_BP"]}",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Localite: ${snap["idlocalite_BP"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "uid : ${snap["iud_BP"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "fonction: ${snap["idtypefonction_BP"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Sexe: ${snap["idgenre_BP"]}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ),
            ),
          )
              :
          Center(
            child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        //color: Colors.indigo,
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Identifiant du nouveau bracelet",
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      Container(
                        //color: Colors.indigo,
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "$_uid",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                    ],
                  ),
                )
            ),
          );
        }
    ):
    Center(
      child: Container(
        //color: Colors.indigo,
          margin: EdgeInsets.only(bottom: 30.0),
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              //height: 50.0,
              child: Text(
                "Veuillez Scanner le bracelet",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
      ),
    );
  }
}

