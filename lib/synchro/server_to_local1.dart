import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

import 'package:mysql1/mysql1.dart';

class Synchro {
  Database db;
  Context context;
  String localPath;
  String onlinePath;
  String db_name_local;
  String user;
  String db_name_online;
  String online_ip;
  String online_link;
  String password;
  var conn;

  Synchro(
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
    //192.168.43.8
    //demo_asset_example.db
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, this.db_name_local);

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
   //   print(databasesPath);
      print("error database");
      // Should happen only the first time you launch your application
    //  print("Creating new copy from asset");

      // Make sure the parent directory exists
    //  try {
       // await Directory(dirname(path)).create(recursive: true);
    //  } catch (_) {}

      // Copy from asset
     // ByteData data = await rootBundle.load(join("asset", "PDAIG.db"));
     // List<int> bytes =
        //  data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
    //  await File(path).writeAsBytes(bytes, flush: true);
    } else {
      try{
      print("Opening local database");

// open the database

      db = await openDatabase(path);
      //  var date = new DateTime.now().toString();

      // var dateParse = DateTime.parse(date);

      // var formattedDate =
      //  "${dateParse.year}-${dateParse.month}-${dateParse.day} ${dateParse.hour}:${dateParse.minute}:${dateParse.second}.${dateParse.millisecond}";

      // var finalDate = formattedDate.toString();

      List<Map> ids = await db.rawQuery('SELECT * FROM parametre');
      var counting;

        conn = await MySqlConnection.connect(ConnectionSettings(
            host: this.online_ip,
            port: 3407,
            user: this.user,
            password: this.password,
            db: this.db_name_online));

      // int updateCount = await db.rawUpdate(
      //  'UPDATE `classe` SET  `flagtransmis`=? WHERE id=?', ['', 'lok']);
      print(" server to local start");

      try {
        //localite
        var counting = 0;

        //final conn = await MySqlConnection.connect(ConnectionSettings(
        // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
        var get_localite_rows =
            await conn.query('SELECT * FROM  localite  ', []);

        //var codification_update_time = "";
        // print("flagtransmis" + localite_update_time);
        counting = 0;
        for (var row in get_localite_rows) {

            try {
              //  print("new" + row['flagtransmis']);
              var id = row['id_localite'];
              int exiting = Sqflite.firstIntValue(await db.rawQuery(
                  'SELECT COUNT(*) FROM localite  where id_localite=?', [id]));
              if (exiting != 0) {
                //update
                List<Map> localite_update = await db.rawQuery(
                    'SELECT * FROM localite  where id_localite=?', [id]);
                var localite_update_time;
                if (localite_update.length == 0)
                  localite_update_time = "";
                else
                  localite_update_time = localite_update.first['flagtransmis'];
                if ((localite_update_time).toString().compareTo(
                    row['flagtransmis']) <
                    0) {
                  await db.rawUpdate(
                      'UPDATE `localite` SET `descriptions`=?,`longitude`=?,`latitude`=?,`pays`=?,`type_localite`=?,`flagtransmis`=? WHERE `id_localite`=?',
                      [
                        row['descriptions'],
                        row['longitude'],
                        row['latitude'],
                        row['pays'],
                        row['type_localite'],
                        row['flagtransmis'],
                        row['id_localite']

                      ]);
                  counting++;
                }
              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `localite`(`id_localite`, `descriptions`, `longitude`, `latitude`, `pays`, `type_localite`, `flagtransmis`) VALUES (?,?,?,?,?,?,?)',
                    [
                      row['id_localite'],
                      row['descriptions'],
                      row['longitude'],
                      row['latitude'],
                      row['pays'],
                      row['type_localite'],
                      row['flagtransmis']
                    ]);
                counting++;
              }
            }catch(e){
              print("error "+e.toString());
            }
        }
        // await db.rawQuery('DELETE FROM `localite` WHERE 1', []);
        // List<Map> slocalite = await db.rawQuery('SELECT * FROM localite');
        //print(slocalite);

        print('localite ${counting}');
        //end localite
      } catch (e) {
        print("error from localite table" + e.toString());
      }

      //langue
      try {
        //langue

        //final conn = await MySqlConnection.connect(ConnectionSettings(
        // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
        var get_langue_rows = await conn.query('SELECT * FROM  langues  ', []);

        //var codification_update_time = "";
      //  print("flagtransmis" + langue_update_time);
        counting = 0;
        for (var row in get_langue_rows) {

          try{

            var id = row['id'];
            int exiting = Sqflite.firstIntValue(await db
                .rawQuery('SELECT COUNT(*) FROM langues  where id=?', [id]));
            if (exiting != 0) {
              List<Map> langue_update = await db.rawQuery(
                  'SELECT * FROM langues  where id=?', [id]);
              var langue_update_time;
              if (langue_update.length == 0)
                langue_update_time = "";
              else
                langue_update_time = langue_update.first['flagtransmis'];
              if ((langue_update_time).toString().compareTo(row['flagtransmis']) <
                  0) {
                //update
                await db.rawUpdate(
                    'UPDATE `langues` SET `description`=?,`flagtransmis`=? WHERE id=?',
                    [row['description'], row['flagtransmis'], row['id']]);
                counting++;
              }
            } else {
              //insert
              await db.rawQuery(
                  'INSERT INTO `langues`(`id`, `description`, `flagtransmis`) VALUES (?,?,?)',
                  [row['id'], row['description'], row['flagtransmis']]);
              counting++;
            }
          }catch(e){
            print("error ");
          }
        }
        // await db.rawQuery('DELETE FROM `langue` WHERE 1', []);
        // List<Map> slangue = await db.rawQuery('SELECT * FROM langue');
        //print(slangue);

        print('langues ${counting}');
        //end langue
      } catch (e) {
        print("error from langue table" + e.toString());
      }
      if (ids.first['locate'].toString().isNotEmpty && ids?.first['locate'] != null) {
        print("locate: " + ids.first['locate'].toString());

        //culture
        try {
          //culture

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_culture_rows = await conn.query(
              'SELECT * FROM  culture  ', []);

          //var codification_update_time = "";
          //print("flagtransmis" + plantation_update_time);
          counting = 0;
          for (var row in get_culture_rows) {

              try{
             // print("new" + row['flagtransmis']);
              var id = row['id_culture'];
              int exiting = Sqflite.firstIntValue(await db.rawQuery(
                  'SELECT COUNT(*) FROM culture  where id_culture=?', [id]));
              if (exiting != 0) {
                //update
                List<Map> culture_update = await db.rawQuery(
                    'SELECT * FROM culture   where id_culture=?', [id]);
                var culture_update_time;
                if (culture_update.length == 0)
                  culture_update_time = "";
                else
                  culture_update_time = culture_update.first['flagtransmis'];
                if ((culture_update_time)
                    .toString()
                    .compareTo(row['flagtransmis']) <
                    0) {
                  await db.rawUpdate(
                      'UPDATE `culture` SET `nom_culture`=?,`code`=?,`flagtransmis`=? WHERE `id_culture`=? ',
                      [row['nom_culture'], row['code'], row['flagtransmis']]);

                  counting++;
                }
              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `culture`(`id_culture`, `nom_culture`, `code`, `flagtransmis`) VALUES (?,?,?,?)',
                    [
                      row['id_culture'],
                      row['nom_culture'],
                      row['code'],
                      row['flagtransmis']
                    ]);
                counting++;
              }
              }catch(e){
                print("error "+e.toString());
              }

          }
          //await db.rawQuery('DELETE FROM `plantation` WHERE 1', []);
          //List<Map> splantation = await db.rawQuery('SELECT * FROM plantation');
          // print(splantation);

          print('culture ${counting}');
          //end culture

        } catch (e) {
          print("error from culture table" + e.toString());
        }

        try {
          //detenteur culture

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_detenteur_culture_rows = await conn.query(
              'SELECT * FROM  detenteur_culture where (locate=? or locate=?)',
              [ids.first['locate'], 'all']);

          //var codification_update_time = "";
          // print("flagtransmis" + detenteur_culture_update_time);
          counting = 0;
          for (var row in get_detenteur_culture_rows) {

              try{

              var id = row['id_det_culture'];
              int exiting = Sqflite.firstIntValue(await db.rawQuery(
                  'SELECT COUNT(*) FROM detenteur_culture  where id_det_culture=?',
                  [id]));
              if (exiting != 0) {
                //update
                List<Map> detenteur_culture_update = await db.rawQuery(
                    'SELECT * FROM detenteur_culture  where id_det_culture=?',
                    [id]);
                var detenteur_culture_update_time;
                if (detenteur_culture_update.length == 0)
                  detenteur_culture_update_time = "";
                else
                  detenteur_culture_update_time =
                  detenteur_culture_update.first['flagtransmis'];
                if ((detenteur_culture_update_time)
                    .toString()
                    .compareTo(row['flagtransmis']) <
                    0) {
                  await db.rawUpdate(
                      'UPDATE `detenteur_culture` SET `id_plantation`=?,`id_culture`=?, campagneAgricole=?,`flagtransmis`=? WHERE `id_det_culture`=?',
                      [
                        row['id_plantation'],
                        row['id_culture'],
                        row['campagneAgricole'],
                        row['flagtransmis'],
                        row['id_det_culture']
                      ]);
                  counting++;
                }
              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `detenteur_culture`(`id_det_culture`, `id_plantation`, `id_culture`,campagneAgricole, `flagtransmis`) VALUES (?,?,?,?,?)',
                    [
                      row['id_det_culture'],
                      row['id_plantation'],
                      row['id_culture'],
                      row['campagneAgricole'],
                      row['flagtransmis']
                    ]);
                counting++;
              }

              }catch(e){
                print("error ");
              }

          }
          //await db.rawQuery('DELETE FROM `detenteur_culture` WHERE 1', []);
          // List<Map> sdetenteur_culture =
          //  await db.rawQuery('SELECT * FROM detenteur_culture');
          // print(sdetenteur_culture);

          print('deteteur culture ${counting}');
          //end detenteur culture

        } catch (e) {
          print("error from detenteur culture table" + e.toString());
        }

        try {
          //detenteur plantation

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_detenteur_plantation_rows = await conn.query(
              'SELECT * FROM  detenteur_plantation where (locate=? or locate=?)',
              [ids.first['locate'], 'all']);

          //var codification_update_time = "";
          // print("flagtransmis" + detenteur_plantation_update_time);
          counting = 0;
          for (var row in get_detenteur_plantation_rows) {
             try{
            //  print("new" + row['flagtransmis']);
              var id = row['id_det_plantation'];
              int exiting = Sqflite.firstIntValue(await db.rawQuery(
                  'SELECT COUNT(*) FROM detenteur_plantation  where id_det_plantation=?',
                  [id]));
              if (exiting != 0) {
                //update
                List<Map> detenteur_plantation_update = await db.rawQuery(
                    'SELECT * FROM detenteur_plantation where id_det_plantation=?',
                    [id]);
                var detenteur_plantation_update_time;
                if (detenteur_plantation_update.length == 0)
                  detenteur_plantation_update_time = "";
                else
                  detenteur_plantation_update_time =
                  detenteur_plantation_update.first['flagtransmis'];
                if ((detenteur_plantation_update_time)
                    .toString()
                    .compareTo(row['flagtransmis']) <
                    0) {

                  await db.rawUpdate(
                      'UPDATE `UPDATE `detenteur_plantation` SET `id_personne`=?,`id_plantation`=?,`flagtransmis`=? WHERE `id_det_plantation`=?',
                      [
                        row['id_personne'],
                        row['id_plantation'],
                        row['flagtransmis'],
                        row['id_det_plantation']
                      ]);
                  counting++;
                }
              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `detenteur_plantation`(`id_det_plantation`, `id_personne`, `id_plantation`, `flagtransmis`) VALUES (?,?,?,?)',
                    [
                      row['id_det_plantation'],
                      row['id_personne'],
                      row['id_plantation'],
                      row['flagtransmis']
                    ]);
                counting++;
              }
             }catch(e){
               print("error ");
             }

          }
          //await db.rawQuery('DELETE FROM `detenteur_culture` WHERE 1', []);
          // List<Map> sdetenteur_culture =
          //   await db.rawQuery('SELECT * FROM detenteur_plantation');
          // print(sdetenteur_culture);

          print('detenteur plantation ${counting}');
        } catch (e) {
          print("error from detenteur plantation table" + e.toString());
        }

        /*
        try {
          //detenteur plantation

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_don_rows = await conn.query(
              'SELECT * FROM  don where (locate=? or locate=?)',
              [ids.first['locate'], 'all']);

          //var codification_update_time = "";
          // print("flagtransmis" + detenteur_plantation_update_time);
          counting = 0;
          for (var row in get_don_rows) {

             // print("new" + row['flagtransmis']);
              var id = row['id_don'];
              int exiting = Sqflite.firstIntValue(await db
                  .rawQuery('SELECT COUNT(*) FROM don  where id_don=?', [id]));
              if (exiting != 0) {
                //update
                List<Map> don_update = await db.rawQuery(
                    'SELECT * FROM don where id_don=?', [id]);
                var don_update_time;
                if (don_update.length == 0)
                  don_update_time = "";
                else
                  don_update_time = don_update.first['flagtransmis'];
                if ((don_update_time).toString().compareTo(row['flagtransmis']) <
                    0) {
                  counting++;
                  await db.rawUpdate(
                      'UPDATE `don` SET `type_don`=?,`variete_semence`=?,`qte_semence`=?,`type_angrais`=?,`qte_angrais`=?,`qte_herbicide`=?,`idpersonne`=?,`flagtransmis`=? WHERE `id_don`=?',
                      [
                        row['type_don'],
                        row['variete_semence'],
                        row['qte_semence'],
                        row['type_angrais'],
                        row['qte_angrais'],
                        row['qte_herbicide'],
                        row['idpersonne'],
                        row['flagtransmis'],
                        row['id_don']
                      ]);
                }
              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `don`(`id_don`, `type_don`, `variete_semence`, `qte_semence`, `type_angrais`, `qte_angrais`, `qte_herbicide`, `idpersonne`, `flagtransmis`) VALUES (?,?,?,?,?,?,?,?,?)',
                    [
                      row['id_don'],
                      row['type_don'],
                      row['variete_semence'],
                      row['qte_semence'],
                      row['type_angrais'],
                      row['qte_angrais'],
                      row['qte_herbicide'],
                      row['idpersonne'],
                      row['flagtransmis']
                    ]);
                counting++;
              }

          }
          //await db.rawQuery('DELETE FROM `detenteur_culture` WHERE 1', []);
          // List<Map> sdetenteur_culture =
          //   await db.rawQuery('SELECT * FROM detenteur_plantation');
          // print(sdetenteur_culture);

          print('don ${counting}');
        } catch (e) {
          print("error from don table" + e.toString());
        }

        */

        try {
          //elevage

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_elevage_rows = await conn.query(
              'SELECT * FROM  elevage where (locate=? or locate=?)',
              [ids.first['locate'], 'all']);

          //var codification_update_time = "";
          // print("flagtransmis" + detenteur_plantation_update_time);
          counting = 0;
          for (var row in get_elevage_rows) {
             // print("new" + row['flagtransmis']);
            try{
              var id = row['id_elevage'];
              int exiting = Sqflite.firstIntValue(await db.rawQuery(
                  'SELECT COUNT(*) FROM elevage  where id_elevage=?', [id]));
              if (exiting != 0) {
                //update
                List<Map> elevage_update = await db.rawQuery(
                    'SELECT * FROM elevage   where id_elevage=?', [id]);
                var elevage_update_time;
                if (elevage_update.length == 0)
                  elevage_update_time = "";
                else
                  elevage_update_time = elevage_update.first['flagtransmis'];

                if ((elevage_update_time)
                    .toString()
                    .compareTo(row['flagtransmis']) <
                    0) {

                  await db.rawUpdate(
                      'UPDATE `elevage` SET `type_elevage`=?,`id_localite`=?,`type_exploitation`=?,`forme_exploitation`=?,`superficie`=?,`espece`=?,`flagtransmis`=? WHERE `id_elevage`=? ',
                      [

                        row['type_elevage'],
                        row['id_localite'],
                        row['type_exploitation'],
                        row['forme_exploitation'],
                        row['superficie'],
                        row['espece'],
                        row['flagtransmis'],
                        row['id_elevage']
                      ]);
                  counting++;
                }
              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `elevage`(`id_elevage`, `type_elevage`, `id_localite`, `type_exploitation`, `forme_exploitation`, `superficie`, `flagtransmis`) VALUES (?,?,?,?,?,?,?)',
                    [
                      row['id_elevage'],
                      row['type_elevage'],
                      row['id_localite'],
                      row['type_exploitation'],
                      row['forme_exploitation'],
                      row['superficie'],
                      row['flagtransmis']
                    ]);
                counting++;
            }
            }catch(e){
              print("error ");
            }
          }
          //await db.rawQuery('DELETE FROM `detenteur_culture` WHERE 1', []);
          //  List<Map> selevage = await db.rawQuery('SELECT * FROM elevage');
          //print(selevage);

          print('elevage ${counting}');
        } catch (e) {
          print("error from elevage table " + e.toString());
        }

        try {
          //especes

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_especes_rows = await conn.query(
              'SELECT * FROM  especes where (locate=? or locate=?)',
              [ids.first['locate'], 'all']);

          //var codification_update_time = "";
          // print("flagtransmis" + detenteur_plantation_update_time);
          counting = 0;
          for (var row in get_especes_rows) {
             try{
             // print("new" + row['flagtransmis']);
              var id = row['id_espece'];
              int exiting = Sqflite.firstIntValue(await db.rawQuery(
                  'SELECT COUNT(*) FROM especes  where id_espece=?', [id]));
              if (exiting != 0) {
                //update
                List<Map> especes_update = await db.rawQuery(
                    'SELECT * FROM especes where  id_espece=?', [id]);
                var especes_update_time;
                if (especes_update.length == 0)
                  especes_update_time = "";
                else
                  especes_update_time = especes_update.first['flagtransmis'];
                if ((especes_update_time)
                    .toString()
                    .compareTo(row['flagtransmis']) <
                    0) {

                  await db.rawUpdate(
                      'UPDATE `especes` SET `nom_especes`=?,`flagtransmis`=? WHERE `id_espece`=? ',
                      [
                        row['nom_especes'],
                        row['flagtransmis'],
                        row['id_espece'],
                      ]);
                  counting++;
                }
              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `especes`(`id_espece`, `nom_especes`, `flagtransmis`) VALUES (?,?,?)',
                    [
                      row['id_espece'],
                      row['nom_especes'],
                      row['flagtransmis']
                    ]);
                counting++;
              }
             }catch(e){
               print("error ");
             }

          }
          //await db.rawQuery('DELETE FROM `detenteur_culture` WHERE 1', []);
          //  List<Map> selevage = await db.rawQuery('SELECT * FROM elevage');
          //print(selevage);

          print('especes ${counting}');
        } catch (e) {
          print("error from especes table " + e.toString());
        }

        try {
          //especes

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_groupement_rows = await conn.query(
              'SELECT * FROM  groupement where (locate=? or locate=?)',
              [ids.first['locate'], 'all']);

          //var codification_update_time = "";
          // print("flagtransmis" + detenteur_plantation_update_time);
          counting = 0;
          for (var row in get_groupement_rows) {
          try{
             // print("new" + row['flagtransmis']);
              var id = row['id_groupement'];
              int exiting = Sqflite.firstIntValue(await db.rawQuery(
                  'SELECT COUNT(*) FROM groupement  where id_groupement=?',
                  [id]));
              if (exiting != 0) {
                //update
                List<Map> groupement_update = await db.rawQuery(
                    'SELECT * FROM groupement where id_groupement=?',
                    [id]);
                var groupement_update_time;
                if (groupement_update.length == 0)
                  groupement_update_time = "";
                else
                  groupement_update_time = groupement_update.first['flagtransmis'];
                if ((groupement_update_time)
                    .toString()
                    .compareTo(row['flagtransmis']) <
                    0) {

                  await db.rawUpdate(
                      'UPDATE `groupement` SET `nom_groupement`=?,`id_localite`=?,`activite_groupement`=?,`flagtransmis`=? WHERE `id_groupement`=?',
                      [
                        row['nom_groupement'],
                        row['id_localite'],
                        row['activite_groupement'],
                        row['flagtransmis'],
                        row['id_groupement'],
                      ]);
                  counting++;
                }
              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `groupement` (`id_groupement`, `nom_groupement`, `id_localite`, `activite_groupement`, `flagtransmis`) VALUES (?,?,?,?,?)',
                    [
                      row['id_groupement'],
                      row['nom_groupement'],
                      row['id_localite'],
                      row['activite_groupement'],
                      row['flagtransmis']
                    ]);
                counting++;
              }
          }catch(e){
            print("error "+e.toString());
          }

          }
          //await db.rawQuery('DELETE FROM `detenteur_culture` WHERE 1', []);
        //  List<Map> sgroupement = await db.rawQuery('SELECT * FROM groupement');
         // print(sgroupement);

          print('groupement ${counting}');
        } catch (e) {
          print("error from groupement table " + e.toString());
        }

        try {

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_membre_groupement_rows = await conn.query(
              'SELECT * FROM  membre_groupement where (locate=? or locate=?)',
              [ids.first['locate'], 'all']);

          //var codification_update_time = "";
          // print("flagtransmis" + detenteur_plantation_update_time);
          counting = 0;
          for (var row in get_membre_groupement_rows) {
              try{
              //print("new" + row['flagtransmis']);
              var id = row['id_mb_groupement'];
              int exiting = Sqflite.firstIntValue(await db.rawQuery(
                  'SELECT COUNT(*) FROM membre_groupement  where id_mb_groupement=?',
                  [id]));
              if (exiting != 0) {
                //update
                List<Map> membre_groupement_update = await db.rawQuery(
                    'SELECT * FROM membre_groupement   where id_mb_groupement=?',
                    [id]);

                var membre_groupement_update_time;
                if (membre_groupement_update.length == 0)
                  membre_groupement_update_time = "";
                else
                  membre_groupement_update_time =
                  membre_groupement_update.first['flagtransmis'];
                if ((membre_groupement_update_time)
                    .toString()
                    .compareTo(row['flagtransmis']) <
                    0) {

                  await db.rawUpdate(
                      'UPDATE `membre_groupement` SET `id_personne`=?,`id_groupement`=?,`statu`=?, `flagtransmis`=? WHERE `id_mb_groupement`=?',
                      [
                        row['id_personne'],
                        row['id_groupement'],
                        row['statu'],
                        row['flagtransmis'],
                        row['id_mb_groupement'],
                      ]);
                  counting++;
                }
              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `membre_groupement`(`id_mb_groupement`, `id_personne`, `id_groupement`, statu, `flagtransmis`) VALUES (?,?,?,?,?)',
                    [
                      row['id_mb_groupement'],
                      row['id_personne'],
                      row['id_groupement'],
                      row['statu'],
                      row['flagtransmis']
                    ]);
                counting++;
              }
              }catch(e){
                print("error ");
              }
          }
          //await db.rawQuery('DELETE FROM `detenteur_culture` WHERE 1', []);
          //  List<Map> sgroupement =
          // await db.rawQuery('SELECT * FROM membre_groupement');
          // print(sgroupement);

          print('membre_groupement ${counting}');
        } catch (e) {
          print("error from membre groupement table " + e.toString());
        }

        try {

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));

          var get_personne_rows = await conn.query(
              'SELECT * FROM  personne  where (locate=? or locate=?)',
              [ids.first['locate'], 'all']);

       //   print(get_personne_rows.toString());
          //print(get_personne_rows.toString());
          //var codification_update_time = "";
          // print("flagtransmis" + personne_update_time);
          counting = 0;
          for (var row in get_personne_rows) {
              try{
             //   print("new" + row['flagtransmis']);
                var id = row['id_personne'];
                //print(id);
                int exiting = Sqflite.firstIntValue(await db.rawQuery(
                    'SELECT COUNT(*) FROM personne  where id_personne=?',
                    [id]));

                if (exiting != 0) {
                  //update
                  List<Map> personne_update = await db.rawQuery(
                      'SELECT * FROM personne  where id_personne=?',
                      [id]);
                  var personne_update_time;
                  if (personne_update.length == 0)
                    personne_update_time = "";
                  else
                    personne_update_time = personne_update.first['flagtransmis'];
                  if ((personne_update_time)
                      .toString()
                      .compareTo(row['flagtransmis']) <
                      0) {
                    print("download personne photo"+row['prenom_personne']);
                    var imageName;
                    if (row['images'].toString().startsWith("\\"))
                      imageName = row['images']
                          .toString()
                          .replaceFirst(new RegExp(r'\\'), '');
                    else
                      imageName = row['images'];
                    // print(imageName);
                    Response response = await Dio().download(
                        this.online_link + this.onlinePath + imageName,
                        this.localPath + imageName);
                    print("response" + response.statusCode.toString());
                    if (response.statusCode == 200) {
                      counting++;
                      await db.rawUpdate(
                          'UPDATE `personne` SET `nom_personne`=?,`prenom_personne`=?,`tel_personne`=?,`genre`=?,`age`=?,`uids`=?,`email`=?,`mdp`=?,`images`=?,`liens`=?,`menage`=?,`flagtransmis`=? WHERE `id_personne`=?',
                          [
                            row['nom_personne'],
                            row['prenom_personne'],
                            row['tel_personne'],
                            row['genre'],
                            row['age'],
                            row['uids'],
                            row['email'],
                            row['mdp'],
                            imageName,
                            row['flagtransmis'],
                            row['liens'],
                            row['menage'],
                            row['id_personne']
                          ]);
                    }
                  }
                } else {

                  //insert



                  print("download personne photo "+row['prenom_personne']);
                  var imageName;
                  if (row['images'].toString().startsWith("\\"))
                    imageName = row['images']
                        .toString()
                        .replaceFirst(new RegExp(r'\\'), '');
                  else
                    imageName = row['images'];
                  // print(imageName);
                  print(this.online_link + this.onlinePath + imageName.toString());

                    Response response = await Dio().download(
                        this.online_link + this.onlinePath + imageName,
                        this.localPath + imageName);
                    print("response" + response.statusCode.toString());

                  //response.statusCode
                  if (response.statusCode == 200) {
                    await db.rawQuery(
                        'INSERT INTO `personne`(`id_personne`,`nom_personne`, `prenom_personne`, `tel_personne`, `genre`, '
                            ' `age`, `uids`, `email`, `mdp`, `images`, liens,menage, `flagtransmis`) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)',
                        [
                          row['id_personne'],
                          row['nom_personne'],
                          row['prenom_personne'],
                          row['tel_personne'],
                          row['genre'],
                          row['age'],
                          row['uids'],
                          row['email'],
                          row['mdp'],
                          imageName,

                          row['liens'],
                          row['menage'],
                          row['flagtransmis']

                        ]);
                    counting++;
                  }
            }
              }catch(e){
                print('error personne row '+e.toString());
              }

          }
          // await db.rawQuery('DELETE FROM `personne` WHERE 1', []);
          // List<Map> spersonne = await db.rawQuery('SELECT * FROM personne');
          //print(spersonne);

          print('personne ${counting}');
          //end personne

        } catch (e) {
          print("error from personne table " + e.toString());
        }

        try {

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_personne_adresse_rows = await conn.query(
              'SELECT * FROM  personne_adresse where (locate=? or locate=?)',
              [ids.first['locate'], 'all']);

          //var codification_update_time = "";
          // print("flagtransmis" + detenteur_plantation_update_time);
          counting = 0;
          for (var row in get_personne_adresse_rows) {
              try{
             // print("new" + row['flagtransmis']);
              var id = row['id_prs_adresse'];
              int exiting = Sqflite.firstIntValue(await db.rawQuery(
                  'SELECT COUNT(*) FROM personne_adresse  where id_prs_adresse=?',
                  [id]));
              if (exiting != 0) {
                //update
                List<Map> personne_adresse_update = await db.rawQuery(
                    'SELECT * FROM personne_adresse   where id_prs_adresse=?',
                    [id]);
                var personne_adresse_update_time;
                if (personne_adresse_update.length == 0)
                  personne_adresse_update_time = "";
                else
                  personne_adresse_update_time =
                  personne_adresse_update.first['flagtransmis'];
                if ((personne_adresse_update_time)
                    .toString()
                    .compareTo(row['flagtransmis']) <
                    0) {
                  counting++;
                  await db.rawUpdate(
                      'UPDATE `personne_adresse` SET `id_personne`=?`id_localite`=?,`flagtransmis`=? WHERE `id_prs_adresse`=?',
                      [
                        row['id_personne'],
                        row['id_localite'],
                        row['flagtransmis'],
                        row['id_prs_adresse']
                      ]);
                }
              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `personne_adresse`(`id_prs_adresse`, `id_personne`, `id_localite`, `flagtransmis`) VALUES (?,?,?,?)',
                    [
                      row['id_prs_adresse'],
                      row['id_personne'],
                      row['id_localite'],
                      row['flagtransmis']
                    ]);
                counting++;
              }
              }catch(e){
                print("error "+e.toString());
              }

          }
          //await db.rawQuery('DELETE FROM `detenteur_culture` WHERE 1', []);
          //  List<Map> sgroupement =
          // await db.rawQuery('SELECT * FROM membre_groupement');
          // print(sgroupement);

          print('personne_adresse ${counting}');
        } catch (e) {
          print("error from  personne_adresse table " + e.toString());
        }

        try {

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_personne_fonction_rows = await conn.query(
              'SELECT * FROM  personne_fonction where (locate=? or locate=?)',
              [ids.first['locate'], 'all']);

          //var codification_update_time = "";
          // print("flagtransmis" + detenteur_plantation_update_time);
          counting = 0;
          for (var row in get_personne_fonction_rows) {
             try{
             // print("new" + row['flagtransmis']);
              var id = row['id_prs_fonction'];
              int exiting = Sqflite.firstIntValue(await db.rawQuery(
                  'SELECT COUNT(*) FROM personne_fonction  where id_prs_fonction=?',
                  [id]));
              if (exiting != 0) {
                //update
                List<Map> personne_fonction_update = await db.rawQuery(
                    'SELECT * FROM personne_fonction  where id_prs_fonction=?',
                    [id]);
                var personne_fonction_update_time;
                if (personne_fonction_update.length == 0)
                  personne_fonction_update_time = "";
                else
                  personne_fonction_update_time =
                  personne_fonction_update.first['flagtransmis'];
                if ((personne_fonction_update_time)
                    .toString()
                    .compareTo(row['flagtransmis']) <
                    0) {
                  counting++;
                  await db.rawUpdate(
                      'UPDATE `personne_fonction` SET `nom_fonction`=?,`id_personne`=?,`flagtransmis`=? WHERE `id_prs_fonction`=? ',
                      [
                        row['nom_fonction'],
                        row['id_personne'],
                        row['flagtransmis'],
                        row['id_prs_fonction']
                      ]);
                }
              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `personne_fonction`(`id_prs_fonction`, `nom_fonction`, `id_personne`, `flagtransmis`) VALUES (?,?,?,?)',
                    [
                      row['id_prs_fonction'],
                      row['nom_fonction'],
                      row['id_personne'],
                      row['flagtransmis']
                    ]);
                counting++;
              }
             }catch(e){
               print("error "+e.toString());
             }

          }
        //  await db.rawQuery('DELETE FROM `personne_fonction` WHERE 1', []);
          //  List<Map> sgroupement =
          // await db.rawQuery('SELECT * FROM personne_fonction');
            //   print(sgroupement);

          print('personne_fonction ${counting}');

        } catch (e) {
          print("error from  personne_fonction table " + e.toString());
        }

        try {

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_plantation_rows = await conn.query(
              'SELECT * FROM  plantation where (locate=? or locate=?)',
              [ids.first['locate'], 'all']);

          //var codification_update_time = "";
          // print("flagtransmis" + detenteur_plantation_update_time);
          counting = 0;
          for (var row in get_plantation_rows) {
            try{
             // print("new" + row['flagtransmis']);
              var id = row['id_plantation'];
              int exiting = Sqflite.firstIntValue(await db.rawQuery(
                  'SELECT COUNT(*) FROM plantation  where id_plantation=?',
                  [id]));
              if (exiting != 0) {
                //update
                List<Map> plantation_update = await db.rawQuery(
                    'SELECT * FROM plantation  where id_plantation=?',
                    [id]);
                var plantation_update_time;
                if (plantation_update.length == 0)
                  plantation_update_time = "";
                else
                  plantation_update_time =
                  plantation_update.first['flagtransmis'];
                if ((plantation_update_time)
                    .toString()
                    .compareTo(row['flagtransmis']) <
                    0) {
                  counting++;
                  await db.rawUpdate(
                      'UPDATE `plantation` SET `desc_plantation`=?,`superficie`=?,`longitude`=?,`latitude`=?,`id_localite`=?,`type_exploitation`=?,`flagtransmis`=? WHERE `id_plantation`=? ',
                      [
                        row['desc_plantation'],
                        row['superficie'],
                        row['longitude'],
                        row['latitude'],
                        row['id_localite'],
                        row['type_exploitation'],
                        row['flagtransmis'],
                        row['id_plantation']
                      ]);
                }
              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `plantation`(`id_plantation`, `desc_plantation`, `superficie`, `longitude`, `latitude`, `id_localite`, `type_exploitation`, `flagtransmis`) VALUES (?,?,?,?,?,?,?,?)',
                    [
                      row['id_plantation'],
                      row['desc_plantation'],
                      row['superficie'],
                      row['longitude'],
                      row['latitude'],
                      row['id_localite'],
                      row['type_exploitation'],
                      row['flagtransmis']

                    ]);
                counting++;
            }
            }catch(e){
              print("error ");
            }
          }
           // await db.rawQuery('DELETE FROM `plantation` WHERE 1', []);
          // List<Map> sgroupement =
          // await db.rawQuery('SELECT * FROM plantation');
          //  print(sgroupement);

          print('plantation ${counting}');

        } catch (e) {
          print("error from  plantation table " + e.toString());
        }
/*
        try {

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_prefecture_rows = await conn.query(
              'SELECT * FROM  prefecture' ,
              null);

          //var codification_update_time = "";
          // print("flagtransmis" + detenteur_plantation_update_time);
          counting = 0;
          for (var row in get_prefecture_rows) {
             try{
             // print("new" + row['flagtransmis']);
              var id = row['id_prefecture'];
              int exiting = Sqflite.firstIntValue(await db.rawQuery(
                  'SELECT COUNT(*) FROM prefecture  where id_prefecture=?',
                  [id]));
              if (exiting != 0) {
                //update
                List<Map> prefecture_update = await db.rawQuery(
                    'SELECT * FROM prefecture  where id_prefecture=?',
                    [id]);
                var prefecture_update_time;
                if (prefecture_update.length == 0)
                  prefecture_update_time = "";
                else
                  prefecture_update_time =
                  prefecture_update.first['flagtransmis'];
                if ((prefecture_update_time)
                    .toString()
                    .compareTo(row['flagtransmis']) <
                    0) {
                  counting++;
                  await db.rawUpdate(
                      'UPDATE `prefecture` SET `id_region`=?,`nom_prefecture`=?,`flagtransmis`=? WHERE `id_prefecture`=?',
                      [
                        row['id_region'],
                        row['nom_prefecture'],
                        row['flagtransmis'],
                        row['id_prefecture'],

                      ]);
                }
              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `prefecture`(`id_prefecture`, `id_region`, `nom_prefecture`, `flagtransmis`) VALUES (?,?,?,?)',
                    [
                      row['id_prefecture'],
                      row['id_region'],
                      row['nom_prefecture'],
                      row['flagtransmis']


                    ]);
                counting++;
            }
             }catch(e){
               print("error ");
             }
          }
          // await db.rawQuery('DELETE FROM `prefecture` WHERE 1', []);
         //  List<Map> sgroupement =
         //  await db.rawQuery('SELECT * FROM prefecture');
          //  print(sgroupement);

          print('prefecture ${counting}');

        } catch (e) {
          print("error from  prefecture table " + e.toString());
        }

        try {

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_region_rows = await conn.query(
              'SELECT * FROM  region' ,
              null);

          //var codification_update_time = "";
          // print("flagtransmis" + detenteur_plantation_update_time);
          counting = 0;
          for (var row in get_region_rows) {
           try{
             // print("new" + row['flagtransmis']);
              var id = row['id_region'];
              int exiting = Sqflite.firstIntValue(await db.rawQuery(
                  'SELECT COUNT(*) FROM region  where id_region=?',
                  [id]));
              if (exiting != 0) {
                //update
                List<Map> region_update = await db.rawQuery(
                    'SELECT * FROM region  where id_region=?',
                    [id]);
                var region_update_time;
                if (region_update.length == 0)
                  region_update_time = "";
                else
                  region_update_time =
                  region_update.first['flagtransmis'];
                if ((region_update_time)
                    .toString()
                    .compareTo(row['flagtransmis']) <
                    0) {
                  counting++;
                  await db.rawUpdate(
                      'UPDATE `region` SET `nom_region`=?,`flagtransmis`=? WHERE `id_region`=?',
                      [
                        row['nom_region'],
                        row['flagtransmis'],
                        row['id_region'],

                      ]);
                }
              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `region`(`id_region`, `nom_region`, `flagtransmis`) VALUES (?,?,?)',
                    [
                      row['id_region'],
                      row['nom_region'],
                      row['flagtransmis']



                    ]);
                counting++;
              }
           }catch(e){
             print("error ");
           }

          }
         //  await db.rawQuery('DELETE FROM `region` WHERE 1', []);
          // List<Map> sgroupement =
          // await db.rawQuery('SELECT * FROM region');
        // print(sgroupement);

          print('region ${counting}');

        } catch (e) {
          print("error from  region table " + e.toString());
        }
*/

        try {

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_rendement_rows = await conn.query(
              'SELECT * FROM  rendement where (locate=? or locate=?)',
              [ids.first['locate'], 'all']);

          //var codification_update_time = "";
          // print("flagtransmis" + detenteur_plantation_update_time);
          counting = 0;
          for (var row in get_rendement_rows) {
            try{
             // print("new" + row['flagtransmis']);
              var id = row['id_rendement'];
              int exiting = Sqflite.firstIntValue(await db.rawQuery(
                  'SELECT COUNT(*) FROM rendement  where id_rendement=?',
                  [id]));
              if (exiting != 0) {
                //update
                List<Map> rendement_update = await db.rawQuery(
                    'SELECT * FROM rendement where id_rendement=?',
                    [id]);
                var rendement_update_time;
                if (rendement_update.length == 0)
                  rendement_update_time = "";
                else
                  rendement_update_time =
                  rendement_update.first['flagtransmis'];
                if ((rendement_update_time)
                    .toString()
                    .compareTo(row['flagtransmis']) <
                    0) {
                  counting++;
                  await db.rawUpdate(
                      'UPDATE `rendement` SET `quantite`=?,`date_rendement`=?,quantite_semence=?,`id_det_plantation`=?,`id_det_culture`=?,`flagtransmis`=? WHERE `id_rendement`=? ',
                      [
                        row['quantite'],
                        row['date_rendement'],
                        row['quantite_semence'],
                        row['id_det_plantation'],
                        row['id_det_culture'],
                        row['flagtransmis'],
                        row['id_rendement']

                      ]);
                }
              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `rendement`(`id_rendement`, `quantite`, `date_rendement`,quantite_semence, `id_det_plantation`, `id_det_culture`, `flagtransmis`) VALUES (?,?,?,?,?,?,?)',
                    [
                      row['id_rendement'],
                      row['quantite'],
                      row['date_rendement'],
                      row['quantite_semence'],
                      row['id_det_plantation'],
                      row['id_det_culture'],
                      row['flagtransmis']


                    ]);
                counting++;
            }
            }catch(e){
              print("error "+e.toString());
            }
          }
         //  await db.rawQuery('DELETE FROM `rendement` WHERE 1', []);
       //   List<Map> sgroupement =
        //  await db.rawQuery('SELECT * FROM rendement');
         //   print(sgroupement);

          print('rendement ${counting}');

        } catch (e) {
          print("error from  rendement table " + e.toString());
        }

        try {

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_rendement_elevage_rows = await conn.query(
              'SELECT * FROM  rendement_elevage where (locate=? or locate=?)',
              [ids.first['locate'], 'all']);

          //var codification_update_time = "";
          // print("flagtransmis" + detenteur_plantation_update_time);
          counting = 0;

          for (var row in get_rendement_elevage_rows) {
           try{
             // print("new" + row['flagtransmis']);
              var id = row['id_rendement_elv'];
              int exiting = Sqflite.firstIntValue(await db.rawQuery(
                  'SELECT COUNT(*) FROM rendement_elevage  where id_rendement_elv=?',
                  [id]));
              if (exiting != 0) {
                //update
                List<Map> rendement_elevage_update = await db.rawQuery(
                    'SELECT * FROM rendement_elevage  where id_rendement_elv=?',
                    [id]);
                var rendement_elevage_update_time;
                if (rendement_elevage_update.length == 0)
                  rendement_elevage_update_time = "";
                else
                  rendement_elevage_update_time =
                  rendement_elevage_update.first['flagtransmis'];
                if ((rendement_elevage_update_time)
                    .toString()
                    .compareTo(row['flagtransmis']) <
                    0) {
                  counting++;
                  await db.rawUpdate(
                      'UPDATE `rendement_elevage` SET `nbre`=?,`date_rendement`=?,`id_elevage`=?,`flagtransmis`=? WHERE `id_rendement_elv`=?',
                      [
                        row['nbre'],
                        row['date_rendement'],
                        row['id_elevage'],
                        row['flagtransmis'],
                        row['id_rendement_elv']

                      ]);
                }
              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `rendement_elevage`(`id_rendement_elv`, `nbre`, `date_rendement`, `id_elevage`, `flagtransmis`) VALUES (?,?,?,?,?)',
                    [
                      row['id_rendement_elv'],
                      row['nbre'],
                      row['date_rendement'],
                      row['id_elevage'],
                      row['flagtransmis']


                    ]);
                counting++;
            }
           }catch(e){
             print("error "+e.toString());
           }
          }
           // await db.rawQuery('DELETE FROM `rendement_elevage` WHERE 1', []);
         // List<Map> sgroupement =
        //  await db.rawQuery('SELECT * FROM rendement_elevage');
        //  print(sgroupement);

          print('rendement_elevage ${counting}');

        } catch (e) {
          print("error from  rendement_elevage table " + e.toString());
        }
/*
        try {

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_sous_prefecture_rows = await conn.query(
              'SELECT * FROM  sous_prefecture' ,
              null);

          //var codification_update_time = "";
          // print("flagtransmis" + detenteur_plantation_update_time);
          counting = 0;
          for (var row in get_sous_prefecture_rows) {
            try{
             // print("new" + row['flagtransmis']);
              var id = row['id_s_prefecture'];
              int exiting = Sqflite.firstIntValue(await db.rawQuery(
                  'SELECT COUNT(*) FROM sous_prefecture  where id_s_prefecture=?',
                  [id]));
              if (exiting != 0) {
                //update
                List<Map> sous_prefecture_update = await db.rawQuery(
                    'SELECT * FROM sous_prefecture  where id_s_prefecture=?',
                    [id]);
                var sous_prefecture_update_time;
                if (sous_prefecture_update.length == 0)
                  sous_prefecture_update_time = "";
                else
                  sous_prefecture_update_time =
                  sous_prefecture_update.first['flagtransmis'];
                if ((sous_prefecture_update_time)
                    .toString()
                    .compareTo(row['flagtransmis']) <
                    0) {
                  counting++;
                  await db.rawUpdate(
                      'UPDATE `sous_prefecture` SET `id_prefecture`=?,`nom_s_prefecture`=?,`flagtransmis`=? WHERE `id_s_prefecture`=?',
                      [
                        row['id_prefecture'],
                        row['nom_s_prefecture'],
                        row['flagtransmis'],
                        row['id_s_prefecture']

                      ]);
                }
              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `sous_prefecture`(`id_s_prefecture`, `id_prefecture`, `nom_s_prefecture`, `flagtransmis`) VALUES (?,?,?,?)',
                    [
                      row['id_s_prefecture'],
                      row['id_prefecture'],
                      row['nom_s_prefecture'],
                      row['flagtransmis']



                    ]);
                counting++;
            }
            }catch(e){
              print("error ");
            }
          }
           // await db.rawQuery('DELETE FROM `sous_prefecture` WHERE 1', []);
        //   List<Map> sgroupement =
         //  await db.rawQuery('SELECT * FROM sous_prefecture');
         //  print(sgroupement);

          print('sous_prefecture ${counting}');

        } catch (e) {
          print("error from  sous_prefecture table " + e.toString());
        }
*/

        try {

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_biens_rows = await conn.query(
              'SELECT * FROM  biens where (locate=? or locate=?)',
              [ids.first['locate'], 'all']);

          //var codification_update_time = "";
          // print("flagtransmis" + detenteur_plantation_update_time);
          counting = 0;
          for (var row in get_biens_rows) {
             try{
            // print("new" + row['flagtransmis']);
            var id = row['id_type_bien'];
            int exiting = Sqflite.firstIntValue(await db.rawQuery(
                'SELECT COUNT(*) FROM biens  where id_type_bien=?',
                [id]));
            if (exiting != 0) {
              //update
              List<Map> biens_update = await db.rawQuery(
                  'SELECT * FROM biens where id_type_bien=?',
                  [id]);
              var biens_update_time;
              if (biens_update.length == 0)
                biens_update_time = "";
              else
                biens_update_time =
                biens_update.first['flagtransmis'];
              if ((biens_update_time)
                  .toString()
                  .compareTo(row['flagtransmis']) <
                  0) {
                counting++;
                await db.rawUpdate(
                    'UPDATE `biens` SET `id_personne`=?,`id_agent`=?,`type_bien`=?,`quantite`=?,`montant`=?,`utilisations`=?,`flagtransmis`=? WHERE `id_type_bien`=?',
                    [
                      row['id_personne'],
                      row['id_agent'],
                      row['type_bien'],
                      row['quantite'],
                      row['montant'],
                      row['utilisations'],
                      row['flagtransmis'],
                      row['id_type_bien']

                    ]);
              }
            } else {
              //insert
              await db.rawQuery(
                  'INSERT INTO `biens`(`id_type_bien`, `id_personne`, `id_agent`, `type_bien`, `quantite`, `montant`, `utilisations`, `flagtransmis`) VALUES (?,?,?,?,?,?,?,?)',
                  [
                    row['id_type_bien'],
                    row['id_personne'],
                    row['id_agent'],
                    row['type_bien'],
                    row['quantite'],
                    row['montant'],
                    row['utilisations'],
                    row['flagtransmis']


                  ]);
              counting++;
            }
             }catch(e){
               print("error ");
             }
          }
          //  await db.rawQuery('DELETE FROM `rendement` WHERE 1', []);
          //   List<Map> sgroupement =
          //  await db.rawQuery('SELECT * FROM rendement');
          //   print(sgroupement);

          print('biens ${counting}');

        } catch (e) {
          print("error from  biens table " + e.toString());
        }

        try {

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_elevage_espece_rows = await conn.query(
              'SELECT * FROM  elevage_espece where (locate=? or locate=?)',
              [ids.first['locate'], 'all']);

          //var codification_update_time = "";
          // print("flagtransmis" + detenteur_plantation_update_time);
          counting = 0;
          for (var row in get_elevage_espece_rows) {
          try{
            // print("new" + row['flagtransmis']);
            var id = row['id_elv_espece'];
            int exiting = Sqflite.firstIntValue(await db.rawQuery(
                'SELECT COUNT(*) FROM elevage_espece  where id_elv_espece=?',
                [id]));
            if (exiting != 0) {
              //update
              List<Map> elevage_espece_update = await db.rawQuery(
                  'SELECT * FROM elevage_espece where id_elv_espece=?',
                  [id]);
              var elevage_espece_update_time;
              if (elevage_espece_update.length == 0)
                elevage_espece_update_time = "";
              else
                elevage_espece_update_time =
                elevage_espece_update.first['flagtransmis'];
              if ((elevage_espece_update_time)
                  .toString()
                  .compareTo(row['flagtransmis']) <
                  0) {
                counting++;
                await db.rawUpdate(
                    'UPDATE `elevage_espece` SET `id_elevage`=?,`espece`=?,`flagtransmis`=? WHERE `id_elv_espece`=?',
                    [

                      row['id_elevage'],
                      row['espece'],
                      row['flagtransmis'],
                      row['id_elv_espece']

                    ]);
              }
            } else {
              //insert
              await db.rawQuery(
                  'INSERT INTO `elevage_espece`(`id_elv_espece`, `id_elevage`, `espece`, `flagtransmis`) VALUES (?,?,?,?)',
                  [
                    row['id_elv_espece'],

                    row['id_elevage'],
                    row['espece'],
                    row['flagtransmis']


                  ]);
              counting++;
            }
          }catch(e){
            print("error ");
          }
          }
          //  await db.rawQuery('DELETE FROM `rendement` WHERE 1', []);
          //   List<Map> sgroupement =
          //  await db.rawQuery('SELECT * FROM rendement');
          //   print(sgroupement);

          print('elevage_espece ${counting}');

        } catch (e) {
          print("error from  elevage_espece table " + e.toString());
        }

        try {

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_services_recus_rows = await conn.query(
              'SELECT * FROM  services_recus where (locate=? or locate=?)',
              [ids.first['locate'], 'all']);

          //var codification_update_time = "";
          // print("flagtransmis" + detenteur_plantation_update_time);
          counting = 0;
          for (var row in get_services_recus_rows) {
           try{
            // print("new" + row['flagtransmis']);
            var id = row['id_service'];
            int exiting = Sqflite.firstIntValue(await db.rawQuery(
                'SELECT COUNT(*) FROM services_recus  where id_service=?',
                [id]));
            if (exiting != 0) {
              //update
              List<Map> services_recus_update = await db.rawQuery(
                  'SELECT * FROM services_recus where id_service=?',
                  [id]);
              var services_recus_update_time;
              if (services_recus_update.length == 0)
                services_recus_update_time = "";
              else
                services_recus_update_time =
                services_recus_update.first['flagtransmis'];
              if ((services_recus_update_time)
                  .toString()
                  .compareTo(row['flagtransmis']) <
                  0) {
                counting++;
                await db.rawUpdate(
                    'UPDATE `services_recus` SET `id_personne`=?,`id_agent`=?,`type_service`=?,`modules`=?,`nombre_jours`=?,`resultats`=?,`lieux`=?,`objectif`=?,`flagtransmis`=? WHERE `id_service`=?',
                    [
                      row['id_personne'],
                      row['id_agent'],
                      row['type_service'],
                      row['modules'],
                      row['nombre_jours'],
                      row['resultats'],
                      row['lieux'],
                      row['objectif'],
                      row['flagtransmis'],
                      row['id_service']

                    ]);
              }
            } else {
              //insert
              await db.rawQuery(
                  'INSERT INTO `services_recus`(`id_service`, `id_personne`, `id_agent`, `type_service`, `modules`, `nombre_jours`, `resultats`, `lieux`, `objectif`, `flagtransmis`) VALUES (?,?,?,?,?,?,?,?,?,?)',
                  [
                    row['id_service'],
                    row['id_personne'],
                    row['id_agent'],
                    row['type_service'],
                    row['modules'],
                    row['nombre_jours'],
                    row['resultats'],
                    row['lieux'],
                    row['objectif'],
                    row['flagtransmis']



                  ]);
              counting++;
            }
           }catch(e){
             print("error ");
           }
          }
          //  await db.rawQuery('DELETE FROM `rendement` WHERE 1', []);
          //   List<Map> sgroupement =
          //  await db.rawQuery('SELECT * FROM rendement');
          //   print(sgroupement);

          print('services_recus ${counting}');

        } catch (e) {
          print("error from  services_recus table " + e.toString());
        }

        try {

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_subvention_rows = await conn.query(
              'SELECT * FROM  subvention where (locate=? or locate=?)',
              [ids.first['locate'], 'all']);

          //var codification_update_time = "";
          // print("flagtransmis" + detenteur_plantation_update_time);
          counting = 0;
          for (var row in get_subvention_rows) {
            try{
            // print("new" + row['flagtransmis']);
            var id = row['id_subvention'];
            int exiting = Sqflite.firstIntValue(await db.rawQuery(
                'SELECT COUNT(*) FROM subvention  where id_subvention=?',
                [id]));
            if (exiting != 0) {
              //update
              List<Map> subvention_update = await db.rawQuery(
                  'SELECT * FROM subvention where id_subvention=?',
                  [id]);
              var subvention_update_time;
              if (subvention_update.length == 0)
                subvention_update_time = "";
              else
                subvention_update_time =
                subvention_update.first['flagtransmis'];
              if ((subvention_update_time)
                  .toString()
                  .compareTo(row['flagtransmis']) <
                  0) {
                counting++;
                await db.rawUpdate(
                    'UPDATE `subvention` SET `id_personne`=?,`id_agent`=?,`montant`=?,`titre_projet`=?,`duree_projet`=?,`zones`=?,`objectif`=?,`apport_projet`=?,`flagtransmis`=? WHERE `id_subvention`=?',
                    [
                      row['id_personne'],
                      row['id_agent'],
                      row['montant'],
                      row['titre_projet'],
                      row['duree_projet'],
                      row['zones'],
                      row['objectif'],
                      row['apport_projet'],
                      row['flagtransmis'],
                      row['id_subvention']

                    ]);
              }
            } else {
              //insert
              await db.rawQuery(
                  'INSERT INTO `subvention`(`id_subvention`, `id_personne`, `id_agent`, `montant`, `titre_projet`, `duree_projet`, `zones`, `objectif`, `apport_projet`, `flagtransmis`) VALUES (?,?,?,?,?,?,?,?,?,?)',
                  [
                    row['id_subvention'],
                    row['id_personne'],
                    row['id_agent'],
                    row['montant'],
                    row['titre_projet'],
                    row['duree_projet'],
                    row['zones'],
                    row['objectif'],
                    row['apport_projet'],
                    row['flagtransmis']




                  ]);
              counting++;
            }
            }catch(e){
              print("error ");
            }

          }
          //  await db.rawQuery('DELETE FROM `rendement` WHERE 1', []);
          //   List<Map> sgroupement =
          //  await db.rawQuery('SELECT * FROM rendement');
          //   print(sgroupement);

          print('subvention ${counting}');

        } catch (e) {
          print("error from  subvention table " + e.toString());
        }


        try {

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_membre_elevage_rows = await conn.query(
              'SELECT * FROM  membre_elevage where (locate=? or locate=?)',
              [ids.first['locate'], 'all']);

          //var codification_update_time = "";
          // print("flagtransmis" + detenteur_plantation_update_time);
          counting = 0;
          for (var row in get_membre_elevage_rows) {
            try{
              // print("new" + row['flagtransmis']);
              var id = row['id_mb_elevage'];
              int exiting = Sqflite.firstIntValue(await db.rawQuery(
                  'SELECT COUNT(*) FROM membre_elevage  where id_mb_elevage=?',
                  [id]));
              if (exiting != 0) {
                //update
                List<Map> membre_elevage_update = await db.rawQuery(
                    'SELECT * FROM membre_elevage where id_mb_elevage=?',
                    [id]);
                var membre_elevage_update_time;
                if (membre_elevage_update.length == 0)
                  membre_elevage_update_time = "";
                else
                  membre_elevage_update_time =
                  membre_elevage_update.first['flagtransmis'];
                if ((membre_elevage_update_time)
                    .toString()
                    .compareTo(row['flagtransmis']) <
                    0) {
                  counting++;
                  await db.rawUpdate(
                      'UPDATE `membre_elevage` SET `id_personne`=?,`id_elevage`=?,`flagtransmis`=? WHERE `id_mb_elevage`=?',
                      [
                        row['id_personne'],
                        row['id_elevage'],
                        row['flagtransmis'],
                        row['id_mb_elevage'],



                      ]);
                }
              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `membre_elevage`(`id_mb_elevage`, `id_personne`, `id_elevage`,  `flagtransmis`) VALUES (?,?,?,?)',
                    [
                      row['id_mb_elevage'],
                      row['id_personne'],
                      row['id_elevage'],
                      row['flagtransmis']


                    ]);
                counting++;
              }
            }catch(e){
              print("error ");
            }

          }
          //  await db.rawQuery('DELETE FROM `rendement` WHERE 1', []);
          //   List<Map> sgroupement =
          //  await db.rawQuery('SELECT * FROM rendement');
          //   print(sgroupement);

          print('membre_elevage ${counting}');

        } catch (e) {
          print("error from  membre_elevage table " + e.toString());
        }


        try {

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_campagne_agricole_rows = await conn.query(
              'SELECT * FROM  campagne_agricole ', []);

          print(get_campagne_agricole_rows.toString());

          //var codification_update_time = "";
          // print("flagtransmis" + detenteur_plantation_update_time);
          counting = 0;
          for (var row in get_campagne_agricole_rows) {
            try{
              // print("new" + row['flagtransmis']);
              var id = row['id'];
              int exiting = Sqflite.firstIntValue(await db.rawQuery(
                  'SELECT COUNT(*) FROM campagne_agricole  where id=?',
                  [id]));
              if (exiting != 0) {
                //update
              //no update here

              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `campagne_agricole`(`id`, `description`) VALUES (?,?)',
                    [
                      row['id'],
                      row['description'],


                    ]);
                counting++;
              }
            }catch(e){
              print("error ");
            }

          }
          //  await db.rawQuery('DELETE FROM `rendement` WHERE 1', []);
           //  List<Map> sgroupement =
          //  await db.rawQuery('SELECT * FROM campagne_agricole');
          // print(sgroupement);

          print('campagne_agricole ${counting}');

        } catch (e) {
          print("error from  campagne_agricole table " + e.toString());
        }


        try {

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_unions_rows = await conn.query(
              'SELECT * FROM  unions ', []);

       //   print(get_unions_rows.toString());

          //var codification_update_time = "";
          // print("flagtransmis" + detenteur_plantation_update_time);
          counting = 0;
          for (var row in get_unions_rows) {
            try{
              // print("new" + row['flagtransmis']);
              var id = row['id_un'];
              int exiting = Sqflite.firstIntValue(await db.rawQuery(
                  'SELECT COUNT(*) FROM unions  where id_un=?',
                  [id]));
              if (exiting != 0) {
                //update
                //no update here

              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `unions`(`id_un`, `id_fed`,description_un ,flagtransmis) VALUES (?,?,?,?)',
                    [
                      row['id_un'],
                      row['id_fed'],
                      row['description_un'],
                      row['flagtransmis'],


                    ]);
                counting++;
              }
            }catch(e){
              print("error ");
            }

          }
          //  await db.rawQuery('DELETE FROM `rendement` WHERE 1', []);
          //  List<Map> sgroupement =
          //  await db.rawQuery('SELECT * FROM campagne_agricole');
          // print(sgroupement);

          print('unions ${counting}');

        } catch (e) {
          print("error from  unions table " + e.toString());
        }

        try {

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_confederation_rows = await conn.query(
              'SELECT * FROM  confederation ', []);

       //   print(get_confederation_rows.toString());

          //var codification_update_time = "";
          // print("flagtransmis" + detenteur_plantation_update_time);
          counting = 0;
          for (var row in get_confederation_rows) {
            try{
              // print("new" + row['flagtransmis']);
              var id = row['id_conf'];
              int exiting = Sqflite.firstIntValue(await db.rawQuery(
                  'SELECT COUNT(*) FROM confederation  where id_conf=?',
                  [id]));
              if (exiting != 0) {
                //update
                //no update here

              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `confederation`(`id_conf`, `description_conf`,flagtransmis) VALUES (?,?,?)',
                    [
                      row['id_conf'],
                      row['description_conf'],

                      row['flagtransmis'],


                    ]);
                counting++;
              }
            }catch(e){
              print("error ");
            }

          }
          //  await db.rawQuery('DELETE FROM `rendement` WHERE 1', []);
          //  List<Map> sgroupement =
          //  await db.rawQuery('SELECT * FROM campagne_agricole');
          // print(sgroupement);

          print('confederation ${counting}');

        } catch (e) {
          print("error from  confederation table " + e.toString());
        }


        try {

          //final conn = await MySqlConnection.connect(ConnectionSettings(
          // host: '192.168.43.8', port: 3306, user: 'root', db: 'pam2'));
          var get_federation_rows = await conn.query(
              'SELECT * FROM  federation ', []);

        //  print(get_federation_rows.toString());

          //var codification_update_time = "";
          // print("flagtransmis" + detenteur_plantation_update_time);
          counting = 0;
          for (var row in get_federation_rows) {
            try{
              // print("new" + row['flagtransmis']);
              var id = row['id_fed'];
              int exiting = Sqflite.firstIntValue(await db.rawQuery(
                  'SELECT COUNT(*) FROM federation  where id_fed=?',
                  [id]));
              if (exiting != 0) {
                //update
                //no update here

              } else {
                //insert
                await db.rawQuery(
                    'INSERT INTO `federation`(`id_fed`, `id_conf`, description_fed, flagtransmis) VALUES (?,?,?,?)',
                    [
                      row['id_fed'],
                      row['id_conf'],
                      row['description_fed'],
                      row['flagtransmis'],


                    ]);
                counting++;
              }
            }catch(e){
              print("error ");
            }

          }
          //  await db.rawQuery('DELETE FROM `rendement` WHERE 1', []);
          //  List<Map> sgroupement =
          //  await db.rawQuery('SELECT * FROM campagne_agricole');
          // print(sgroupement);

          print('federation ${counting}');

        } catch (e) {
          print("error from  federation table " + e.toString());
        }



        print("local to server start");

        final DateTime now = DateTime.now();
        final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
        final String finalDate = formatter.format(now);
        print(finalDate);
        var count;
        try{
          List<Map> culture =
          await db.rawQuery('SELECT * FROM culture where flagtransmis=""');
          // print(inscription);
          count = 0;

          for (var row in culture) {
            try{
            await conn.query(
                'INSERT INTO `culture`(`id_culture`, `nom_culture`, `code`, `flagtransmis`, `locate`) VALUES (?,?,?,?,?)',
                [
                  row['id_culture'],
                  row['nom_culture'],
                  row['code'],
                  finalDate,
                  'all'
                ]);

            await db.rawUpdate(
                'UPDATE `culture` SET  `flagtransmis`=? WHERE id_culture=?',
                [finalDate, row['id_culture']]);
            count++;
            }catch(e){
              print("error ");
            }
          }

          print('culture ${count}');

        }catch(e){
          print("error from  culture table " + e.toString());

        }


        try{
          List<Map> plantation =
          await db.rawQuery('SELECT * FROM plantation where flagtransmis=""');

          count = 0;

          for (var row in plantation) {
            try{
              await conn.query(
                  'INSERT INTO `plantation`(`id_plantation`, `desc_plantation`, `superficie`, `longitude`, `latitude`, `id_localite`, `type_exploitation`, `flagtransmis`, `locate`) VALUES (?,?,?,?,?,?,?,?,?)',

                  [
                    row['id_plantation'],
                    row['desc_plantation'],
                    row['superficie'],
                    row['longitude'],
                    row['latitude'],
                    row['id_localite'],
                    row['type_exploitation'],
                    finalDate,
                    ids.first['locate']
                  ]);

              await db.rawUpdate(
                  'UPDATE `plantation` SET  `flagtransmis`=? WHERE id_plantation=?',
                  [finalDate, row['id_plantation']]);
              count++;
            }catch(e){
              print("error "+e.toString());
            }
          }

          print('plantation ${count}');

        }catch(e){
          print("error from  plantation table " + e.toString());

        }


        try{
          List<Map> detenteur_culture =
          await db.rawQuery('SELECT * FROM detenteur_culture where flagtransmis=""');
          // print(inscription);
          count = 0;

          for (var row in detenteur_culture) {
            try{
            await conn.query(
                'INSERT INTO `detenteur_culture`(`id_det_culture`, `id_plantation`, `id_culture`, campagneAgricole, `flagtransmis`, `locate`) VALUES (?,?,?,?,?,?)',
                [
                  row['id_det_culture'],
                  row['id_plantation'],
                  row['id_culture'],
                  row['campagneAgricole'],
                  finalDate,
                  ids.first['locate']
                ]);

            await db.rawUpdate(
                'UPDATE `detenteur_culture` SET  `flagtransmis`=? WHERE id_det_culture=?',
                [finalDate, row['id_det_culture']]);
            count++;
            }catch(e){
              print("error "+e.toString());
            }
          }

          print(' detenteur culture ${count}');

        }catch(e){
          print("error from  detenteur culture table " + e.toString());

        }


    /*
        try{
          List<Map> don =
          await db.rawQuery('SELECT * FROM don where flagtransmis=""');
          // print(inscription);
          count = 0;

          for (var row in don) {
            await conn.query(
                'INSERT INTO `don`(`id_don`, `type_don`, `variete_semence`, `qte_semence`, `type_angrais`, `qte_angrais`, `qte_herbicide`, `idpersonne`, `flagtransmis`, `locate`) VALUES (?,?,?,?,?,?,?,?,?,?)',

                [
                  row['id_don'],
                  row['type_don'],
                  row['variete_semence'],
                  row['qte_semence'],
                  row['type_angrais'],
                  row['qte_angrais'],
                  row['qte_herbicide'],
                  row['idpersonne'],
                  finalDate,
                  ids.first['locate']
                ]);

            await db.rawUpdate(
                'UPDATE `don` SET  `flagtransmis`=? WHERE id_don=?',
                [finalDate, row['id_don']]);
            count++;
          }

          print(' don ${count}');

        }catch(e){
          print("error from  don table " + e.toString());

        }
        */

        try{
          List<Map> elevage =
          await db.rawQuery('SELECT * FROM elevage where flagtransmis=""');
          // print(inscription);
          count = 0;

          for (var row in elevage) {
            try{
            await conn.query(
                'INSERT INTO `elevage`(`id_elevage`,  `type_elevage`, `id_localite`, `type_exploitation`, `forme_exploitation`, `superficie`, `flagtransmis`, `locate`) VALUES  (?,?,?,?,?,?,?,?)',

                [
                  row['id_elevage'],
                  row['type_elevage'],
                  row['id_localite'],
                  row['type_exploitation'],
                  row['forme_exploitation'],
                  row['superficie'],

                  finalDate,
                  ids.first['locate']
                ]);

            await db.rawUpdate(
                'UPDATE `elevage` SET  `flagtransmis`=? WHERE id_elevage=?',
                [finalDate, row['id_elevage']]);
            count++;
            }catch(e){
              print("error "+e.toString());
            }
          }

          print(' elevage ${count}');

        }catch(e){
          print("error from  elevage table " + e.toString());

        }

        try{
          List<Map> especes =
          await db.rawQuery('SELECT * FROM especes where flagtransmis=""');
          // print(inscription);
          count = 0;

          for (var row in especes) {
            try{
            await conn.query(
                'INSERT INTO `especes`(`id_espece`, `nom_especes`, `flagtransmis`, `locate`) VALUES (?,?,?,?)',

                [
                  row['id_espece'],
                  row['nom_especes'],
                  finalDate,
                  ids.first['locate']
                ]);

            await db.rawUpdate(
                'UPDATE `especes` SET  `flagtransmis`=? WHERE id_espece=?',
                [finalDate, row['id_espece']]);
            count++;
            }catch(e){
              print("error ");
            }
          }

          print('especes ${count}');

        }catch(e){
          print("error from  especes table " + e.toString());

        }

        try{
          List<Map> groupement =
          await db.rawQuery('SELECT * FROM groupement where flagtransmis=""');
          // print(inscription);
          count = 0;

          for (var row in groupement) {
            try{
            await conn.query(
                'INSERT INTO `groupement`(`id_groupement`, `nom_groupement`, `id_localite`, `activite_groupement`, `flagtransmis`, `locate`) VALUES (?,?,?,?,?,?)',

                [
                  row['id_groupement'],
                  row['nom_groupement'],
                  row['id_localite'],
                  row['activite_groupement'],
                  finalDate,
                  ids.first['locate']
                ]);

            await db.rawUpdate(
                'UPDATE `groupement` SET  `flagtransmis`=? WHERE id_groupement=?',
                [finalDate, row['id_groupement']]);
            count++;
            }catch(e){
              print("error "+e.toString());
            }
          }

          print('groupement ${count}');

        }catch(e){
          print("error from  groupement table " + e.toString());

        }

        try{
          List<Map> membre_groupement =
          await db.rawQuery('SELECT * FROM membre_groupement where flagtransmis=""');

          count = 0;

          for (var row in membre_groupement) {
            try{
            await conn.query(
                'INSERT INTO `membre_groupement`(`id_mb_groupement`, `id_personne`, `id_groupement`, statu, `flagtransmis`, `locate`) VALUES (?,?,?,?,?,?)',

                [
                  row['id_mb_groupement'],
                  row['id_personne'],
                  row['id_groupement'],
                  row['statu'],
                  finalDate,
                  ids.first['locate']
                ]);

            await db.rawUpdate(
                'UPDATE `membre_groupement` SET  `flagtransmis`=? WHERE id_groupement=?',
                [finalDate, row['id_groupement']]);
            count++;
            }catch(e){
              print("error ");
            }
          }

          print('membre_groupement ${count}');

        }catch(e){
          print("error from  membre_groupement table " + e.toString());

        }
            try{

              List<Map> personne =
              await db.rawQuery('SELECT * FROM personne where flagtransmis=""');
            //  print(this.onlinePath);
              count = 0;
              for (var row in personne) {
                try {
                  print("uploadi image "+row['nom_personne']);

                  final dio = Dio();

                  dio.options.headers = {
                    'Content-Type': 'application/x-www-form-urlencoded'
                  };
                  // Directory appDocDirectory = await getApplicationDocumentsDirectory();
                  final file = await MultipartFile.fromFile(
                      this.localPath + row['images'],
                      filename: row['images']);
                   print(this.online_link + this.onlinePath + row['images']);
                  final formData = FormData.fromMap({
                    'file': file,
                    'online_path': this.onlinePath
                  }); // 'file' - this is an api key, can be different

                  Response response = await dio.post(
                       // or dio.post
                         this.online_link + "upload.php",
                         data: formData,
                         options:
                         Options(contentType: Headers.formUrlEncodedContentType));
                     print("response " + response.statusCode.toString());


                  if (response.statusCode == 200) {
                    await conn.query(
                        'INSERT INTO `personne`(`id_personne`, `nom_personne`, `prenom_personne`, `tel_personne`, `genre`, `age`, `uids`, `email`, `mdp`, `images`, `liens`,menage, `flagtransmis`, `locate`) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
                        [
                          row['id_personne'],
                          row['nom_personne'],
                          row['prenom_personne'],
                          row['tel_personne'],
                          row['genre'],
                          row['age'],
                          row['uids'],
                          row['email'],
                          row['mdp'],
                          row['images'],
                          row['liens'],
                          row['menage'],
                          finalDate,
                          ids.first['locate']
                        ]);

                    await db.rawUpdate(
                        'UPDATE `personne` SET  `flagtransmis`=? WHERE id_personne=?',
                        [finalDate, row['id_personne']]);
                    count++;
                  }
                } catch (err) {
                  print('uploading error: $err');
                }
              }
              // await db.rawQuery('DELETE FROM `personne` WHERE 1', []);
              print('personne  ${count}');

            }catch(e){
              print("error from  personne table " + e.toString());
            }


        try{
          List<Map> personne_addresse =
          await db.rawQuery('SELECT * FROM personne_adresse where flagtransmis=""');
           // print(personne_addresse);
          count = 0;

          for (var row in personne_addresse) {
            try{
            await conn.query(
                'INSERT INTO `personne_adresse`(`id_prs_adresse`, `id_personne`, `id_localite`, `flagtransmis`, `locate`) VALUES (?,?,?,?,?)',

                [
                  row['id_prs_adresse'],
                  row['id_personne'],
                  row['id_localite'],
                  finalDate,
                  ids.first['locate']
                ]);

            await db.rawUpdate(
                'UPDATE `personne_adresse` SET  `flagtransmis`=? WHERE id_prs_adresse=?',
                [finalDate, row['id_prs_adresse']]);
            count++;
            }catch(e){
              print("error ");
            }
          }

          print('personne_adresse ${count}');

        }catch(e){
          print("error from  personne_adresse table " + e.toString());

        }

        try{
          List<Map> personne_fonction =
          await db.rawQuery('SELECT * FROM personne_fonction where flagtransmis=""');

          count = 0;

          for (var row in personne_fonction) {
            try{
            await conn.query(
                'INSERT INTO `personne_fonction`(`id_prs_fonction`, `nom_fonction`, `id_personne`, `flagtransmis`, `locate`) VALUES (?,?,?,?,?)',

                [
                  row['id_prs_fonction'],
                  row['nom_fonction'],
                  row['id_personne'],
                  finalDate,
                  ids.first['locate']
                ]);

            await db.rawUpdate(
                'UPDATE `personne_fonction` SET  `flagtransmis`=? WHERE id_prs_fonction=?',
                [finalDate, row['id_prs_fonction']]);
            count++;
            }catch(e){
              print("error ");
            }
          }

          print('personne_fonction ${count}');

        }catch(e){
          print("error from  personne_fonction table " + e.toString());

        }

        try{
          List<Map> detenteur_plantation =
          await db.rawQuery('SELECT * FROM detenteur_plantation where flagtransmis=""');
          // print(inscription);
          count = 0;

          for (var row in detenteur_plantation) {
            try{
              await conn.query(
                  'INSERT INTO `detenteur_plantation`(`id_det_plantation`, `id_personne`, `id_plantation`, `flagtransmis`, `locate`) VALUES (?,?,?,?,?)',

                  [
                    row['id_det_plantation'],
                    row['id_personne'],
                    row['id_plantation'],
                    finalDate,
                    ids.first['locate']
                  ]);

              await db.rawUpdate(
                  'UPDATE `detenteur_plantation` SET  `flagtransmis`=? WHERE id_det_plantation=?',
                  [finalDate, row['id_det_plantation']]);
              count++;
            }catch(e){
              print("error "+e.toString());
            }
          }

          print(' detenteur plantation ${count}');

        }catch(e){
          print("error from  detenteur plantation table " + e.toString());

        }



        try{
          List<Map> rendement =
          await db.rawQuery('SELECT * FROM rendement where flagtransmis=""');

          count = 0;

          for (var row in rendement) {
            try{
            await conn.query(
                'INSERT INTO `rendement`(`id_rendement`, `quantite`, `date_rendement`,`quantite_semence`, `id_det_plantation`, `id_det_culture`, `flagtransmis`, `locate`) VALUES (?,?,?,?,?,?,?,?)',

                [
                  row['id_rendement'],
                  row['quantite'],
                  row['date_rendement'],
                  row['quantite_semence'],
                  row['id_det_plantation'],
                  row['id_det_culture'],
                  finalDate,
                  ids.first['locate']
                ]);

            await db.rawUpdate(
                'UPDATE `rendement` SET  `flagtransmis`=? WHERE id_rendement=?',
                [finalDate, row['id_rendement']]);
            count++;
            }catch(e){
              print("error "+e.toString());
            }
          }

          print('rendement ${count}');

        }catch(e){
          print("error from  rendement table " + e.toString());

        }

        try{
          List<Map> rendement_elevage =
          await db.rawQuery('SELECT * FROM rendement_elevage where flagtransmis=""');

          count = 0;

          for (var row in rendement_elevage) {
            try{
            await conn.query(
                'INSERT INTO `rendement_elevage`(`id_rendement_elv`, `nbre`, `date_rendement`, `id_elevage`, `flagtransmis`, `locate`) VALUES (?,?,?,?,?,?)',

                [
                  row['id_rendement_elv'],
                  row['nbre'],
                  row['date_rendement'],
                  row['id_elevage'],
                  finalDate,
                  ids.first['locate']
                ]);

            await db.rawUpdate(
                'UPDATE `rendement_elevage` SET  `flagtransmis`=? WHERE id_rendement_elv=?',
                [finalDate, row['id_rendement_elv']]);
            count++;
            }catch(e){
              print("error "+e.toString());
            }
          }

          print('rendement_elevage ${count}');

        }catch(e){
          print("error from  rendement_elevage table " + e.toString());

        }

        try{
          List<Map> biens =
          await db.rawQuery('SELECT * FROM biens where flagtransmis=""');

          count = 0;

          for (var row in biens) {
            try{
            await conn.query(
                'INSERT INTO `biens`(`id_type_bien`, `id_personne`, `id_agent`, `type_bien`, `quantite`, `montant`, `utilisations`, `flagtransmis`, `locate`) VALUES (?,?,?,?,?,?,?,?,?)',
                [
                  row['id_type_bien'],
                  row['id_personne'],
                  row['id_agent'],
                  row['type_bien'],
                  row['quantite'],
                  row['montant'],
                  row['utilisations'],
                  finalDate,
                  ids.first['locate']
                ]);

            await db.rawUpdate(
                'UPDATE `biens` SET  `flagtransmis`=? WHERE id_type_bien=?',
                [finalDate, row['id_type_bien']]);
            count++;
            }catch(e){
              print("error "+e.toString());
            }
          }

          print('biens ${count}');

        }catch(e){
          print("error from  biens table " + e.toString());

        }

        try{
          List<Map> elevage_espece =
          await db.rawQuery('SELECT * FROM elevage_espece where flagtransmis=""');

          count = 0;

          for (var row in elevage_espece) {
            try{
            await conn.query(
                'INSERT INTO `elevage_espece`(`id_elv_espece`, `id_elevage`, `espece`, `flagtransmis`, `locate`) VALUES (?,?,?,?,?)',
                [
                  row['id_elv_espece'],
                  row['id_elevage'],
                  row['espece'],
                  finalDate,
                  ids.first['locate']
                ]);

            await db.rawUpdate(
                'UPDATE `elevage_espece` SET  `flagtransmis`=? WHERE id_elv_espece=?',
                [finalDate, row['id_elv_espece']]);
            count++;
            }catch(e){
              print("error "+e.toString());
            }
          }

          print('elevage_espece ${count}');

        }catch(e){
          print("error from  elevage_espece table " + e.toString());

        }

        try{
          List<Map> services_recus =
          await db.rawQuery('SELECT * FROM services_recus where flagtransmis=""');

          count = 0;

          for (var row in services_recus) {
            try{
            await conn.query(
                'INSERT INTO `services_recus`(`id_service`, `id_personne`, `id_agent`, `type_service`, `modules`, `nombre_jours`, `resultats`, `lieux`, `objectif`, `flagtransmis`, `locate`) VALUES  (?,?,?,?,?,?,?,?,?,?,?)',
                [
                  row['id_service'],
                  row['id_personne'],
                  row['id_agent'],
                  row['type_service'],
                  row['modules'],
                  row['nombre_jours'],
                  row['resultats'],
                  row['lieux'],
                  row['objectif'],
                  finalDate,
                  ids.first['locate']
                ]);

            await db.rawUpdate(
                'UPDATE `services_recus` SET  `flagtransmis`=? WHERE id_service=?',
                [finalDate, row['id_service']]);
            count++;
            }catch(e){
              print("error "+e.toString());
            }
          }

          print('services_recus ${count}');

        }catch(e){
          print("error from  services_recus table " + e.toString());

        }


        try{
          List<Map> subvention =
          await db.rawQuery('SELECT * FROM subvention where flagtransmis=""');

          count = 0;

          for (var row in subvention) {
            try{
            await conn.query(
                'INSERT INTO `subvention`(`id_subvention`, `id_personne`, `id_agent`, `montant`, `titre_projet`, `duree_projet`, `zones`, `objectif`, `apport_projet`, `flagtransmis`, `locate`) VALUES   (?,?,?,?,?,?,?,?,?,?,?)',
                [
                  row['id_subvention'],
                  row['id_personne'],
                  row['id_agent'],
                  row['montant'],
                  row['titre_projet'],
                  row['duree_projet'],
                  row['zones'],
                  row['objectif'],
                  row['apport_projet'],
                  finalDate,
                  ids.first['locate']
                ]);

            await db.rawUpdate(
                'UPDATE `subvention` SET  `flagtransmis`=? WHERE id_service=?',
                [finalDate, row['id_service']]);
            count++;
            }catch(e){
              print("error "+e.toString());
            }
          }

          print('subvention ${count}');

        }catch(e){
          print("error from  subvention table " + e.toString());

        }

        try{
          List<Map> membre_elevage =
          await db.rawQuery('SELECT * FROM membre_elevage where flagtransmis=""');

          count = 0;

          for (var row in membre_elevage) {
            try{
              await conn.query(
                  'INSERT INTO `membre_elevage`(`id_mb_elevage`, `id_personne`, id_elevage, `flagtransmis`, `locate`) VALUES   (?,?,?,?,?)',
                  [
                    row['id_mb_elevage'],
                    row['id_personne'],
                    row['id_elevage'],
                    finalDate,
                    ids.first['locate']
                  ]);

              await db.rawUpdate(
                  'UPDATE `membre_elevage` SET  `flagtransmis`=? WHERE id_mb_elevage=?',
                  [finalDate, row['id_mb_elevage']]);
              count++;
            }catch(e){
              print("error ");
            }
          }

          print('membre_elevage ${count}');

        }catch(e){
          print("error from  membre_elevage table " + e.toString());

        }







      }
        await conn.close();
    }catch(e){
    print("error tables"+e.toString());
    }finally{
        //Duration temps = new Duration(hours:0, minutes:1, seconds:00);

        Future.delayed(const Duration(seconds: 60),()=> connect());
      }

    }

  }

  synchronize() {
    connect();
  }
}
