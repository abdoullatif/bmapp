import 'package:bmapp/database/database.dart';
import 'package:bmapp/database/storageUtil.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class Service extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: serviceRecu(),
    );
  }
}

class serviceRecu extends StatefulWidget {
  @override
  _serviceRecuState createState() => _serviceRecuState();
}

class _serviceRecuState extends State<serviceRecu> {

  //
  final format = DateFormat("yyyy-MM-dd");
  //

  final _formKey3 = GlobalKey<FormState>();

  //String
  String _type_service = "";

  //
  var id_personne = StorageUtil.getString("id_personne");

  //Textbox
  TextEditingController _nature_service = TextEditingController();
  TextEditingController nature = TextEditingController();
  TextEditingController _nature = TextEditingController();
  //
  TextEditingController _resultat_service = TextEditingController();
  TextEditingController _lieu_service = TextEditingController();
  TextEditingController _objectif_service = TextEditingController();
  TextEditingController _module_service = TextEditingController();
  TextEditingController _nbre_jour_service = TextEditingController();
  //

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
  Widget build(BuildContext context) {

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
                      "SERVICE RECU",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Divider(),
              SizedBox(height: 25.0),
              Form(
                key: _formKey3,
                child: Column(
                  children: <Widget>[
                    //
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
                                  "Avez-vous recu un service :  ",
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
                          groupValue: service_recu,
                          activeColor: Colors.indigo,
                          onChanged: (value) {
                            print("Radio value is $value");
                            setSelectedServiceRecu(value);
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
                                  "OUI",
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
                          groupValue: service_recu,
                          activeColor: Colors.indigo,
                          onChanged: (value) {
                            print("Radio value is $value");
                            setSelectedServiceRecu(value);
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
                      titleText: 'Type de service',
                      hintText: '',
                      value: _type_service,
                      onSaved: (value) {
                        setState(() {
                          _type_service = value;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          _type_service = value;
                        });
                      },
                      dataSource: [
                        {"display": "Formation", "value": "Formation"},
                        {"display": "Accompagnement Technique", "value": "Accompagement Technique"},
                        {"display": "Autres services", "value": "Autres services"}
                      ],
                      textField: 'display',
                      valueField: 'value',
                      validator: (value) {
                        if (_type_service == "") {
                          return 'Veuiller Slectionner';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 25.0),
                    TextFormField(
                      //keyboardType: TextInputType.number,
                      obscureText: false,
                      controller: _nature,
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
                      //keyboardType: TextInputType.number,
                      obscureText: false,
                      controller: _resultat_service,
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        //icon: Icon(Icons.show_chart, color: Colors.blue),
                        hintText: "Resultat",
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
                      controller: _lieu_service,
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        //icon: Icon(Icons.show_chart, color: Colors.blue),
                        hintText: "Lieu",
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
                      controller: _objectif_service,
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        //icon: Icon(Icons.show_chart, color: Colors.blue),
                        hintText: "Objectif",
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
                      controller: _module_service,
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        //icon: Icon(Icons.show_chart, color: Colors.blue),
                        hintText: "Module",
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
                      controller: _nbre_jour_service,
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        //icon: Icon(Icons.show_chart, color: Colors.blue),
                        hintText: "Nombre de jour",
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
                          if (_formKey3.currentState.validate()) {
                            //
                            var _tab = await DB.initTabquery();
                            String idserrecgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                            await DB.insert("services_recus", {
                              "id_service": idserrecgen,
                              "id_personne": id_personne,
                              "id_agent": id_personne,
                              "type_service": _nature_service,
                              "modules": _module_service.text,
                              "nombre_jours": _nbre_jour_service.text,
                              "resultats": _resultat_service.text,
                              "lieux": _lieu_service.text,
                              "objectif": _objectif_service.text,
                              "flagtransmis": "",
                            });
                            setState(() {
                              _type_service = '';
                              _nature_service = TextEditingController()..text = '';
                              _module_service = TextEditingController()..text = '';
                              _nbre_jour_service = TextEditingController()..text = '';
                              _resultat_service = TextEditingController()..text = '';
                              _lieu_service = TextEditingController()..text = '';
                              _objectif_service = TextEditingController()..text = '';
                            });
                            var confirm = await showDialog<String>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Enregistrer"),
                                  content: Text(
                                    'Enregistrement des services recus effecter avec succes ! ', style: TextStyle(color: Colors.red,),),
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
                          //verification bd
                        },
                        child: Text("Enregistrer",
                          textAlign: TextAlign.center,),
                      ),
                    ),
                    SizedBox(height: 25.0),
                  ],
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

