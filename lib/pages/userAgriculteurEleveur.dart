import 'dart:io';
import 'package:bmapp/database/storageUtil.dart';
import 'package:bmapp/models/add_groupement.dart';
import 'package:bmapp/models/donnee_culture.dart';
import 'package:bmapp/models/donnee_route.dart';
import 'package:bmapp/pages/membreEleveur.dart';
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
import 'membreAgriculteur.dart';


class AgriculteurEleveurPannel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: UserAgriculteurEleveur(),
    );
  }
}

class UserAgriculteurEleveur extends StatefulWidget {
  @override
  _UserAgriculteurEleveurState createState() => _UserAgriculteurEleveurState();
}

class _UserAgriculteurEleveurState extends State<UserAgriculteurEleveur> {

  //
  final format = DateFormat("yyyy-MM-dd");

  //formulaire key
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  final _formKey5 = GlobalKey<FormState>();

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
  String _unite_mesure_rendement;
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
  TextEditingController _nom = TextEditingController();
  TextEditingController _prenom = TextEditingController();
  TextEditingController _superficie_elevage = TextEditingController();
  TextEditingController _preciser_type_elevage = TextEditingController();
  TextEditingController _nombre = TextEditingController();
  TextEditingController _date_rendement_elevage = TextEditingController();
  TextEditingController _forme_exploitation = TextEditingController();
  //
  String forme_exploitation_avicole = ""; //Radio
  String forme_exploitation_piscicole = ""; //Radio
  String type_exploitation_elevage = ""; //Radio
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

  @override
  Widget build(BuildContext context)  {
    //
    var dateNow = new DateTime.now();
    var dates = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    var date = dates.toString();
    final DonneeRoute userInfo = ModalRoute.of(context).settings.arguments;

    //USER
    Future<List<Map<String, dynamic>>> userprofil() async{
      List<Map<String, dynamic>> queryPerson = await DB.queryUserAgriculteurEleveur(userInfo.id);
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
          //--------------------------------------------------------------------------
          //--------------------SELECT CULTURE MINE----------------------------------
          //--------------------------------------------------------------------------
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
          Future<List<Map<String, dynamic>>> membreMenagePlantation() async {
            List<Map<String, dynamic>> querymembreMenage = await DB.queryMembreAgriculteurAG(snap[0]['id_plantation']);
            return querymembreMenage;
          }
          //Selections des membre de menage
          Future<List<Map<String, dynamic>>> membreMenageElevage() async {
            List<Map<String, dynamic>> querymembreMenage = await DB.queryMembreEleveur(snap[0]['id_elevage']);
            return querymembreMenage;
          }
          //ESPECE
          Future<List<Map<String, dynamic>>> espece() async {
            List<Map<String, dynamic>> queryPerson = await DB.queryEspece(snap[0]['id_elevage']);
            return queryPerson;
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
          /// -----------------------------------------------------------------------------------------
          /// ----------------------------VERIFICATION DES DU MEMBRE GROUPEMENT------------------------
          /// -----------------------------------------------------------------------------------------
          //Selections des culture de la personne
          Future<List<Map<String, dynamic>>> MmbreGrp() async {
            List<Map<String, dynamic>> queryMmbreGrp = await DB.queryMbreGrp(snap[0]['id_personne']);
            return queryMmbreGrp;
          }
          /// ----------------------------------------------------------------------------------------
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
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Type d'activite : Agriculteur-Eléveur", //${snap[0]["nom_culture"]}
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
                      Container(
                        //color: Colors.indigo,
                        //margin: EdgeInsets.only(bottom: 10.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Ferme",
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
                    length: 5,
                    child: Scaffold(
                      appBar: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        bottom: TabBar(
                            unselectedLabelColor: Colors.indigo,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicator: BoxDecoration(
                                //borderRadius: BorderRadius.circular(50),
                                color: Colors.indigo),
                            tabs: [
                              Tab(
                                child: Container(
                                  decoration: BoxDecoration(
                                    //borderRadius: BorderRadius.circular(50),
                                    border: Border(
                                      bottom: BorderSide(width: 5.0, color: Colors.lightBlue.shade900),
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text("RENDEMENT/AJOUT"),
                                  ),
                                ),
                              ),
                              Tab(
                                child: Container(
                                  decoration: BoxDecoration(
                                    //borderRadius: BorderRadius.circular(50),
                                    border: Border(
                                      bottom: BorderSide(width: 5.0, color: Colors.lightBlue.shade900),
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text("CULTURES"),
                                  ),
                                ),
                              ),
                              Tab(
                                child: Container(
                                  decoration: BoxDecoration(
                                    //borderRadius: BorderRadius.circular(50),
                                    border: Border(
                                      bottom: BorderSide(width: 5.0, color: Colors.lightBlue.shade900),
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text("ESPECES"),
                                  ),
                                ),
                              ),
                              Tab(
                                child: Container(
                                  decoration: BoxDecoration(
                                      //borderRadius: BorderRadius.circular(50),
                                      border: Border(
                                        bottom: BorderSide(width: 5.0, color: Colors.lightBlue.shade900),
                                      ),
                                  ),//color: Colors.indigo, width: 1
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text("MEMBRE PLANTATION"),
                                  ),
                                ),
                              ),
                              Tab(
                                child: Container(
                                  decoration: BoxDecoration(
                                    //borderRadius: BorderRadius.circular(50),
                                    border: Border(
                                      bottom: BorderSide(width: 5.0, color: Colors.lightBlue.shade900),
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text("MEMBRE FERME"),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      body: TabBarView(children: [
                        //CULTURE/ESPECE !!!!!!!!!!
                        SingleChildScrollView(
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
                                              "RENDEMENT CULTURE",
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
                                            TextFormField(
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
                                                if (value.isEmpty) {
                                                  return 'Veuiller entrer une information';
                                                }
                                                return null;
                                              },
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

                                                  print(snap);

                                                  _qteSemence = TextEditingController()..text = snap.isNotEmpty ? snap[0]['quantite_semence'] : "0";

                                                  return Row(
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
                                                  if (_formKey1.currentState.validate()) {
                                                    //verification
                                                    var _tab = await DB.initTabquery();
                                                    String idrendgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                                                    //
                                                    int semence_rendement;
                                                    semence_rendement = int.parse(_quantite_rendement.text);
                                                    int semence_qte;
                                                    semence_qte = int.parse(_qteSemence.text);
                                                    double semence_kg;
                                                    double rendement_kg;
                                                    rendement_kg = semence_rendement * 1/0001;
                                                    semence_kg = semence_qte * 1/1000;
                                                    print("$semence_kg kg");
                                                    print("$rendement_kg kg");
                                                    //
                                                    var det_cult = await DB.queryIdDetCult(snap[0]['id_plantation'],_culture_rendement);
                                                    //print(det_cult);
                                                    //insertion du nom de la tablette
                                                    await DB.insert("rendement", {
                                                      "id_rendement": idrendgen,
                                                      "quantite": _unite_mesure_rendement == "grammes" ? rendement_kg : semence_rendement , // _quantite_rendement.text, //
                                                      "quantite_semence": _unite_mesure_qte_semence == "grammes" ? semence_kg : semence_qte , // _qteSemence.text, //
                                                      "unites": _unite_mesure_qte_semence,
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
                                    ///--------------------------------------------------------------------------------
                                    ///-------------------------FERME---------------------------------------------------
                                    ///---------------------------------------------------------------------------------
                                    //snap[0]["nom_culture"] == "Pisciculture" ?
                                    Column(
                                      children: [
                                        Form(
                                          key: _formKey3,
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
                                                      if (_formKey3.currentState.validate()) {


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
                                    ), //: Container()
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
                                              "RENDEMENT FERME",
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
                                      key: _formKey4,
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
                                                if (value.isEmpty) {
                                                  return 'Veuiller entrer une information';
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
                                                if (value.isEmpty) {
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
                                                  if (_formKey4.currentState.validate()) {
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
                                                        msg: "Rendement enregistrer avec succès ! ",
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
                                    ///-----------------------END--------------------------------------------------------
                                    Divider(),
                                    Container(
                                      //color: Colors.indigo,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: SizedBox(
                                            //height: 50.0,
                                            child: Text(
                                              "AJOUTER UNE CULTURE DANS LA PLANTATION",
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
                                                        //
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
                                                          "quantite_semence": _unite_mesure == "grammes" ? semence_kg : semence, //_quantite_semence.text, //
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
                        ),
                        //Culture
                        _culture,
                        ///------------------------------------------------------------------
                        ///-------------------------------ESPECE------------------------------
                        ///-------------------------------------------------------------------
                        FutureBuilder(
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
                        ),
                        ///-----------------------------------------------------------------------
                        FutureBuilder(
                            future: membreMenagePlantation(),
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
                        ///----------------------------------------------------------------------------------------------
                        ///------------------------------------MEMBRE MENAGE FERME---------------------------------------
                        ///----------------------------------------------------------------------------------------------
                        FutureBuilder(
                            future: membreMenageElevage(),
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
                    )),
              ),
            ],
          );

          return snap.isEmpty ? Center(
            child: Text("Un probleme est survenir lors du chargement des informations !"),
          ) : _Culture;
        }
    );
    //-------------------------------------------------------------------------
    return Container(
      child: _user,
    );
  }
}

///--------------------------------------------------------------------------------------------
//                          FutureBuilder(
//                             future: MmbreGrp(),
//                             builder: (BuildContext context, AsyncSnapshot snapshot) {
//                               List<Map<String, dynamic>> mbreGrp = snapshot.data;
//                               if (snapshot.connectionState == ConnectionState.waiting) {
//                                 return Center(
//                                   child: CircularProgressIndicator(),
//                                 );
//                               }
//                               if (snapshot.hasError) {
//                                 return Center(
//                                   child: Text("Erreur de chargement, Veuillez ressaillez"),
//                                 );
//                               }
//                               return ;
//                             }
//                         ),

