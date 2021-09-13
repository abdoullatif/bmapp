//
import 'dart:io';
import 'package:bmapp/database/database.dart';
import 'package:bmapp/models/chef_groupement.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';



class Addgroupement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Groupement"),
      ),
      body: add_groupement(),
    );
  }
}

class add_groupement extends StatefulWidget {
  @override
  _add_groupementState createState() => _add_groupementState();
}

class _add_groupementState extends State<add_groupement> {

  //var form
  final _formKey = GlobalKey<FormState>();

  //var
  String _localite = "";
  String chefgroup = "";
  String _unions = "";

  //Liste groupement
  List queryPersongroupmnt;
  List queryPersongroupmntSaved;
  bool exist=false;

  //textediting
  TextEditingController _activite_groupement = TextEditingController();
  TextEditingController _nom_groupement = TextEditingController();

  //Membre Groupement
  Future<List<Map<String, dynamic>>> Membregroupement(String id_groupement) async {
    List<Map<String, dynamic>> queryPerson = await DB.queryMbreGrpmt(id_groupement);
    return queryPerson;
  }

  Future<List<Map<String, dynamic>>> groupement() async {
       if(!exist) {
         queryPersongroupmnt = await DB.querygroupinfo();
         queryPersongroupmntSaved = queryPersongroupmnt;
         exist = true;
       }
    return queryPersongroupmnt;
  }

  @override
   initState()   {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    /*
    //localite
    Future<void> SelectLocalite() async {
      List<Map<String, dynamic>> queryLocalite = await DB.queryAll("localite");
      return queryLocalite;
    }
    final _Localites = FutureBuilder(
        future: SelectLocalite(),
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
            titleText: 'Localite',
            hintText: 'zone',
            value: _localite,
            onSaved: (value) {
              setState(() {
                _localite = value;
              });
            },
            onChanged: (value) {
              setState(() {
                _localite = value;
              });
            },
            dataSource: snap,
            textField: 'descriptions',
            valueField: 'id_localite',
            validator: (value) {
              if (_localite == "") {
                return 'Veuiller Slectionner une localite';
              }
              return null;
            },
          );
        }
    );
    */

    //Unions
    Future<void> SelectUnions() async {
      List<Map<String, dynamic>> queryUnions = await DB.queryAll("unions");
      //queryUnions += [{"description_un": "union agricole", "id_un": "23"}];
      return queryUnions;
    }
    final _Unions = FutureBuilder(
        future: SelectUnions(),
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
            titleText: 'Unions',
            hintText: '',
            value: _unions,
            onSaved: (value) {
              setState(() {
                _unions = value;
              });
            },
            onChanged: (value) {
              setState(() {
                _unions = value;
              });
            },
            dataSource: snap,
            textField: 'description_un',
            valueField: 'id_un',
            validator: (value) {
              if (_unions == "") {
                return 'Veuiller Slectionner une localite';
              }
              return null;
            },
          );
        }
    );

    //
    final _groupement = FutureBuilder(
        future: groupement(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List<Map<String, dynamic>> info_groupmnt = snapshot.data;
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
          int n = info_groupmnt.length;
          final items = List<String>.generate(n, (i) => "Item $i");
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return RaisedButton(
                        elevation: 0,
                        padding: EdgeInsets.all(0.0),
                        color: Colors.transparent,
                        disabledColor: Colors.transparent,
                        onPressed: () async{
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    //height: 50.0,
                                    child: Text(
                                      "MEMBRE",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                content: setupAlertDialoadContainer(context,info_groupmnt[index]["id_groupement"]),
                              );

                            },
                          );
                        },
                        child: Card(
                          margin: EdgeInsets.only(top: 25.0,),
                          elevation: 2.0,
                          child: ListTile(
                            title: Text('Nom du groupememt : ${info_groupmnt[index]["nom_groupement"]} \nActivites: ${info_groupmnt[index]["activite_groupement"]} \nUnion: ${info_groupmnt[index]["description_un"]}'
                                '\nPresident : ${info_groupmnt[index]['nom_personne']}  ${info_groupmnt[index]['prenom_personne']}',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),),
                          ),
                        ),
                      );
                    }
                ),
              ),
            ],
          );
        }
    );
    //-------------------------Chef de groupement --------------------------------
    //----------------------------------------------------------------------------
    Future<List<chefgroupModel>> getData(filter) async {

      List<Map<String, dynamic>> queryRows;
      var models;

      if(filter != "" || filter != null) {
        queryRows = await DB.querychefgroupfilter(filter);
      } else {
        queryRows = await DB.querychefgroup();
      }

      models = chefgroupModel.fromJsonList(queryRows);
      return models;
    }
    final _chef = FindDropdown<chefgroupModel>(
      label: "",
      onFind: (String filter) => getData(filter),
      onChanged: (chefgroupModel data) {
        print(data.id);
        chefgroup = data.id;
      },
      dropdownBuilder: (BuildContext context, chefgroupModel item) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: (item?.avatar == null)
              ? ListTile(
            leading: CircleAvatar(),
            title: Text("Aucun chef selectionner"),
          )
              : ListTile(
            leading: CircleAvatar(
              backgroundImage: FileImage(File("/storage/emulated/0/Android/data/com.tulipind.bmapp/files/Pictures/${item.avatar}")),
            ),
            title: Text(item.name),
            //subtitle: Text(item.createdAt.toString()),
          ),
        );
      },
      dropdownItemBuilder:
          (BuildContext context, chefgroupModel item, bool isSelected) {
        return Container(
          decoration: !isSelected
              ? null
              : BoxDecoration(
            border:
            Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: ListTile(
            selected: isSelected,
            title: Text(item.name),
            subtitle: Text(item.prenom),
            leading: CircleAvatar(
              backgroundImage: FileImage(File("/storage/emulated/0/Android/data/com.tulipind.bmapp/files/Pictures/${item.avatar}")),
            ),
          ),
        );
      },
    );

    //
    return Container(
      child: Center(
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 50.0, right: 50.0),
              width: MediaQuery.of(context).size.width / 2,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        //color: Colors.indigo,
                          margin: EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              //height: 50.0,
                              child: Text(
                                "Enregistrer un nouveau groupement",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                      //formulaire d'enregistrement de groupement
                      TextFormField(
                        //keyboardType: TextInputType.number,
                        obscureText: false,
                        controller: _nom_groupement,
                        decoration: InputDecoration(
                          //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          //icon: Icon(Icons.photo_size_select_small, color: Colors.blue),
                          hintText: "nom du groupement",
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
                      //_Localites,
                      //SizedBox(height: 25.0),
                      TextFormField(
                        //keyboardType: TextInputType.number,
                        obscureText: false,
                        controller: _activite_groupement,
                        decoration: InputDecoration(
                          //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          //icon: Icon(Icons.photo_size_select_small, color: Colors.blue),
                          hintText: "Activites",
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
                      _Unions,
                      SizedBox(height: 25.0),
                      _chef,
                      SizedBox(height: 25.0),
                      Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color(0xff01A0C7),
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          onPressed: () async{
                            if (_formKey.currentState.validate()) {
                              //Verification
                              List<Map<String, dynamic>> _tab = await DB.queryAll("parametre");
                              if(_tab.isNotEmpty){
                                var _locate = await DB.queryWherelocate("localite",_tab[0]["locate"]);
                                if (_locate.isNotEmpty) {
                                  //Verification groupement
                                  List<Map<String, dynamic>> _ifexiste = await DB.queryverifgroup(chefgroup);
                                  //id genere
                                  String idgroupgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
                                  String idmbgroupgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);

                                  print(_ifexiste);
                                  if(_ifexiste.isEmpty){
                                    // insertion du nom de la tablette
                                    await DB.insert("groupement", {
                                      "id_groupement": idgroupgen,
                                      "nom_groupement": _nom_groupement.text,
                                      "id_localite": _locate[0]["id_localite"],
                                      "activite_groupement": _activite_groupement.text,
                                      "id_union": _unions,
                                      "flagtransmis": "",
                                    });
                                    await DB.insert("membre_groupement", {
                                      "id_mb_groupement": idmbgroupgen,
                                      "id_personne": chefgroup,
                                      "id_groupement": idgroupgen,
                                      "statu": "Chef",
                                      "flagtransmis": "",
                                    });
                                    setState(() {
                                      //
                                      _nom_groupement = TextEditingController(text: "");
                                      _activite_groupement = TextEditingController(text: "");
                                      _unions = "";
                                      //
                                      _localite = "";
                                      chefgroup = "";
                                      //
                                      exist = false;
                                    });

                                    Fluttertoast.showToast(
                                        msg: "Enregistrement du groupement effectué avec succès !", //Présence enregistrée,
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 5,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Vous avez déjà adhere a un groupement !", //Présence enregistrée,
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
                                      msg: "Veuiller selectionner une localite !", //Présence enregistrée,
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
                                    msg: "La tablette n\'a pas d\'identifiant !", //Présence enregistrée,
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
                          child: Text("Enregistrer", textAlign: TextAlign.center,),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
            VerticalDivider(),
            Container(
              width: MediaQuery.of(context).size.width / 2.5,
              child: Column(
                children: [
                  SizedBox(height: 15.0),
                  Container(
                    //color: Colors.indigo,
                      //margin: EdgeInsets.only(bottom: 5.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          //height: 20.0,
                          child: Text(
                            "GROUPEMENT",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                  ),
                  SizedBox(height: 15.0),
                  TextField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search)
                    ),
                    onChanged: (text){
                      setState(() {
                        text = text.toLowerCase();
                        queryPersongroupmnt =  queryPersongroupmntSaved;
                        queryPersongroupmnt = queryPersongroupmnt.where((element) {
                          var nom_groupement = element["nom_groupement"].toLowerCase();
                          var activity = element["activite_groupement"].toLowerCase();
                          var union = element["description_un"].toLowerCase();
                          var president_nom = element["nom_personne"].toLowerCase();
                          var president_prenom = element["prenom_personne"].toLowerCase();
                          return nom_groupement.contains(text)||activity.contains(text) ||union.contains(text) ||president_nom.contains(text) ||president_prenom.contains(text)   ;
                        }).toList();
                      });

                    },
                  ),
                  SizedBox(height: 5.0),
                  Expanded(
                    child: _groupement,
                  ),
                  SizedBox(height: 25.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget setupAlertDialoadContainer(context, String id_groupmnt) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: Colors.white,
          height: 400.0, // Change as per your requirement
          width: 300.0, // Change as per your requirement
          child: FutureBuilder(
            future: Membregroupement(id_groupmnt),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              List<Map<String, dynamic>> info_mb_groupmnt = snapshot.data;
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text("Erreur de chargement, Veuillez ressaiyez"),
                );
              }
              int nb = info_mb_groupmnt.length;
              final itemsM = List<String>.generate(nb, (i) => "Item $i");
              return Container(
                height: 300.0, // Change as per your requirement
                width: 300.0, // Change as per your requirement
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: itemsM.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 5.0,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.transparent,
                          backgroundImage: FileImage(File('/storage/emulated/0/Android/data/com.tulipind.bmapp/files/Pictures/${info_mb_groupmnt[index]['images']}')),
                          //backgroundImage: Image.file(file),
                        ),
                        title: Text('${info_mb_groupmnt[index]['nom_personne']} ${info_mb_groupmnt[index]['prenom_personne']}'),
                        subtitle: info_mb_groupmnt[index]['statu'] == "Chef" ? Text('President(e)') : Text('Membre'),
                        trailing: info_mb_groupmnt[index]['statu'] == "Chef" ? Icon(Icons.account_tree) : null,
                      ),
                    );
                  },
                ),
              );

            },
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: FlatButton(

            onPressed: (){
              Navigator.pop(context);
            },child: Text("Quitter"),),
        )
      ],
    );
  }

}

/*
  SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      //color: Colors.indigo,
                        margin: EdgeInsets.only(bottom: 30.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            //height: 50.0,
                            child: Text(
                              "Liste des groupements",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                    ),
                  ],
                ),
              ),
 */