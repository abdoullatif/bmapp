import 'dart:io';

import 'package:bmapp/database/database.dart';
import 'package:bmapp/database/storageUtil.dart';
import 'package:bmapp/models/donnee_route.dart';
import 'package:bmapp/pages/User.dart';
import 'package:flutter/material.dart';

class SearchUI extends SearchDelegate<String> {

  var idtypefonction = StorageUtil.getString("idtypefonction");

  Future<List> _operation(String input) async{
    List<Map<String, dynamic>> tab = await DB.queryAll("parametre");
    var _locate = await DB.queryWherelocate("localite",tab[0]["locate"]);
    List<Map<String, dynamic>> queryRows = await DB.querySearch(_locate[0]["id_localite"].toString(),input);
    return queryRows;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context,null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Column(
      children: [
        Text('just a test!'),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    String data = query;
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<List>(
              stream: Stream.fromFuture(_operation(data)),
              builder: (context, snap){
                if(snap.hasData) {
                  List currentItems = snap.data;
                  switch (snap.connectionState) {
                    case ConnectionState.waiting:
                      return Container();
                    default:
                      if (snap.hasError) {
                        return Text('Une erreur c\'est produite');
                      } else {
                        return CustomScrollView(
                          shrinkWrap: true,
                          slivers: [
                            SliverList(
                                delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                    return Card(
                                      margin: EdgeInsets.only(top: 25.0,),
                                      elevation: 2.0,
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          foregroundColor: Colors.transparent,
                                          backgroundImage: FileImage(File('/storage/emulated/0/Android/data/com.tulipind.bmapp/files/Pictures/${currentItems[index]["images"]}')),
                                          //backgroundImage: Image.file(file),
                                        ),
                                        title: Text('${currentItems[index]["nom_personne"]} ${currentItems[index]["prenom_personne"]}'),
                                        subtitle: Text('${currentItems[index]["nom_fonction"]}'),
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => UserPannel(),settings: RouteSettings(arguments: DonneeRoute(
                                              '${currentItems[index]['id_personne']}', '${currentItems[index]['nom_fonction']}'
                                          ))),);
                                        },
                                      ),
                                    );
                                  },
                                  childCount: currentItems.length ?? 0,
                                )
                            )
                          ],
                        );
                      }
                  }
                }
                else if(query == ""){
                  return Column();
                }
                return Container();
              }
          )
        ],
      ),
    );
  }
}