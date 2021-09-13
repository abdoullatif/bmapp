

import 'dart:io';

import 'package:bmapp/database/storageUtil.dart';
import 'package:flutter/material.dart';

import 'changePassword.dart';

class ProfileAgent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mon profile"),
      ),
      body: ProfileA(),
    );
  }
}

class ProfileA extends StatefulWidget {
  @override
  _ProfileAState createState() => _ProfileAState();
}

class _ProfileAState extends State<ProfileA> {
  @override
  Widget build(BuildContext context) {

    var idpersonne = '';
    var nom = '';
    var prenom = '';
    var tel = '';
    var genre = '';
    var age = '';
    var uids = '';
    var email = '';
    var mdp = '';
    var images = '';
    var fonction = '';
    var localite = '';

    //asynchrone
    idpersonne = StorageUtil.getString("id_personne");
    nom = StorageUtil.getString("nom");
    prenom = StorageUtil.getString("prenom");
    tel = StorageUtil.getString("tel");
    genre = StorageUtil.getString("genre");
    age = StorageUtil.getString("age");
    uids = StorageUtil.getString("uids");
    email = StorageUtil.getString("email");
    mdp = StorageUtil.getString("mdp");
    images = StorageUtil.getString("images");
    localite = StorageUtil.getString("localite");
    fonction = StorageUtil.getString("fonction") == "AD" ? "Agent" : StorageUtil.getString("fonction");

    return Center(
      child: Container(
        padding: EdgeInsets.all(20.0),
        width: MediaQuery.of(context).size.width/3,
        child: Card(
          elevation: 10.0,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                //widget
                Container(
                  padding: EdgeInsets.all(10),
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: FileImage(File('/storage/emulated/0/Android/data/com.tulipind.bmapp/files/Pictures/$images')),
                  ),
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
                          "$nom $prenom",
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
                          "Localite: $localite",
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
                          "telephone: $tel",
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
                          "Sexe: $genre",
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
                          "Age: $age",
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
                          "fonction: $fonction",
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
                          "Email: $email",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                ),
                Divider(),
                FlatButton(
                  child: Text("Modifier mon mot de passe"),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => changePassword()),);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

