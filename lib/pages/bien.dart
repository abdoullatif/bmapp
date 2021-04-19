import 'package:bmapp/database/database.dart';
import 'package:bmapp/database/storageUtil.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class Bien extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: bien(),
    );
  }
}

class bien extends StatefulWidget {
  @override
  _bienState createState() => _bienState();
}

class _bienState extends State<bien> {

  //
  final format = DateFormat("yyyy-MM-dd");
  //
  final _formKey = GlobalKey<FormState>();

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  final _formKey4 = GlobalKey<FormState>();
  final _formKey5 = GlobalKey<FormState>();
  final _formKey6 = GlobalKey<FormState>();
  final _formKey7 = GlobalKey<FormState>();
  //
  final _formKey8 = GlobalKey<FormState>();
  final _formKey9 = GlobalKey<FormState>();
  final _formKey10 = GlobalKey<FormState>();

  //String
  String _culture_rendement = "";
  String _add_culture = "";
  String _type_service = "";
  String _type_bien = "";
  String _type_elv = "";

  //
  var id_personne = StorageUtil.getString("id_personne");

  //Textbox
  TextEditingController _autre_culture = TextEditingController();
  TextEditingController _quantite = TextEditingController();
  TextEditingController _date_rendement = TextEditingController();
  TextEditingController _nbre = TextEditingController();
  TextEditingController _nature_bien = TextEditingController();
  TextEditingController _nature_service = TextEditingController();
  TextEditingController nature = TextEditingController();
  TextEditingController _qte_bien = TextEditingController();
  TextEditingController _nature = TextEditingController();
  TextEditingController _montant_subvention = TextEditingController();
  TextEditingController _type_projet = TextEditingController();
  TextEditingController _duree_projet = TextEditingController();
  TextEditingController _zone = TextEditingController();
  TextEditingController _objectif = TextEditingController();
  TextEditingController _apport_projet = TextEditingController();
  //
  TextEditingController _resultat_service = TextEditingController();
  TextEditingController _quantite_semence = TextEditingController();
  TextEditingController _quantite_rendement = TextEditingController();
  TextEditingController _lieu_service = TextEditingController();
  TextEditingController _objectif_service = TextEditingController();
  TextEditingController _module_service = TextEditingController();
  TextEditingController _nbre_jour_service = TextEditingController();
  //
  TextEditingController _montant_bien = TextEditingController();
  TextEditingController _utilisation_bien = TextEditingController();
  TextEditingController _poids = TextEditingController();
  //
  TextEditingController _nom_espece = TextEditingController();
  //
  TextEditingController _qteSemence = TextEditingController();

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
  //----------------------SELECTION PALANTATION---------------------------------
  //----------------------------------------------------------------------------
  /*
  Future<List<addgroupModel>> getData(filter) async {
    List<Map<String, dynamic>> queryRows = await DB.queryAll("groupement");
    var models = addgroupModel.fromJsonList(queryRows);
    return models;
  }
  */

  @override
  Widget build(BuildContext context) {


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
    final idpersonne = ModalRoute.of(context).settings.arguments;


    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width /1.5,
        child: SingleChildScrollView(
          child: Column(
            children: [
              //-----------------------------------LES FORMULAIRE DE BIEN ET SERVICES -------------
              Divider(),
              Container(
                //color: Colors.indigo,
                //margin: EdgeInsets.only(bottom: 30.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      //height: 50.0,
                      child: Text(
                        "BIEN",
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
              Form(
                key: _formKey4,
                child: SingleChildScrollView(
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
                                    "Avez-vous recu un bien :  ",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          Radio(
                            value: "Oui",
                            groupValue: bien_recu,
                            activeColor: Colors.indigo,
                            onChanged: (value) {
                              print("Radio value is $value");
                              setSelectedBienRecu(value);
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
                                    "Oui",
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
                            value: "Non",
                            groupValue: bien_recu,
                            activeColor: Colors.indigo,
                            onChanged: (value) {
                              print("Radio value is $value");
                              setSelectedBienRecu(value);
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
                                    "Non",
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
                      DropDownFormField(
                        titleText: 'Type de bien',
                        hintText: '',
                        value: _type_bien,
                        onSaved: (value) {
                          setState(() {
                            _type_bien = value;
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            _type_bien = value;
                          });
                        },
                        dataSource: [
                          {"display": "Equipement", "value": "Equipement"},
                          {"display": "Outillage", "value": "Outillage"},
                          {"display": "Materiel", "value": "Materiel"},
                          {"display": "Intrant", "value": "Intrant"}
                        ],
                        textField: 'display',
                        valueField: 'value',
                        validator: (value) {
                          if (_type_bien == "") {
                            return 'Veuiller Slectionner une localite';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 25.0),
                      TextFormField(
                        //keyboardType: TextInputType.number,
                        obscureText: false,
                        controller: _nature_bien,
                        decoration: InputDecoration(
                          //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          //icon: Icon(Icons.show_chart, color: Colors.blue),
                          hintText: "Nature",
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
                      TextFormField(
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        controller: _qte_bien,
                        decoration: InputDecoration(
                          //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          //icon: Icon(Icons.show_chart, color: Colors.blue),
                          hintText: "Quantite",
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
                      TextFormField(
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        controller: _montant_bien,
                        decoration: InputDecoration(
                          //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          //icon: Icon(Icons.show_chart, color: Colors.blue),
                          hintText: "Montant",
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
                      TextFormField(
                        //keyboardType: TextInputType.number,
                        obscureText: false,
                        controller: _utilisation_bien,
                        decoration: InputDecoration(
                          //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          //icon: Icon(Icons.show_chart, color: Colors.blue),
                          hintText: "Utilisation",
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
                              //
                              //verification
                              var _tab = await DB.initTabquery();
                              String idbiengen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                              await DB.insert("biens", {
                                "id_type_bien": idbiengen,
                                "id_personne": idpersonne,
                                "id_agent": id_personne,
                                "type_bien": _type_bien,
                                "nature": _nature_bien.text,
                                "quantite": _qte_bien.text,
                                "montant": _montant_bien.text,
                                "utilisations": _utilisation_bien.text,
                                "flagtransmis": "",
                              });
                              setState(() {
                                bien_recu = '';
                                _nature_bien = TextEditingController()..text = '';
                                _qte_bien = TextEditingController()..text = '';
                                _montant_bien = TextEditingController()..text = '';
                                _utilisation_bien = TextEditingController()..text = '';
                              });
                              var confirm = await showDialog<String>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Enregistrer"),
                                    content: Text(
                                      'Enregistrement des biens effectuer avec succes ! ! ', style: TextStyle(color: Colors.red,),),
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
                              Scaffold
                                  .of(context)
                                  .showSnackBar(SnackBar(content: Text('')));
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
          ),
        ),
      ),
    );
  }
}

