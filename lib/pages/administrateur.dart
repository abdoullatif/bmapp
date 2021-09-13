
import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:bmapp/database/storageUtil.dart';
import 'package:bmapp/pages/ForgetUid.dart';
import 'package:bmapp/pages/Pdaig_website.dart';
import 'package:bmapp/pages/groupement.dart';
import 'package:bmapp/pages/langue.dart';
import 'package:bmapp/pages/parametre.dart';
import 'package:bmapp/pages/profile_agent.dart';
import 'package:bmapp/pages/suivit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bmapp/pages/zone.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'enregistrement.dart';


//Page administateur
class Administrateur extends StatefulWidget {
  @override
  _AdministrateurState createState() => _AdministrateurState();
}

class _AdministrateurState extends State<Administrateur> {
  @override
  Widget build(BuildContext context) {
    //
    var images = StorageUtil.getString("images");
    var email = StorageUtil.getString("email");
    var nom = StorageUtil.getString("nom");
    var prenom = StorageUtil.getString("prenom");

    return Scaffold(
      appBar: AppBar(
        title: Text("Administration"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                radius: 80,
                backgroundImage: FileImage(File('/storage/emulated/0/Android/data/com.tulipind.bmapp/files/Pictures/$images')),
              ),
              accountName: Text(nom+" "+prenom),
              accountEmail: Text(email),
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
            /*
            new ListTile(
                leading: Icon(Icons.info),
                title: new Text("A propos"),
                onTap: () {
                  Navigator.pop(context);
                }),*/
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
          //Navigator.popUntil(context, ModalRoute.withName('/login'));
        },
        tooltip: 'Quitter',
        backgroundColor: Colors.transparent,
        child: Image.asset("images/close.png"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}