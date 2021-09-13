
import 'package:bmapp/database/database.dart';
import 'package:bmapp/database/storageUtil.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter/material.dart';

class changePassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: passwordPannel(),
    );
  }
}

class passwordPannel extends StatefulWidget {
  @override
  _passwordPannelState createState() => _passwordPannelState();
}

class _passwordPannelState extends State<passwordPannel> {
  @override
  Widget build(BuildContext context) {
    //asynchrone
    var idpersonne = StorageUtil.getString("id_personne");
    var mdp = StorageUtil.getString("mdp");
    //print(idpersonne);
    //print(mdp);
    //
    var dates = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    var date = dates.toString();
    //
    final _formKey4 = GlobalKey<FormState>();
    TextEditingController _oldPassword = TextEditingController();
    TextEditingController _newPassword = TextEditingController();
    TextEditingController _confirmNewPassword = TextEditingController();

    //String id = ModalRoute.of(context).settings.arguments;

    //
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        child: Form(
          key: _formKey4,
          child: SingleChildScrollView(
            child: Column(
              children: [
                //SizedBox(height: 100.0),
                Container(
                  //color: Colors.indigo,
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        //height: 50.0,
                        child: Text(
                          "Modifier Mon password",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                ),
                SizedBox(height: 25.0),
                TextFormField(
                  obscureText: true,
                  controller: _oldPassword,
                  decoration: InputDecoration(
                    //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    //icon: Icon(Icons.photo_size_select_small, color: Colors.blue),
                    hintText: "Ancien mot de passe ",
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
                  obscureText: true,
                  controller: _newPassword,
                  decoration: InputDecoration(
                    //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    //icon: Icon(Icons.photo_size_select_small, color: Colors.blue),
                    hintText: "Nouveau mot de passe ",
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
                  obscureText: true,
                  controller: _confirmNewPassword,
                  decoration: InputDecoration(
                    //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    //icon: Icon(Icons.photo_size_select_small, color: Colors.blue),
                    hintText: "Comfirmer le nouveau mot de passe ",
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

                        if(_oldPassword.text == mdp){
                          if(_newPassword.text == _confirmNewPassword.text ){
                            //insertion du nom de la tablette
                            await DB.updatePersonne("personne", {
                              "mdp": _newPassword.text,
                              "flagtransmis": "",
                            },idpersonne);
                            setState(() {
                              _oldPassword = TextEditingController()..text = '';
                              _newPassword = TextEditingController()..text = '';
                              _confirmNewPassword = TextEditingController()..text = '';
                            });
                            Scaffold
                                .of(context)
                                .showSnackBar(SnackBar(content: Text('Modification du mot de passe effectué avec succes !')));
                          } else {
                            Scaffold
                                .of(context)
                                .showSnackBar(SnackBar(content: Text('Comfirmation du mot de passe incorrete !')));
                          }
                        } else {
                          Scaffold
                              .of(context)
                              .showSnackBar(SnackBar(content: Text('Ancien mot de passe incorrecte !')));
                        }

                      }
                    },
                    child: Text("Modifier",
                      textAlign: TextAlign.center,),
                  ),
                ),
                SizedBox(height: 25.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}