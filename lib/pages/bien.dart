import 'package:bmapp/database/database.dart';
import 'package:bmapp/database/storageUtil.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  final _formKey4 = GlobalKey<FormState>();


  //String
  String _culture_rendement = "";
  String _add_culture = "";
  String _type_service = "";
  String _type_bien = "";
  String _type_elv = "";

  //
  var id_personne = StorageUtil.getString("id_personne");

  //Textbox

  TextEditingController _nature_bien = TextEditingController();

  TextEditingController nature = TextEditingController();
  TextEditingController _qte_bien = TextEditingController();

  //
  TextEditingController _montant_bien = TextEditingController();
  TextEditingController _utilisation_bien = TextEditingController();


  //Bool
  bool formul = false;

  //String
  String service_recu = "";
  String bien_recu = "";
  String subvention_recu = "";
  String id_mb_groupement = "";


  setSelectedBienRecu(String val){
    setState(() {
      bien_recu = val;
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
    if(bien_recu == "Non" || bien_recu == ""){
      formul = false;
    } else {
      formul = true;
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

                      Visibility(
                        visible: formul,
                        child: Column(
                          children: [
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

                                    Fluttertoast.showToast(
                                        msg: "Enregistrement des biens effectué avec succès ! ", //Présence enregistrée,
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
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}

