import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import 'package:mysql1/mysql1.dart';

class Videos {
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
  Videos(String db_name_local, String localPath, String onlinePath, String user,
      String password, String db_name_online, online_ip, online_link) {
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
      // await Directory(dirname(path)).create(recursive: true);
      // } catch (_) {}

      // Copy from asset
      //  ByteData data = await rootBundle.load(join("asset", "databasespamdb"));
      // List<int> bytes =
      //  data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      // await File(path).writeAsBytes(bytes, flush: true);
    } else {
      try{
      print("Opening database");
      var date = new DateTime.now().toString();
      print(date);

// open the database

      db = await openDatabase(path);
      // var date = new DateTime.now().toString();

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

      //categories
      var counting;


      var get_categories_rows =
          await conn.query('SELECT * FROM  categories ', []);

      //var codification_update_time = "";
      //print("flagtransmis" + categories_update_time);
      counting = 0;
      for (var row in get_categories_rows) {
           try {
           //  print("new" + row['flagtransmis']);
             var id = row['id'];
             int exiting = Sqflite.firstIntValue(await db
                 .rawQuery(
                 'SELECT COUNT(*) FROM categories  where id=?', [id]));
             if (exiting != 0) {
               //update

               List<Map> categories_update = await db.rawQuery(
                   'SELECT * FROM categories   where id=?', [id]);
               var categories_update_time;
               if (categories_update.length == 0)
                 categories_update_time = "";
               else
                 categories_update_time =
                 categories_update.first['flagtransmis'];
           //    print(categories_update_time);
               if ((categories_update_time).toString().compareTo(
                   row['flagtransmis']) <
                   0) {
                 print("update");
                 counting++;
                 await db.rawUpdate(
                     'UPDATE `categories` SET `nom_categ`=?,`flagtransmis`=? WHERE id=?',
                     [row['nom_categ'], row['flagtransmis'], row['id']]);
               }
             } else {
               //insert
               print("insert");
               counting++;
               await db.rawQuery(
                   'INSERT INTO `categories`(`id`, `nom_categ`,flagtransmis) VALUES (?,?,?)',
                   [row['id'], row['nom_categ'], row['flagtransmis']]);
             }
           }catch(e){
             print('error categrie row '+e.toString());
           }
      }
      //await db.rawQuery('DELETE FROM `categories` WHERE 1', []);
      //List<Map> scategories = await db.rawQuery('SELECT * FROM categories');
      //print(scategories);

      print('categories ${counting}');
      //end categories

      //media

      List<Map> media_update = await db.rawQuery(
          'SELECT * FROM media  ORDER BY flagtransmis DESC LIMIT 1', null);

      var get_media_rows = await conn.query('SELECT * FROM  media ', []);
      var media_update_time;
      if (media_update.length == 0)
        media_update_time = "";
      else
        media_update_time = media_update.first['flagtransmis'];
      //var codification_update_time = "";
      //print("flagtransmis" + media_update_time);
      counting = 0;
      for (var row in get_media_rows) {
         try{
            var id = row['id'];
            int exiting = Sqflite.firstIntValue(await db
                .rawQuery('SELECT COUNT(*) FROM media  where id=?', [id]));
            if (exiting != 0) {
              //update


              if ((media_update_time).toString().compareTo(row['flagtransmis']) < 0) {
                print('download vidoes update'+row['media_file'].toString());
                // print(row['flagtransmis']);
                var fileName;
                if (row['media_file'].toString().startsWith("\\"))
                  fileName = row['media_file']
                      .toString()
                      .replaceFirst(new RegExp(r'\\'), '');
                else
                  fileName = row['media_file'];
                Response response = await Dio().download(
                    this.online_link + this.onlinePath + fileName,
                    this.localPath + fileName);
                print("response" + response.statusCode.toString());
                if (response.statusCode == 200) {
                  counting++;
                  print("new" + row['flagtransmis']);
                  await db.rawUpdate(

                      'UPDATE `media` SET media_title =?, `media_lang`=?, `media_categorie`=?, media_sous_categorie=?,  `media_file`=?, `flagtransmis`=? WHERE id=?',
                      [
                        row['media_title'],
                        row['media_lang'],
                        row['media_categorie'],
                        row['media_sous_categorie'],
                        fileName.toString(),
                        row['flagtransmis'],
                        row['id']
                      ]);
                }
              }
            } else {
              //insert
               print('download vidoes'+row['media_file'].toString());
                // print(row['flagtransmis']);
                var fileName;
                if (row['media_file'].toString().startsWith("\\"))
                  fileName = row['media_file']
                      .toString()
                      .replaceFirst(new RegExp(r'\\'), '');
                else
                  fileName = row['media_file'];
                Response response = await Dio().download(
                    this.online_link + this.onlinePath + fileName,
                    this.localPath + fileName);
                print("response" + response.statusCode.toString());
                if (response.statusCode == 200) {
                  counting++;
                  print("new" + row['flagtransmis']);
                  await db.rawQuery(
                      'INSERT INTO `media`(`id`, `media_title`, `media_lang`, `media_categorie`, media_sous_categorie , `media_file`,`flagtransmis`) VALUES (?,?,?,?,?,?,?)',
                      [
                        row['id'],
                        row['media_title'],
                        row['media_lang'],
                        row['media_categorie'],
                        row['media_sous_categorie'],
                        fileName.toString(),
                        row['flagtransmis']
                      ]);
                }
              }

         }catch(e){
           print('error media row '+e.toString());
         }
      }
      // await db.rawQuery('DELETE FROM `media` WHERE 1', []);
      //List<Map> smedia = await db.rawQuery('SELECT * FROM media');
      //print(smedia);

      print('media ${counting}');
      //end media

      //sous_categorie
    /*
      List<Map> sous_categorie_update = await db.rawQuery(
          'SELECT * FROM sous_categories  ORDER BY flagtransmis DESC LIMIT 1',
          null);

      var get_sous_categorie_rows =
          await conn.query('SELECT * FROM  sous_categorie ', []);
      var sous_categorie_update_time;
      if (sous_categorie_update.length == 0)
        sous_categorie_update_time = "";
      else
        sous_categorie_update_time =
            sous_categorie_update.first['flagtransmis'];
      //var codification_update_time = "";
      // print("flagtransmis sous" + sous_categorie_update_time);
      counting = 0;
      for (var row in get_sous_categorie_rows) {
        if ((sous_categorie_update_time)
                .toString()
                .compareTo(row['flagtransmis']) <
            0) {
          counting++;
          // print("new" + row['flagtransmis']);
          var id = row['id'];
          int exiting = Sqflite.firstIntValue(await db.rawQuery(
              'SELECT COUNT(*) FROM sous_categories  where id=?', [id]));
          if (exiting != 0) {
            //update
            await db.rawUpdate(
                'UPDATE `sous_categories` SET id_categorie=?,`nom_scateg`=?,`photo_scateg`=?,`flagtransmis`=? WHERE id=?',
                [
                  row['id_categorie'],
                  row['nom_scateg'],
                  row['photo_scateg'],
                  row['flagtransmis'],
                  row['id']
                ]);
          } else {
            //insert
            await db.rawQuery(
                'INSERT INTO `sous_categories`(`id`, `id_categorie`, `nom_scateg`, `photo_scateg`, `flagtransmis`) VALUES (?,?,?,?,?)',
                [
                  row['id'],
                  row['id_categorie'],
                  row['nom_scateg'],
                  row['photo_scateg'],
                  row['flagtransmis']
                ]);
          }
        }
      }
      //await db.rawQuery('DELETE FROM `sous_categories` WHERE 1', []);
      // List<Map> ssous_categorie =
      // await db.rawQuery('SELECT * FROM sous_categories');
      // print(ssous_categorie);

      print('sous_categorie ${counting}');
      //end sous_categorie
      */

      await conn.close();

      }catch(e){
        print('error video '+e.toString());
      }finally{
        Future.delayed(const Duration(seconds: 1800),()=> connect());

      }

    }
  }

  synchronize() {
    connect();
  }
}
