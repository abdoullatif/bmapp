import 'package:bmapp/database/database.dart';
import 'package:bmapp/database/storageUtil.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class Subvention extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: subvention(),
    );
  }
}

class subvention extends StatefulWidget {
  @override
  _subventionState createState() => _subventionState();
}

class _subventionState extends State<subvention> {

  //
  final format = DateFormat("yyyy-MM-dd");

  final _formKey5 = GlobalKey<FormState>();
  //
  var id_personne = StorageUtil.getString("id_personne");

  //Textbox
  TextEditingController nature = TextEditingController();
  TextEditingController _montant_subvention = TextEditingController();
  TextEditingController _type_projet = TextEditingController();
  TextEditingController _duree_projet = TextEditingController();
  TextEditingController _zone = TextEditingController();
  TextEditingController _objectif = TextEditingController();
  TextEditingController _apport_projet = TextEditingController();

  //Bool
  bool formul = false;

  //String
  String service_recu = "";
  String bien_recu = "";
  String subvention_recu = "";
  String id_mb_groupement = "";

  setSelectedSubventionRecu(String val){
    setState(() {
      subvention_recu = val;
    });
  }

  //-----------------------------------------Selecte groupement-----
  Future<void> SelectGroupement() async {
    List<Map<String, dynamic>> queryGroup = await DB.queryAll("groupement");
    return queryGroup;
  }


  @override
  Widget build(BuildContext context) {

    //
    if(subvention_recu == "Non" || subvention_recu == ""){
      formul = false;
    } else {
      formul = true;
    }

    //
    var dateNow = new DateTime.now();
    var dates = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    var date = dates.toString();
    final idpersonne = ModalRoute.of(context).settings.arguments;
    print(idpersonne);

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width /1.5,
        child: SingleChildScrollView(
          child: Column(
            children: [
              //-----------------------------------LES FORMULAIRE DE BIEN ET SERVICES -------------
              Divider(),
              Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      //height: 50.0,
                      child: Text(
                        "SUBVENTION",
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
                key: _formKey5,
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
                                    "Avez-vous recu une subvention ?",
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
                            groupValue: subvention_recu,
                            activeColor: Colors.indigo,
                            onChanged: (value) {
                              print("Radio value is $value");
                              setSelectedSubventionRecu(value);
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
                            groupValue: subvention_recu,
                            activeColor: Colors.indigo,
                            onChanged: (value) {
                              print("Radio value is $value");
                              setSelectedSubventionRecu(value);
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

                      Visibility(
                        visible: formul,
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.number,
                              obscureText: false,
                              controller: _montant_subvention,
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
                              controller: _type_projet,
                              decoration: InputDecoration(
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                //icon: Icon(Icons.show_chart, color: Colors.blue),
                                hintText: "Type de projet",
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
                              controller: _duree_projet,
                              decoration: InputDecoration(
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                //icon: Icon(Icons.show_chart, color: Colors.blue),
                                hintText: "duree du projet",
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
                              controller: _zone,
                              decoration: InputDecoration(
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                //icon: Icon(Icons.show_chart, color: Colors.blue),
                                hintText: "zone",
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
                              controller: _objectif,
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
                              controller: _apport_projet,
                              decoration: InputDecoration(
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                //icon: Icon(Icons.show_chart, color: Colors.blue),
                                hintText: "Apport au projet",
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
                                  if (_formKey5.currentState.validate()) {
                                    //verification
                                    var _tab = await DB.initTabquery();
                                    String idsubgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                                    await DB.insert("subvention", {
                                      "id_subvention": idsubgen,
                                      "id_personne": idpersonne,
                                      "id_agent": id_personne,
                                      "montant": _montant_subvention.text,
                                      "titre_projet": _type_projet.text,
                                      "duree_projet": _duree_projet.text,
                                      "zones": _zone.text,
                                      "objectif": _objectif.text,
                                      "apport_projet": _apport_projet.text,
                                      "flagtransmis": "",
                                    });
                                    setState(() {
                                      _montant_subvention = TextEditingController()..text = '';
                                      _type_projet = TextEditingController()..text = '';
                                      _duree_projet = TextEditingController()..text = '';
                                      _zone = TextEditingController()..text = '';
                                      _objectif = TextEditingController()..text = '';
                                      _apport_projet = TextEditingController()..text = '';
                                    });

                                    Fluttertoast.showToast(
                                        msg: "Subvention enregistré avec succès ! ", //Présence enregistrée,
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
                          ],
                        ),
                      ),
                      SizedBox(height: 25.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

