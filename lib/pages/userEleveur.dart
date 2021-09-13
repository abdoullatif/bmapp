import 'dart:io';
import 'package:bmapp/database/storageUtil.dart';
import 'package:bmapp/models/add_groupement.dart';
import 'package:bmapp/models/donnee_culture.dart';
import 'package:bmapp/models/donnee_route.dart';
import 'package:bmapp/pages/rendement.dart';
import 'package:bmapp/pages/service_bien_subvention.dart';
import 'package:bmapp/pages/userAgriculteurEleveur.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:bmapp/database/database.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

import 'groupementUser.dart';
import 'membreEleveur.dart';


class UserPannelEleveur extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: UserEleveur(),
    );
  }
}

class UserEleveur extends StatefulWidget {
  @override
  _UserEleveurState createState() => _UserEleveurState();
}

class _UserEleveurState extends State<UserEleveur> {

  //
  final format = DateFormat("yyyy-MM-dd");

  final _formKey3 = GlobalKey<FormState>();
  final _formKey6 = GlobalKey<FormState>();
  final _formKey7 = GlobalKey<FormState>();

  //String
  String _add_culture = "";

  String _unite_mesure = "kilogrammes";
  String _type_elv = "";

  //
  var id_personne = StorageUtil.getString("id_personne");

  TextEditingController _nbre = TextEditingController();
  TextEditingController nature = TextEditingController();
  TextEditingController _poids = TextEditingController();
  //
  TextEditingController _nom_espece = TextEditingController();
  //
  TextEditingController _desc_plantation = TextEditingController();
  TextEditingController _superficie_agriculture = TextEditingController();
  TextEditingController _preciser_culture = TextEditingController();
  TextEditingController _date_rendement_culture = TextEditingController();
  TextEditingController _forme_exploitation = TextEditingController();
  TextEditingController _quantite_semence = TextEditingController();

  String type_exploitation_agriculture = "Individuelle";

  //Bool
  bool eleveur = false;
  bool pecheur = false;
  bool autre = false;
  bool avi = false;
  bool pisci = false;

  bool preciser_culture = false;
  bool culture_save = false;

  //String
  String service_recu = "";
  String bien_recu = "";
  String subvention_recu = "";
  String id_mb_groupement = "";

  //
  String _type_culture = "";



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

  StateSetter _setState;

  @override
  Widget build(BuildContext context)  {
    //

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
    //-------------------------------GEOLOCASATOR----------------------------------------
    Position position;
    Future getPosition() async {
      position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    }
    //-----------------------Culture Agriculture-----------------------------------
    Future<void> SelectCultureAG() async {
      List<Map<String, dynamic>> queryCulture = await DB.querySelectCulture("AG");
      queryCulture += [
        {"nom_culture": "Autre", "nom_culture": "Autre"},
      ];
      return queryCulture;
    }
    //----------------------------------------------------------------------------
    //LISTE DE MES GROUPEMENT
    Future<void> SelectMeGroup() async {
      List<Map<String, dynamic>> queryGroup = await DB.querygroupunionuser(userInfo.id);
      return queryGroup;
    }
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
                                        backgroundColor: Colors.green,
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
                                    '\nPresident : ${newDataList[index]['nom_personne']}  ${newDataList[index]['prenom_personne']}',
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
    //
    Future<List<Map<String, dynamic>>> userprofil() async{
      List<Map<String, dynamic>> queryPerson = await DB.queryUserEleveur(userInfo.id);
      return queryPerson;
    }
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

          //*********************Verification president groupement
          Future<List<Map<String, dynamic>>> MmbreGrp() async {
            List<Map<String, dynamic>> queryMmbreGrp = await DB.queryMbreGrp(snap[0]['id_personne']);
            return queryMmbreGrp;
          }
          //***************************************ELEVEUR**************************************************
          //Selections des membre de menage
          print(snap[0]['id_elevage']);
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
          //***************************************ELEVEUR**************************************************
          //ESPECE
          Future<List<Map<String, dynamic>>> espece() async {
            List<Map<String, dynamic>> queryPerson = await DB.queryEspece(snap[0]['id_elevage']);
            return queryPerson;
          }
          final _espece = FutureBuilder(
              future: espece(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                List<Map<String, dynamic>> espece_elv = snapshot.data;
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
                int n = espece_elv.length;
                final items = List<String>.generate(n, (i) => "Item $i");
                return espece_elv.isNotEmpty ? ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.only(top: 25.0,),
                        elevation: 2.0,
                        child: ListTile(
                          title: Text('Espece: ${espece_elv[index]["espece"]}'),
                          //subtitle: Text('Nombre : ${espece_elv[index]["nbre"]} \nDate de rendement : ${espece_elv[index]["date_rendement"]}'),
                        ),
                      );
                    }
                ) : Container();
              }
          );
          //----les info du graphics femme enceinte
          final _Elevage_profile = snap[0]["menage"] == "Chef" ?
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                width: MediaQuery.of(context).size.width/3,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      //widget
                      Container(
                        padding: EdgeInsets.all(10),
                        child: CircleAvatar(
                          radius: 80,
                          backgroundImage: FileImage(File('/storage/emulated/0/Android/data/com.tulipind.bmapp/files/Pictures/${snap[0]["images"]}')),
                        ),
                      ),
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
                      SizedBox(height: 25.0),
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Type d'activite : Eléveur", //${snap[0]["nom_culture"]}
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
                                "Superficie : ${snap[0]["superficie"]} metre carre",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      Divider(),
                      Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color(0xff01A0C7),
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          onPressed: () async{

                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => GroupementSelect(),settings: RouteSettings(arguments: snap[0]["id_personne"],)),
                            );

                          },
                          child: Text("Groupement", textAlign: TextAlign.center,),
                        ),
                      ),
                      SizedBox(height: 25.0),
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
                      ),
                      /*
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
                      ),*/
                      SizedBox(height: 25.0),
                      snap[0]["nom_fonction"] == "CE" ? Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color(0xff01A0C7),
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          onPressed: () async{
                            //
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Container(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "AJOUTER UNE PLANTATION",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  content: StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setState){
                                      _setState = setState;
                                      //
                                      setSelectedExploitationAgriculture(String val){
                                        setState(() {
                                          type_exploitation_agriculture = val;
                                        });
                                      }
                                      //
                                      if (_type_culture == "Autre") {
                                        preciser_culture = true;
                                      } else {
                                        preciser_culture = false;
                                      }
                                      //
                                      return Container(
                                        width: MediaQuery.of(context).size.width/2,
                                        child: Form(
                                          key: _formKey3,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                //SizedBox(height: 25.0),
                                                TextFormField(
                                                  obscureText: false,
                                                  controller: _desc_plantation,
                                                  decoration: InputDecoration(
                                                    fillColor: Colors.white,
                                                    filled: true,
                                                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                                    hintText: "Description de la plantation",
                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(32.0)),
                                                    //icon: Icon(Icons.photo_size_select_small, color: Colors.black),
                                                    hintStyle:
                                                    TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                                                    //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
                                                    enabledBorder: new UnderlineInputBorder(
                                                        borderSide: new BorderSide(color: Colors.blue)),
                                                    focusedBorder: UnderlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.orange),
                                                    ),
                                                  ),
                                                  validator: (value) {
                                                    if (_desc_plantation.text.isEmpty) {
                                                      return 'Veuiller entrer une information';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                SizedBox(height: 25.0),
                                                TextFormField(
                                                  obscureText: false,
                                                  keyboardType: TextInputType.number,
                                                  controller: _superficie_agriculture,
                                                  decoration: InputDecoration(
                                                    fillColor: Colors.white,
                                                    filled: true,
                                                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                                    hintText: "Superficie",
                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(32.0)),
                                                    //icon: Icon(Icons.photo_size_select_small, color: Colors.black),
                                                    hintStyle:
                                                    TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                                                    //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
                                                    enabledBorder: new UnderlineInputBorder(
                                                        borderSide: new BorderSide(color: Colors.blue)),
                                                    focusedBorder: UnderlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.orange),
                                                    ),
                                                  ),
                                                  validator: (value) {

                                                    String pattern = r'^[0-9]*$'; //(^(?:[+0]9)?[0-9]{10,12}$)
                                                    RegExp regExp = new RegExp(pattern);
                                                    if (_superficie_agriculture.text.length == 0) {
                                                      return 'Veuillez entrer une information';
                                                    }
                                                    else if (_superficie_agriculture.text.isEmpty) {
                                                      return 'Veuillez entrer une information';
                                                    }
                                                    else if (!regExp.hasMatch(_superficie_agriculture.text)) {
                                                      return 'Veuillez entrer un numbre';
                                                    }
                                                    return null;

                                                    if (_superficie_agriculture.text.isEmpty) {
                                                      return 'Veuiller entrer une information';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                SizedBox(height: 25.0),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                      //color: Colors.indigo,
                                                      //margin: EdgeInsets.only(bottom: 30.0),
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: SizedBox(
                                                            //height: 50.0,
                                                            child: Text(
                                                              "Type d'exploitation : ",
                                                              style: TextStyle(
                                                                fontSize: 18.0,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                    ),
                                                    SizedBox(
                                                      width: 50.0,
                                                    ),
                                                    Radio(
                                                      value: "Individuelle",
                                                      groupValue: type_exploitation_agriculture,
                                                      activeColor: Colors.indigo,
                                                      onChanged: (value) {
                                                        print("Radio value is $value");
                                                        setSelectedExploitationAgriculture(value);
                                                      },
                                                    ),
                                                    Container(
                                                      //color: Colors.indigo,
                                                      //margin: EdgeInsets.only(bottom: 30.0),
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: SizedBox(
                                                            //height: 50.0,
                                                            child: Text(
                                                              "Individuelle",
                                                              style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                    ),
                                                    Radio(
                                                      value: "Association ou famille",
                                                      groupValue: type_exploitation_agriculture,
                                                      activeColor: Colors.indigo,
                                                      onChanged: (value) {
                                                        print("Radio value is $value");
                                                        setSelectedExploitationAgriculture(value);
                                                      },
                                                    ),
                                                    Container(
                                                      //color: Colors.indigo,
                                                      //margin: EdgeInsets.only(bottom: 30.0),
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: SizedBox(
                                                            //height: 50.0,
                                                            child: Text(
                                                              "Association ou famille",
                                                              style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 25.0),
                                                Container(
                                                  //color: Colors.indigo,
                                                  //margin: EdgeInsets.only(bottom: 30.0),
                                                    child: Align(
                                                      alignment: Alignment.center,
                                                      child: SizedBox(
                                                        //height: 50.0,
                                                        child: Text(
                                                          "Cultures",
                                                          style: TextStyle(
                                                            fontSize: 20.0,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                ),
                                                SizedBox(height: 25.0),
                                                FutureBuilder(
                                                    future: SelectCultureAG(),
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
                                                        titleText: 'Type de culture',
                                                        hintText: 'culture',
                                                        value: _type_culture,
                                                        onSaved: (value) {
                                                          setState(() {
                                                            _type_culture = value;
                                                          });
                                                        },
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _type_culture = value;
                                                          });
                                                        },
                                                        //snap
                                                        dataSource: snap,
                                                        textField: 'nom_culture',
                                                        valueField: 'nom_culture',
                                                        validator: (value) {
                                                          if (_type_culture == "") {
                                                            return 'Veuiller Slectionner une Culture';
                                                          }
                                                          return null;
                                                        },
                                                      );
                                                    }),
                                                SizedBox(height: 25.0),
                                                Visibility(
                                                  visible: preciser_culture,
                                                  child: Column(
                                                    children: [
                                                      TextFormField(
                                                        obscureText: false,
                                                        controller: _preciser_culture,
                                                        decoration: InputDecoration(
                                                          fillColor: Colors.white,
                                                          filled: true,
                                                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                                          hintText: "Preciser la culture",
                                                          border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(32.0)),
                                                          //icon: Icon(Icons.donut_small, color: Colors.black),
                                                          hintStyle:
                                                          TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                                                          //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
                                                          enabledBorder: new UnderlineInputBorder(
                                                              borderSide: new BorderSide(color: Colors.blue)),
                                                          focusedBorder: UnderlineInputBorder(
                                                            borderSide: BorderSide(color: Colors.orange),
                                                          ),
                                                        ),
                                                        validator: (value) {
                                                          if (_preciser_culture.text.isEmpty) {
                                                            return 'Veuiller entrer une information';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                      SizedBox(height: 25.0),
                                                      TextFormField(
                                                        obscureText: false,
                                                        controller: _forme_exploitation,
                                                        decoration: InputDecoration(
                                                          fillColor: Colors.white,
                                                          filled: true,
                                                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                                          hintText: "Forme d'exploitation",
                                                          border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(32.0)),
                                                          //icon: Icon(Icons.donut_small, color: Colors.black),
                                                          hintStyle:
                                                          TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                                                          //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
                                                          enabledBorder: new UnderlineInputBorder(
                                                              borderSide: new BorderSide(color: Colors.blue)),
                                                          focusedBorder: UnderlineInputBorder(
                                                            borderSide: BorderSide(color: Colors.orange),
                                                          ),
                                                        ),
                                                        validator: (value) {
                                                          if (_forme_exploitation.text.isEmpty) {
                                                            return 'Veuiller entrer une information';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                      SizedBox(height: 25.0),
                                                    ],
                                                  ),
                                                ),

                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 500, //MediaQuery.of(context).size.width/2.8
                                                      child: TextFormField(
                                                        obscureText: false,
                                                        keyboardType: TextInputType.number,
                                                        controller: _quantite_semence,
                                                        decoration: InputDecoration(
                                                          fillColor: Colors.white,
                                                          filled: true,
                                                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                                          hintText: "Quantite de semence",
                                                          border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(32.0)),
                                                          //icon: Icon(Icons.border_color, color: Colors.black),
                                                          hintStyle:
                                                          TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                                                          //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
                                                          enabledBorder: new UnderlineInputBorder(
                                                              borderSide: new BorderSide(color: Colors.blue)),
                                                          focusedBorder: UnderlineInputBorder(
                                                            borderSide: BorderSide(color: Colors.orange),
                                                          ),
                                                        ),
                                                        validator: (value) {

                                                          String pattern = r'^[0-9]*$'; //(^(?:[+0]9)?[0-9]{10,12}$)
                                                          RegExp regExp = new RegExp(pattern);
                                                          if (_quantite_semence.text.length == 0) {
                                                            return 'Veuillez entrer une information';
                                                          }
                                                          else if (_quantite_semence.text.isEmpty) {
                                                            return 'Veuillez entrer une information';
                                                          }
                                                          else if (!regExp.hasMatch(_quantite_semence.text)) {
                                                            return 'Veuillez entrer un numbre';
                                                          }
                                                          return null;

                                                          if (_quantite_semence.text.isEmpty) {
                                                            return 'Veuiller entrer une information';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(width: 30.0,),
                                                    Container(
                                                      width: 100, //MediaQuery.of(context).size.width/10
                                                      child: DropDownFormField(
                                                        titleText: 'Unite de mesure',
                                                        hintText: 'kg/g',
                                                        value: _unite_mesure,
                                                        onSaved: (value) {
                                                          setState(() {
                                                            _unite_mesure = value;
                                                          });
                                                        },
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _unite_mesure = value;
                                                          });
                                                        },
                                                        //snap
                                                        dataSource: [
                                                          {"display": "kilogrammes", "value": "kilogrammes"},
                                                          {"display": "grammes", "value": "grammes"},
                                                          {"display": "boutures", "value": "boutures"},
                                                        ],
                                                        textField: 'display',
                                                        valueField: 'value',
                                                        validator: (value) {
                                                          if (_unite_mesure == "") {
                                                            return 'Veuiller Selectionner une Culture';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: 25.0),
                                                //Date de rendement
                                                DateTimeField(
                                                  format: format,
                                                  controller: _date_rendement_culture,
                                                  decoration: InputDecoration(
                                                    icon: Icon(Icons.date_range, color: Colors.blue),
                                                    hintText: "Date de rendement",
                                                    hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                                                    enabledBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.blue)),
                                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange),),
                                                  ),
                                                  onShowPicker: (context, currentValue) {
                                                    return showDatePicker(
                                                        context: context,
                                                        firstDate: DateTime(1900),
                                                        initialDate: currentValue ?? DateTime.now(),
                                                        lastDate: DateTime(2100));
                                                  },
                                                  validator: (value) {
                                                    if (_date_rendement_culture.text.isEmpty) {
                                                      return 'Veuiller entrer une information';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                SizedBox(height: 25.0),
                                                //
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Annuler',style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                      onPressed: () {
                                        Navigator.of(context).pop('non');
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('Enregistrer',style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                      onPressed: () async{
                                        if (_formKey3.currentState.validate()){
                                          //GPS
                                          getPosition();
                                          //tablette
                                          var _tab = await DB.initTabquery();
                                          var _culture = await DB.querySelectCult(_type_culture);
                                          var _campagne = await DB.queryCampagne();
                                          if(_tab.isNotEmpty){
                                            if(_campagne.isNotEmpty){
                                              var _locate = await DB.queryWherelocate("localite",_tab[0]["locate"]);
                                              if (_locate.isNotEmpty){
                                                //Agriculteur
                                                String idrendeagrigen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                                                String iddetplantgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                                                String idplangen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                                                String iddetcultgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                                                //
                                                int semence;
                                                semence = int.parse(_quantite_semence.text);
                                                double semence_kg;
                                                semence_kg = semence * 1/1000;
                                                //
                                                String idcult = _preciser_culture.text;
                                                String idcul = idcult.replaceAll(" ", "").toUpperCase();
                                                var verif_culture = await DB.queryVerifCult(idcul);

                                                if(_type_culture == "Autre" && idcul != "" || idcul != null && verif_culture.isEmpty){

                                                  //PERSONNE FONCTION
                                                  await DB.updatePersonne("personne_fonction", {
                                                    "nom_fonction": "CAGCE",
                                                    "flagtransmis": "",
                                                  },snap[0]["id_personne"]);
                                                  //PLANTATION
                                                  await DB.insert("plantation", {
                                                    "id_plantation": idplangen,
                                                    "desc_plantation": _desc_plantation.text,
                                                    "superficie": _superficie_agriculture.text,
                                                    "longitude": position != null ? position.longitude : _locate[0]["longitude"],
                                                    "latitude": position != null ? position.latitude : _locate[0]["latitude"],
                                                    "id_localite": _locate[0]["id_localite"],
                                                    "type_exploitation": type_exploitation_agriculture,
                                                    "flagtransmis": "",
                                                  });
                                                  //
                                                  await DB.insert("detenteur_plantation", {
                                                    "id_det_plantation": iddetplantgen,
                                                    "id_personne": snap[0]["id_personne"],
                                                    "id_plantation": idplangen,
                                                    "flagtransmis": "",
                                                  });
                                                  //
                                                  if (_type_culture == "Autre"){

                                                    await DB.insert("culture", {
                                                      "id_culture": idcul,
                                                      "nom_culture": _preciser_culture.text,
                                                      "code": "AG",
                                                      "flagtransmis": "",
                                                    });
                                                    //
                                                    await DB.insert("detenteur_culture", {
                                                      "id_det_culture": iddetcultgen,
                                                      "id_plantation": idplangen,
                                                      "id_culture": idcul,
                                                      "campagneAgricole": _campagne[0]['description'],
                                                      "flagtransmis": "",
                                                    });
                                                    //
                                                    await DB.insert("rendement", {
                                                      "id_rendement": idrendeagrigen,
                                                      "quantite": "0",
                                                      "quantite_semence": _unite_mesure == "grammes" ? semence_kg : semence, // _quantite_semence.text, // ,
                                                      "unites": _unite_mesure,
                                                      "date_rendement": _date_rendement_culture.text,
                                                      "id_det_plantation": iddetplantgen,
                                                      "id_det_culture": iddetcultgen,
                                                      "flagtransmis": "",
                                                    });

                                                  } else {
                                                    await DB.insert("detenteur_culture", {
                                                      "id_det_culture": iddetcultgen,
                                                      "id_plantation": idplangen,
                                                      "id_culture": _culture[0]['id_culture'],
                                                      "campagneAgricole": _campagne[0]['description'],
                                                      "flagtransmis": "",
                                                    });
                                                    //
                                                    await DB.insert("rendement", {
                                                      "id_rendement": idrendeagrigen,
                                                      "quantite": "0",
                                                      "quantite_semence": _unite_mesure == "grammes" ? semence_kg : semence, // _quantite_semence.text,
                                                      "unites": _unite_mesure,
                                                      "date_rendement": _date_rendement_culture.text,
                                                      "id_det_plantation": iddetplantgen,
                                                      "id_det_culture": iddetcultgen,
                                                      "flagtransmis": "",
                                                    });
                                                  }
                                                  //
                                                  //
                                                  setState(() {
                                                    //On vides les champs a zero
                                                    _desc_plantation = TextEditingController(text: "");
                                                    _superficie_agriculture = TextEditingController(text: "");
                                                    _preciser_culture = TextEditingController(text: "");
                                                    _date_rendement_culture  = TextEditingController(text: "");
                                                    _forme_exploitation  = TextEditingController(text: "");
                                                    _type_culture = "";
                                                  });
                                                  //
                                                  Fluttertoast.showToast(
                                                      msg: "Plantation enregistrer avec succes", //Présence enregistrée,
                                                      toastLength: Toast.LENGTH_LONG,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 5,
                                                      backgroundColor: Colors.green,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0
                                                  );
                                                  //
                                                  Navigator.of(context).pop('');
                                                  Navigator.pop(context,() {
                                                    setState(() {});
                                                  });
                                                  //PUSH
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AgriculteurEleveurPannel(),settings: RouteSettings(arguments: DonneeRoute(
                                                      '${snap[0]['id_personne']}', '${snap[0]['nom_fonction']}'
                                                  ))),);

                                                } else if (_type_culture != "Autre"){
                                                  //PERSONNE FONCTION
                                                  await DB.updatePersonne("personne_fonction", {
                                                    "nom_fonction": "CAGCE",
                                                    "flagtransmis": "",
                                                  },snap[0]["id_personne"]);
                                                  //PLANTATION
                                                  await DB.insert("plantation", {
                                                    "id_plantation": idplangen,
                                                    "desc_plantation": _desc_plantation.text,
                                                    "superficie": _superficie_agriculture.text,
                                                    "longitude": position != null ? position.longitude : _locate[0]["longitude"],
                                                    "latitude": position != null ? position.latitude : _locate[0]["latitude"],
                                                    "id_localite": _locate[0]["id_localite"],
                                                    "type_exploitation": type_exploitation_agriculture,
                                                    "flagtransmis": "",
                                                  });
                                                  //
                                                  await DB.insert("detenteur_plantation", {
                                                    "id_det_plantation": iddetplantgen,
                                                    "id_personne": snap[0]["id_personne"],
                                                    "id_plantation": idplangen,
                                                    "flagtransmis": "",
                                                  });
                                                  //
                                                  if (_type_culture == "Autre"){

                                                    await DB.insert("culture", {
                                                      "id_culture": idcul,
                                                      "nom_culture": _preciser_culture.text,
                                                      "code": "AG",
                                                      "flagtransmis": "",
                                                    });
                                                    //
                                                    await DB.insert("detenteur_culture", {
                                                      "id_det_culture": iddetcultgen,
                                                      "id_plantation": idplangen,
                                                      "id_culture": idcul,
                                                      "campagneAgricole": _campagne[0]['description'],
                                                      "flagtransmis": "",
                                                    });
                                                    //
                                                    await DB.insert("rendement", {
                                                      "id_rendement": idrendeagrigen,
                                                      "quantite": "0",
                                                      "quantite_semence": _unite_mesure == "grammes" ? semence_kg : semence, //_quantite_semence.text,
                                                      "unites": _unite_mesure,
                                                      "date_rendement": _date_rendement_culture.text,
                                                      "id_det_plantation": iddetplantgen,
                                                      "id_det_culture": iddetcultgen,
                                                      "flagtransmis": "",
                                                    });

                                                  } else {
                                                    await DB.insert("detenteur_culture", {
                                                      "id_det_culture": iddetcultgen,
                                                      "id_plantation": idplangen,
                                                      "id_culture": _culture[0]['id_culture'],
                                                      "campagneAgricole": _campagne[0]['description'],
                                                      "flagtransmis": "",
                                                    });
                                                    //
                                                    await DB.insert("rendement", {
                                                      "id_rendement": idrendeagrigen,
                                                      "quantite": "0",
                                                      "quantite_semence": _unite_mesure == "grammes" ? semence_kg : semence, // _quantite_semence.text,
                                                      "unites": _unite_mesure,
                                                      "date_rendement": _date_rendement_culture.text,
                                                      "id_det_plantation": iddetplantgen,
                                                      "id_det_culture": iddetcultgen,
                                                      "flagtransmis": "",
                                                    });
                                                  }

                                                  //
                                                  setState(() {
                                                    //On vides les champs a zero
                                                    _desc_plantation = TextEditingController(text: "");
                                                    _superficie_agriculture = TextEditingController(text: "");
                                                    _preciser_culture = TextEditingController(text: "");
                                                    _date_rendement_culture  = TextEditingController(text: "");
                                                    _forme_exploitation  = TextEditingController(text: "");
                                                    _type_culture = "";
                                                  });
                                                  //
                                                  Fluttertoast.showToast(
                                                      msg: "Plantation enregistrer avec succes", //Présence enregistrée,
                                                      toastLength: Toast.LENGTH_LONG,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 5,
                                                      backgroundColor: Colors.green,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0
                                                  );
                                                  //
                                                  Navigator.of(context).pop('');
                                                  Navigator.pop(context,() {
                                                    setState(() {});
                                                  });
                                                  //PUSH
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AgriculteurEleveurPannel(),settings: RouteSettings(arguments: DonneeRoute(
                                                      '${snap[0]['id_personne']}', '${snap[0]['nom_fonction']}'
                                                  ))),);

                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg: "La culture saissi existe déja !", //Présence enregistrée,
                                                      toastLength: Toast.LENGTH_LONG,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 5,
                                                      backgroundColor: Colors.red,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0
                                                  );
                                                }

                                              }
                                            }
                                          }

                                        }

                                      },
                                    ),
                                  ],
                                  //shape: CircleBorder(),
                                );
                              },
                            );
                            //
                          },
                          child: Text("Ajouter une Plantation", textAlign: TextAlign.center,),
                        ),
                      ) : Container(),
                      SizedBox(height: 25.0),
                    ],
                  ),
                ),
              ),
              VerticalDivider(),//-------------------------------------------------
              Container(
                margin: EdgeInsets.only(left: 80.0, right: 50.0),
                width: MediaQuery.of(context).size.width/2,
                child: DefaultTabController(
                    length: 3,
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
                                    child: Text("SUIVIT"),
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
                                    child: Text("ESPECE"),
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
                                    child: Text("MEMBRE MENAGE"),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      body: TabBarView(children: [
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              snap[0]["menage"] == "Chef" ?
                              Column(
                                children: [
                                  //snap[0]["nom_culture"] == "Pisciculture" ?
                                  Column(
                                    children: [
                                      Form(
                                        key: _formKey6,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: <Widget>[
                                              //
                                              //SizedBox(height: 25.0),
                                              Divider(),
                                              Container(
                                                //color: Colors.indigo,
                                                //margin: EdgeInsets.only(bottom: 30.0),
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: SizedBox(
                                                      //height: 50.0,
                                                      child: Text(
                                                        "NOUVELLE  ESPECE",
                                                        style: TextStyle(
                                                          fontSize: 20.0,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                              ),
                                              Divider(),
                                              SizedBox(height: 25.0),
                                              TextFormField(
                                                //keyboardType: TextInputType.number,
                                                obscureText: false,
                                                controller: _nom_espece,
                                                decoration: InputDecoration(
                                                  //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                                  //icon: Icon(Icons.photo_size_select_small, color: Colors.blue),
                                                  hintText: "Nom de l'espece",
                                                  hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                                                  //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
                                                  enabledBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.blue)),
                                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange),),
                                                ),
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return 'Veuiller entrer une information';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              SizedBox(height: 25.0),
                                              //SizedBox(height: 25.0),
                                              Material(
                                                elevation: 5.0,
                                                borderRadius: BorderRadius.circular(30.0),
                                                color: Color(0xff01A0C7),
                                                child: MaterialButton(
                                                  minWidth: MediaQuery.of(context).size.width,
                                                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                                  onPressed: () async{
                                                    if (_formKey6.currentState.validate()) {

                                                      //traitement nom for insert
                                                      String nom_de_espece = _nom_espece.text;
                                                      var verif_espece = await DB.queryverifespelv(nom_de_espece.toLowerCase());
                                                      //verification
                                                      var _tab = await DB.initTabquery();

                                                      if(_tab.isNotEmpty){

                                                        if(verif_espece.isNotEmpty){

                                                          Fluttertoast.showToast(
                                                              msg: "Cette éspèce a déjà été enregistrée ! ",
                                                              toastLength: Toast.LENGTH_LONG,
                                                              gravity: ToastGravity.BOTTOM,
                                                              timeInSecForIosWeb: 5,
                                                              backgroundColor: Colors.red,
                                                              textColor: Colors.white,
                                                              fontSize: 16.0
                                                          );

                                                        } else {

                                                          String idelvespgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                                                          //insertion du nom de la tablette
                                                          await DB.insert("elevage_espece", {
                                                            "id_elv_espece": idelvespgen,
                                                            "id_elevage": snap[0]["id_elevage"],
                                                            "espece": nom_de_espece.toLowerCase(),
                                                            "flagtransmis": "",
                                                          });
                                                          setState(() {
                                                            _nom_espece = TextEditingController()..text = '';
                                                          });

                                                          Fluttertoast.showToast(
                                                              msg: "Nouvelle éspèce enregistré avec succès ! ",
                                                              toastLength: Toast.LENGTH_LONG,
                                                              gravity: ToastGravity.BOTTOM,
                                                              timeInSecForIosWeb: 5,
                                                              backgroundColor: Colors.green,
                                                              textColor: Colors.white,
                                                              fontSize: 16.0
                                                          );

                                                        }

                                                      } else {

                                                        Fluttertoast.showToast(
                                                            msg: "La tablette n'a pas d'identifiant ! ",
                                                            toastLength: Toast.LENGTH_LONG,
                                                            gravity: ToastGravity.BOTTOM,
                                                            timeInSecForIosWeb: 5,
                                                            backgroundColor: Colors.red,
                                                            textColor: Colors.white,
                                                            fontSize: 16.0
                                                        );

                                                      }

                                                    }
                                                  },
                                                  child: Text("Enregistrer",
                                                    textAlign: TextAlign.center,),
                                                ),
                                              ),
                                              SizedBox(height: 25.0),
                                              Divider(),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ), // : Container()
                                  SizedBox(height: 25.0),
                                  Divider(),
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "RENDEMENT",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  Divider(),
                                  Form(
                                    key: _formKey7,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: <Widget>[
                                          snap[0]["nom_culture"] == "Pisciculture" ?
                                          TextFormField(
                                            keyboardType: TextInputType.number,
                                            obscureText: false,
                                            controller: _poids,
                                            decoration: InputDecoration(
                                              //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                              //icon: Icon(Icons.photo_size_select_small, color: Colors.blue),
                                              hintText: "Entre le poids en Kg",
                                              hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                                              //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
                                              enabledBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.blue)),
                                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange),),
                                            ),
                                            validator: (value) {
                                              String pattern = r'^[0-9]*$'; //(^(?:[+0]9)?[0-9]{10,12}$)
                                              RegExp regExp = new RegExp(pattern);
                                              if (value.length == 0) {
                                                return 'Veuillez entrer une information';
                                              }
                                              else if (value.isEmpty) {
                                                return 'Veuillez entrer une information';
                                              }
                                              else if (!regExp.hasMatch(value)) {
                                                return 'Veuillez entrer un numbre';
                                              }
                                              return null;
                                            },
                                          ) : TextFormField(
                                            keyboardType: TextInputType.number,
                                            obscureText: false,
                                            controller: _nbre,
                                            decoration: InputDecoration(
                                              //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                              //icon: Icon(Icons.photo_size_select_small, color: Colors.blue),
                                              hintText: "Nombre de tête",
                                              hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                                              //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
                                              enabledBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.blue)),
                                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange),),
                                            ),
                                            validator: (value) {
                                              String pattern = r'^[0-9]*$'; //(^(?:[+0]9)?[0-9]{10,12}$)
                                              RegExp regExp = new RegExp(pattern);
                                              if (value.length == 0) {
                                                return 'Veuillez entrer une information';
                                              }
                                              else if (value.isEmpty) {
                                                return 'Veuillez entrer une information';
                                              }
                                              else if (!regExp.hasMatch(value)) {
                                                return 'Veuillez entrer un numbre';
                                              }
                                              return null;
                                            },
                                          ),
                                          SizedBox(height: 25.0),
                                          Material(
                                            elevation: 5.0,
                                            borderRadius: BorderRadius.circular(30.0),
                                            color: Color(0xff01A0C7),
                                            child: MaterialButton(
                                              minWidth: MediaQuery.of(context).size.width,
                                              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                              onPressed: () async{
                                                if (_formKey7.currentState.validate()) {
                                                  //verification
                                                  var _tab = await DB.initTabquery();
                                                  String iderendelvgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                                                  //insertion du nom de la tablette
                                                  await DB.insert("rendement_elevage", {
                                                    "id_rendement_elv": iderendelvgen,
                                                    "nbre": snap[0]["nom_culture"] == "Pisciculture" ? _poids.text : _nbre.text,
                                                    "date_rendement": date,
                                                    "id_elevage": snap[0]["id_elevage"],
                                                    "flagtransmis": "",
                                                  });
                                                  setState(() {
                                                    _nbre = TextEditingController()..text = '';
                                                    _poids = TextEditingController()..text = '';
                                                  });

                                                  Fluttertoast.showToast(
                                                      msg: "Rendement enregistré avec succès ! ",
                                                      toastLength: Toast.LENGTH_LONG,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 5,
                                                      backgroundColor: Colors.green,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0
                                                  );
                                                }
                                              },
                                              child: Text("Enregistrer",
                                                textAlign: TextAlign.center,),
                                            ),
                                          ),
                                          SizedBox(height: 25.0),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                ],
                              ) : Center( child: Text("Pas de suivit"),),
                            ],
                          ),
                        ),
                        _espece,

                        FutureBuilder(
                            future: membreMenage(),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              List<Map<String, dynamic>> mbreMenage = snapshot.data;
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
                              //
                              print(mbreMenage);
                              //
                              int n = mbreMenage.length;
                              final items = List<String>.generate(n, (i) => "Item $i");

                              return mbreMenage.isNotEmpty ? Column(
                                children: [
                                  SizedBox(height: 15.0,),
                                  Container(
                                    //color: Colors.indigo,
                                      //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child:Text(
                                            "Nombre de membre : $n",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 5.0,),
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

                                              Navigator.push(context, MaterialPageRoute(builder: (context) => UserMembreEleveur(),settings: RouteSettings(arguments: DonneeRoute(
                                                  '${mbreMenage[index]['id_personne']}', '${mbreMenage[index]['nom_fonction']}'
                                              ))),);

                                            },
                                            child: Card(
                                              margin: EdgeInsets.only(top: 25.0,),
                                              elevation: 2.0,
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  backgroundColor: Colors.transparent,
                                                  foregroundColor: Colors.transparent,
                                                  backgroundImage: FileImage(File('/storage/emulated/0/Android/data/com.tulipind.bmapp/files/Pictures/${mbreMenage[index]['images']}')),
                                                  //backgroundImage: Image.file(file),
                                                ),
                                                title: Text('${mbreMenage[index]['nom_personne']} ${mbreMenage[index]['prenom_personne']}'),
                                                subtitle: mbreMenage[index]['nom_fonction'] == "E" ? Text('Membre Eleveur') :
                                                mbreMenage[index]['nom_fonction'] == "CE" ? Text('Chef menage Eleveur') :
                                                mbreMenage[index]['nom_fonction'] == "AG" ? Text('Membre Agriculteur') :
                                                mbreMenage[index]['nom_fonction'] == "CAG" ? Text('Chef menage Agriculteur') :
                                                Text('${mbreMenage[index]['nom_fonction']}'),
                                              ),
                                            )
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ) : Center(child: Text("Aucun membre enregistrer"),);
                            }
                        ),

                      ]),
                    )
                ),
              ),
            ],
          ) :
          ///-----------------------------------------------------------------------------------------------------------
          ///========================================
          /// =======================================
          /// --------------------------------------------------------------------------------------------------------------
          Center(
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
                                    mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                                    crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                                    children: [
                                      //SizedBox(width: 180.0,),
                                      Column(
                                        children: <Widget>[
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
                                              margin: EdgeInsets.only(bottom: 30.0),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: SizedBox(
                                                  //height: 50.0,
                                                  child: Text(
                                                    "Type d'activite : ${snap[0]["nom_culture"]}",
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
                                                    "Superficie : ${snap[0]["superficie"]} metre carre",
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              )
                                          ),
                                          Divider(),
                                          SizedBox(height: 25.0),
                                        ],
                                      ),

                                      SizedBox(width: 380.0,),

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
                                                          "Status: ${groupmntInfo[0]["statu"]}",
                                                          style: TextStyle(
                                                            fontSize: 14.0,
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
                                                                "Chef Groupement: ${presi[0]["nom_personne"]} ${presi[0]["prenom_personne"]}",
                                                                style: TextStyle(
                                                                  fontSize: 14.0,
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
                                                          "Unions : ${groupmntInfo[0]["union"]}",
                                                          style: TextStyle(
                                                            fontSize: 14.0,
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
          _Elevage_profile;
        }
    );
    //-------------------------------------------------------------------------
    return Container(
      child: _user,
    );
  }
}

