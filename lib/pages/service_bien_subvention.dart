import 'package:bmapp/pages/Service.dart';
import 'package:bmapp/pages/bien.dart';
import 'package:bmapp/pages/subvention.dart';
import 'package:flutter/material.dart';


class ServiceBienSubvention extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: sbs_pannel(),
    );
  }
}

class sbs_pannel extends StatefulWidget {
  @override
  _sbs_pannelState createState() => _sbs_pannelState();
}

class _sbs_pannelState extends State<sbs_pannel> {

  @override
  Widget build(BuildContext context) {

    final idpersonne = ModalRoute.of(context).settings.arguments;

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  blurRadius: 3,
                  offset: Offset(10, 10),
                ),
              ],
            ),
            child: RaisedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Service()),
                );
              },
              child: Text("Service Recu",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              elevation: 10,
              color: Colors.blueAccent,
              textColor: Colors.white,
              padding: EdgeInsets.all(70.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
          SizedBox(width: 50.0,),
          Container(
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  blurRadius: 3,
                  offset: Offset(10, 10),
                ),
              ],
            ),
            child: RaisedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Bien()),
                );
              },
              child: Text("Bien",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              elevation: 10,
              color: Colors.blueAccent,
              textColor: Colors.white,
              padding: EdgeInsets.all(100.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
          SizedBox(width: 50.0,),
          Container(
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  blurRadius: 3,
                  offset: Offset(10, 10),
                ),
              ],
            ),
            child: RaisedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Subvention(),settings: RouteSettings(arguments: idpersonne,)),
                );
              },
              child: Text("Subvention",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              elevation: 10,
              color: Colors.blueAccent,
              textColor: Colors.white,
              padding: EdgeInsets.all(70.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ],
      ),
    );
  }
}

