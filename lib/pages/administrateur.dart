//package native
import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:bmapp/database/storageUtil.dart';
import 'package:bmapp/models/chef_groupement.dart';
import 'package:bmapp/models/ferme_model.dart';
import 'package:bmapp/pages/ForgetUid.dart';
import 'package:bmapp/pages/Pdaig_website.dart';
import 'package:bmapp/pages/groupement.dart';
import 'package:bmapp/pages/langue.dart';
import 'package:bmapp/pages/parametre.dart';
import 'package:bmapp/pages/profile_agent.dart';
import 'package:bmapp/pages/suivit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import 'package:intl/intl.dart';

import 'package:flutter/foundation.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:flutter/services.dart';


//package importer
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:dropdown_search/dropdown_search.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart';


//package sooba
import 'package:bmapp/database/database.dart';
import 'package:bmapp/models/plantation_model.dart';
import 'package:random_string/random_string.dart';
import 'package:bmapp/pages/zone.dart';
import 'package:shared_preferences/shared_preferences.dart';



//Login
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {


  //variable all
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _mdp = TextEditingController();

  String uids = "";
  String nfc = "";

  @override
  Widget build(BuildContext context) {
    //
    FlutterNfcReader.read().then((response) {
      //print(response.id.substring(2));
      uids = response.id.substring(2);
      nfc = uids.toUpperCase();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.only(left: 200.0, right: 200.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 200.0,
                      child: Image.asset(
                        "images/logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      obscureText: false,
                      controller: _email,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(0.0),
                          child: Icon(
                            Icons.account_circle,
                            color: Colors.grey,
                          ), // icon is 48px widget.
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Veuiller entrer votre addresse email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: _mdp,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(0.0),
                          child: Icon(
                            Icons.vpn_key,
                            color: Colors.grey,
                          ), // icon is 48px widget.
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Veuiller entrer votre mot de passe';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(30.0),
                      color: Color(0xff01A0C7),
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            //Verification
                            List<Map<String, dynamic>> tab = await DB.queryAll("parametre");
                            if (true) {
                              //
                              List<Map<String, dynamic>> personne = await DB.query2Where("personne",_email.text,_mdp.text);
                              //
                              if(personne.isNotEmpty) {
                                if(nfc != ""){
                                  List<Map<String, dynamic>> verifUid = await DB.query3Where("personne",_email.text,_mdp.text,nfc);
                                  if(verifUid.isNotEmpty){
                                    //
                                    List<Map<String, dynamic>> Agent = await DB.queryAgent(verifUid[0]['id_personne']);
                                    //Enregistrement des donnees en memoir
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setString('id_personne', Agent[0]['id_personne']);
                                    prefs.setString('nom', Agent[0]['nom_personne']);
                                    prefs.setString('prenom', Agent[0]['prenom_personne']);
                                    prefs.setString('tel', Agent[0]['tel_personne']);
                                    prefs.setString('genre', Agent[0]['genre']);
                                    prefs.setString('age', Agent[0]['age']);
                                    prefs.setString('uids', Agent[0]['uids']);
                                    prefs.setString('email', Agent[0]['email']);
                                    prefs.setString('mdp', Agent[0]['mdp']);
                                    prefs.setString('images', Agent[0]['images']);
                                    //Localite
                                    prefs.setString('localite', Agent[0]['descriptions']);
                                    //Fonction
                                    prefs.setString('fonction', Agent[0]['nom_fonction']);
                                    //
                                    setState(() {
                                      _email = TextEditingController(text: "");
                                      _mdp = TextEditingController(text: "");
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Administrateur()),
                                    );
                                    //
                                  } else {
                                    var confirm = await showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Authentification"),
                                          content: Text(
                                            'Bracelet non correspondant', style: TextStyle(color: Colors.red,),),
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
                                } else {
                                  var confirm = await showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Authentification"),
                                        content: Text(
                                          'Veuillez Scanner votre bracelet pour confirmer votre identite', style: TextStyle(color: Colors.green,),),
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
                              } else if(_email.text == "SuperAdmin@tld.com" && _mdp.text == "Tulip2020") {
                                //
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setString('id_personne', "007");
                                prefs.setString('nom', "Super");
                                prefs.setString('prenom', "Admin");
                                prefs.setString('email', "SuperAdmin@tld.com");
                                //
                                setState(() {
                                  _email = TextEditingController(text: "");
                                  _mdp = TextEditingController(text: "");
                                });
                                //
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Administrateur()),
                                );
                              } else {
                                //Error
                                var confirm = await showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Probleme d\'authentification"),
                                      content: Text(
                                        'Eurreur d\'authentification mot de passe ou email incorrecte', style: TextStyle(color: Colors.black,),),
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
                            } else {
                              Scaffold.of(context)
                                  .showSnackBar(SnackBar(content: Text('La tablette pas identifiant')));
                            }
                          }
                        },
                        child: Text(
                          "Se Connecter",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//Page administateur
class Administrateur extends StatefulWidget {
  @override
  _AdministrateurState createState() => _AdministrateurState();
}

class _AdministrateurState extends State<Administrateur> {
  @override
  Widget build(BuildContext context) {
    //
    var email = StorageUtil.getString("email");

    return Scaffold(
      appBar: AppBar(
        title: Text("Administration"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: Text("nom prenom"),
              accountEmail: Text("email"),
              currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Text('A', style: TextStyle(color: Colors.black87))),
              /*
              decoration: new BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xff74ABE4), Color(0xffA892ED)]),
              ),
              */
            ),
            email == "SuperAdmin@tld.com" ? new ListTile(
                leading: Icon(Icons.tablet),
                title: Text("Parametre"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ParametreTablette()),);
                }) : Container(),
            new ListTile(
                leading: Icon(Icons.person),
                title: new Text("Mes informations"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileAgent()),);
                }),
            new ListTile(
                leading: Icon(Icons.language),
                title: new Text("Langue / Localite"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Langues()),);
                }),
            new ListTile(
                leading: Icon(Icons.nfc_rounded),
                title: new Text("Braceles perdu"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetUid()),);
                }),
            new Divider(),
            new ListTile(
                leading: Icon(Icons.info),
                title: new Text("A propos"),
                onTap: () {
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          /*
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color.fromARGB(255, 30, 198, 89), Color.fromARGB(255, 96, 96, 96)],
                stops: [0, 1],
              )
          ),
           */
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3.2,
                  child: Image.asset(
                    "images/logo.png",
                    height: 150,
                    width: 200,
                  ),
                ),
                Container(
                  child: Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Container(
                          child: Card(
                            color: Colors.transparent,
                            elevation: 0,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Add_user()),
                                );
                              },
                              child: Image.asset("images/add.png"),
                            ),
                          ),
                        ),
                        Container(
                          child: Card(
                            color: Colors.transparent,
                            elevation: 0,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Listsuivit()),
                                );
                              },
                              child: Image.asset("images/supervision.png"),
                            ),
                          ),
                        ),
                        Container(
                          child: Card(
                            color: Colors.transparent,
                            elevation: 0,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Addgroupement()),
                                );
                              },
                              child: Image.asset("images/groupement.png"),
                            ),
                          ),
                        ),
                        Container(
                          child: Card(
                            color: Colors.transparent,
                            elevation: 0,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Zone()),
                                );
                              },
                              child: Image.asset("images/zone.png"),
                            ),
                          ),
                        ),
                        Container(
                          child: Card(
                            color: Colors.transparent,
                            elevation: 0,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Pdaig_website()),
                                );
                              },
                              child: Image.asset("images/pdaig.png"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //
          //remove all share pre
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove("id_personne");
          prefs.remove("nom");
          prefs.remove("prenom");
          prefs.remove("age");
          prefs.remove("genre");
          prefs.remove("tel");
          prefs.remove("uids");
          prefs.remove("email");
          prefs.remove("mdp");
          prefs.remove("images");
          prefs.remove("localite");
          prefs.remove("");
          prefs.remove("fonction");
          //
          Navigator.pop(context);
        },
        tooltip: 'Quitter',
        backgroundColor: Colors.transparent,
        child: Image.asset("images/close.png"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

//
class Add_user extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Sreen1(),
    );
  }
}

//Page formulaire
class Sreen1 extends StatefulWidget {
  @override
  _Sreen1State createState() => _Sreen1State();
}

class _Sreen1State extends State<Sreen1> {
  //-----------------------------------------------------------------------------------
  List<GlobalKey<FormState>> formKeys = [GlobalKey<FormState>(), GlobalKey<FormState>(), GlobalKey<FormState>(), GlobalKey<FormState>()];
  //-------------------------------GEOLOCASATOR----------------------------------------
  Position position;
  Future getPosition() async {
    position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
  //-----------------------------IMAGE PICKED-------------------------------------
  File _imagefile;
  String _images = "";
  String _imageLocation;
  final picker = ImagePicker();
  //
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    _imagefile = File(pickedFile.path);
    _images = basename(_imagefile.path);
    final photo = File("/storage/emulated/0/DCLM/Camera/$_images");
    //state
    setState(() {
      _imagefile = File(pickedFile.path);
      _images = basename(_imagefile.path);
      _imageLocation = pickedFile.path;
    });
    //await photo.delete();
  }
  //----------------------------------------------------------------------------
  //****************************************************************************
  String nfc_msg_visible = "false";
  searchuid (uid) async {
    List<Map<String, dynamic>> queryPersonne = await DB.queryWhereUid("personne", uid);
    if(queryPersonne.isNotEmpty){
      if(queryPersonne[0]['iud'] == uid){
        nfc_msg_visible = "exist";
      } else {
        nfc_msg_visible = "exist";
      }
    } else {
      nfc_msg_visible = "true";
    }
  }
  //----------------------------------------------------------------------------

  //final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  //var countriesKey = GlobalKey<FindDropdownState>();

  //variable input
  //final _formKey = GlobalKey<FormState>();

  TextEditingController _nom = TextEditingController();
  TextEditingController _prenom = TextEditingController();
  TextEditingController _telephone = TextEditingController();
  TextEditingController _autre_lien = TextEditingController();
  TextEditingController _desc_plantation = TextEditingController();
  TextEditingController _superficie_agriculture = TextEditingController();
  TextEditingController _superficie_elevage = TextEditingController();
  TextEditingController _preciser_culture = TextEditingController();
  TextEditingController _preciser_type_elevage = TextEditingController();
  TextEditingController _nombre = TextEditingController();
  TextEditingController _date_rendement_culture = TextEditingController();
  TextEditingController _date_rendement_elevage = TextEditingController();
  //
  TextEditingController _type_exploitation = TextEditingController();
  TextEditingController _forme_exploitation = TextEditingController();
  //
  //TextEditingController _culture = TextEditingController();
  TextEditingController _quantite_semence = TextEditingController();

  //Bool
  bool chef = false;
  bool autre_lien = false;
  bool chefElv = false;
  //
  bool membre_agriculteur = false;
  bool eleveur = false;
  bool CE = false;
  bool pecheur = false;
  bool CP = false;
  bool personne = false;
  //
  bool travail_culture = false;
  bool agriculteur = false;

  //
  bool avicole = false;
  bool pisciculture = false;
  bool autre_type_elevage = false;
  bool preciser_culture = false;
  bool culture_save = false;

  //Chekbox
  //bool checkedValue; //Radio

  //
  //Checkbox value
  List _espece_pisciculture = List();
  bool _espece1 = false;
  bool _espece2 = false;
  bool _espece3 = false;
  bool _espece4 = false;


  //var
  String _localites = "";
  String _genre = "";
  //
  String _activite = "";
  String _type_culture = "";
  String _menage = "";
  String _lien = "";
  String _travail_culture = "";
  String _type_elevage = "";
  String id_culture = "";
  String _nom_fonction = "";
  String plantation;
  String ferme;
  //
  String _uids = "";

  //
  int _currentStep = 0;

  //
  final format = DateFormat("yyyy-MM-dd");

  StepperType _stepperType = StepperType.vertical;

  //
  switchStepType() {
    setState(() => StepperType == StepperType.vertical
        ? _stepperType = StepperType.horizontal
        : _stepperType == StepperType.vertical);
  }

  //Radio
  String age = "";
  String type_exploitation_agriculture = ""; //Radio
  String type_exploitation_elevage = ""; //Radio
  String type_exploitation_avicole = ""; //Radio
  String type_exploitation_pisciculture = ""; //Radio
  String forme_exploitation_avicole = ""; //Radio
  String forme_exploitation_piscicole = ""; //Radio

  @override
  void iniState(){
    super.initState();
    //
    _localites = "";
    _genre = "";
    _activite = "";
    _type_culture = "";
    _menage = "";
    _lien = "";
    _travail_culture = "";
    _type_elevage = "";
    id_culture = "";
    _uids = "";
    _nom_fonction = "";
  }

  setSelectedAge(String val){
    setState(() {
      age = val;
    });
  }

  setSelectedExploitationAgriculture(String val){
    setState(() {
      type_exploitation_agriculture = val;
    });
  }

  setSelectedExploitationElevage(String val){
    setState(() {
      type_exploitation_elevage = val;
    });
  }

  setSelectedExploitationAvicole(String val){
    setState(() {
      forme_exploitation_avicole = val;
    });
  }

  setSelectedExploitationPisciculture(String val){
    setState(() {
      forme_exploitation_piscicole = val;
    });
  }

  //----------------------localites---------------------------------------------
  Future<void> SelectLocalite() async {
    List<Map<String, dynamic>> queryLocalite = await DB.queryAll("localite");
    return queryLocalite;
  }
  //-----------------------Culture elevage-----------------------------------
  Future<void> SelectCultureEL() async {
    List<Map<String, dynamic>> queryCulture = await DB.querySelectCulture("EL");
    queryCulture += [{"nom_culture": "Autre", "nom_culture": "Autre"}];
    return queryCulture;
  }

  List culture = [
    {"display": "Riziculture", "value": "Riziculture"},
    {"display": "Maïs culture", "value": "Maïs culture"},
    {"display": "Aviculture", "value": "Aviculture"},
    {"display": "Pisciculture", "value": "Pisciculture"},
    {"display": "Pomme de terre", "value": "Pomme de terre"},
    {"display": "Maraichage", "value": "Maraichage"},
  ];
  //-----------------------Culture elevage-----------------------------------
  Future<void> SelectCultureAG() async {
    List<Map<String, dynamic>> queryCulture = await DB.querySelectCulture("AG");
    queryCulture += [
      {"nom_culture": "Autre", "nom_culture": "Autre"},
    ];
    return queryCulture;
  }
  //---------------------------Autre--------------------------------------------

  //----------------------SELECTION PALANTATION---------------------------------
  //----------------------------------------------------------------------------
  Future<List<PlantationModel>> getData(filter) async {
    /*
    var response = await Dio().get(
      "http://5d85ccfb1e61af001471bf60.mockapi.io/user",
      queryParameters: {"filter": filter},
    );
    */
    List<Map<String, dynamic>> tab = await DB.queryAll("parametre");
    var _locate = await DB.queryWherelocate("localite",tab[0]["locate"]);
    List<Map<String, dynamic>> queryRows = await DB.queryPlantation(_locate[0]["id_localite"].toString());
    var models = PlantationModel.fromJsonList(queryRows);
    return models;
  }
  //----------------------SELECTION FERME---------------------------------
  //----------------------------------------------------------------------------
  Future<List<fermeModel>> getDataFerme(filter) async {
    List<Map<String, dynamic>> tab = await DB.queryAll("parametre");
    var _locate = await DB.queryWherelocate("localite",tab[0]["locate"]);
    List<Map<String, dynamic>> queryRows = await DB.queryFerme(_locate[0]["id_localite"].toString());
    var modelFerme = fermeModel.fromJsonList(queryRows);
    return modelFerme;
  }
  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    //
    getPosition();
    //
    FlutterNfcReader.read().then((response) {
      //print(response.id.substring(2));
      _uids = response.id.substring(2);
      String nfc = _uids.toUpperCase();
      setState(() {
        if(mounted) {
          searchuid(nfc);
        } else {
          searchuid(nfc);
        }
      });
    });

    //
    //Visibiliter chef ou membre
    if(_menage == "membre" && _activite == "Agriculteur"){
      chef = true;
      chefElv = false;
    } else if (_menage == "membre" && _activite == "Eleveur") {
      chef = false;
      chefElv = true;
    } else {
      chef = false;
      chefElv = false;
    }
    //Visibilite Autre
    if(_lien == "Autre"){
      autre_lien = true;
    } else {
      autre_lien = false;
    }
    //Visibilite Type de personne
    if(_menage == "Chef" && _activite == "Agriculteur"){
      agriculteur = true;
      membre_agriculteur = false;
      eleveur = false;
      _nom_fonction = "CAG";
    } else if(_menage == "membre" && _activite == "Agriculteur"){
      membre_agriculteur = true;
      agriculteur = false;
      eleveur = false;
      _nom_fonction = "AG";
    } else if(_menage == "membre" && _activite == "Eleveur"){
      eleveur = false;
      agriculteur = false;
      membre_agriculteur = false;
      _nom_fonction = "E";
    } else if(_menage == "Chef" && _activite == "Eleveur"){
      eleveur = true;
      agriculteur = false;
      membre_agriculteur = false;
      _nom_fonction = "CE";
    }else {
      eleveur = false;
      agriculteur = false;
      membre_agriculteur = false;
    }
    //Visibilty culture  membre
    if(_travail_culture == "Oui"){
      travail_culture = true;
    } else {
      travail_culture = false;
    }
    //
    if(_type_elevage == "Aviculture"){
      avicole = true;
      pisciculture = false;
      autre_type_elevage = false;
      culture_save = false;
    } else if (_type_elevage == "Pisciculture"){
      pisciculture = true;
      avicole = false;
      autre_type_elevage = false;
      culture_save = false;
    } else if(_type_elevage == "Autre"){
      autre_type_elevage = true;
      pisciculture = false;
      avicole = false;
      culture_save = false;
    } else if (_type_elevage != "Aviculture" && _type_elevage != "Pisciculture" && _type_elevage != "Autre"){
      culture_save = true;
      pisciculture = false;
      avicole = false;
      autre_type_elevage = false;
    }
    else {
      culture_save = false;
      pisciculture = false;
      avicole = false;
      autre_type_elevage = false;
    }
    //
    if (_type_culture == "Autre") {
      preciser_culture = true;
    } else {
      preciser_culture = false;
    }
    //
    //--------------------------------------------------------------------------
    return Container(
      margin: EdgeInsets.only(left: 100.0, right: 100.0, top: 50.0),
      child: Stepper(
        steps: _stepper(),
        physics: ClampingScrollPhysics(),
        currentStep: this._currentStep,
        type: StepperType.horizontal,
        onStepTapped: (step) {
          setState(() {
            this._currentStep = step;
          });
        },
        onStepContinue: () {
          setState(() {

            //fonction d'enregistrement
            addUser () async {
              //nom de la tablette
              var _tab = await DB.initTabquery();
              var _culture_ele = await DB.querySelectCult(_type_elevage);
              var _culture = await DB.querySelectCult(_type_culture);
              var _campagne = await DB.queryCampagne();
              if(_tab.isNotEmpty){
                print(_campagne);
                if(_campagne.isNotEmpty){
                  var _locate = await DB.queryWherelocate("localite",_tab[0]["locate"]);
                  if (_locate.isNotEmpty){
                    //id genere
                    String idpersonnegen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                    String idpersonneaddgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                    String iddetcultgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                    String idpersonnefongen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                    //Agriculteur
                    String idrendeagrigen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                    //
                    String iddetplantgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                    String idplangen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                    //elevage
                    String idelevgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                    String idrendelevgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                    String idmbelevgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                    //
                    var dateNow = new DateTime.now();

                    if (_menage == "Chef") {
                      //personne
                      await DB.insert("personne", {
                        "id_personne": idpersonnegen,
                        "nom_personne": _nom.text,
                        "prenom_personne": _prenom.text,
                        "tel_personne": _telephone.text,
                        "genre": _genre,
                        "age": age,
                        "menage": _menage,
                        "liens": "",
                        "uids": _uids.toUpperCase(),
                        "email": "",
                        "mdp": "",
                        "images": _images,
                        "flagtransmis": "",
                      });
                    } else {
                      //personne
                      await DB.insert("personne", {
                        "id_personne": idpersonnegen,
                        "nom_personne": _nom.text,
                        "prenom_personne": _prenom.text,
                        "tel_personne": _telephone.text,
                        "genre": _genre,
                        "age": age,
                        "menage": _menage,
                        "liens": _lien == "Autre" ? _autre_lien.text : _lien,
                        "uids": _uids.toUpperCase(),
                        "email": "",
                        "mdp": "",
                        "images": _images,
                        "flagtransmis": "",
                      });
                    }
                    //-----------------------------Continuous------------------------------
                    //personne_adresse
                    await DB.insert("personne_adresse", {
                      "id_prs_adresse": idpersonneaddgen,
                      "id_personne": idpersonnegen,
                      "id_localite": _locate[0]["id_localite"],
                      "flagtransmis": "",
                    });
                    //personne_fonction
                    await DB.insert("personne_fonction", {
                      "id_prs_fonction": idpersonnefongen,
                      "nom_fonction": _nom_fonction,
                      "id_personne": idpersonnegen,
                      "flagtransmis": "",
                    });
                    //
                    if (_menage == "Chef" && _activite == "Agriculteur") {
                      //Insertion en fonction des admin
                      await DB.insert("plantation", {
                        "id_plantation": idplangen,
                        "desc_plantation": _desc_plantation.text,
                        "superficie": _superficie_agriculture.text,
                        "longitude": position.longitude,
                        "latitude": position.latitude,
                        "id_localite": _locate[0]["id_localite"],
                        "type_exploitation": type_exploitation_agriculture,
                        "flagtransmis": "",
                      });
                      //
                      await DB.insert("detenteur_plantation", {
                        "id_det_plantation": iddetplantgen,
                        "id_personne": idpersonnegen,
                        "id_plantation": idplangen,
                        "flagtransmis": "",
                      });
                      //
                      if (_type_culture == "Autre"){
                        String idcult = _preciser_culture.text;
                        String idcul = idcult.replaceAll(" ", "").toUpperCase();
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
                          "quantite_semence": _quantite_semence.text,
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
                          "quantite_semence": _quantite_semence.text,
                          "date_rendement": _date_rendement_culture.text,
                          "id_det_plantation": iddetplantgen,
                          "id_det_culture": iddetcultgen,
                          "flagtransmis": "",
                        });
                      }
                      //
                    } else if (_menage == "membre" && _activite == "Agriculteur"){
                      //
                      await DB.insert("detenteur_plantation", {
                        "id_det_plantation": iddetplantgen,
                        "id_personne": idpersonnegen,
                        "id_plantation": plantation,
                        "flagtransmis": "",
                      });
                      /*
                      //
                      await DB.insert("detenteur_culture", {
                        "id_det_culture": iddetcultgen,
                        "id_plantation": plantation,
                        "id_culture": _culture[0]['id_culture'],
                        "flagtransmis": "",
                      });
                      //
                      await DB.insert("rendement", {
                        "id_rendement": idrendeagrigen,
                        "quantite": "0",
                        "quantite_semence": _quantite_semence.text,
                        "date_rendement": _date_rendement_culture.text,
                        "id_det_plantation": iddetplantgen,
                        "id_det_culture": iddetcultgen,
                        "flagtransmis": "",
                      });
                      //
                      if (_type_culture == "Autre"){
                        String idcultgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                        await DB.insert("culture", {
                          "id_culture": idcultgen,
                          "nom_culture": _preciser_culture.text,
                          "code": "AG",
                          "flagtransmis": "",
                        });
                      }
                      */

                    } else if (_menage == "Chef" && _activite == "Eleveur") {
                      if(_type_elevage == "Aviculture"){
                        //elevage
                        await DB.insert("elevage", {
                          "id_elevage": idelevgen,
                          "type_elevage": _culture_ele[0]['id_culture'],
                          "id_localite": _locate[0]["id_localite"],
                          "type_exploitation": type_exploitation_elevage,
                          "forme_exploitation": _type_elevage == "Aviculture" ? forme_exploitation_avicole : (_type_elevage == "Pisciculture" ? forme_exploitation_piscicole : ""),
                          "superficie": _superficie_elevage.text,
                          "flagtransmis": "",
                        });
                        //membre elevage
                        await DB.insert("membre_elevage", {
                          "id_mb_elevage": idmbelevgen,
                          "id_personne": idpersonnegen,
                          "id_elevage": idelevgen,
                          "flagtransmis": "",
                        });
                        //rendement_elevage
                        await DB.insert("rendement_elevage", {
                          "id_rendement_elv": idrendelevgen,
                          "nbre": _type_elevage == "Aviculture" ? _nombre.text : "0",
                          "date_rendement": _date_rendement_elevage.text,
                          "id_elevage": idelevgen,
                          "flagtransmis": "",
                        });
                      } else if (_type_elevage == "Pisciculture") {
                        //elevage
                        await DB.insert("elevage", {
                          "id_elevage": idelevgen,
                          "type_elevage": _culture_ele[0]['id_culture'],
                          "id_localite": _locate[0]["id_localite"],
                          "type_exploitation": type_exploitation_elevage,
                          "forme_exploitation": _type_elevage == "Aviculture" ? forme_exploitation_avicole : (_type_elevage == "Pisciculture" ? forme_exploitation_piscicole : ""),
                          "superficie": _superficie_elevage.text,
                          "flagtransmis": "",
                        });
                        //membre elevage
                        await DB.insert("membre_elevage", {
                          "id_mb_elevage": idmbelevgen,
                          "id_personne": idpersonnegen,
                          "id_elevage": idelevgen,
                          "flagtransmis": "",
                        });
                        //rendement_elevage
                        await DB.insert("rendement_elevage", {
                          "id_rendement_elv": idrendelevgen,
                          "nbre": _type_elevage == "Aviculture" ? _nombre.text : "0",
                          "date_rendement": _date_rendement_elevage.text,
                          "id_elevage": idelevgen,
                          "flagtransmis": "",
                        });
                        //Escpece elevage
                        int n = _espece_pisciculture.length;
                        for(int i = 0; i < n;i++){
                          //Insertion des donnee espece
                          String idelevespgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                          await DB.insert("elevage_espece", {
                            "id_elv_espece": idelevespgen,
                            "id_elevage": idelevgen,
                            "espece": _espece_pisciculture[i],
                            "flagtransmis": "",
                          });
                        }
                      } else if (_type_elevage == "Autre"){
                        String idelevcultgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                        String idcul = _preciser_type_elevage.text;
                        String idcult = idcul.replaceAll(" ", "").toUpperCase();
                        await DB.insert("culture", {
                          "id_culture": idcult,
                          "nom_culture": _preciser_type_elevage.text,
                          "code": "EL",
                          "flagtransmis": "",
                        });
                        //
                        //elevage
                        await DB.insert("elevage", {
                          "id_elevage": idelevgen,
                          "type_elevage": idcult,
                          "id_localite": _locate[0]["id_localite"],
                          "type_exploitation": type_exploitation_elevage,
                          "forme_exploitation": _forme_exploitation.text,
                          "superficie": _superficie_elevage.text,
                          "flagtransmis": "",
                        });
                        //membre elevage
                        await DB.insert("membre_elevage", {
                          "id_mb_elevage": idmbelevgen,
                          "id_personne": idpersonnegen,
                          "id_elevage": idelevgen,
                          "flagtransmis": "",
                        });
                        //rendement_elevage
                        await DB.insert("rendement_elevage", {
                          "id_rendement_elv": idrendelevgen,
                          "nbre": _type_elevage == "Aviculture" || _type_elevage == "Autre" ? _nombre.text : "0",
                          "date_rendement": _date_rendement_elevage.text,
                          "id_elevage": idelevgen,
                          "flagtransmis": "",
                        });
                      } else {
                        //elevage
                        await DB.insert("elevage", {
                          "id_elevage": idelevgen,
                          "type_elevage": _culture_ele[0]['id_culture'],
                          "id_localite": _locate[0]["id_localite"],
                          "type_exploitation": type_exploitation_elevage,
                          "forme_exploitation": _type_elevage == "Aviculture" ? forme_exploitation_avicole : (_type_elevage == "Pisciculture" ? forme_exploitation_piscicole : _forme_exploitation.text),
                          "superficie": _superficie_elevage.text,
                          "flagtransmis": "",
                        });
                        //membre elevage
                        await DB.insert("membre_elevage", {
                          "id_mb_elevage": idmbelevgen,
                          "id_personne": idpersonnegen,
                          "id_elevage": idelevgen,
                          "flagtransmis": "",
                        });
                        //rendement_elevage
                        await DB.insert("rendement_elevage", {
                          "id_rendement_elv": idrendelevgen,
                          "nbre": _nombre.text,
                          "date_rendement": _date_rendement_elevage.text,
                          "id_elevage": idelevgen,
                          "flagtransmis": "",
                        });
                      }
                    } else if (_menage == "membre" && _activite == "Eleveur") {
                      //elevage
                      await DB.insert("membre_elevage", {
                        "id_mb_elevage": idmbelevgen,
                        "id_personne": idpersonnegen,
                        "id_elevage": ferme,
                        "flagtransmis": "",
                      });
                      //
                      /*
                      await DB.insert("elevage", {
                        "id_elevage": idelevgen,
                        "id_personne": idpersonnegen,
                        "type_elevage": _culture_ele[0]['id_culture'],
                        "id_localite": _localites,
                        "type_exploitation": type_exploitation_elevage,
                        "forme_exploitation": _type_elevage == "Aviculture" ? forme_exploitation_avicole : (_type_elevage == "Pisciculture" ? forme_exploitation_piscicole : ""),
                        "superficie": _superficie_elevage.text,
                        "flagtransmis": "",
                      });
                      //elevage
                      await DB.insert("rendement_elevage", {
                        "id_rendement_elv": idrendelevgen,
                        "nbre": _type_elevage == "Aviculture" ? _nombre.text : "",
                        "date_rendement": _date_rendement_elevage.text,
                        "id_elevage": idelevgen,
                        "flagtransmis": "",
                      });
                      //
                      if (_type_elevage == "Pisciculture") {
                        //
                        int n = _espece_pisciculture.length;
                        for(int i = 0; i < n;i++){
                          //Insertion des donnee espece
                          String idelevespgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                          await DB.insert("elevage_espece", {
                            "id_elv_espece": idelevespgen,
                            "id_personne": idpersonnegen,
                            "id_elevage": idelevgen,
                            "espece": _espece_pisciculture[i],
                            "flagtransmis": "",
                          });
                        }
                        //
                      } else if (_type_elevage == "Autre"){
                        String idelevcultgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                        await DB.insert("culture", {
                          "id_culture": idelevcultgen,
                          "nom_culture": _preciser_type_elevage.text,
                          "code": "EL",
                          "flagtransmis": "",
                        });
                      }
                      */
                    }
                    setState(() {
                      //On vides les champs a zero
                      _nom = TextEditingController(text: "");
                      _prenom = TextEditingController(text: "");
                      _telephone = TextEditingController(text: "");
                      _desc_plantation = TextEditingController(text: "");
                      _superficie_agriculture = TextEditingController(text: "");
                      _superficie_elevage = TextEditingController(text: "");
                      _preciser_culture = TextEditingController(text: "");
                      _preciser_type_elevage = TextEditingController(text: "");
                      _nombre = TextEditingController(text: "");
                      _date_rendement_culture  = TextEditingController(text: "");
                      _date_rendement_elevage  = TextEditingController(text: "");
                      _forme_exploitation  = TextEditingController(text: "");
                      //plantation = "";
                      //_uids = "";
                      _genre = "";
                      _localites = "";
                      _images = "";
                      nfc_msg_visible = "false";
                      _localites = "";
                      _genre = "";
                      _activite = "";
                      _type_culture = "";
                      _menage = "";
                      _lien = "";
                      _travail_culture = "";
                      _type_elevage = "";
                      id_culture = "";
                      _uids = "";
                      _nom_fonction = "";
                      _imagefile = null;

                      //Stepper
                      _currentStep = 0;
                    });
                    Scaffold
                        .of(context)
                        .showSnackBar(SnackBar(content: Text(
                        'Enregistrement effectuer avec succes !')));
                  } else {
                    Scaffold
                        .of(context)
                        .showSnackBar(SnackBar(content: Text(
                        'Veuller selectionner une localite !')));
                  }
                }else {
                  Scaffold
                      .of(context)
                      .showSnackBar(SnackBar(content: Text(
                      'Oups La campagne n\'a pas ete synchroniser ! ')));
                }
              }else{
                Scaffold
                    .of(context)
                    .showSnackBar(SnackBar(content: Text(
                    'La tablette na pas d\'identifiant ou n\'a pas ete identifier, Veuiller contacter la call center')));
              }
            }
            //------------------------------------------------------------------
            if (formKeys[_currentStep].currentState.hashCode.toString() == "2011"){
              print("enregistrement du membre");
              //Verification de l'image
              if (_images != ""){
                //verification du scannage nfc
                if (nfc_msg_visible == "true"){
                  //Insertion dans la base de donnees
                  addUser();
                  //
                } else {
                  Scaffold
                      .of(context)
                      .showSnackBar(SnackBar(content: Text(
                      'Veuillez scanner un bracelets nfc !')));
                }
              } else {
                Scaffold
                    .of(context)
                    .showSnackBar(SnackBar(content: Text(
                    'Photo non prise !')));
              }
              //------------------------------------------------------------------
            } else if(formKeys[_currentStep].currentState.validate()) {
              //
              if (this._currentStep < this._stepper().length - 1) {
                this._currentStep = this._currentStep + 1;
              } else {
                print("Enregistrement du chef");                //Verification de l'image
                if (_images != ""){
                  //verification du scannage nfc
                  if (nfc_msg_visible == "true"){
                    //Insertion dans la base de donnees
                    addUser();
                    //
                  } else {
                    Scaffold
                        .of(context)
                        .showSnackBar(SnackBar(content: Text(
                        'Veuillez scanner un bracelets nfc !')));
                  }
                } else {
                  Scaffold
                      .of(context)
                      .showSnackBar(SnackBar(content: Text(
                      'Photo non prise !')));
                }

                //if(_formKey.currentState.validate()) {}

                print("complet enregistrement");
              }
            }
            //-------------------------------------------------------------------
          });
        },
        onStepCancel: () {
          setState(() {
            if (this._currentStep > 0) {
              this._currentStep = this._currentStep - 1;
            } else {
              this._currentStep = 0;
            }
          });
        },
      ),
    );
  }


  List<Step> _stepper() {
    List<Step> _steps = [
      //Les noms
      Step(
        title: Text('Information personnel'),
        content: Container(
          //margin: EdgeInsets.only(left: 100.0, right: 100.0),
          child: Form(
            key: formKeys[0],
            child: Column(
              children: <Widget>[
                TextFormField(
                  obscureText: false,
                  controller: _nom,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintText: "Entrer le nom",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                    //icon: Icon(Icons.account_circle, color: Colors.black),
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
                    if (value.isEmpty) {
                      return 'Veuiller entrer une information';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 25.0),
                TextFormField(
                  obscureText: false,
                  controller: _prenom,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintText: "Entrer le prenom",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                    //icon: Icon(Icons.edit, color: Colors.black),
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
                    if (value.isEmpty) {
                      return 'Veuiller entrer une information';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 25.0),
                TextFormField(
                  obscureText: false,
                  controller: _telephone,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                    //icon: Icon(Icons.phone, color: Colors.black),
                    hintText: "Entrer le numero de telephone",
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
                    if (value.isEmpty) {
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
                              "Age :  ",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                    ),
                    Radio(
                      value: "18 a 35 ans",
                      groupValue: age,
                      activeColor: Colors.indigo,
                      onChanged: (value) {
                        print("Radio value is $value");
                        setSelectedAge(value);
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
                              "18 a 35 ans",
                              style: TextStyle(
                                fontSize: 16.0,
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
                      value: "plus de 35 ans",
                      groupValue: age,
                      activeColor: Colors.indigo,
                      onChanged: (value) {
                        print("Radio value is $value");
                        setSelectedAge(value);
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
                              "plus de 35 ans",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                    ),
                    //************************************
                  ],
                ),
                SizedBox(height: 25.0),
                //Dropdown genre
                DropDownFormField(
                  titleText: 'Genre',
                  hintText: 'sexe',
                  value: _genre,
                  onSaved: (value) {
                    setState(() {
                      _genre = value;
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      _genre = value;
                    });
                  },
                  dataSource: [
                    {"display": "Masculin", "value": "Masculin"},
                    {"display": "Feminin", "value": "Feminin"}
                  ],
                  textField: 'display',
                  valueField: 'value',
                  validator: (value) {
                    if (_genre == "") {
                      return 'Veuiller Slectionner';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 25.0),
                //
                RaisedButton(
                  color: Colors.teal,
                  elevation: 5,
                  hoverElevation: 10,
                  padding: EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: 100.0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('Image', style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,),),
                    ),
                  ),
                  onPressed: getImage,
                ),
                SizedBox(
                  height: 35.0,
                  child: _imagefile == null
                      ? Text(
                    'Veuillez prendre la photo de l\'utlisateur', style: TextStyle(color: Colors.red,),)
                      : /*Image.file(_image)*/ Text('Photo selectionner' , style: TextStyle(color: Colors.green,),),
                ),
                SizedBox(height: 25.0),
                //
              ],
            ),
          ),
        ),
        isActive: _currentStep >= 0,
        state: StepState.disabled,
      ),
      //autre
      Step(
        title: Text('Activites et localité'),
        content: Form(
          key: formKeys[1],
          child: Column(
            children: <Widget>[
              DropDownFormField(
                titleText: 'Type d\'activite',
                hintText: 'activite',
                value: _activite,
                onSaved: (value) {
                  setState(() {
                    _activite = value;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    _activite = value;
                  });
                },
                dataSource: [
                  {"display": "Eleveur", "value": "Eleveur"},
                  {"display": "Agriculteur", "value": "Agriculteur"}
                ],
                textField: 'display',
                valueField: 'value',
                validator: (value) {
                  if (_activite == "") {
                    return 'Veuiller Slectionner une localite';
                  }
                  return null;
                },
              ),
              SizedBox(height: 25.0),
              /*
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
                      value: _localites,
                      onSaved: (value) {
                        setState(() {
                          _localites = value;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          _localites = value;
                        });
                      },
                      //snap
                      dataSource: snap,
                      textField: 'descriptions',
                      valueField: 'id_localite',
                      validator: (value) {
                        if (_localites == "") {
                          return 'Veuiller Slectionner une localite';
                        }
                        return null;
                      },
                    );
                  }),
              SizedBox(height: 25.0),
              */
              DropDownFormField(
                titleText: 'Menage',
                hintText: 'type de menage',
                value: _menage,
                onSaved: (value) {
                  setState(() {
                    _menage = value;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    _menage = value;
                  });
                },
                dataSource: [
                  {"display": "Chef de menage", "value": "Chef"},
                  {"display": "membre du menage", "value": "membre"}
                ],
                textField: 'display',
                valueField: 'value',
                validator: (value) {
                  if (_menage == "") {
                    return 'Veuiller Slectionner';
                  }
                  return null;
                },
              ),
              SizedBox(height: 25.0),
              Visibility(
                visible: chef,
                child: Column(
                  children: <Widget>[
                    //-------------------------Select plantation--------------------
                    FindDropdown<PlantationModel>(
                      label: "Plantation",
                      onFind: (String filter) => getData(filter),
                      onChanged: (PlantationModel data) {
                        print(data.id);
                        plantation = data.id;
                      },
                      dropdownBuilder: (BuildContext context, PlantationModel item) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).dividerColor),
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          child: (item?.avatar == null)
                              ? ListTile(
                            leading: CircleAvatar(),
                            title: Text("Aucune plantation selectionner"),
                          )
                              : ListTile(
                            leading: CircleAvatar(
                              backgroundImage: FileImage(File("/storage/emulated/0/Android/data/com.tulipind.bmapp/files/Pictures/${item.avatar}")),
                            ),
                            title: Text(item.name),
                            //subtitle: Text(item.createdAt.toString()),
                          ),
                        );
                      },
                      dropdownItemBuilder:
                          (BuildContext context, PlantationModel item, bool isSelected) {
                        return Container(
                          decoration: !isSelected
                              ? null
                              : BoxDecoration(
                            border:
                            Border.all(color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            selected: isSelected,
                            title: Text(item.name),
                            subtitle: Text(item.prenom),
                            leading: CircleAvatar(
                              backgroundImage: FileImage(File("/storage/emulated/0/Android/data/com.tulipind.bmapp/files/Pictures/${item.avatar}")),
                            ),
                          ),
                        );
                      },
                    ),
                    //-------------------------------------------------------------------------------------
                    SizedBox(height: 25.0),
                    //Combo box select
                    DropDownFormField(
                      titleText: 'Lien',
                      hintText: 'Preciser le lien de parenté',
                      value: _lien,
                      onSaved: (value) {
                        setState(() {
                          _lien = value;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          _lien = value;
                        });
                      },
                      dataSource: [
                        {"display": "pere", "value": "pere"},
                        {"display": "mere", "value": "mere"},
                        {"display": "Oncle", "value": "Oncle"},
                        {"display": "Tante", "value": "Tante"},
                        {"display": "Cousin", "value": "Cousin"},
                        {"display": "Cousine", "value": "Cousine"},
                        {"display": "Autre", "value": "Autre"}
                      ],
                      textField: 'display',
                      valueField: 'value',
                      validator: (value) {
                        if (_lien == "") {
                          return 'Veuiller Slectionner une localite';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 25.0),
                    Visibility(
                      visible: autre_lien,
                      child: TextFormField(
                        obscureText: false,
                        controller: _autre_lien,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "preciser",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          //icon: Icon(Icons.edit, color: Colors.black),
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
                          if (value.isEmpty) {
                            return 'Veuiller entrer une information';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 25.0),

                  ],
                ),
              ),
              //-----------------------------------------------------------------------------------------|
              //|
              //|--------------------------Si chef est eleveur-------------------------------------------|
              //|
              //-----------------------------------------------------------------------------------------|
              //SizedBox(height: 25.0),
              Visibility(
                visible: chefElv,
                child: Column(
                  children: <Widget>[
                    //-------------------------Select plantation--------------------
                    FindDropdown<fermeModel>(
                      label: "Ferme",
                      onFind: (String filter) => getDataFerme(filter),
                      onChanged: (fermeModel data) {
                        print(data.id);
                        ferme = data.id;
                      },
                      dropdownBuilder: (BuildContext context, fermeModel item) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).dividerColor),
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          child: (item?.avatar == null)
                              ? ListTile(
                            leading: CircleAvatar(),
                            title: Text("Aucune ferme selectionner"),
                          )
                              : ListTile(
                            leading: CircleAvatar(
                              backgroundImage: FileImage(File("/storage/emulated/0/Android/data/com.tulipind.bmapp/files/Pictures/${item.avatar}")),
                            ),
                            title: Text(item.name),
                            //subtitle: Text(item.createdAt.toString()),
                          ),
                        );
                      },
                      dropdownItemBuilder:
                          (BuildContext context, fermeModel item, bool isSelected) {
                        return Container(
                          decoration: !isSelected
                              ? null
                              : BoxDecoration(
                            border:
                            Border.all(color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            selected: isSelected,
                            title: Text(item.name),
                            subtitle: Text(item.prenom),
                            leading: CircleAvatar(
                              backgroundImage: FileImage(File("/storage/emulated/0/Android/data/com.tulipind.bmapp/files/Pictures/${item.avatar}")),
                            ),
                          ),
                        );
                      },
                    ),
                    //-------------------------------------------------------------------------------------
                    SizedBox(height: 25.0),
                    //Combo box select
                    DropDownFormField(
                      titleText: 'Lien',
                      hintText: 'Preciser le lien de parenté',
                      value: _lien,
                      onSaved: (value) {
                        setState(() {
                          _lien = value;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          _lien = value;
                        });
                      },
                      dataSource: [
                        {"display": "pere", "value": "pere"},
                        {"display": "mere", "value": "mere"},
                        {"display": "Oncle", "value": "Oncle"},
                        {"display": "Tante", "value": "Tante"},
                        {"display": "Cousin", "value": "Cousin"},
                        {"display": "Cousine", "value": "Cousine"},
                        {"display": "Autre", "value": "Autre"}
                      ],
                      textField: 'display',
                      valueField: 'value',
                      validator: (value) {
                        if (_lien == "") {
                          return 'Veuiller Slectionner une localite';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 25.0),
                    Visibility(
                      visible: autre_lien,
                      child: TextFormField(
                        obscureText: false,
                        controller: _autre_lien,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "preciser",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          //icon: Icon(Icons.edit, color: Colors.black),
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
                          if (value.isEmpty) {
                            return 'Veuiller entrer une information';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 25.0),

                  ],
                ),
              ),

            ],
          ),
        ),
        isActive: _currentStep >= 1,
        state: StepState.disabled,
      ),
      //Encors autre
      agriculteur || eleveur ? Step(
        title: Text('Plantation / Elevage'),
        content: Form(
          key: formKeys[2],
          child: Column(
            children: <Widget>[
              Visibility(
                visible: agriculteur,
                child: Column(
                  children: <Widget>[
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
                        if (value.isEmpty) {
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
                        if (value.isEmpty) {
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
                              if (value.isEmpty) {
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
                              if (value.isEmpty) {
                                return 'Veuiller entrer une information';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 25.0),
                        ],
                      ),
                    ),
                    TextFormField(
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
                        if (value.isEmpty) {
                          return 'Veuiller entrer une information';
                        }
                        return null;
                      },
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
                    ),
                    SizedBox(height: 25.0),
                  ],
                ),
              ),
              /*
              Visibility(
                visible: membre_agriculteur,
                child: Column(
                  children: <Widget>[
                    DropDownFormField(
                      titleText: 'Travailler vous dans une culture ?',
                      hintText: 'culture',
                      value: _travail_culture,
                      onSaved: (value) {
                        setState(() {
                          _travail_culture = value;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          _travail_culture = value;
                        });
                      },
                      dataSource: [
                        {"display": "Oui", "value": "Oui"},
                        {"display": "Non", "value": "Non"}
                      ],
                      textField: 'display',
                      valueField: 'value',
                      validator: (value) {
                        if (_travail_culture == "") {
                          return 'Veuiller Slectionner une localite';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 25.0),
                    Visibility(
                      visible: travail_culture,
                      child: Column(
                        children: <Widget>[
                          //SizedBox(height: 25.0),
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
                                    if (value.isEmpty) {
                                      return 'Veuiller entrer une information';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 25.0),
                              ],
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            obscureText: false,
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
                              if (value.isEmpty) {
                                return 'Veuiller entrer une information';
                              }
                              return null;
                            },
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
                          ),
                          SizedBox(height: 25.0),

                        ],
                      ),
                    )
                    /////////////////////////////
                  ],
                ),
               */
              Visibility(
                visible: eleveur,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      controller: _superficie_elevage,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Superficie",
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
                        if (value.isEmpty) {
                          return 'Veuiller entrer une information';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 25.0),
                    FutureBuilder(
                        future: SelectCultureEL(),
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
                            titleText: 'Type d\'elevage',
                            hintText: 'Elevage',
                            value: _type_elevage,
                            onSaved: (value) {
                              setState(() {
                                _type_elevage = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _type_elevage = value;
                              });
                            },
                            //snap
                            dataSource: snap,
                            textField: 'nom_culture',
                            valueField: 'nom_culture',
                            validator: (value) {
                              if (_type_elevage == "") {
                                return 'Veuiller Slectionner une Culture';
                              }
                              return null;
                            },
                          );
                        }),
                    SizedBox(height: 25.0),
                    Visibility(
                      visible: autre_type_elevage,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            obscureText: false,
                            controller: _preciser_type_elevage,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              hintText: "Preciser le type d'elevage'",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                              //icon: Icon(Icons.edit, color: Colors.black),
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
                              if (value.isEmpty) {
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
                              if (value.isEmpty) {
                                return 'Veuiller entrer une information';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 25.0),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            obscureText: false,
                            controller: _nombre,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              hintText: "Nombre",
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
                              if (value.isEmpty) {
                                return 'Veuiller entrer une information';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 25.0),
                        ],
                      ),
                    ),
                    SizedBox(height: 25.0),
                    Visibility(
                      visible: culture_save,
                      child: Column(
                        children: [
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
                              if (value.isEmpty) {
                                return 'Veuiller entrer une information';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 25.0),
                          TextFormField(
                            obscureText: false,
                            controller: _nombre,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              hintText: "Nombre",
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
                              if (value.isEmpty) {
                                return 'Veuiller entrer une information';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 25.0),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: avicole,
                      child: Column(
                        children: <Widget>[
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
                                        "forme d'exploitation avicole : ",
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
                                value: "Aviculture  villageoise",
                                groupValue: forme_exploitation_avicole,                                 activeColor: Colors.indigo,
                                onChanged: (value) {
                                  print("Radio value is $value");
                                  setSelectedExploitationAvicole(value);
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
                                        "Aviculture  villageoise",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                              Radio(
                                value: "Semi-intensive",
                                groupValue: forme_exploitation_avicole,
                                activeColor: Colors.indigo,
                                onChanged: (value) {
                                  print("Radio value is $value");
                                  setSelectedExploitationAvicole(value);
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
                                        "Semi-intensive",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                              Radio(
                                value: "Intensive",
                                groupValue: forme_exploitation_avicole,
                                activeColor: Colors.indigo,
                                onChanged: (value) {
                                  print("Radio value is $value");
                                  setSelectedExploitationAvicole(value);
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
                                        "Intensive",
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

                        ],
                      ),
                    ),
                    Visibility(
                      visible: pisciculture,
                      child: Column(
                        children: <Widget>[
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
                                        "forme d'exploitation piscicole : ",
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
                                value: "Etang",
                                groupValue: forme_exploitation_piscicole,
                                activeColor: Colors.indigo,
                                onChanged: (value) {
                                  print("Radio value is $value");
                                  setSelectedExploitationPisciculture(value);
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
                                        "Etang",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                              Radio(
                                value: "Marre",
                                groupValue: forme_exploitation_piscicole,
                                activeColor: Colors.indigo,
                                onChanged: (value) {
                                  print("Radio value is $value");
                                  setSelectedExploitationPisciculture(value);
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
                                        "Marre",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                              Radio(
                                value: "Retenu",
                                groupValue: forme_exploitation_piscicole,
                                activeColor: Colors.indigo,
                                onChanged: (value) {
                                  print("Radio value is $value");
                                  setSelectedExploitationPisciculture(value);
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
                                        "Retenu",
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
                                    "Selectionner les especes ",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          CheckboxListTile (
                            title: Text("Tilapia"),
                            controlAffinity: ListTileControlAffinity.platform,
                            value: _espece1,
                            onChanged: (bool value){
                              setState(() {
                                if(value == true){
                                  _espece_pisciculture.add("Tilapia");
                                  _espece1 = value;
                                } else {
                                  _espece_pisciculture.remove("Tilapia");
                                  _espece1 = value;
                                }
                              });
                            },
                            activeColor: Colors.green,
                            checkColor: Colors.black,
                          ),
                          SizedBox(height: 25.0),
                          CheckboxListTile (
                            title: Text("Scillure"),
                            controlAffinity: ListTileControlAffinity.platform,
                            value: _espece2,
                            onChanged: (bool value){
                              setState(() {
                                if(value == true){
                                  _espece_pisciculture.add("Scillure");
                                  _espece2 = value;
                                } else {
                                  _espece_pisciculture.remove("Scillure");
                                  _espece2 = value;
                                }
                              });
                            },
                            activeColor: Colors.green,
                            checkColor: Colors.black,
                          ),
                          SizedBox(height: 25.0),
                          CheckboxListTile (
                            title: Text("Heterotis"),
                            controlAffinity: ListTileControlAffinity.platform,
                            value: _espece3,
                            onChanged: (bool value){
                              setState(() {
                                if(value == true){
                                  _espece_pisciculture.add("Heterotis");
                                  _espece3 = value;
                                } else {
                                  _espece_pisciculture.remove("Heterotis");
                                  _espece3 = value;
                                }
                              });
                            },
                            activeColor: Colors.green,
                            checkColor: Colors.black,
                          ),
                          SizedBox(height: 25.0),
                          CheckboxListTile (
                            title: Text("Hemicromis"),
                            controlAffinity: ListTileControlAffinity.platform,
                            value: _espece4,
                            onChanged: (bool value){
                              setState(() {
                                if(value == true){
                                  _espece_pisciculture.add("Hemicromis");
                                  _espece4 = value;
                                } else {
                                  _espece_pisciculture.remove("Hemicromis");
                                  _espece4 = value;
                                }
                              });
                            },
                            activeColor: Colors.green,
                            checkColor: Colors.black,
                          ),
                          SizedBox(height: 25.0),

                        ],
                      ),
                    ),
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
                          groupValue: type_exploitation_elevage ,
                          activeColor: Colors.indigo,
                          onChanged: (value) {
                            print("Radio value is $value");
                            setSelectedExploitationElevage(value);
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
                          groupValue: type_exploitation_elevage ,
                          activeColor: Colors.indigo,
                          onChanged: (value) {
                            print("Radio value is $value");
                            setSelectedExploitationElevage(value);
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
                    Visibility(
                      visible: avicole,
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.number,
                            obscureText: false,
                            controller: _nombre,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              hintText: "Nombre",
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
                              if (value.isEmpty) {
                                return 'Veuiller entrer une information';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 25.0),
                        ],
                      ),
                    ),
                    DateTimeField(
                      format: format,
                      controller: _date_rendement_elevage,
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
                    ),
                    SizedBox(height: 25.0),

                  ],
                ),
              ),
            ],
          ),
        ),
        isActive: _currentStep >= 2,
        state: StepState.disabled,
      ) : Step(
        title: Text('Confirmation'),
        content: Form(
          key: formKeys[3],
          child: Column(
            children: <Widget>[
              SizedBox(
                //height: 150.0,
                  child: nfc_msg_visible == "false"
                      ? Column(
                    children: <Widget>[
                      SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage("images/scan_nfc.png"),
                        ),
                      ),
                      Text(
                        'Veuillez Scanner le bracelet d\'identification', style: TextStyle(color: Colors.red,),),
                    ],
                  )
                      : (nfc_msg_visible == "exist" ?
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage("images/scan_nfc.png"),
                        ),
                      ),
                      Text('Ce bracelet a deja ete utlilise, Veuillez utilise un autre bracelet' , style: TextStyle(color: Colors.red,),),
                    ],
                  ) :
                  Text('Bracelet scanner avec succes merci' , style: TextStyle(color: Colors.green,),)
                  )
              ),
              SizedBox(height: 25.0,),
              //
              Container(
                //color: Colors.indigo,
                //margin: EdgeInsets.only(bottom: 30.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      //height: 50.0,
                      child: Text(
                        "Les informations saissir sont-il correcte ?",
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
        ),
        isActive: _currentStep >= 2,
        state: StepState.disabled,
      ),
      agriculteur || eleveur ? Step(
        title: Text('Confirmation'),
        content: Form(
          key: formKeys[3],
          child: Column(
            children: <Widget>[
              SizedBox(
                //height: 150.0,
                  child: nfc_msg_visible == "false"
                      ? Column(
                    children: <Widget>[
                      SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage("images/scan_nfc.png"),
                        ),
                      ),
                      Text(
                        'Veuillez Scanner le bracelet d\'identification', style: TextStyle(color: Colors.red,),),
                    ],
                  )
                      : (nfc_msg_visible == "exist" ?
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage("images/scan_nfc.png"),
                        ),
                      ),
                      Text('Ce bracelet a deja ete utlilise, Veuillez utilise un autre bracelet' , style: TextStyle(color: Colors.red,),),
                    ],
                  ) :
                  Text('Bracelet scanner avec succes merci' , style: TextStyle(color: Colors.green,),)
                  )
              ),
              SizedBox(height: 25.0,),
              //
              Container(
                //color: Colors.indigo,
                //margin: EdgeInsets.only(bottom: 30.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      //height: 50.0,
                      child: Text(
                        "Les informations saissir sont-il correcte ?",
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
        ),
        isActive: _currentStep >= 3,
        state: StepState.disabled,
      ) : Step(
        title: Text(''),
        content: Container(),
      ),
    ];
    return _steps;
  }
}
