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
import 'package:intl/intl.dart';
import 'package:bmapp/database/database.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

import 'groupementUser.dart';
import 'membreAgriculteur.dart';


class UserPannel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: User(),
    );
  }
}

class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {

  //
  final format = DateFormat("yyyy-MM-dd");
  //formulaire key
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();

  //String
  String _culture_rendement = "";
  String _add_culture = "";
  String _type_elv = "";
  //
  var id_personne = StorageUtil.getString("id_personne");

  //Textbox
  TextEditingController _autre_culture = TextEditingController();
  TextEditingController _date_rendement = TextEditingController();
  TextEditingController _nbre = TextEditingController();
  TextEditingController nature = TextEditingController();
  TextEditingController _quantite_semence = TextEditingController();
  TextEditingController _quantite_rendement = TextEditingController();
  TextEditingController _poids = TextEditingController();
  //
  TextEditingController _nom_espece = TextEditingController();
  //
  TextEditingController _qteSemence = TextEditingController();
  //Checkbox value
  List _espece_pisciculture = List();
  bool _espece1 = false;
  bool _espece2 = false;
  bool _espece3 = false;
  bool _espece4 = false;

  //Bool
  bool eleveur = false;
  bool pecheur = false;
  bool autre = false;
  bool avi = false;
  bool pisci = false;

  //
  String _type_elevage = "";
  String id_culture = "";
  String plantation;
  String ferme;
  //
  String Chef_menage_agriculteur;
  String Chef_menage_eleveur;
  //
  String _unite_mesure = "kilogrammes";

  //String
  String service_recu = "";
  String bien_recu = "";
  String subvention_recu = "";
  String id_mb_groupement = "";
  
  //String _unite_mesure;
  String _unite_mesure_rendement = "kilogrammes";
  String _unite_mesure_qte_semence = "kilogrammes";

  //
  bool avicole = false;
  bool pisciculture = false;
  bool autre_type_elevage = false;
  bool preciser_culture = false;
  bool culture_save = false;
  //
  StateSetter _setState;


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
  //Ferme
  TextEditingController _superficie_elevage = TextEditingController();
  TextEditingController _preciser_type_elevage = TextEditingController();
  TextEditingController _nombre = TextEditingController();
  TextEditingController _date_rendement_elevage = TextEditingController();
  TextEditingController _forme_exploitation = TextEditingController();
  //
  String forme_exploitation_avicole = "Aviculture  villageoise"; //Radio
  String forme_exploitation_piscicole = "Etang"; //Radio
  String type_exploitation_elevage = "Individuelle"; //Radio
  String type_exploitation_avicole = ""; //Radio
  String type_exploitation_pisciculture = ""; //Radio

  //--------------------------------------------------------------------------
  //-----------------------------------------Selecte groupement-----
  Future<void> SelectGroupement() async {
    List<Map<String, dynamic>> queryGroup = await DB.queryAll("groupement");
    return queryGroup;
  }
  //----------------------SELECTION PALANTATION---------------------------------
  //----------------------------------------------------------------------------
  //-----------------------Culture elevage-----------------------------------
  Future<void> SelectCultureEL() async {
    List<Map<String, dynamic>> queryCulture = await DB.querySelectCulture("EL");
    queryCulture += [{"nom_culture": "Autre", "nom_culture": "Autre"}];
    return queryCulture;
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
    var dateNow = new DateTime.now();
    var dates = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    var date = dates.toString();
    final DonneeRoute userInfo = ModalRoute.of(context).settings.arguments;
    //
    Future<List<Map<String, dynamic>>> userprofil() async{
      List<Map<String, dynamic>> queryPerson = await DB.queryUserAgriculteur(userInfo.id);
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

          //Add culture
          Future<void> AddCultureAG() async {
            var _campagne = await DB.queryCampagne();
            //print(_campagne[0]['description']);
            List<Map<String, dynamic>> queryCultureadd = await DB.querySelectCultureSuivit("AG",snap[0]["id_plantation"],_campagne[0]['description']);
            queryCultureadd += [
              {"nom_culture": "Autre", "id_culture": "Autre"},
            ];
            return queryCultureadd;
          }
          //------------------------------------------------------------------------------
          //--------------------SELECT CULTURE MINE---------------------------------------
          //------------------------------------------------------------------------------
          //print(snap[0]["id_plantation"]);
          Future<void> SelectCultureAG() async {
            var _campagne = await DB.queryCampagne();
            List<Map<String, dynamic>> queryCulture = await DB.querySelectMyCulture("AG",snap[0]["id_plantation"],_campagne[0]['description']);
            return queryCulture;
          }
          //Quantite semence select
          Future<void> QteSemance(String id_plantation,String qte_rendement) async {
            var _campagne = await DB.queryCampagne(); //
            List<Map<String, dynamic>> queryCulture = await DB.querySelectQteS(id_plantation,qte_rendement); //'SELECT * FROM detenteur_culture WHERE id_plantation = "$id_plantation" AND id_culture= "$id_culture"
            return queryCulture;
          }
          //Selections des culture de la personne
          Future<List<Map<String, dynamic>>> culture() async {
            var _campagne = await DB.queryCampagne();
            List<Map<String, dynamic>> queryPerson = await DB.queryCulture(snap[0]['id_plantation'],_campagne[0]['description']);
            return queryPerson;
          }
          //***************************************ELEVEUR**************************************************
          //Selections des membre de menage
          Future<List<Map<String, dynamic>>> membreMenage() async {
            List<Map<String, dynamic>> querymembreMenage = await DB.queryMembreAgriculteurAG(snap[0]['id_plantation']);
            return querymembreMenage;
          }
          final _culture = FutureBuilder(
              future: culture(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                List<Map<String, dynamic>> culture = snapshot.data;
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
                int n = culture.length;
                final items = List<String>.generate(n, (i) => "Item $i");
                return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return RaisedButton(
                        elevation: 0,
                        padding: EdgeInsets.all(0.0),
                        color: Colors.transparent,
                        disabledColor: Colors.transparent,
                        child: Card(
                          margin: EdgeInsets.only(top: 25.0,),
                          elevation: 2.0,
                          child: ListTile(
                            title: Text('Culture: ${culture[index]["nom_culture"]}'),
                            //subtitle: Text('Date de rendement: ${culture[index]["date_rendement"]} \nQuantite de semence: ${culture[index]["quantite_semence"]} Kg'),
                            //Quantite recolte: ${culture[index]["quantite"]} Kg
                          ),
                        ),
                        onPressed: (){
                          //Mes rendement
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RendementCulture(),settings: RouteSettings(arguments: DonneeCulture(
                                '${snap[0]['id_plantation']}', '${culture[index]["id_c"]}'
                            ))),
                          );
                        },
                      );
                    }
                );
              }
          );
          /// VERIFICATION DES DU MEMBRE GROUPEMENT
          ///
          ///
          //Selections des culture de la personne
          Future<List<Map<String, dynamic>>> MmbreGrp() async {
            List<Map<String, dynamic>> queryMmbreGrp = await DB.queryMbreGrp(snap[0]['id_personne']);
            return queryMmbreGrp;
          }
          /// -------------------------------------------

          //les agriculteurs
          final _Culture = Row(
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
                                "Type d'activite : Agriculteur", //${snap[0]["nom_culture"]}
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
                            return mbreGrp.isNotEmpty || snap[0]["menage"] == "Chef" ?
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
                      snap[0]["nom_fonction"] == "CAG" ? Material(
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
                                            "AJOUTER UNE FERME",
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
                                      return Container(
                                        width: MediaQuery.of(context).size.width/2,
                                        child: Form(
                                          key: _formKey3,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
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
                                                    if (_superficie_elevage.text.length == 0) {
                                                      return 'Veuillez entrer une information';
                                                    }
                                                    else if (_superficie_elevage.text.isEmpty) {
                                                      return 'Veuillez entrer une information';
                                                    }
                                                    else if (!regExp.hasMatch(_superficie_elevage.text)) {
                                                      return 'Veuillez entrer un numbre';
                                                    }
                                                    return null;

                                                    if (_superficie_elevage.text.isEmpty) {
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
                                                            return 'Veuillez Slectionner une Culture';
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
                                                          hintText: "Preciser le type d'elevage",
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
                                                          if (_preciser_type_elevage.text.isEmpty) {
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
                                                          if (_forme_exploitation.text.isEmpty) {
                                                            return 'Veuillez entrer une information';
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
                                                          if (_nombre.text.isEmpty) {
                                                            return 'Veuillez entrer une information';
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
                                                          if (_forme_exploitation.text.isEmpty) {
                                                            return 'Veuillez entrer une information';
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
                                                          if (_nombre.text.isEmpty) {
                                                            return 'Veuillez entrer une information';
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
                                                                    "forme \nd'exploitation\navicole : ",
                                                                    style: TextStyle(
                                                                      fontSize: 16.0,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                          ),
                                                          SizedBox(
                                                            width: 5.0,
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
                                                                      fontSize: 14.0,
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
                                                                      fontSize: 14.0,
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
                                                                      fontSize: 14.0,
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
                                                      width: 10.0,
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
                                                          if (_nombre.text.isEmpty) {
                                                            return 'Veuillez entrer une information';
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
                                                  validator: (value) {
                                                    if (_date_rendement_elevage.text.isEmpty) {
                                                      return 'Veuillez entrer une information';
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
                                        setState(() {
                                          //On vides les champs a zero
                                          _superficie_elevage = TextEditingController(text: "");
                                          _preciser_type_elevage = TextEditingController(text: "");
                                          _nombre = TextEditingController(text: "");
                                          _date_rendement_elevage  = TextEditingController(text: "");
                                          _forme_exploitation  = TextEditingController(text: "");
                                          _type_elevage = "";
                                          id_culture = "";
                                        });
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
                                          //nom de la tablette
                                          var _tab = await DB.initTabquery();
                                          var _culture_ele = await DB.querySelectCult(_type_elevage);
                                          var _campagne = await DB.queryCampagne();
                                          if(_tab.isNotEmpty){
                                            print(_campagne);
                                            if(_campagne.isNotEmpty){
                                              var _locate = await DB.queryWherelocate("localite",_tab[0]["locate"]);
                                              if (_locate.isNotEmpty){
                                                //elevage
                                                String idelevgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                                                String idrendelevgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                                                String idmbelevgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);

                                                String idcul = _preciser_type_elevage.text;
                                                String idcult = idcul.replaceAll(" ", "").toUpperCase();
                                                var verif_culture = await DB.queryVerifCult(idcult);

                                                if(_type_elevage == "Autre" && idcul != "" || idcul != null && verif_culture.isEmpty){
                                                  //PERSONNE FONCTION
                                                  await DB.updatePersonne("personne_fonction", {
                                                    "nom_fonction": "CAGCE",
                                                    "flagtransmis": "",
                                                  },snap[0]["id_personne"]);
                                                  //
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
                                                      "id_personne": snap[0]["id_personne"],
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
                                                      "id_personne": snap[0]["id_personne"],
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
                                                      "id_personne": snap[0]["id_personne"],
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
                                                      "id_personne": snap[0]["id_personne"],
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
                                                  //
                                                  setState(() {
                                                    //On vides les champs a zero
                                                    _superficie_elevage = TextEditingController(text: "");
                                                    _preciser_type_elevage = TextEditingController(text: "");
                                                    _nombre = TextEditingController(text: "");
                                                    _date_rendement_elevage  = TextEditingController(text: "");
                                                    _forme_exploitation  = TextEditingController(text: "");
                                                    _type_elevage = "";
                                                    id_culture = "";
                                                  });
                                                  //
                                                  //
                                                  Fluttertoast.showToast(
                                                      msg: "Elevage enregistrer avec succes", //Présence enregistrée,
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

                                                } else if (_type_elevage != "Autre") {
                                                  //PERSONNE FONCTION
                                                  await DB.updatePersonne("personne_fonction", {
                                                    "nom_fonction": "CAGCE",
                                                    "flagtransmis": "",
                                                  },snap[0]["id_personne"]);
                                                  //
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
                                                      "id_personne": snap[0]["id_personne"],
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
                                                      "id_personne": snap[0]["id_personne"],
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
                                                      "id_personne": snap[0]["id_personne"],
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
                                                      "id_personne": snap[0]["id_personne"],
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
                                                  //
                                                  setState(() {
                                                    //On vides les champs a zero
                                                    _superficie_elevage = TextEditingController(text: "");
                                                    _preciser_type_elevage = TextEditingController(text: "");
                                                    _nombre = TextEditingController(text: "");
                                                    _date_rendement_elevage  = TextEditingController(text: "");
                                                    _forme_exploitation  = TextEditingController(text: "");
                                                    _type_elevage = "";
                                                    id_culture = "";
                                                  });
                                                  //
                                                  //
                                                  Fluttertoast.showToast(
                                                      msg: "Elevage enregistrer avec succes", //Présence enregistrée,
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
                          },
                          child: Text("Ajouter une Ferme", textAlign: TextAlign.center,),
                        ),
                      ) : Container(),
                      SizedBox(height: 25.0),
                    ],
                  ),
                ),
              ),
              VerticalDivider(),//-------------------------------------------------
              Container(
                margin: EdgeInsets.only(left:80.0, right:50.0),
                //padding: EdgeInsets.only(left: 50, right: 50),
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
                                    child: Text("CULTURE"),
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
                                    child: Text("VOIR LES CULTURES"),
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
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    snap[0]["menage"] == "Chef" ?
                                    SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          SizedBox(height: 25.0),
                                          Divider(),
                                          Container(
                                            //color: Colors.indigo,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: SizedBox(
                                                  //height: 50.0,
                                                  child: Text(
                                                    "NOUVEAU RENDEMENT",
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              )
                                          ),
                                          Divider(),
                                          SizedBox(height: 25.0),
                                          Form(
                                            key: _formKey1,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: <Widget>[
                                                  //
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
                                                          titleText: 'Culture',
                                                          hintText: 'Selectionner une culture',
                                                          value: _culture_rendement,
                                                          onSaved: (value) {
                                                            setState(() {
                                                              _culture_rendement = value;
                                                            });
                                                          },
                                                          onChanged: (value) {
                                                            setState(() {
                                                              _culture_rendement = value;
                                                            });
                                                          },
                                                          //snap
                                                          dataSource: snap,
                                                          textField: 'nom_culture',
                                                          valueField: 'id_culture',
                                                          validator: (value) {
                                                            if (_culture_rendement == "") {
                                                              return 'Veuiller Slectionner une Culture';
                                                            }
                                                            return null;
                                                          },
                                                        );
                                                      }),
                                                  SizedBox(height: 25.0),


                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(context).size.width/2.8,
                                                        child: TextFormField(
                                                          keyboardType: TextInputType.number,
                                                          obscureText: false,
                                                          controller: _quantite_rendement,
                                                          decoration: InputDecoration(
                                                            //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                                            //icon: Icon(Icons.show_chart, color: Colors.blue),
                                                            hintText: "Rendement",
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
                                                      ),
                                                      SizedBox(width: 30.0,),
                                                      Container(
                                                        width: MediaQuery.of(context).size.width/10,
                                                        child: DropDownFormField(
                                                          titleText: 'Unite de mesure',
                                                          hintText: 'kg/g',
                                                          value: _unite_mesure_rendement,
                                                          onSaved: (value) {
                                                            setState(() {
                                                              _unite_mesure_rendement = value;
                                                            });
                                                          },
                                                          onChanged: (value) {
                                                            setState(() {
                                                              _unite_mesure_rendement = value;
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
                                                            if (_unite_mesure_rendement == "") {
                                                              return 'Veuiller Selectionner une Culture';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  //
                                                  /*
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(context).size.width/2.8,
                                                        child: ,
                                                      ),
                                                      SizedBox(width: 30.0,),
                                                      Container(
                                                        width: MediaQuery.of(context).size.width/10,
                                                        child: DropDownFormField(
                                                          titleText: 'Unite de mesure',
                                                          hintText: 'kg/g',
                                                          value: _unite_mesure_rendement,
                                                          onSaved: (value) {
                                                            setState(() {
                                                              _unite_mesure_rendement = value;
                                                            });
                                                          },
                                                          onChanged: (value) {
                                                            setState(() {
                                                              _unite_mesure_rendement = value;
                                                            });
                                                          },
                                                          //snap
                                                          dataSource: [
                                                            {"display": "kg", "value": "kilogrammes"},
                                                            {"display": "g", "value": "grammes"},
                                                            {"display": "bt", "value": "boutures"},
                                                          ],
                                                          textField: 'display',
                                                          valueField: 'value',
                                                          validator: (value) {
                                                            if (_unite_mesure_rendement == "") {
                                                              return 'Veuiller Selectionner une Culture';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),

                                                  */

                                                  SizedBox(height: 25.0),

                                                  _culture_rendement != "" ? FutureBuilder(
                                                      future: QteSemance(snap[0]["id_plantation"],_culture_rendement),
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

                                                        _qteSemence = TextEditingController()..text = snap.isNotEmpty ? snap[0]['quantite_semence'] : "0";

                                                        return TextFormField(
                                                          keyboardType: TextInputType.number,
                                                          obscureText: false,
                                                          controller: _qteSemence,
                                                          decoration: InputDecoration(
                                                            //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                                            //icon: Icon(Icons.photo_size_select_small, color: Colors.blue),
                                                            hintText: "Quantité de semence",
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
                                                        );

                                                          Row(
                                                          children: [
                                                            Container(
                                                              width: MediaQuery.of(context).size.width/2.8,
                                                              child: TextFormField(
                                                                keyboardType: TextInputType.number,
                                                                obscureText: false,
                                                                controller: _qteSemence,
                                                                decoration: InputDecoration(
                                                                  //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                                                  //icon: Icon(Icons.photo_size_select_small, color: Colors.blue),
                                                                  hintText: "Quantité de semence",
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
                                                            ),
                                                            SizedBox(width: 30.0,),
                                                            Container(
                                                              width: MediaQuery.of(context).size.width/10,
                                                              child: DropDownFormField(
                                                                titleText: 'Unite de mesure',
                                                                hintText: 'kg/g',
                                                                value: _unite_mesure_qte_semence,
                                                                onSaved: (value) {
                                                                  setState(() {
                                                                    _unite_mesure_qte_semence = value;
                                                                  });
                                                                },
                                                                onChanged: (value) {
                                                                  setState(() {
                                                                    _unite_mesure_qte_semence = value;
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
                                                                  if (_unite_mesure_qte_semence == "") {
                                                                    return 'Veuiller Selectionner une Culture';
                                                                  }
                                                                  return null;
                                                                },
                                                              ),
                                                            )
                                                          ],
                                                        );




                                                      }
                                                  ) :
                                                  TextFormField(
                                                    keyboardType: TextInputType.number,
                                                    obscureText: false,
                                                    controller: _qteSemence,
                                                    decoration: InputDecoration(
                                                      //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                                      //icon: Icon(Icons.photo_size_select_small, color: Colors.blue),
                                                      hintText: "Quantité de semence",
                                                      hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                                                      //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
                                                      enabledBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.blue)),
                                                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange),),
                                                    ),
                                                    validator: (value) {
                                                      if (value.isEmpty) {
                                                        return 'Veuillez entrer une information';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  /*Row(
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(context).size.width/2.8,
                                                        child: TextFormField(
                                                          keyboardType: TextInputType.number,
                                                          obscureText: false,
                                                          controller: _qteSemence,
                                                          decoration: InputDecoration(
                                                            //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                                            //icon: Icon(Icons.photo_size_select_small, color: Colors.blue),
                                                            hintText: "Quantité de semence",
                                                            hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                                                            //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
                                                            enabledBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.blue)),
                                                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange),),
                                                          ),
                                                          validator: (value) {
                                                            if (value.isEmpty) {
                                                              return 'Veuillez entrer une information';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(width: 30.0,),
                                                      Container(
                                                        width: MediaQuery.of(context).size.width/10,
                                                        child: DropDownFormField(
                                                          titleText: 'Unite de mesure',
                                                          hintText: 'kg/g',
                                                          value: _unite_mesure_qte_semence,
                                                          onSaved: (value) {
                                                            setState(() {
                                                              _unite_mesure_qte_semence = value;
                                                            });
                                                          },
                                                          onChanged: (value) {
                                                            setState(() {
                                                              _unite_mesure_qte_semence = value;
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
                                                            if (_unite_mesure_qte_semence == "") {
                                                              return 'Veuillez Selectionner une Culture';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),*/

                                                  SizedBox(height: 25.0),
                                                  Material(
                                                    elevation: 5.0,
                                                    borderRadius: BorderRadius.circular(30.0),
                                                    color: Color(0xff01A0C7),
                                                    child: MaterialButton(
                                                      minWidth: MediaQuery.of(context).size.width,
                                                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                                      onPressed: () async{
                                                        if (_formKey1.currentState.validate()) {
                                                          //verification
                                                          var _tab = await DB.initTabquery();
                                                          String idrendgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                                                          //
                                                          int quantite_rendement;
                                                          quantite_rendement = int.parse(_quantite_rendement.text);
                                                          int semence_qte;
                                                          semence_qte = int.parse(_qteSemence.text);
                                                          double semence_kg;
                                                          double rendement_kg;
                                                          rendement_kg = quantite_rendement * 1/1000;
                                                          semence_kg = semence_qte * 1/1000;
                                                          //print("$semence_kg kg");
                                                          //print("$rendement_kg kg");
                                                          //
                                                          var det_cult = await DB.queryIdDetCult(snap[0]['id_plantation'],_culture_rendement);
                                                          //print(det_cult);
                                                          //insertion du nom de la tablette
                                                          await DB.insert("rendement", {
                                                            "id_rendement": idrendgen,
                                                            "quantite": _unite_mesure_rendement == "grammes" ? rendement_kg : quantite_rendement , // _quantite_rendement.text, //
                                                            "quantite_semence": _qteSemence.text, // _unite_mesure_qte_semence == "grammes" ? semence_kg : semence_qte , //
                                                            "unites": _unite_mesure_rendement,
                                                            "date_rendement": date,
                                                            "id_det_plantation": snap[0]["id_det_plantation"],
                                                            "id_det_culture": det_cult[0]["id_det_culture"],
                                                            "flagtransmis": "",
                                                          });
                                                          setState(() {
                                                            _qteSemence = TextEditingController()..text = '';
                                                            _quantite_rendement = TextEditingController()..text = '';
                                                            _culture_rendement = "";
                                                            //_date_rendement = TextEditingController()..text = '';
                                                          });


                                                          Fluttertoast.showToast(
                                                              msg: "Nouveau rendement enregistré avec succès ! ", //Présence enregistrée,
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
                                          Container(
                                            //color: Colors.indigo,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: SizedBox(
                                                  //height: 50.0,
                                                  child: Text(
                                                    "AJOUTER UNE CULTURE",
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              )
                                          ),
                                          Divider(),
                                          SizedBox(height: 25.0),
                                          Form(
                                            key: _formKey2,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  //
                                                  FutureBuilder(
                                                      future: AddCultureAG(),
                                                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                                                        List list_cultu = snapshot.data;
                                                        //print(list_cultu);
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
                                                        //Probleme
                                                        return DropDownFormField(
                                                          titleText: 'Culture',
                                                          hintText: 'Selectionner une culture',
                                                          value: _add_culture,
                                                          onSaved: (value) {
                                                            setState(() {
                                                              _add_culture = value;
                                                            });
                                                          },
                                                          onChanged: (value) {
                                                            setState(() {
                                                              _add_culture = value;
                                                            });
                                                          },
                                                          //snap
                                                          dataSource: list_cultu,
                                                          textField: 'nom_culture',
                                                          valueField: 'id_culture',
                                                          validator: (value) {
                                                            if (_add_culture == "") {
                                                              return 'Veuiller Selectionner une Culture';
                                                            }
                                                            return null;
                                                          },
                                                        );
                                                      }),

                                                  SizedBox(height: 25.0),
                                                  Visibility(
                                                    visible: autre,
                                                    child: Column(
                                                      children: [
                                                        TextFormField(
                                                          //keyboardType: TextInputType.number,
                                                          obscureText: false,
                                                          controller: _autre_culture,
                                                          decoration: InputDecoration(
                                                            //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                                            //icon: Icon(Icons.photo_size_select_small, color: Colors.blue),
                                                            hintText: "Autre culture",
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
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(context).size.width/2.8,
                                                        child: TextFormField(
                                                          keyboardType: TextInputType.number,
                                                          obscureText: false,
                                                          controller: _quantite_semence,
                                                          decoration: InputDecoration(
                                                            //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                                            //icon: Icon(Icons.photo_size_select_small, color: Colors.blue),
                                                            hintText: "Quantite semence",
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
                                                      ),
                                                      SizedBox(width: 30.0,),
                                                      Container(
                                                        width: MediaQuery.of(context).size.width/10,
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
                                                  DateTimeField(
                                                    format: format,
                                                    controller: _date_rendement,
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
                                                      if (_date_rendement.text.isEmpty) {
                                                        return 'Veuiller entrer une information';
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
                                                        if (_formKey2.currentState.validate()) {
                                                          //verification
                                                          var _tab = await DB.initTabquery();
                                                          String iddetcultgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                                                          String idrendgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                                                          var _campagne = await DB.queryCampagne();
                                                          String idcultgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                                                          //insertion du nom de la tablette
                                                          int semence;
                                                          semence = int.parse(_quantite_semence.text);
                                                          double semence_kg;
                                                          semence_kg = semence * 1/1000;
                                                          //print("$semence_kg kg");
                                                          String idcult = _autre_culture.text;
                                                          String idcul = idcult.replaceAll(" ", "").toUpperCase();
                                                          var verif_culture = await DB.queryVerifCult(idcul);

                                                          if(_add_culture == "Autre") {
                                                            if(verif_culture.isEmpty){
                                                              await DB.insert("culture", {
                                                                "id_culture": idcul,
                                                                "nom_culture": _autre_culture.text,
                                                                "code": "AG",
                                                                "flagtransmis": "",
                                                              });
                                                              await DB.insert("detenteur_culture", {
                                                                "id_det_culture": iddetcultgen,
                                                                "id_plantation": snap[0]["id_plantation"],
                                                                "id_culture": idcult.replaceAll(" ", "").toUpperCase(),
                                                                "campagneAgricole": _campagne[0]['description'],
                                                                "flagtransmis": "",
                                                              });
                                                              //
                                                              await DB.insert("rendement", {
                                                                "id_rendement": idrendgen,
                                                                "quantite": "0",
                                                                "quantite_semence": _unite_mesure == "grammes" ? semence_kg : semence, // _quantite_semence.text, //
                                                                "unites": _unite_mesure,
                                                                "date_rendement": date,
                                                                "id_det_plantation": snap[0]["id_det_plantation"],
                                                                "id_det_culture": iddetcultgen, //det_cult[0]["id_det_culture"]
                                                                "flagtransmis": "",
                                                              });
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg: "Culture existe deja ! ", //Présence enregistrée,
                                                                  toastLength: Toast.LENGTH_LONG,
                                                                  gravity: ToastGravity.BOTTOM,
                                                                  timeInSecForIosWeb: 5,
                                                                  backgroundColor: Colors.red,
                                                                  textColor: Colors.white,
                                                                  fontSize: 16.0
                                                              );
                                                            }

                                                          } else {
                                                            await DB.insert("detenteur_culture", {
                                                              "id_det_culture": iddetcultgen,
                                                              "id_plantation": snap[0]["id_plantation"],
                                                              "id_culture": _add_culture,
                                                              "campagneAgricole": _campagne[0]['description'],
                                                              "flagtransmis": "",
                                                            });
                                                            //
                                                            var det_cult = await DB.queryIdDetCult(snap[0]['id_plantation'],_add_culture);
                                                            //
                                                            await DB.insert("rendement", {
                                                              "id_rendement": idrendgen,
                                                              "quantite": "0",
                                                              "quantite_semence": _unite_mesure == "grammes" ? semence_kg : semence, // _quantite_semence.text, //
                                                              "unites": _unite_mesure,
                                                              "date_rendement": date,
                                                              "id_det_plantation": snap[0]["id_det_plantation"],
                                                              "id_det_culture": det_cult[0]["id_det_culture"],
                                                              "flagtransmis": "",
                                                            });
                                                          }
                                                          setState(() {
                                                            _quantite_semence = TextEditingController()..text = '';
                                                            _autre_culture = TextEditingController()..text = '';
                                                            _add_culture = "";
                                                            _date_rendement = TextEditingController()..text = '';
                                                          });

                                                          Fluttertoast.showToast(
                                                              msg: "Culture ajouté avec succès ! ", //Présence enregistrée,
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
                                        ],
                                      ),
                                    ) : Center( child: Text('Vous ne pouvez pas enregistré des cultures'), ),
                                  ],
                                ),
                              );
                            }
                        ),
                        _culture,
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

                                              Navigator.push(context, MaterialPageRoute(builder: (context) => UserMembreAgriculteur(),settings: RouteSettings(arguments: DonneeRoute(
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
                    )),
              ),
            ],
          );

          return snap.isEmpty ? Center(
            child: Text("Un probleme est survenir lors du chargement des informations !"),
          ) :
          userInfo.fonction == "AG" || userInfo.fonction == "CAG" ? _Culture : Center(child: Text("Probleme  !") );
        }
    );

    //-------------------------------------------------------------------------

    return Container(
      child: _user,
    );
  }
}

