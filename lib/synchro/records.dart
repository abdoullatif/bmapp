import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import 'package:mysql1/mysql1.dart';

class Records {
  Database db;
  Context context;
  String localPath;
  String onlinePath;
  String db_name_local;
  String user;
  String password;
  String db_name_online;
  String online_ip;
  String online_link;
  Records(
      String db_name_local,
      String localPath,
      String onlinePath,
      String user,
      String password,
      String db_name_online,
      online_ip,
      online_link) {
    // classe();
    this.localPath = localPath;
    this.onlinePath = onlinePath;
    this.db_name_local = db_name_local;
    this.user = user;
    this.password = password;
    this.db_name_online = db_name_online;
    this.online_ip = online_ip;
    this.online_link = online_link;
  }
  connect() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, this.db_name_local);

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("error database");

      // Make sure the parent directory exists
      // try {
      //  await Directory(dirname(path)).create(recursive: true);
      // } catch (_) {}

      // Copy from asset
      // ByteData data = await rootBundle.load(join("asset", "databasespamdb"));
      // List<int> bytes =
      //  data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      // await File(path).writeAsBytes(bytes, flush: true);
    } else {
      try{
      print("Opening database");
      // String date = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
      //DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss");

// open the database

      db = await openDatabase(path);

      //  DateTime.parse(formattedString)

      // DateTime.parse("1969-07-20 20:18:04");
      //var date = new DateTime.now().toString();

      // var dateParse = DateTime.parse(date);

      //var formattedDate =
      //  "${dateParse.year}-${dateParse.month}-${dateParse.day} ${dateParse.hour}:${dateParse.minute}:${dateParse.second}.${dateParse.millisecond}";

      // var finalDate = formattedDate.toString();

      List<Map> ids = await db.rawQuery('SELECT * FROM parametre');

      // int updateCount = await db.rawUpdate(
      //  'UPDATE `classe` SET  `flagtransmis`=? WHERE id=?', ['', 'lok']);

      final conn = await MySqlConnection.connect(ConnectionSettings(
          host: this.online_ip,
          port: 3407,
          user: this.user,
          password: this.password,
          db: this.db_name_online));

      var counting;

      //personne_adresse
      List<Map> audio = await db.rawQuery('SELECT * FROM fichier_audio');
      //print(personne_adresse);
      counting = 0;

      for (var row in audio) {
        try {
          final dio = Dio();

          dio.options.headers = {
            'Content-Type': 'application/x-www-form-urlencoded'
          };
          // Directory appDocDirectory = await getApplicationDocumentsDirectory();
          final file = await MultipartFile.fromFile(
              this.localPath + row['nom_audio'],
              filename: row['nom_audio']);

          final formData = FormData.fromMap({
            'file': file,
            'online_path': this.onlinePath
          });

          // 'file' - this is an api key, can be different
print("online_path "+this.onlinePath);
          final response = await dio.post(
              // or dio.post
              this.online_link + "upload.php",
              data: formData,
              options: Options(contentType: Headers.formUrlEncodedContentType));
          print("response " + response.data.toString());
          if (response.statusCode == 200) {
            await conn.query(
                'INSERT INTO `fichier_audio`(`id_audio`, `iud`, `nom_audio`, `date_audio`, `flagtransmis`) VALUES (?,?,?,?,?)',
                [
                  row['id'],
                  row['uid'],
                  row['nom_audio'],
                  row['date_audio'],
                  "false"
                ]);

            await db.rawDelete(
                "DELETE FROM `fichier_audio` WHERE id=?", [row['id']]);
            final dir = File(this.localPath + row['nom_audio']);
            dir.deleteSync(recursive: true);
            counting++;
          }
        } catch (err) {
          print('uploading error: $err');
        }
      }

      print('fichier_audio ${counting}');

      await conn.close();
    }catch(e){
    print("error records " +e.toString());
    }finally{
    //Duration temps = new Duration(hours:0, minutes:1, seconds:00);

    Future.delayed(const Duration(seconds: 900),()=> connect());
    }
    }
  }

  synchronize() {
    connect();
  }
}
