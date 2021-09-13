
import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:bmapp/models/ferme_model.dart';
import 'package:bmapp/models/plantation_ferme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

//package importer
import 'package:image_picker/image_picker.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart';

//package sooba
import 'package:bmapp/database/database.dart';
import 'package:bmapp/models/plantation_model.dart';
import 'package:random_string/random_string.dart';

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
  //------------------------------SELECT CAMPAGNE AGRICOLE----------------------
  Future<void> SelectSession() async {
    List<Map<String, dynamic>> querySession = await DB.queryCampagne();
    return querySession;
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
  //TextEditingController _culture = TextEditingController();
  TextEditingController _quantite_semence = TextEditingController();

  //Bool
  bool chef = false;
  bool chefElv = false;
  bool chefAgrElv = false;
  bool chefAgElv = false;
  bool autre_lien = false;

  //bool membre_agriculteur = false;
  bool eleveur = false;
  bool CE = false;
  bool pecheur = false;
  bool CP = false;
  bool personne = false;
  //
  bool travail_culture = false;
  bool agriculteur = false;
  bool eleveur_agriculteur = false;

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
  String plantation = "";
  String ferme = "";
  //
  String _uids = "";
  //
  String Chef_menage_agriculteur;
  String Chef_menage_eleveur;
  String Chef_menage_agriculteur_elevage;
  //
  String _unite_mesure = "kilogrammes";


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
  String age = "18 a 35 ans";
  String type_exploitation_agriculture = "Individuelle"; //Radio
  String type_exploitation_elevage = "Individuelle"; //Radio
  String type_exploitation_avicole = ""; //Radio
  String type_exploitation_pisciculture = ""; //Radio
  String forme_exploitation_avicole = "Aviculture  villageoise"; //Radio
  String forme_exploitation_piscicole = "Etang"; //Radio

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
  //-----------------------Culture Agriculture-----------------------------------
  Future<void> SelectCultureAG() async {
    List<Map<String, dynamic>> queryCulture = await DB.querySelectCulture("AG");
    queryCulture += [
      {"nom_culture": "Autre", "nom_culture": "Autre"},
    ];
    return queryCulture;
  }
  //----------------------------------------------------------------------------
  //----------------------SELECTION PALANTATION---------------------------------
  //----------------------------------------------------------------------------
  Future<List<PlantationModel>> getData(filter) async {

    List<Map<String, dynamic>> tab = await DB.queryAll("parametre");
    var _locate = await DB.queryWherelocate("localite",tab[0]["locate"]);
    List<Map<String, dynamic>> queryRows;

    if (filter != "" || filter != null) {
      queryRows = await DB.queryPlantationfilter(_locate[0]["id_localite"].toString(),filter);
    } else {
      queryRows = await DB.queryPlantation(_locate[0]["id_localite"].toString());
    }

    var models = PlantationModel.fromJsonList(queryRows);
    return models;
  }
  //----------------------------------------------------------------------------
  //----------------------SELECTION FERME---------------------------------------
  //----------------------------------------------------------------------------
  Future<List<fermeModel>> getDataFerme(filter) async {
    List<Map<String, dynamic>> tab = await DB.queryAll("parametre");
    var _locate = await DB.queryWherelocate("localite",tab[0]["locate"]);
    List<Map<String, dynamic>> queryRows;

    if(filter != "" || filter != null){
      queryRows = await DB.queryFermefilter(_locate[0]["id_localite"].toString(),filter);
    } else {
      queryRows = await DB.queryFerme(_locate[0]["id_localite"].toString());
    }

    var modelFerme = fermeModel.fromJsonList(queryRows);
    return modelFerme;
  }
  //----------------------------------------------------------------------------
  //----------------------SELECTION PALANTATION ET FERME---------------------------------
  //----------------------------------------------------------------------------
  Future<List<PlantationFermeModel>> getDataFermePlantation(filter) async {
    /*
    var response = await Dio().get(
      "http://5d85ccfb1e61af001471bf60.mockapi.io/user",
      queryParameters: {"filter": filter},
    );
    */
    List<Map<String, dynamic>> tab = await DB.queryAll("parametre");
    var _locate = await DB.queryWherelocate("localite",tab[0]["locate"]);
    List<Map<String, dynamic>> queryRows;

    if(filter != "" || filter != null){
      queryRows = await DB.queryChefPlantationFermefilter(_locate[0]["id_localite"].toString(),filter);
    } else {
      queryRows = await DB.queryChefPlantationFerme(_locate[0]["id_localite"].toString());
    }

    var models = PlantationFermeModel.fromJsonList(queryRows);
    return models;
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
      chefAgElv = false;
    } else if (_menage == "membre" && _activite == "Eleveur") {
      chefElv = true;
      chef = false;
      chefAgElv = false;
    } else if (_menage == "membre" && _activite == "Agriculteur et Eleveur") {
      chefAgElv = true;
      chefElv = false;
      chef = false;
    } else {
      chef = false;
      chefElv = false;
      chefAgElv = false;
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
      //membre_agriculteur = false;
      eleveur = false;
      eleveur_agriculteur = false;
      _nom_fonction = "CAG";
    } else if(_menage == "membre" && _activite == "Agriculteur"){
      //membre_agriculteur = true;
      eleveur_agriculteur = false;
      agriculteur = false;
      eleveur = false;
      _nom_fonction = "AG";
    } else if(_menage == "membre" && _activite == "Eleveur"){
      eleveur = false;
      agriculteur = false;
      eleveur_agriculteur = false;
      //membre_agriculteur = false;
      _nom_fonction = "E";
    } else if(_menage == "Chef" && _activite == "Eleveur"){
      eleveur = true;
      agriculteur = false;
      eleveur_agriculteur = false;
      //membre_agriculteur = false;
      _nom_fonction = "CE";
    } else if (_menage == "Chef" && _activite == "Agriculteur et Eleveur") {
      //Chef agriculteur eleveur
      eleveur = false;
      agriculteur = false;
      //membre_agriculteur = false;
      eleveur_agriculteur = true;
      _nom_fonction = "CAGCE";
    } else if (_menage == "membre" && _activite == "Agriculteur et Eleveur") { 
      //membre agriculteur eleveur
      eleveur = false;
      agriculteur = false;
      //membre_agriculteur = false;
      eleveur_agriculteur = false;
      _nom_fonction = "AGE";
    } else {
      eleveur = false;
      agriculteur = false;
      eleveur_agriculteur = false;
      //membre_agriculteur = false;
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
    } else {
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


                    //Verification Culture
                    String idcult = _preciser_culture.text;
                    String idcul = idcult.replaceAll(" ", "").toUpperCase();

                    //
                    int semence;
                    semence = int.parse(_quantite_semence.text);
                    double semence_kg;
                    semence_kg = semence * 1/1000;
                    //print("$semence_kg kg");

                    var verif_culture = await DB.queryVerifCult(idcul);

                    if(idcult != null || idcult != "" && verif_culture.isEmpty){

                      ///----------------------------------------------------------------------
                      ///----------------------INSCRIPTION-------------------------------------
                      ///----------------------------------------------------------------------
                      //id genere
                      String idpersonnegen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                      String idpersonneaddgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);

                      String idpersonnefongen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                      //Agriculteur
                      String idrendeagrigen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                      String iddetcultgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
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
                            "quantite_semence": _unite_mesure == "grammes" ? semence_kg : semence, // _quantite_semence.text,
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
                            "quantite_semence": _unite_mesure == "grammes" ? semence_kg : semence, // _quantite_semence.text, // _unite_mesure == "g" ? semence_kg : semence,
                            "unites": _unite_mesure,
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
                      } else if (_menage == "Chef" && _activite == "Agriculteur et Eleveur") {
                        ///-----------------------------------------------------------------------------------------------------
                        ///---------------------------------------PLANTATION----------------------------------------------------
                        ///-----------------------------------------------------------------------------------------------------
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
                            "quantite_semence": _unite_mesure == "grammes" ? semence_kg : semence, // _quantite_semence.text, // _unite_mesure == "g" ? semence_kg : semence,
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
                            "quantite_semence": _unite_mesure == "grammes" ? semence_kg : semence, // _quantite_semence.text, // _unite_mesure == "g" ? semence_kg : semence,
                            "unites": _unite_mesure,
                            "date_rendement": _date_rendement_culture.text,
                            "id_det_plantation": iddetplantgen,
                            "id_det_culture": iddetcultgen,
                            "flagtransmis": "",
                          });
                        }
                        ///-----------------------------------------------------------------------------------------------------
                        ///------------------------------------------FERME------------------------------------------------------
                        ///-----------------------------------------------------------------------------------------------------
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
                        ///-------------------------------END------------------------------------------------------------------------

                      } else if (_menage == "membre" && _activite == "Agriculteur et Eleveur") {
                        //PLANTATION
                        await DB.insert("detenteur_plantation", {
                          "id_det_plantation": iddetplantgen,
                          "id_personne": idpersonnegen,
                          "id_plantation": plantation,
                          "flagtransmis": "",
                        });
                        //ELEVAGE
                        await DB.insert("membre_elevage", {
                          "id_mb_elevage": idmbelevgen,
                          "id_personne": idpersonnegen,
                          "id_elevage": ferme,
                          "flagtransmis": "",
                        });
                      }
                      //
                      setState(() {
                        //On vides les champs a zero
                        _nom = TextEditingController(text: "");
                        _prenom = TextEditingController(text: "");
                        _telephone = TextEditingController(text: "");
                        _autre_lien = TextEditingController(text: "");
                        _desc_plantation = TextEditingController(text: "");
                        _superficie_agriculture = TextEditingController(text: "");
                        _superficie_elevage = TextEditingController(text: "");
                        _preciser_culture = TextEditingController(text: "");
                        _preciser_type_elevage = TextEditingController(text: "");
                        _nombre = TextEditingController(text: "");
                        _date_rendement_culture  = TextEditingController(text: "");
                        _date_rendement_elevage  = TextEditingController(text: "");
                        _forme_exploitation  = TextEditingController(text: "");
                        _quantite_semence  = TextEditingController(text: "");
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

                      Fluttertoast.showToast(
                          msg: "Enregistrement effectué avec succès !",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 5,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 20.0
                      );

                      //Verification plantation,ferme
                      /*
                    if(plantation != "" || ferme != ""){} else {
                      Fluttertoast.showToast(
                          msg: "Veuillez selectionnez un chef de menage",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 5,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 20.0
                      );}
                    */
                      ///-----------------------------------------------------------------------
                      ///----------------------------END----------------------------------------
                      ///-----------------------------------------------------------------------

                    } else if (idcult == null || idcult == "" || idcult.isEmpty) {

                      ///----------------------------------------------------------------------
                      ///----------------------INSCRIPTION-------------------------------------
                      ///----------------------------------------------------------------------
                      //id genere
                      String idpersonnegen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                      String idpersonneaddgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);

                      String idpersonnefongen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                      //Agriculteur
                      String idrendeagrigen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                      String iddetcultgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                      String iddetplantgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                      String idplangen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                      //elevage
                      String idelevgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                      String idrendelevgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                      String idmbelevgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                      //
                      var dateNow = new DateTime.now();

                      //int semence;
                      //semence = int.parse(_quantite_semence.text);
                      //double semence_kg;
                      //semence_kg = semence * 1/1000;
                      //print("$semence_kg kg");

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
                            "quantite_semence": _unite_mesure == "grammes" ? semence_kg : semence, // _quantite_semence.text, // _unite_mesure == "g" ? semence_kg : semence,
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
                            "quantite_semence": _unite_mesure == "grammes" ? semence_kg : semence, // _quantite_semence.text, // _unite_mesure == "g" ? semence_kg : semence,
                            "unites": _unite_mesure,
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
                      } else if (_menage == "Chef" && _activite == "Agriculteur et Eleveur") {
                        ///-----------------------------------------------------------------------------------------------------
                        ///---------------------------------------PLANTATION----------------------------------------------------
                        ///-----------------------------------------------------------------------------------------------------
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
                            "quantite_semence": _unite_mesure == "grammes" ? semence_kg : semence, // _quantite_semence.text, // _unite_mesure == "g" ? semence_kg : semence,
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
                            "quantite_semence": _unite_mesure == "grammes" ? semence_kg : semence, // _quantite_semence.text, // _unite_mesure == "g" ? semence_kg : semence,
                            "unites": _unite_mesure,
                            "date_rendement": _date_rendement_culture.text,
                            "id_det_plantation": iddetplantgen,
                            "id_det_culture": iddetcultgen,
                            "flagtransmis": "",
                          });
                        }
                        ///-----------------------------------------------------------------------------------------------------
                        ///------------------------------------------FERME------------------------------------------------------
                        ///-----------------------------------------------------------------------------------------------------
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
                        ///-------------------------------END------------------------------------------------------------------------

                      } else if (_menage == "membre" && _activite == "Agriculteur et Eleveur") {
                        //PLANTATION
                        await DB.insert("detenteur_plantation", {
                          "id_det_plantation": iddetplantgen,
                          "id_personne": idpersonnegen,
                          "id_plantation": plantation,
                          "flagtransmis": "",
                        });
                        //ELEVAGE
                        await DB.insert("membre_elevage", {
                          "id_mb_elevage": idmbelevgen,
                          "id_personne": idpersonnegen,
                          "id_elevage": ferme,
                          "flagtransmis": "",
                        });
                      }
                      //
                      setState(() {
                        //On vides les champs a zero
                        _nom = TextEditingController(text: "");
                        _prenom = TextEditingController(text: "");
                        _telephone = TextEditingController(text: "");
                        _autre_lien = TextEditingController(text: "");
                        _desc_plantation = TextEditingController(text: "");
                        _superficie_agriculture = TextEditingController(text: "");
                        _superficie_elevage = TextEditingController(text: "");
                        _preciser_culture = TextEditingController(text: "");
                        _preciser_type_elevage = TextEditingController(text: "");
                        _nombre = TextEditingController(text: "");
                        _date_rendement_culture  = TextEditingController(text: "");
                        _date_rendement_elevage  = TextEditingController(text: "");
                        _forme_exploitation  = TextEditingController(text: "");
                        _quantite_semence  = TextEditingController(text: "");
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

                      Fluttertoast.showToast(
                          msg: "Enregistrement effectué avec succès !",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 5,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 20.0
                      );

                      //Verification plantation,ferme
                      /*
                    if(plantation != "" || ferme != ""){} else {
                      Fluttertoast.showToast(
                          msg: "Veuillez selectionnez un chef de menage",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 5,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 20.0
                      );}
                    */
                      ///-----------------------------------------------------------------------
                      ///----------------------------END----------------------------------------
                      ///-----------------------------------------------------------------------

                    } else {
                      Fluttertoast.showToast(
                          msg: "La culture existe déjà !",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 5,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 20.0
                      );
                    }

                    ///----------------------------------------------------------------------------------------------------------

                  } else {

                    Fluttertoast.showToast(
                        msg: "Localite non synchroniser ou veuillez selectionner une localite !",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 5,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 20.0
                    );

                  }
                }else {

                  Fluttertoast.showToast(
                      msg: "Oups La campagne n\'a pas été synchronisé ! ",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 5,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 20.0
                  );

                }
              }else{

                Fluttertoast.showToast(
                    msg: "La tablette na pas d\'identifiant ou n\'a pas été identifier, Veuiller contacter la call center",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 5,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 20.0
                );

              }
            }
            //------------------------------------------------------------------
            if (formKeys[_currentStep].currentState.hashCode.toString() == "2011"){
              print("enregistrement du membre");
              print(plantation);
              //Verification de l'image
              if (_images != ""){
                //verification du scannage nfc
                if (nfc_msg_visible == "true"){
                  //Insertion dans la base de donnees
                  addUser();
                  //
                } else {

                  Fluttertoast.showToast(
                      msg: "Veuillez scanner un bracelets nfc !",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 5,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 20.0
                  );

                }
              } else {

                Fluttertoast.showToast(
                    msg: "Veuillez prendre la photo du beneficiaire !",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 5,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 20.0
                );

              }
              //------------------------------------------------------------------
            } else if(formKeys[_currentStep].currentState.validate()) {
              //
              if (this._currentStep < this._stepper().length - 1) {
                this._currentStep = this._currentStep + 1;
              } else {
                print("Enregistrement du chef");
                //Verification de l'image
                if (_images != ""){
                  //verification du scannage nfc
                  if (nfc_msg_visible == "true"){
                    //Insertion dans la base de donnees
                    addUser();
                    //
                  } else {

                    Fluttertoast.showToast(
                        msg: "Veuillez scanner un bracelets nfc !",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 5,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 20.0
                    );

                  }
                } else {
                  Fluttertoast.showToast(
                      msg: "Veuillez prendre la photo du beneficiaire !",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 5,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 20.0
                  );
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
                Divider(),
                FutureBuilder(
                    future: SelectSession(),
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
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 5.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "SESSION: ${snap[0]['description']}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ) :
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 5.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "SESSION EN COURS DE SYNCHRONISATION",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ) ;
                    }
                ),
                Divider(),
                SizedBox(height: 25.0),
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
                    String pattern = r'^[0-9]*$'; //(^(?:[+0]9)?[0-9]{10,12}$)
                    RegExp regExp = new RegExp(pattern);
                    if (value.length == 0) {
                      return 'Veuillez entrer une information';
                    }
                    else if (value.isEmpty) {
                      return 'Veuillez entrer une information';
                    }
                    else if (!regExp.hasMatch(value)) {
                      return 'Veuillez entrer un nombre valide';
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
                _imagefile == null
                    ? Text(
                  'Veuillez prendre la photo de l\'utlisateur', style: TextStyle(color: Colors.red,),)
                    :
                Column(
                  children: [
                    SizedBox(height: 5.0,),
                    SizedBox(
                      height: 250.0,
                      width: 250.0,
                      child: Image.file(_imagefile),
                    ),
                    SizedBox(height: 10.0,),
                    Text('Photo selectionnée' , style: TextStyle(color: Colors.green,),),
                  ],
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
        title: Text('Activites'),
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
                  {"display": "Agriculteur", "value": "Agriculteur"},
                  {"display": "Agriculteur et Eleveur", "value": "Agriculteur et Eleveur"}
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
              //-----------------------------------------------------------------------------------------|
              //|
              //|--------------------------Si membre est Agriculteur-------------------------------------|
              //|
              //-----------------------------------------------------------------------------------------|
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
                        Chef_menage_agriculteur = item?.avatar == null ? "" : "${item.name} ${item.prenom}" ;
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
                      validate: (value) {
                        if (plantation == "" || plantation == null) {
                          return 'Veuillez Slectionner un chef de menage';
                        }
                        return null;
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
                          return 'Veuillez Selectionner le lien';
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
                            return 'Veuillez entrer une information';
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
              //|--------------------------Si membre est eleveur-----------------------------------------|
              //|
              //-----------------------------------------------------------------------------------------|
              //SizedBox(height: 25.0),
              Visibility(
                visible: chefElv,
                child: Column(
                  children: <Widget>[
                    //-------------------------Select ferme--------------------
                    FindDropdown<fermeModel>(
                      label: "Ferme",
                      onFind: (String filter) => getDataFerme(filter),
                      onChanged: (fermeModel data) {
                        print(data.id);
                        ferme = data.id;
                      },
                      dropdownBuilder: (BuildContext context, fermeModel item) {
                        Chef_menage_eleveur = item?.avatar == null ? "" : "${item.name} ${item.prenom}";
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
                      validate: (value) {
                        if (ferme == "") {
                          return 'Veuiller Slectionner un chef de menage';
                        }
                        return null;
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
                            return 'Veuillez entrer une information';
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
              //|--------------------------Si membre est eleveur et agriculteur--------------------------|
              //|
              //-----------------------------------------------------------------------------------------|

              Visibility(
                visible: chefAgElv,
                child: Column(
                  children: <Widget>[
                    //-------------------------Select plantation--------------------
                    FindDropdown<PlantationFermeModel>(
                      label: "Plantation/Ferme",
                      onFind: (String filter) => getDataFermePlantation(filter),
                      onChanged: (PlantationFermeModel data) {
                        print(data.id_plantation);
                        plantation = data.id_plantation;
                        ferme = data.id_ferme;
                      },
                      dropdownBuilder: (BuildContext context, PlantationFermeModel item) {
                        Chef_menage_agriculteur_elevage = item?.avatar == null ? "" : "${item.name} ${item.prenom}" ;
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
                          (BuildContext context, PlantationFermeModel item, bool isSelected) {
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
                      validate: (value) {
                        if (plantation == "") {
                          return 'Veuillez Slectionner un chef de ménage';
                        }
                        return null;
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
                            return 'Veuillez entrer une information';
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
      agriculteur || eleveur || eleveur_agriculteur ? Step(
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
                        String pattern = r'^[0-9]*$'; //(^(?:[+0]9)?[0-9]{10,12}$)
                        RegExp regExp = new RegExp(pattern);
                        if (value.length == 0) {
                          return 'Veuillez entrer une information';
                        }
                        else if (value.isEmpty) {
                          return 'Veuillez entrer une information';
                        }
                        else if (!regExp.hasMatch(value)) {
                          return 'Veuillez entrer un nombre valide';
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
                              if (_type_culture == "" || _type_culture.isEmpty) {
                                return 'Veuillez Slectionner une Culture';
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

                    Row(
                      children: [
                        Container(
                          width: 800, //MediaQuery.of(context).size.width/2.8
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
                              if (value.length == 0) {
                                return 'Veuillez entrer une information';
                              }
                              else if (value.isEmpty) {
                                return 'Veuillez entrer une information';
                              }
                              else if (!regExp.hasMatch(value)) {
                                return 'Veuillez entrer un nombre valide';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 30.0,),
                        Container(
                          width: 200, //MediaQuery.of(context).size.width/10
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
                        String pattern = r'^[0-9]*$'; //(^(?:[+0]9)?[0-9]{10,12}$)
                        RegExp regExp = new RegExp(pattern);
                        if (value.length == 0) {
                          return 'Veuillez entrer une information';
                        }
                        else if (value.isEmpty) {
                          return 'Veuillez entrer une information';
                        }
                        else if (!regExp.hasMatch(value)) {
                          return 'Veuillez entrer un nombre valide';
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
                              hintText: "Nombre de tête",
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
                              if (value.length == 0) {
                                return 'Veuillez entrer une information';
                              }
                              else if (value.isEmpty) {
                                return 'Veuillez entrer une information';
                              }
                              else if (!regExp.hasMatch(value)) {
                                return 'Veuillez entrer un nombre valide';
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
                            keyboardType: TextInputType.number,
                            obscureText: false,
                            controller: _nombre,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              hintText: "Nombre de tête",
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
                              String pattern = r'^[0-9]*$'; //(^(?:[+0]9)?[0-9]{10,12}$)
                              RegExp regExp = new RegExp(pattern);
                              if (value.length == 0) {
                                return 'Veuillez entrer une information';
                              }
                              else if (value.isEmpty) {
                                return 'Veuillez entrer une information';
                              }
                              else if (!regExp.hasMatch(value)) {
                                return 'Veuillez entrer un nombre valide';
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
                              hintText: "Nombre de tête",
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
                              if (value.length == 0) {
                                return 'Veuillez entrer une information';
                              }
                              else if (value.isEmpty) {
                                return 'Veuillez entrer une information';
                              }
                              else if (!regExp.hasMatch(value)) {
                                return 'Veuillez entrer un nombre valide';
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

              Visibility(
                visible: eleveur_agriculteur,
                child: Column(
                  children: <Widget>[
                    Divider(),
                    Container(
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            //height: 50.0,
                            child: Text(
                              "PLANTATION",
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                    ),
                    Divider(),
                    SizedBox(height: 25.0),
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
                        String pattern = r'^[0-9]*$'; //(^(?:[+0]9)?[0-9]{10,12}$)
                        RegExp regExp = new RegExp(pattern);
                        if (value.length == 0) {
                          return 'Veuillez entrer une information';
                        }
                        else if (value.isEmpty) {
                          return 'Veuillez entrer une information';
                        }
                        else if (!regExp.hasMatch(value)) {
                          return 'Veuillez entrer un nombre valide';
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
                              if (_type_culture == "" || _type_culture.isEmpty) {
                                return 'Veuillez Slectionnez une Culture';
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
                                return 'Veuillez entrer une information';
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
                                return 'Veuillez entrer une information';
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
                          width: 800, //MediaQuery.of(context).size.width/2.8
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
                              if (value.length == 0) {
                                return 'Veuillez entrer une information';
                              }
                              else if (value.isEmpty) {
                                return 'Veuillez entrer une information';
                              }
                              else if (!regExp.hasMatch(value)) {
                                return 'Veuillez entrer un nombre valide';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 30.0,),
                        Container(
                          width: 200, //MediaQuery.of(context).size.width/10
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
                    ),
                    SizedBox(height: 25.0),

                    ///-----------------------------------------------------------------------------------------------------
                    ///--------------------------------------FERME----------------------------------------------------------
                    /// ----------------------------------------------------------------------------------------------------

                    Divider(),
                    Container(
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            //height: 50.0,
                            child: Text(
                              "FERME",
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                    ),
                    Divider(),
                    SizedBox(height: 25.0),

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
                        String pattern = r'^[0-9]*$'; //(^(?:[+0]9)?[0-9]{10,12}$)
                        RegExp regExp = new RegExp(pattern);
                        if (value.length == 0) {
                          return 'Veuillez entrer une information';
                        }
                        else if (value.isEmpty) {
                          return 'Veuillez entrer une information';
                        }
                        else if (!regExp.hasMatch(value)) {
                          return 'Veuillez entrer un nombre valide';
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
                              hintText: "Nombre de tête",
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
                              if (value.length == 0) {
                                return 'Veuillez entrer une information';
                              }
                              else if (value.isEmpty) {
                                return 'Veuillez entrer une information';
                              }
                              else if (!regExp.hasMatch(value)) {
                                return 'Veuillez entrer un nombre valide';
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
                            keyboardType: TextInputType.number,
                            obscureText: false,
                            controller: _nombre,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              hintText: "Nombre de tête",
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
                              String pattern = r'^[0-9]*$'; //(^(?:[+0]9)?[0-9]{10,12}$)
                              RegExp regExp = new RegExp(pattern);
                              if (value.length == 0) {
                                return 'Veuillez entrer une information';
                              }
                              else if (value.isEmpty) {
                                return 'Veuillez entrer une information';
                              }
                              else if (!regExp.hasMatch(value)) {
                                return 'Veuillez entrer un nombre valide';
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
                              hintText: "Nombre de tête",
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
                              if (value.length == 0) {
                                return 'Veuillez entrer une information';
                              }
                              else if (value.isEmpty) {
                                return 'Veuillez entrer une information';
                              }
                              else if (!regExp.hasMatch(value)) {
                                return 'Veuillez entrer un nombre valide';
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
              ///------------------------------------------------------------------------------------
              ///------------------------END---------------------------------------------------------
              /// -----------------------------------------------------------------------------------
            ],
          ),
        ),
        isActive: _currentStep >= 2,
        state: StepState.disabled,
      ) : Step(
        title: Text('Confirmation'),
        content: Form(
            key: formKeys[3],
            child: Row(
              children: [
                Container(
                  width: 500.0,
                  child: Column(
                    children: <Widget>[
                      Card(
                        child: Column(
                          children: [
                            SizedBox(height: 25.0,),
                            Container(
                              //color: Colors.indigo,
                              //margin: EdgeInsets.only(bottom: 30.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    //height: 50.0,
                                    child: Text(
                                      "LES INSFORMATIONS SAISIES SONT-IL CORRECTE ?",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                            ),
                            //Fiche de tous ce qui a ete saisi
                            SizedBox(height: 15.0),
                            _imagefile == null
                                ? Text(
                              'Veuillez prendre la photo de l\'utlisateur', style: TextStyle(color: Colors.red,),)
                                :
                            Column(
                              children: [
                                SizedBox(height: 5.0,),
                                SizedBox(
                                  height: 150.0,
                                  width: 150.0,
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: FileImage(_imagefile),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15.0),
                            Container(
                              //color: Colors.indigo,
                              //margin: EdgeInsets.only(bottom: 30.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    //height: 50.0,
                                    child: Text(
                                      "Nom : ${_nom.text}",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                            ),
                            SizedBox(height: 15.0,),
                            Container(
                              //color: Colors.indigo,
                              //margin: EdgeInsets.only(bottom: 30.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    //height: 50.0,
                                    child: Text(
                                      "Prenom : ${_prenom.text}",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                            ),
                            SizedBox(height: 15.0,),
                            Container(
                              //color: Colors.indigo,
                              //margin: EdgeInsets.only(bottom: 30.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    //height: 50.0,
                                    child: Text(
                                      "Telephone : ${_telephone.text}",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                            ),
                            SizedBox(height: 15.0,),
                            Container(
                              //color: Colors.indigo,
                              //margin: EdgeInsets.only(bottom: 30.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    //height: 50.0,
                                    child: Text(
                                      "Age : $age",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                            ),
                            SizedBox(height: 15.0,),
                            Container(
                              //color: Colors.indigo,
                              //margin: EdgeInsets.only(bottom: 30.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    //height: 50.0,
                                    child: Text(
                                      "Sexe : $_genre",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                            ),
                            SizedBox(height: 15.0,),
                            Container(
                              //color: Colors.indigo,
                              //margin: EdgeInsets.only(bottom: 30.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    //height: 50.0,
                                    child: Text(
                                      "Type d'activite : $_activite",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                            ),
                            SizedBox(height: 15.0,),
                            Container(
                              //color: Colors.indigo,
                              //margin: EdgeInsets.only(bottom: 30.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    //height: 50.0,
                                    child: Text(
                                      "Menage : $_menage",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                            ),
                            SizedBox(height: 15.0,),
                            _menage == "membre" && _activite == "Eleveur" ?
                            Column(
                              children: [
                                Container(
                                  //color: Colors.indigo,
                                  //margin: EdgeInsets.only(bottom: 30.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        //height: 50.0,
                                        child: Text(
                                          "Ferme : $Chef_menage_eleveur",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                ),
                                SizedBox(height: 15.0,),
                                _lien == "Autre" ?
                                Container(
                                  //color: Colors.indigo,
                                  //margin: EdgeInsets.only(bottom: 30.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        //height: 50.0,
                                        child: Text(
                                          "Lien : ${_autre_lien.text}",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                ) :
                                Container(
                                  //color: Colors.indigo,
                                  //margin: EdgeInsets.only(bottom: 30.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        //height: 50.0,
                                        child: Text(
                                          "Lien : $_lien",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                ),
                                SizedBox(height: 15.0,),
                              ],
                            ) : _menage == "membre" && _activite == "Agriculteur" ?
                            Column(
                              children: [
                                Container(
                                  //color: Colors.indigo,
                                  //margin: EdgeInsets.only(bottom: 30.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        //height: 50.0,
                                        child: Text(
                                          "Plantation : $Chef_menage_agriculteur",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                ),
                                SizedBox(height: 15.0,),
                                _lien == "Autre" ?
                                Container(
                                  //color: Colors.indigo,
                                  //margin: EdgeInsets.only(bottom: 30.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        //height: 50.0,
                                        child: Text(
                                          "Lien : ${_autre_lien.text}",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                ) :
                                Container(
                                  //color: Colors.indigo,
                                  //margin: EdgeInsets.only(bottom: 30.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        //height: 50.0,
                                        child: Text(
                                          "Lien : $_lien",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                ),
                                SizedBox(height: 15.0,),
                              ],
                            ) : _menage == "membre" && _activite == "Agriculteur et Eleveur" ?
                            ///----------------------------------------------------------------
                            ///----------MEMBRE AGRICULTEUR ELEVEUR---------------------------
                            /// --------------------------------------------------------------
                            Column(
                              children: [
                                Container(
                                  //color: Colors.indigo,
                                  //margin: EdgeInsets.only(bottom: 30.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        //height: 50.0,
                                        child: Text(
                                          "Ferme/Plantation : $Chef_menage_agriculteur_elevage",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                ),
                                SizedBox(height: 15.0,),
                                _lien == "Autre" ?
                                Container(
                                  //color: Colors.indigo,
                                  //margin: EdgeInsets.only(bottom: 30.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        //height: 50.0,
                                        child: Text(
                                          "Lien : ${_autre_lien.text}",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                ) :
                                Container(
                                  //color: Colors.indigo,
                                  //margin: EdgeInsets.only(bottom: 30.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        //height: 50.0,
                                        child: Text(
                                          "Lien : $_lien",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                ),
                                SizedBox(height: 15.0,),
                              ],
                            ) : Container(child:Text("Probleme suvenue !")),

                          ],
                        ),
                      ),

                    ],
                  ),
                ),
                Container(
                  width: 500.0,
                  child: SizedBox(
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
                      Center(child: Text('Bracelet scanner avec succes merci' , style: TextStyle(color: Colors.green,),))
                      )
                  ),
                ),
              ],
            )
        ),
        isActive: _currentStep >= 2,
        state: StepState.disabled,
      ),
      agriculteur || eleveur || eleveur_agriculteur ? Step(
        title: Text('Confirmation'),
        content: Form(
          key: formKeys[3],
          child: Row(
            children: [
              Container(
                width: 500.0,
                child: Column(
                  children: <Widget>[
                    Card(
                      child: Column(
                        children: [
                          SizedBox(height: 15.0),
                          Container(
                            //color: Colors.indigo,
                            //margin: EdgeInsets.only(bottom: 30.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  //height: 50.0,
                                  child: Text(
                                    "LES INFORMATIONS SAISIES SONT-IL CORRECTE ?",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          //Fiche de tous ce qui a ete saisi
                          SizedBox(height: 15.0),
                          _imagefile == null
                              ? Text(
                            'Veuillez prendre la photo de l\'utlisateur', style: TextStyle(color: Colors.red,),)
                              :
                          Column(
                            children: [
                              SizedBox(height: 5.0,),
                              SizedBox(
                                height: 150.0,
                                width: 150.0,
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: FileImage(_imagefile),
                                ),
                                //child: Image.file(_imagefile),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.0),
                          Container(
                            //color: Colors.indigo,
                            //margin: EdgeInsets.only(bottom: 30.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  //height: 50.0,
                                  child: Text(
                                    "Nom : ${_nom.text}",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          SizedBox(height: 15.0,),
                          Container(
                            //color: Colors.indigo,
                            //margin: EdgeInsets.only(bottom: 30.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  //height: 50.0,
                                  child: Text(
                                    "Prenom : ${_prenom.text}",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          SizedBox(height: 15.0,),
                          Container(
                            //color: Colors.indigo,
                            //margin: EdgeInsets.only(bottom: 30.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  //height: 50.0,
                                  child: Text(
                                    "Telephone : ${_telephone.text}",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          SizedBox(height: 15.0,),
                          Container(
                            //color: Colors.indigo,
                            //margin: EdgeInsets.only(bottom: 30.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  //height: 50.0,
                                  child: Text(
                                    "Age : $age",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          SizedBox(height: 15.0,),
                          Container(
                            //color: Colors.indigo,
                            //margin: EdgeInsets.only(bottom: 30.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  //height: 50.0,
                                  child: Text(
                                    "Sexe : $_genre",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          SizedBox(height: 15.0,),
                          Container(
                            //color: Colors.indigo,
                            //margin: EdgeInsets.only(bottom: 30.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  //height: 50.0,
                                  child: Text(
                                    "Type d'activite : $_activite",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          SizedBox(height: 15.0,),
                          Container(
                            //color: Colors.indigo,
                            //margin: EdgeInsets.only(bottom: 30.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  //height: 50.0,
                                  child: Text(
                                    "Menage : $_menage",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          SizedBox(height: 15.0,),
                          _menage == "Chef" && _activite == "Eleveur" ? Column(
                            children: [
                              Container(
                                //color: Colors.indigo,
                                //margin: EdgeInsets.only(bottom: 30.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      //height: 50.0,
                                      child: Text(
                                        "Superficie : ${_superficie_elevage.text}",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(height: 15.0,),
                              Container(
                                //color: Colors.indigo,
                                //margin: EdgeInsets.only(bottom: 30.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      //height: 50.0,
                                      child: Text(
                                        "Type d'elevage : $_type_elevage",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(height: 15.0,),
                              _type_elevage == "Pisciculture" ?
                              Column(
                                children: [
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Forme d'exploitation piscicolte : $forme_exploitation_piscicole",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                  //Les expeces
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Type d'exploitation : $type_exploitation_elevage",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "date de rendement : ${_date_rendement_elevage.text}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                ],
                              ) :  _type_elevage == "Aviculture" ?
                              Column(
                                children: [
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Forme d'exploitation avicole : $forme_exploitation_avicole",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Nombre de tête : ${_nombre.text}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "date de rendement : ${_date_rendement_elevage.text}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                ],
                              ) :  _type_elevage == "Autre" ?
                              Column(
                                children: [
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Elevage : ${_preciser_type_elevage.text}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Forme exploitation : ${_forme_exploitation.text}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Nombre de tête : ${_nombre.text}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Type d'exploitation : $type_exploitation_elevage",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "date de rendement : ${_date_rendement_elevage.text}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                ],
                              ) : Column(
                                children: [
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Forme d'exploitation : ${_forme_exploitation.text}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Nombre de tête : ${_nombre.text}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Type d'exploitation : $type_exploitation_elevage",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "date de rendement : ${_date_rendement_elevage.text}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                ],
                              ) ,

                            ],
                          ) : _menage == "Chef" && _activite == "Agriculteur" ?
                          Column(
                            children: [
                              Container(
                                //color: Colors.indigo,
                                //margin: EdgeInsets.only(bottom: 30.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      //height: 50.0,
                                      child: Text(
                                        "Description de la plantation : ${_desc_plantation.text}",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(height: 15.0,),
                              Container(
                                //color: Colors.indigo,
                                //margin: EdgeInsets.only(bottom: 30.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      //height: 50.0,
                                      child: Text(
                                        "Superficie : ${_superficie_agriculture.text}",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(height: 15.0,),
                              Container(
                                //color: Colors.indigo,
                                //margin: EdgeInsets.only(bottom: 30.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      //height: 50.0,
                                      child: Text(
                                        "Type d'exploitation : $type_exploitation_agriculture",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(height: 15.0,),
                              _type_culture == "Autre" ?
                              Column(
                                children: [
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Culture : ${_preciser_culture.text}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Forme d'exploitation : ${_forme_exploitation.text}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  //SizedBox(height: 15.0,),
                                ],
                              ) :
                              Container(
                                //color: Colors.indigo,
                                //margin: EdgeInsets.only(bottom: 30.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      //height: 50.0,
                                      child: Text(
                                        "Culture : $_type_culture",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(height: 15.0,),
                              Container(
                                //color: Colors.indigo,
                                //margin: EdgeInsets.only(bottom: 30.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      //height: 50.0,
                                      child: Text(
                                        "Quantite semence : ${_quantite_semence.text}",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(height: 15.0,),
                              Container(
                                //color: Colors.indigo,
                                //margin: EdgeInsets.only(bottom: 30.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      //height: 50.0,
                                      child: Text(
                                        "date de rendement : ${_date_rendement_culture.text}",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(height: 15.0,),
                            ],
                          )  : _menage == "Chef" && _activite == "Agriculteur et Eleveur" ? Column(
                            children: [
                              ///----------------------------------------------------------------------------------------------
                              ///----------------------PLANTATION--------------------------------------------------------------
                              ///----------------------------------------------------------------------------------------------
                              Container(
                                //color: Colors.indigo,
                                //margin: EdgeInsets.only(bottom: 30.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      //height: 50.0,
                                      child: Text(
                                        "PLANTATIONS",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(height: 15.0,),
                              Container(
                                //color: Colors.indigo,
                                //margin: EdgeInsets.only(bottom: 30.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      //height: 50.0,
                                      child: Text(
                                        "Description de la plantation : ${_desc_plantation.text}",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(height: 15.0,),
                              Container(
                                //color: Colors.indigo,
                                //margin: EdgeInsets.only(bottom: 30.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      //height: 50.0,
                                      child: Text(
                                        "Superficie : ${_superficie_agriculture.text}",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(height: 15.0,),
                              Container(
                                //color: Colors.indigo,
                                //margin: EdgeInsets.only(bottom: 30.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      //height: 50.0,
                                      child: Text(
                                        "Type d'exploitation : $type_exploitation_agriculture",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(height: 15.0,),
                              _type_culture == "Autre" ?
                              Column(
                                children: [
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Culture : ${_preciser_culture.text}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Forme d'exploitation : ${_forme_exploitation.text}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  //SizedBox(height: 15.0,),
                                ],
                              ) :
                              Container(
                                //color: Colors.indigo,
                                //margin: EdgeInsets.only(bottom: 30.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      //height: 50.0,
                                      child: Text(
                                        "Culture : $_type_culture",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(height: 15.0,),
                              Container(
                                //color: Colors.indigo,
                                //margin: EdgeInsets.only(bottom: 30.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      //height: 50.0,
                                      child: Text(
                                        "Quantite semence : ${_quantite_semence.text}",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(height: 15.0,),
                              Container(
                                //color: Colors.indigo,
                                //margin: EdgeInsets.only(bottom: 30.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      //height: 50.0,
                                      child: Text(
                                        "date de rendement : ${_date_rendement_culture.text}",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(height: 15.0,),
                              ///-----------------------------------------------------------------------------------------
                              /// FERME
                              ///----------------------------------------------------------------------------------------
                              Container(
                                //color: Colors.indigo,
                                //margin: EdgeInsets.only(bottom: 30.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      //height: 50.0,
                                      child: Text(
                                        "FERME",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(height: 15.0,),

                              Container(
                                //color: Colors.indigo,
                                //margin: EdgeInsets.only(bottom: 30.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      //height: 50.0,
                                      child: Text(
                                        "Superficie : ${_superficie_elevage.text}",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(height: 15.0,),
                              Container(
                                //color: Colors.indigo,
                                //margin: EdgeInsets.only(bottom: 30.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      //height: 50.0,
                                      child: Text(
                                        "Type d'elevage : $_type_elevage",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(height: 15.0,),
                              _type_elevage == "Pisciculture" ?
                              Column(
                                children: [
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Forme d'exploitation piscicolte : $forme_exploitation_piscicole",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                  //Les expeces
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Type d'exploitation : $type_exploitation_elevage",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "date de rendement : ${_date_rendement_elevage.text}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                ],
                              ) :  _type_elevage == "Aviculture" ?
                              Column(
                                children: [
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Forme d'exploitation avicole : $forme_exploitation_avicole",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Nombre de tête : ${_nombre.text}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "date de rendement : ${_date_rendement_elevage.text}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                ],
                              ) :  _type_elevage == "Autre" ?
                              Column(
                                children: [
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Elevage : ${_preciser_type_elevage.text}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Forme exploitation : ${_forme_exploitation.text}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Nombre de tête : ${_nombre.text}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Type d'exploitation : $type_exploitation_elevage",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "date de rendement : ${_date_rendement_elevage.text}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                ],
                              ) : Column(
                                children: [
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Forme d'exploitation : ${_forme_exploitation.text}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Nombre de tête : ${_nombre.text}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "Type d'exploitation : $type_exploitation_elevage",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                    //color: Colors.indigo,
                                    //margin: EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          //height: 50.0,
                                          child: Text(
                                            "date de rendement : ${_date_rendement_elevage.text}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 15.0,),
                              ]),

                            ],
                          ) : Container(child:Text("Probleme suvenue !")),
                        ],
                      ),
                    ),
                    SizedBox(height: 25.0,),
                    //SizedBox(height: 25.0,),
                  ],
                ),
              ),
              Container(
                width: 500.0,
                child: SizedBox(
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
                        Text('Ce bracelet a déjà été utlilisé, Veuillez utiliser un autre bracelet' , style: TextStyle(color: Colors.red,),),
                      ],
                    ) :
                    Center(child: Text('Bracelet scanné avec succes merci' , style: TextStyle(color: Colors.green,),))
                    )
                ),
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
