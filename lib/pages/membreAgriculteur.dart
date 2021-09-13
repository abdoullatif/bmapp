import 'dart:io';
import 'package:bmapp/database/storageUtil.dart';
import 'package:bmapp/models/add_groupement.dart';
import 'package:bmapp/models/donnee_culture.dart';
import 'package:bmapp/models/donnee_route.dart';
import 'package:bmapp/pages/rendement.dart';
import 'package:bmapp/pages/service_bien_subvention.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:bmapp/database/database.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

import 'groupementUser.dart';



class UserMembreAgriculteur extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: AuserMembre(),
    );
  }
}


class AuserMembre extends StatefulWidget {
  @override
  _AuserMembreState createState() => _AuserMembreState();
}

class _AuserMembreState extends State<AuserMembre> {

  //
  final format = DateFormat("yyyy-MM-dd");

  //String
  String _add_culture = "";

  String _type_elv = "";

  //
  var id_personne = StorageUtil.getString("id_personne");


  TextEditingController nature = TextEditingController();

  //Bool
  bool eleveur = false;
  bool pecheur = false;
  bool autre = false;
  bool avi = false;
  bool pisci = false;

  //String
  String service_recu = "";
  String bien_recu = "";
  String subvention_recu = "";
  String id_mb_groupement = "";


  setSelectedServiceRecu(String val){
    setState(() {
      service_recu = val;
    });
  }

  setSelectedBienRecu(String val){
    setState(() {
      bien_recu = val;
    });
  }

  setSelectedSubventionRecu(String val){
    setState(() {
      service_recu = val;
    });
  }

  //--------------------------------------------------------------------------
  //-----------------------------------------Selecte groupement-----
  Future<void> SelectGroupement() async {
    List<Map<String, dynamic>> queryGroup = await DB.queryAll("groupement");
    return queryGroup;
  }

  @override
  Widget build(BuildContext context)  {

    //
    if (_add_culture == "Autre"){
      autre = true;
    } else {
      autre = false;
    }
    //
    if (_type_elv == "Aviculture"){
      avi = true;
      pisci = false;
    } else if (_type_elv == "Pisciculture") {
      avi = false;
      pisci = true;
    }else {
      avi = false;
      pisci = false;
    }

    //
    var dateNow = new DateTime.now();
    var dates = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    var date = dates.toString();
    final DonneeRoute userInfo = ModalRoute.of(context).settings.arguments;

    Future<List<Map<String, dynamic>>> userprofil() async{
      List<Map<String, dynamic>> queryPerson = await DB.queryUserAgriculteurAG(userInfo.id);
      return queryPerson;
    }
    //-----------------------------Group--------------------------------------
    //LISTE DES GROUPEMENT
    Future<void> SelectAllGroupement() async {
      List<Map<String, dynamic>> queryGroup = await DB.querygroupinfo();
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
                              List<Map<String, dynamic>> _groupmnt = await DB.queryverifgroupmnt(userInfo.id,snap[index]['id_groupement']);
                              List<Map<String, dynamic>> _ifexiste = await DB.queryverifgroup(userInfo.id);
                              //List<Map<String, dynamic>> _groupmnt = await DB.queryverifgroupmnt(idpersonne);
                              if(_tab.isNotEmpty){
                                //id genere
                                String idmbgroupgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                                //Insertion
                                if(_ifexiste.isEmpty){
                                  //
                                  await DB.insert("membre_groupement", {
                                    "id_mb_groupement": idmbgroupgen,
                                    "id_personne": userInfo.id,
                                    "id_groupement": snap[index]['id_groupement'],
                                    "statu": "membre",
                                    "flagtransmis": "",
                                  });
                                  //
                                  Fluttertoast.showToast(
                                      msg: "Adherer au groupement ! ! ", //Présence enregistrée,
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 5,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                  //
                                  setState(() {
                                    confirm = "";
                                  });
                                } else {
                                  //
                                  Fluttertoast.showToast(
                                      msg: "Vous avez déjà adhere a un groupement !", //Présence enregistrée,
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 5,
                                      backgroundColor: Colors.redAccent,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
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
                              title: Text('Groupement: ${newDataList[index]['nom_groupement']} \nActivites: ${newDataList[index]['activite_groupement']} \nUnion: ${newDataList[index]['description_un']}'
                                  '\nPresident(e) : ${newDataList[index]['nom_personne']}  ${newDataList[index]['prenom_personne']}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text('Toucher pour Adherer'),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 40.0,),
                ]
            ),
          );
        }
    );
    //---------------------------future builder------------------------------------------
    final _user = FutureBuilder(
        future: userprofil(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List<Map<String, dynamic>> snap = snapshot.data;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Erreur de chargement, Veuillez ressaillez"),
            );
          }

          //-----------------------------------------------------------------------------------------------
          Future<List<Map<String, dynamic>>> MmbreGrp() async {
            List<Map<String, dynamic>> queryMmbreGrp = await DB.queryMbreGrp(snap[0]['id_personne']);
            return queryMmbreGrp;
          }
          //***************************************ELEVEUR**************************************************
          //Selections des membre de menage
          Future<List<Map<String, dynamic>>> membreMenage() async {
            List<Map<String, dynamic>> querymembreMenage = await DB.queryMembreEleveur(snap[0]['id_elevage']);
            return querymembreMenage;
          }
          //***************************************Groupement**************************************************
          //Selections des Info group
          Future<List<Map<String, dynamic>>> groupementInfo() async {
            List<Map<String, dynamic>> querygroupementInfo = await DB.queryInfoGroupmt(snap[0]['id_personne']);
            return querygroupementInfo;
          }
          //-------------------------------------------

          //les agriculteurs
          final _Culture = Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 100, //
              child: Column(
                //shrinkWrap: true,
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: CircleAvatar(
                        radius: 80,
                        backgroundImage: FileImage(File('/storage/emulated/0/Android/data/com.tulipind.bmapp/files/Pictures/${snap[0]["images"]}')),
                      ),
                    ),
                  ),
                  //Divider(),
                  Expanded(
                    child: DefaultTabController(
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
                                      child: Text("INFORMATION/ACTIVITES"),
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
                                      child: Text("GROUPEMENT"),
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                        body: TabBarView(children: [
                          Container(
                            padding: EdgeInsets.all(20.0),
                            width: MediaQuery.of(context).size.width/3,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround, //Center Row contents horizontally,
                                    crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                                    children: [
                                      //SizedBox(width: 180.0,),
                                      Column(
                                        children: <Widget>[
                                          //
                                          SizedBox(width: 300.0,),
                                          //widget
                                          Divider(),
                                          Container(
                                            //color: Colors.indigo,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: SizedBox(
                                                  //height: 50.0,
                                                  child: Text(
                                                    "Identifiant:  ${snap[0]["id_personne"]}",
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              )
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
                                                    "${snap[0]["nom_personne"]} ${snap[0]["prenom_personne"]}",
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
                                                    "Menage : ${snap[0]["menage"]}",
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
                                                    "Localite: ${snap[0]["descriptions"]}",
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
                                                //alignment: Alignment.center,
                                                child: SizedBox(
                                                  //height: 50.0,
                                                  child: Text(
                                                    "Contacte: ${snap[0]["tel_personne"]}",
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
                                                    "Age: ${snap[0]["age"]}",
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
                                                    "Sexe: ${snap[0]["genre"]}",
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              )
                                          ),
                                          Divider(),
                                          Container(
                                            //color: Colors.indigo,
                                            //margin: EdgeInsets.only(bottom: 10.0),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: SizedBox(
                                                  //height: 50.0,
                                                  child: Text(
                                                    "Plantation",
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              )
                                          ),
                                          Divider(),
                                          SizedBox(height: 10.0),
                                          Container(
                                            //color: Colors.indigo,
                                              margin: EdgeInsets.only(bottom: 15.0),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: SizedBox(
                                                  //height: 50.0,
                                                  child: Text(
                                                    "Description: ${snap[0]["desc_plantation"]}",
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
                                              margin: EdgeInsets.only(bottom: 15.0),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: SizedBox(
                                                  //height: 50.0,
                                                  child: Text(
                                                    "Superficie: ${snap[0]["superficie"]} metre carré",
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

                                      //SizedBox(width: 350.0,),

                                      FutureBuilder(
                                          future: groupementInfo(),
                                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                                            List<Map<String, dynamic>> groupmntInfo = snapshot.data;
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            }
                                            if (snapshot.hasError) {
                                              return Center(
                                                child: Text("Erreur de chargement, Veuillez ressaillez"),
                                              );
                                            }

                                            //***************************************Groupement**************************************************
                                            //Selections des Info group
                                            Future<List<Map<String, dynamic>>> infogroupmtpresit() async {
                                              List<Map<String, dynamic>> querygroupementInfo = await DB.queryPreGrp(groupmntInfo[0]['id_groupement']);
                                              return querygroupementInfo;
                                            }

                                            return groupmntInfo.isNotEmpty ? Column(
                                              children: <Widget>[

                                                Container(
                                                  //color: Colors.indigo,
                                                    margin: EdgeInsets.only(bottom: 30.0),
                                                    child: Align(
                                                      alignment: Alignment.center,
                                                      child: SizedBox(
                                                        //height: 50.0,
                                                        child: Text(
                                                          "Groupement : ${groupmntInfo[0]["nom_groupement"]}",
                                                          style: TextStyle(
                                                            fontSize: 16.0,
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
                                                      //alignment: Alignment.center,
                                                      child: SizedBox(
                                                        //height: 50.0,
                                                        child: Text(
                                                          "Status: ${groupmntInfo[0]["statu"]}",
                                                          style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                ),

                                                FutureBuilder(
                                                    future: infogroupmtpresit(),
                                                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                                                      List<Map<String, dynamic>> presi = snapshot.data;
                                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                                        return Center(
                                                          child: CircularProgressIndicator(),
                                                        );
                                                      }
                                                      if (snapshot.hasError) {
                                                        return Center(
                                                          child: Text("Erreur de chargement, Veuillez ressaillez"),
                                                        );
                                                      }
                                                      return Container(
                                                        //color: Colors.indigo,
                                                          margin: EdgeInsets.only(bottom: 30.0),
                                                          child: Align(
                                                            alignment: Alignment.center,
                                                            child: SizedBox(
                                                              //height: 50.0,
                                                              child: Text(
                                                                "Président(e) Groupement: ${presi[0]["nom_personne"]} ${presi[0]["prenom_personne"]}",
                                                                style: TextStyle(
                                                                  fontSize: 16.0,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                      );
                                                    }
                                                ),

                                                Container(
                                                  //color: Colors.indigo,
                                                    margin: EdgeInsets.only(bottom: 30.0),
                                                    child: Align(
                                                      alignment: Alignment.center,
                                                      child: SizedBox(
                                                        //height: 50.0,
                                                        child: Text(
                                                          "Activites Groupement: ${groupmntInfo[0]["activite_groupement"]}",
                                                          style: TextStyle(
                                                            fontSize: 16.0,
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
                                                          "Unions : ${groupmntInfo[0]["description_un"]}",
                                                          style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                ),
                                                Divider(),
                                                SizedBox(height: 25.0),
                                              ],
                                            ) : Container(child: Text('Vous n\'avez adhere a aucun groupement'),);
                                          }
                                      ),

                                    ],
                                  ),
                                  FutureBuilder(
                                      future: MmbreGrp(),
                                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                                        List<Map<String, dynamic>> mbreGrp = snapshot.data;
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        if (snapshot.hasError) {
                                          return Center(
                                            child: Text("Erreur de chargement, Veuillez ressaillez"),
                                          );
                                        }
                                        return mbreGrp.isNotEmpty ?
                                        Material(
                                          elevation: 5.0,
                                          borderRadius: BorderRadius.circular(30.0),
                                          color: Color(0xff01A0C7),
                                          child: MaterialButton(
                                            minWidth: MediaQuery.of(context).size.width,
                                            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                            onPressed: () async{
                                              Navigator.push(context, MaterialPageRoute(
                                                  builder: (context) => ServiceBienSubvention(),settings: RouteSettings(arguments: snap[0]["id_personne"],)),
                                              );
                                            },
                                            child: Text("Suivit & Aide", textAlign: TextAlign.center,),
                                          ),
                                        ) :
                                        Container(
                                          child: Text(""),
                                        );
                                      }
                                  ),
                                  SizedBox(height: 25.0),
                                ],
                              ),
                            ),
                          ),
                          _groupement,
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );

          return snap.isEmpty ? Center(
            child: Text("Un probleme est survenir lors du chargement des informations !"),
          ) :
           _Culture;
        }
    );

    //-------------------------------------------------------------------------

    return Container(
      child: _user,
    );
  }
}

