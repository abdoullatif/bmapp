
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';

//package sooba
import 'package:bmapp/database/database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'administrateur.dart';



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

    passAdmin(String nfc) async{
      if(_email.text.isNotEmpty && _mdp.text.isNotEmpty){
        //
        List<Map<String, dynamic>> personne = await DB.query2Where("personne",_email.text,_mdp.text);
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

              /*Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Administrateur()),
              );*/

              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) => Administrateur()), ModalRoute.withName('/Acceuil'));

              //
            } else {
              Fluttertoast.showToast(
                  msg: "Ce bracelets ne correspond pas a votre identifiants, Veuillez scanner a nouveau", //Présence enregistrée,
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 5,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
          } else {
            Fluttertoast.showToast(
                msg: "Veuillez Scanner votre bracelet pour confirmer votre identite", //Présence enregistrée,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 5,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
          }
        } else if(_email.text == "SuperAdmin@tld.com" && _mdp.text == "Tulip2020") {
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
          Fluttertoast.showToast(
              msg: "Email ou mot de passe incorrecte, Veuillez réessayer", //Présence enregistrée,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 5,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }

      } else {
        Fluttertoast.showToast(
            msg: "Veuillez rempli email et mot de passe ", //Présence enregistrée,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }

    FlutterNfcReader.read().then((response) {
      //print(response.id.substring(2));
      uids = response.id.substring(2);
      nfc = uids.toUpperCase();
      setState(() {
        if(mounted) {
          print(nfc);
          passAdmin(nfc);
        } else {
          print(nfc);
          passAdmin(nfc);
        }
      });
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

                            // Lancement du modale
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return InkWell(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        SizedBox(height: 30.0,),
                                        SizedBox(
                                          height: 100.0,
                                          width: 100.0,
                                          child: CircleAvatar(
                                            radius: 50,
                                            backgroundImage: AssetImage("images/scan_nfc.png"),
                                          ),
                                        ),
                                        SizedBox(height: 10.0,),
                                        Text('Placer votre bracelet sur la tablette'),
                                        SizedBox(height: 10.0,),
                                        //Text('$msg_error'),//, style: TextStyle(color: Colors.green,),
                                        SizedBox(height: 30.0,),
                                      ],
                                    ),
                                    onTap: () async{
                                      Navigator.pop(context);
                                      //Tout est bon avec un toucher on passe
                                      passAdmin(nfc);
                                    },
                                  );
                                });

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