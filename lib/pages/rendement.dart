import 'package:bmapp/database/database.dart';
import 'package:bmapp/models/donnee_culture.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

class RendementCulture extends StatefulWidget {
  @override
  _RendementCultureState createState() => _RendementCultureState();
}

class _RendementCultureState extends State<RendementCulture> {
  //

  @override
  Widget build(BuildContext context) {

    //String
    final DonneeCulture userInfo = ModalRoute.of(context).settings.arguments;
    print(userInfo.id_culture);
    print(userInfo.id_plantation);

    var dateNow = new DateTime.now();
    //
    var dates = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    var date = dates.toString();

    //Selections des culture de la personne
    Future<List<Map<String, dynamic>>> rendement() async {
      var _campagne = await DB.queryCampagne();
      List<Map<String, dynamic>> queryPerson = await DB.queryRendement(userInfo.id_plantation,userInfo.id_culture);
      return queryPerson;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Rendement'),
      ),
      body: FutureBuilder(
          future: rendement(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            List<Map<String, dynamic>> rendement = snapshot.data;
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
            int n = rendement.length;
            final items = List<String>.generate(n, (i) => "Item $i");
            return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.only(top: 25.0,),
                    elevation: 2.0,
                    child: ListTile(
                      title: Text('Quantite: ${rendement[index]["quantite"]} Kg'),
                      subtitle: Text('Date de rendement: ${rendement[index]["date_rendement"]} \nQuantite de semence: ${rendement[index]["quantite_semence"]} Kg'),
                    ),
                  );
                }
            );
          }
      ),
    );
  }
}
