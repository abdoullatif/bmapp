//package native
import 'dart:async';
//pakage importer pub get
import 'package:sqflite/sqflite.dart';
//import 'package:path/path.dart';
//import 'package:path_provider/path_provider.dart';

//Code
class DB{
  static Database _db;
  static int get _version => 1;

  static Future<void> init() async{
    if (_db != null) return;
    try{
      String _path = await getDatabasesPath() + 'bmdb';
      print("succes");
      print(_path);
      _db = (await openDatabase(_path, version: _version, onCreate: onCreate)) as Database;
    } catch (ex){
      print(ex);
    }
  }
  static void onCreate(Database db, int version) async{
    //------------------------------Parametre de la tablette------------------------
    //table parametre
    await db.execute('''
    CREATE TABLE parametre(
    id INTEGER PRIMARY KEY,
    device TEXT,
    locate TEXT,
    dbname TEXT,
    user TEXT,
    mdp TEXT,
    adresse_server TEXT,
    ip_server TEXT,
    site_pdaig TEXT,
    langue TEXT)
    ''');
    //table Campagne Agricole
    await db.execute('''
    CREATE TABLE campagne_agricole(
    id INTEGER PRIMARY KEY,
    description TEXT)
    ''');
    //table langue
    await db.execute('''
    CREATE TABLE langues(
    id TEXT,
    description TEXT,
    flagtransmis TEXT)
    ''');
    //-----------------------------Enregitrer une personne------------------------
    //table personne
    await db.execute('''
    CREATE TABLE personne(
    id_personne TEXT PRIMARY KEY,
    nom_personne TEXT,
    prenom_personne TEXT,
    tel_personne TEXT,
    genre TEXT,
    age TEXT,
    menage TEXT,
    liens TEXT,
    uids TEXT,
    email TEXT,
    mdp TEXT,
    images TEXT,
    flagtransmis TEXT)
    ''');
    //Table Adresse
    await db.execute('''
    CREATE TABLE personne_adresse(
    id_prs_adresse TEXT PRIMARY KEY,
    id_personne TEXT,
    id_localite TEXT,
    flagtransmis TEXT)
    ''');
    //personne fonction
    await db.execute('''
    CREATE TABLE personne_fonction(
    id_prs_fonction TEXT PRIMARY KEY,
    nom_fonction TEXT,
    id_personne TEXT,
    flagtransmis TEXT)
    ''');
    //---------------------------------------localite----------------------------
    //table localite
    await db.execute('''
    CREATE TABLE localite(
    id_localite TEXT PRIMARY KEY,
    descriptions TEXT,
    longitude TEXT,
    latitude TEXT,
    pays TEXT,
    type_localite TEXT,
    flagtransmis TEXT)
    ''');
    //table prefecture
    await db.execute('''
    CREATE TABLE prefecture(
    id_prefecture TEXT PRIMARY KEY,
    id_region TEXT,
    nom_prefecture TEXT,
    flagtransmis TEXT)
    ''');
    //table Regions
    await db.execute('''
    CREATE TABLE region(
    id_region TEXT PRIMARY KEY,
    nom_region TEXT,
    flagtransmis TEXT)
    ''');
    //-------------------------------------Rendement----------------------------
    //table rendement
    await db.execute('''
    CREATE TABLE rendement(
    id_rendement TEXT PRIMARY KEY,
    quantite TEXT,
    quantite_semence TEXT,
    date_rendement TEXT,
    id_det_plantation TEXT,
    id_det_culture TEXT,
    flagtransmis TEXT)
    ''');
    //table rendement elevage
    await db.execute('''
    CREATE TABLE rendement_elevage(
    id_rendement_elv TEXT PRIMARY KEY,
    nbre TEXT,
    date_rendement TEXT,
    id_elevage TEXT,
    flagtransmis TEXT)
    ''');
    //------------------------------Services----------------------------------
    //table Service_rendu
    await db.execute('''
    CREATE TABLE services_recus(
    id_service TEXT PRIMARY KEY,
    id_personne TEXT,
    id_agent TEXT,
    type_service TEXT,
    modules TEXT,
    nombre_jours TEXT,
    resultats TEXT,
    lieux TEXT,
    objectif TEXT,
    flagtransmis TEXT)
    ''');
    //Biens
    //table Service_rendu
    await db.execute('''
    CREATE TABLE biens(
    id_type_bien TEXT PRIMARY KEY,
    id_personne TEXT,
    id_agent TEXT,
    type_bien TEXT,
    nature TEXT,
    quantite TEXT,
    montant TEXT,
    utilisations TEXT,
    flagtransmis TEXT)
    ''');
    //table Sous_prefecture
    await db.execute('''
    CREATE TABLE sous_prefecture(
    id_s_prefecture TEXT PRIMARY KEY,
    id_prefecture TEXT,
    nom_s_prefecture TEXT,
    flagtransmis TEXT)
    ''');
    //----------------------------subvention----------------------------------
    //Subvention
    await db.execute('''
    CREATE TABLE subvention(
    id_subvention TEXT PRIMARY KEY,
    id_personne TEXT,
    id_agent TEXT,
    montant TEXT,
    titre_projet TEXT,
    duree_projet TEXT,
    zones TEXT,
    objectif TEXT,
    apport_projet TEXT,
    flagtransmis TEXT)
    ''');
    //-------------------Enregitrer un Agriculteur----------------------------
    //table detenteur_plantation
    await db.execute('''
    CREATE TABLE detenteur_plantation(
    id_det_plantation TEXT PRIMARY KEY,
    id_personne TEXT,
    id_plantation TEXT,
    flagtransmis TEXT)
    ''');
    //table plantation
    await db.execute('''
    CREATE TABLE plantation(
    id_plantation TEXT PRIMARY KEY,
    desc_plantation TEXT,
    superficie TEXT,
    longitude TEXT,
    latitude TEXT,
    id_localite TEXT,
    type_exploitation TEXT,
    flagtransmis TEXT)
    ''');
    //table detenteur_culture
    await db.execute('''
    CREATE TABLE detenteur_culture(
    id_det_culture TEXT PRIMARY KEY,
    id_plantation TEXT,
    id_culture TEXT,
    campagneAgricole TEXT,
    flagtransmis TEXT)
    ''');
    //table culture
    await db.execute('''
    CREATE TABLE culture(
    id_culture TEXT PRIMARY KEY,
    nom_culture TEXT,
    code TEXT,
    flagtransmis TEXT)
    ''');
    //------------------------Enregistrer un eleveur---------------------
    //table elevage
    await db.execute('''
    CREATE TABLE elevage(
    id_elevage TEXT PRIMARY KEY,
    type_elevage TEXT,
    id_localite TEXT,
    type_exploitation TEXT,
    forme_exploitation TEXT,
    superficie TEXT,
    flagtransmis TEXT)
    ''');
    //table espece elevage
    await db.execute('''
    CREATE TABLE elevage_espece(
    id_elv_espece TEXT PRIMARY KEY,
    id_elevage TEXT,
    espece TEXT,
    flagtransmis TEXT)
    ''');
    //table espece
    await db.execute('''
    CREATE TABLE especes(
    id_espece TEXT PRIMARY KEY,
    nom_espece TEXT,
    flagtransmis TEXT)
    ''');
    //------------------------Groupement---------------------------------------
    //table groupement
    await db.execute('''
    CREATE TABLE groupement(
    id_groupement TEXT PRIMARY KEY,
    nom_groupement TEXT,
    id_localite TEXT,
    activite_groupement TEXT,
    id_union TEXT,
    flagtransmis TEXT)
    ''');
    //table membre groupement
    await db.execute('''
    CREATE TABLE membre_groupement(
    id_mb_groupement TEXT PRIMARY KEY,
    id_personne TEXT,
    id_groupement TEXT,
    statu TEXT,
    flagtransmis TEXT)
    ''');
    //table membre elevage
    await db.execute('''
    CREATE TABLE membre_elevage(
    id_mb_elevage TEXT PRIMARY KEY,
    id_personne TEXT,
    id_elevage TEXT,
    flagtransmis TEXT)
    ''');
    //------------------------Table Media---------------------------------------
    //table media
    await db.execute('''
    CREATE TABLE media(
    id INTEGER PRIMARY KEY,
    media_title TEXT,
    media_lang TEXT,
    media_categorie TEXT,
    media_sous_categorie TEXT,
    media_file TEXT,
    flagtransmis TEXT)
    ''');
    //table categories
    await db.execute('''
    CREATE TABLE categories(
    id TEXT PRIMARY KEY,
    nom_categ TEXT,
    flagtransmis TEXT)
    ''');
    //--------------------------------------------Audio-------------------------
    //table fichier audio
    await db.execute('''
    CREATE TABLE fichier_audio(
    id TEXT PRIMARY KEY,
    uid TEXT,
    nom_audio TEXT,
    date_audio TEXT,
    flagtransmis TEXT)
    ''');
    //---------------------------------------federation, confederation, union----------
    //table federation;
    await db.execute('''
    CREATE TABLE federation(
    id_fed TEXT PRIMARY KEY,
    id_conf TEXT,
    description_fed TEXT,
    flagtransmis TEXT)
    ''');
    //table fichier audio
    await db.execute('''
    CREATE TABLE confederation(
    id_conf TEXT PRIMARY KEY,
    description_conf TEXT,
    flagtransmis TEXT)
    ''');
    //table fichier audio
    await db.execute('''
    CREATE TABLE unions(
    id_un TEXT PRIMARY KEY,
    id_fed TEXT,
    description_un TEXT,
    flagtransmis TEXT)
    ''');

  }

  //----------------------------------------------------------------------------------------------------------------------------------------
  //Liste des utilisateur ou beneficiaire
  static Future<List<Map<String, dynamic>>> queryUser(String id_localite) async => await _db.rawQuery('SELECT personne.id_personne AS id_personne,* FROM personne,personne_fonction,personne_adresse WHERE personne.id_personne = personne_fonction.id_personne and personne.id_personne = personne_adresse.id_personne and personne_fonction.nom_fonction in ("CAG","AG","CE","E") and personne_adresse.id_localite = "$id_localite"');
  //Liste des utlisateur enfonction du comboBox
  static Future<List<Map<String, dynamic>>> queryUserComboEl(String id_localite,String select) async => await _db.rawQuery('SELECT personne.id_personne AS id_personne,* FROM personne,personne_fonction,personne_adresse WHERE personne.id_personne = personne_fonction.id_personne and personne.id_personne = personne_adresse.id_personne and personne_fonction.nom_fonction in ("CE","E") and personne_adresse.id_localite = "$id_localite"');

  //Liste user agriculteur
  static Future<List<Map<String, dynamic>>> queryUserComboAG(String id_localite,String select) async => await _db.rawQuery('SELECT personne.id_personne AS id_personne,* FROM personne,personne_fonction,personne_adresse WHERE personne.id_personne = personne_fonction.id_personne and personne.id_personne = personne_adresse.id_personne and personne_fonction.nom_fonction in ("CAG","AG") and personne_adresse.id_localite = "$id_localite"');


  //Liste des utilisation
  static Future<List<Map<String, dynamic>>> queryPlantation(String id_localite) async => await _db.rawQuery('SELECT personne.id_personne AS id_personne,* FROM personne,personne_fonction,personne_adresse,detenteur_plantation,plantation WHERE personne.id_personne = personne_fonction.id_personne and personne_fonction.nom_fonction = "CAG" and personne.id_personne = personne_adresse.id_personne and personne.id_personne = detenteur_plantation.id_personne and detenteur_plantation.id_plantation = plantation.id_plantation and personne_adresse.id_localite = "$id_localite"');
  //Profile CHEF CAG
  static Future<List<Map<String, dynamic>>> queryUserAgriculteur(String id) async => await _db.rawQuery('SELECT personne.id_personne AS id_personne,* FROM personne,personne_fonction,personne_adresse,plantation,detenteur_culture,detenteur_plantation,localite WHERE personne.id_personne = "$id" and personne.id_personne = personne_fonction.id_personne and personne_adresse.id_personne = personne.id_personne and personne_adresse.id_localite = localite.id_localite and personne.id_personne = detenteur_plantation.id_personne and plantation.id_plantation = detenteur_plantation.id_plantation and plantation.id_plantation = detenteur_culture.id_plantation');
  //PROFILE AG
  static Future<List<Map<String, dynamic>>> queryUserAgriculteurAG(String id) async => await _db.rawQuery('SELECT personne.id_personne AS id_personne,* FROM personne,personne_fonction,personne_adresse,detenteur_plantation,plantation,detenteur_culture,localite WHERE personne.id_personne = "$id" and personne.id_personne = personne_fonction.id_personne and personne_adresse.id_personne = personne.id_personne and personne_adresse.id_localite = localite.id_localite and personne.id_personne = detenteur_plantation.id_personne and detenteur_plantation.id_plantation = plantation.id_plantation and plantation.id_plantation = detenteur_culture.id_plantation');
  //profile Eleveur
  static Future<List<Map<String, dynamic>>> queryUserEleveur(String id) async => await _db.rawQuery('SELECT personne.id_personne AS id_personne,* FROM personne,personne_fonction,personne_adresse,membre_elevage,elevage,localite,culture WHERE personne.id_personne = "$id" and personne.id_personne = personne_fonction.id_personne and personne_adresse.id_personne = personne.id_personne and personne.id_personne = membre_elevage.id_personne and membre_elevage.id_elevage = elevage.id_elevage and personne_adresse.id_localite = localite.id_localite and elevage.type_elevage = culture.id_culture');
  //Selection des Culture
  static Future<List<Map<String, dynamic>>> queryCulture(String id_plantation, String campagne) async => await _db.rawQuery('select detenteur_culture.id_det_culture AS id_c,* from plantation,detenteur_culture,culture where plantation.id_plantation = detenteur_culture.id_plantation AND detenteur_culture.id_culture = culture.id_culture AND plantation.id_plantation="$id_plantation" AND culture.code="AG" and detenteur_culture.campagneAgricole = "$campagne"');// group by culture.id_culture

  //Selection des rendement
  static Future<List<Map<String, dynamic>>> queryRendement(String idplantation,String id_det_culture) async => await _db.rawQuery('select * from detenteur_culture join rendement on detenteur_culture.id_det_culture = rendement.id_det_culture where detenteur_culture.id_det_culture = "$id_det_culture" AND detenteur_culture.id_plantation = "$idplantation"');

  //Selection des espece
  static Future<List<Map<String, dynamic>>> querySelectQteS(String id_plantation,String id_culture) async => await _db.rawQuery('SELECT * FROM detenteur_culture,rendement WHERE detenteur_culture.id_plantation = "$id_plantation" AND detenteur_culture.id_culture= "$id_culture" AND detenteur_culture.id_det_culture = rendement.id_det_culture order by date_rendement desc Limit 1');

  //Selection des espece
  static Future<List<Map<String, dynamic>>> queryIdDetCult(String id_plantation,String id_culture) async => await _db.rawQuery('SELECT * FROM detenteur_culture WHERE id_plantation = "$id_plantation" AND id_culture= "$id_culture"');
  //Verification du chef de groupement
  static Future<List<Map<String, dynamic>>> queryMbreGrp(String id_personne) async => await _db.rawQuery('SELECT * FROM membre_groupement WHERE membre_groupement.id_personne = "$id_personne" and statu = "Chef"');
  //Selection des espece
  static Future<List<Map<String, dynamic>>> queryEspece(String id_elevage) async => await _db.rawQuery('SELECT * FROM elevage_espece WHERE elevage_espece.id_elevage = "$id_elevage"');
  //Selection des culture en fonction des utilisateur
  static Future<List<Map<String, dynamic>>> querySelectMyCulture(String code, String plantation, String campagne) async => await _db.rawQuery('SELECT * FROM detenteur_culture,culture,plantation WHERE plantation.id_plantation = "$plantation" and detenteur_culture.id_culture = culture.id_culture and detenteur_culture.id_plantation = plantation.id_plantation and code = "$code" and detenteur_culture.campagneAgricole = "$campagne"');
  static Future<List<Map<String, dynamic>>> querySelectCultureSuivit(String code, String plantation, String campagne) async => await _db.rawQuery('SELECT * FROM culture WHERE culture.code = "$code" and culture.id_culture NOT IN (SELECT id_culture FROM detenteur_culture WHERE id_plantation = "$plantation" and campagneAgricole = "$campagne")');
  static Future<List<Map<String, dynamic>>> querySelectCulture(String code) async => await _db.rawQuery('SELECT * FROM culture WHERE code = "$code"');
  static Future<List<Map<String, dynamic>>> querySelectCult(String nom_culture) async => await _db.rawQuery('SELECT * FROM culture WHERE nom_culture = "$nom_culture"');
  //Section des membre de groupement
  static Future<List<Map<String, dynamic>>> querychefgroup() async => await _db.rawQuery('SELECT personne.id_personne AS id_personne,* FROM personne,personne_fonction,personne_adresse WHERE personne.id_personne = personne_fonction.id_personne and personne.id_personne = personne_adresse.id_personne and personne_fonction.nom_fonction in ("C","CE","CAG","AG")');

  //Section des GROUPEMENT DANS LE PANNEL
  static Future<List<Map<String, dynamic>>> querygroupunion() async => await _db.rawQuery('SELECT * FROM groupement,unions WHERE groupement.id_union = unions.id_un');

  static Future<List<Map<String, dynamic>>> querygroupunionuser(String idpersonne) async => await _db.rawQuery('SELECT * FROM membre_groupement,groupement,unions WHERE groupement.id_union = unions.id_un and membre_groupement.id_personne = "$idpersonne" and membre_groupement.id_groupement = groupement.id_groupement');

  static Future<List<Map<String, dynamic>>> querygroupuser(String idpersonne) async => await _db.rawQuery('SELECT * FROM membre_groupement,groupement,unions WHERE groupement.id_union = unions.id_un and membre_groupement.id_personne = "$idpersonne" and membre_groupement.id_groupement = groupement.id_groupement and "$idpersonne" NOT IN (SELECT id_personne FROM membre_groupement)');


  //Selection des chef eleveur Ferme
  static Future<List<Map<String, dynamic>>> queryFerme(String id_localite) async => await _db.rawQuery('SELECT personne.id_personne AS id_personne,* FROM personne,personne_fonction,personne_adresse,membre_elevage,elevage WHERE personne.id_personne = personne_fonction.id_personne and personne.id_personne = personne_adresse.id_personne and personne_fonction.nom_fonction = "CE" and personne.id_personne = membre_elevage.id_personne and membre_elevage.id_elevage = elevage.id_elevage and personne_adresse.id_localite = "$id_localite"');
  //Verification groupement
  //static Future<List<Map<String, dynamic>>> queryverifgroupmnt(String id_personne) async => await _db.rawQuery('SELECT * FROM membre_groupement WHERE id_personne = "$id_personne"');
  static Future<List<Map<String, dynamic>>> querycountgroupmnt(String id_personne) async => await _db.rawQuery('SELECT COUNT(id) AS nmbre_groupment FROM membre_groupement WHERE id_personne = "$id_personne"');
  static Future<List<Map<String, dynamic>>> queryverifgroupmnt(String id_personne, String group) async => await _db.rawQuery('SELECT * FROM membre_groupement WHERE id_personne = "$id_personne" AND id_groupement = "$group"');
  static Future<List<Map<String, dynamic>>> queryverifgroupmntChef(String id_personne, String group) async => await _db.rawQuery('SELECT * FROM membre_groupement WHERE id_personne = "$id_personne" AND id_groupement = "$group" AND statu = "Chef"');
  //Selection des donnees d'un agent
  static Future<List<Map<String, dynamic>>> queryAgent(String id_personne) async => await _db.rawQuery('SELECT personne.id_personne AS id_personne,* FROM personne,personne_fonction,personne_adresse,localite WHERE personne.id_personne = "$id_personne" and personne.id_personne = personne_fonction.id_personne and personne.id_personne = personne_adresse.id_personne and personne_adresse.id_localite = localite.id_localite');

  //----------------------------------------------------------------------------------------------------------------------------------------
  //Select Were
  static Future<List<Map<String, dynamic>>> queryWherelocalite(String table,String id) async => await _db.query(table, where: 'descriptions = ?', whereArgs: [id]);
  //Query where locate
  static Future<List<Map<String, dynamic>>> queryWherelocate(String table,String locate) async => await _db.query(table, where: 'descriptions = ?', whereArgs: [locate]);

  //------------------------------------------------------------------------------------------------------------------------------------------

  //Recuperation des info dans la Campagne agricole
  static Future<List<Map<String, dynamic>>> queryCampagne() async => await _db.rawQuery('SELECT * FROM campagne_agricole order by id desc limit 1');

  //------------------------------------------------------------------------------------------------------------------------------------------
  //Serache personne
  static Future<List<Map<String, dynamic>>> querySearch(String idloc, String query) async => await _db.rawQuery('SELECT personne.id_personne AS id_personne,* FROM personne,personne_fonction,personne_adresse WHERE personne.id_personne = personne_fonction.id_personne and personne.id_personne = personne_adresse.id_personne and personne_fonction.nom_fonction in ("CAG","AG","CE","E") and personne_adresse.id_localite = "$idloc" and (nom_personne Like "%$query%" OR prenom_personne Like "%$query%")');



  //----------------------------------------------------------------------------------------------------------------------------------------

  static Future<List<Map<String, dynamic>>> queryAll(String table) async => _db.query(table);

  static Future<int> insert(String table, Map<String, dynamic> model) async => await _db.insert(table, model);

  static Future<int> update(String table, Map<String, dynamic> model,int id) async => await _db.update(table, model, where: 'id = ?', whereArgs: [id]);

  //Select Were
  static Future<List<Map<String, dynamic>>> queryWhere(String table,String id) async => await _db.query(table, where: 'id_localite = ?', whereArgs: [id]);

  //Select 2 deux Were
  static Future<List<Map<String, dynamic>>> query2Where(String table, String email, String mdp) async => await _db.query(table, where: 'email = ? and mdp = ?', whereArgs: [email,mdp]);

  //Select 3 trois Were
  static Future<List<Map<String, dynamic>>> query3Where(String table, String email, String mdp, String uids) async => await _db.query(table, where: 'email = ? and mdp = ? and uids = ?', whereArgs: [email,mdp,uids]);

  //Select 1 un Were uid
  static Future<List<Map<String, dynamic>>> queryWhereUid(String table, String uid) async => await _db.query(table, where: 'uids = ?', whereArgs: [uid]);

  //Select Were
  static Future<List<Map<String, dynamic>>> queryCodif(String table,String entite) async => await _db.query(table, where: 'entite = ?', whereArgs: [entite]);

  //Select 2 deux Were codif
  static Future<List<Map<String, dynamic>>> queryCodif2Where(String table, String entite, String param) async => await _db.query(table, where: 'entite = ? and desc_crt = ?', whereArgs: [entite,param]);

  //Select 2 deux Were codif
  static Future<List<Map<String, dynamic>>> queryparam2Where(String table, String param1, String param2) async => await _db.query(table, where: 'entite = ? and categories = ?', whereArgs: [param1,param2]);

  //initial qurey tab
  static Future<List<Map<String, dynamic>>> initTabquery() async => await DB.queryAll("parametre");

  //les Requet preparer commencemet personne ...

  //Select Were ippersonne
  static Future<List<Map<String, dynamic>>> queryWhereidpersonne(String table,String id) async => await _db.query(table, where: 'id_personne = ?', whereArgs: [id]);

  //*************************************************************************************************************************************************
  //|          Media Querie
  //*************************************************************************************************************************************************
  //Select media video presentation max 1
  static Future<List<Map<String, dynamic>>> queryMediaCateg(String categorie, String lang) async => await _db.rawQuery('SELECT * FROM media WHERE media_categorie = "$categorie" and media_lang = "$lang" and media_sous_categorie = "presentation" ORDER BY id DESC LIMIT 1');//ifnull(length(media_sous_categorie), 1) = 1 or ifnull(length(media_sous_categorie), 0) = 0

  //Select Video Sous categories max 6
  static Future<List<Map<String, dynamic>>> queryMediaCategAll(String categorie, String lang) async => await _db.rawQuery('SELECT * FROM media WHERE media_categorie = "$categorie" and media_lang = "$lang" ORDER BY id DESC LIMIT 6');

  //Select Video Sous categories max 6
  static Future<List<Map<String, dynamic>>> queryMediaScateg(String categorie, String scateg, String lang) async => await _db.rawQuery('SELECT * FROM media WHERE media_categorie = "$categorie" and media_sous_categorie = "$scateg" and media_lang = "$lang" ORDER BY id DESC LIMIT 6');

  //Select Video Sous categories max 6
  static Future<List<Map<String, dynamic>>> queryMediaScategAliment(String categorie, String scateg, String lang) async => await _db.rawQuery('SELECT * FROM media WHERE media_categorie = "$categorie" and media_sous_categorie = "$scateg" and media_lang = "$lang" ORDER BY id DESC LIMIT 1');

  //Select Video
  static Future<List<Map<String, dynamic>>> queryMedia(int id) async => await _db.rawQuery('SELECT * FROM media WHERE id = "$id"');

  //*************************************************************************************************************************************************
  //|          Vocale Querie
  //*************************************************************************************************************************************************

  //Select Video
  static Future<List<Map<String, dynamic>>> queryVocal(String nom_audio) async => await _db.rawQuery('SELECT * FROM fichier_audio WHERE nom_audio = "$nom_audio"');



}