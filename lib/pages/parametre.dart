import 'package:bmapp/database/database.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ParametreTablette extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        centerTitle: true,
      ),
      body: Parametre(),
    );
  }
}



class Parametre extends StatefulWidget {
  @override
  _ParametreState createState() => _ParametreState();
}

class _ParametreState extends State<Parametre> {
  //variable
  final _formKey = GlobalKey<FormState>();
  //textbox
  TextEditingController _locate = TextEditingController();
  TextEditingController _device = TextEditingController();
  TextEditingController _adresse_server = TextEditingController();
  TextEditingController _ip_server = TextEditingController();
  TextEditingController _site_pdaig = TextEditingController();
  TextEditingController _user = TextEditingController();
  TextEditingController _mdp = TextEditingController();
  TextEditingController _dbname = TextEditingController();
  //-------------------------------------------------------------------------------------
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(left: 100.0, right: 100.0, top: 30, bottom: 30.0,),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Container(
              //color: Colors.indigo,
                margin: EdgeInsets.only(bottom: 30.0),
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 30.0,
                    child: Text("Panneau de configuration", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,),),
                  ),
                )
            ),
            TextFormField(
              obscureText: false,
              controller: _device,
              decoration: InputDecoration(
                icon: Icon(Icons.tablet, color: Colors.blue),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Identifiant de la tablette",
                //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  print(value);
                  return 'Veuiller entrer le nom de la tablette';
                }
                return null;
              },
            ),
            //SizedBox(height: 25.0),
            SizedBox(height: 25.0),
            TextFormField(
              obscureText: false,
              controller: _adresse_server,
              decoration: InputDecoration(
                icon: Icon(Icons.vpn_lock, color: Colors.blue),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Adresse DNS du server",
                //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Veuiller entrer l\'Adresse DNS du server';
                }
                return null;
              },
            ),
            SizedBox(height: 25.0),
            TextFormField(
              obscureText: false,
              controller: _dbname,
              decoration: InputDecoration(
                icon: Icon(Icons.vpn_lock, color: Colors.blue),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Nom de la base de donnee",
                //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Veuiller entrer l\'Adresse DNS du server';
                }
                return null;
              },
            ),
            SizedBox(height: 25.0),
            TextFormField(
              obscureText: false,
              controller: _ip_server,
              decoration: InputDecoration(
                icon: Icon(Icons.settings, color: Colors.blue),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Adresse ip du server",
                //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Veuiller entrer l\'Adresse ip du server';
                }
                return null;
              },
            ),
            SizedBox(height: 25.0),
            TextFormField(
              obscureText: false,
              controller: _site_pdaig,
              decoration: InputDecoration(
                icon: Icon(Icons.web, color: Colors.blue),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Site web officiel du pdaig",
                //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Veuiller le site officiel du pdaig';
                }
                return null;
              },
            ),
            SizedBox(height: 25.0),
            TextFormField(
              obscureText: false,
              controller: _user,
              decoration: InputDecoration(
                icon: Icon(Icons.edit, color: Colors.blue),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Nom utlilisateur server",
                //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Veuiller entrer le Nom utlilisateur server';
                }
                return null;
              },
            ),
            SizedBox(height: 25.0),
            TextFormField(
              obscureText: false,
              controller: _mdp,
              decoration: InputDecoration(
                icon: Icon(Icons.security, color: Colors.blue),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Mot de passe Utilisateur-server",
                //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, width: 1.0)),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Veuiller entrer le Mot de passe Utilisateur-server';
                }
                return null;
              },
            ),
            SizedBox(height: 25.0),
            Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width/2.1,
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Color(0xff01A0C7),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      onPressed: () async{
                        if (true) {
                          //Verification
                          List<Map<String, dynamic>> tab = await DB.queryAll("parametre");
                          if(tab.isNotEmpty){
                            //On modifie les informations present
                            await DB.update("parametre", {
                              "device": _device.text,
                              "locate": "",
                              "dbname": _dbname.text,
                              "mdp": _mdp.text,
                              "adresse_server": _adresse_server.text,
                              "ip_server": _ip_server.text,
                              "site_pdaig": _site_pdaig.text,
                              "user": _user.text,
                            },tab[0]['id']);
                            Scaffold
                                .of(context)
                                .showSnackBar(SnackBar(content: Text('Modification effectuer avec succes !')));
                          } else {
                            // insertion du nom de la tablette
                            await DB.insert("parametre", {
                              "device": _device.text,
                              "locate": "",
                              "adresse_server": _adresse_server.text,
                              "dbname": _dbname.text,
                              "ip_server": _ip_server.text,
                              "site_pdaig": _site_pdaig.text,
                              "user": _user.text,
                              "mdp": _mdp.text,
                              "langue": "Français",
                            });
                            Scaffold
                                .of(context)
                                .showSnackBar(SnackBar(content: Text('Enregistrement effectuer avec succes !')));
                          }
                        }
                      },
                      child: Text("Enregistrer", textAlign: TextAlign.center,),
                    ),
                  ),
                ),
                VerticalDivider(),
                Container(
                  width: MediaQuery.of(context).size.width/3,
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Color(0xff01A0C7),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      onPressed: () async{
                        List<Map<String, dynamic>> tab = await DB.queryAll("parametre");
                        if(tab.isNotEmpty){
                          setState(() {
                            _locate = TextEditingController(text: tab[0]['locate']);
                            _device = TextEditingController(text: tab[0]['device']);
                            _adresse_server = TextEditingController(text: tab[0]['adresse_server']);
                            _dbname = TextEditingController(text: tab[0]['dbname']);
                            _ip_server = TextEditingController(text: tab[0]['ip_server']);
                            _site_pdaig = TextEditingController(text: tab[0]['site_pam']);
                            _user = TextEditingController(text: tab[0]['user']);
                            _mdp = TextEditingController(text: tab[0]['mdp']);
                          });
                        }
                      },
                      child: Text("Voir les info", textAlign: TextAlign.center,),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 35.0),
          ],
        ),
      ),
    );
  }
}
