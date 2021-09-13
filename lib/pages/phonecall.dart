import 'dart:async';
import 'dart:io' as io;
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:bmapp/database/database.dart';
import 'package:bmapp/database/storageUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_string/random_string.dart';



class Phone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Call Center'),
        centerTitle: true,
      ),
      body: PhoneCall(),
    );
  }
}

class PhoneCall extends StatefulWidget {
  @override
  _PhoneCallState createState() => _PhoneCallState();
}

class _PhoneCallState extends State<PhoneCall> {
  //voice recorder var
  FlutterAudioRecorder _recorder;
  Recording _recording;
  Timer _t;
  Widget _buttonIcon = Icon(Icons.do_not_disturb_on);
  String _alert;
  //audio
  String iud = StorageUtil.getString("iud");
  String _iud = "";
  String nfc = "";
  //
  AudioPlayer player = AudioPlayer();

  @override
  void dispose() async{
    // TODO: implement dispose
    super.dispose();
    if(nom_v != null){
      var _vocal = await DB.queryVocal(nom_v);
      if (_vocal.isEmpty){
        File audio = File("/storage/emulated/0/Android/data/com.tulipind.bmapp/files/$nom_v");
        await audio.delete();
      }
    }
  }

  //
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _prepare();
    });
  }

  //void
  void _opt(DragEndDetails details) async {
    switch (_recording.status) {
      case RecordingStatus.Initialized:
        {
          await _startRecording();
          break;
        }
      case RecordingStatus.Recording:
        {
          await _stopRecording();
          break;
        }
      case RecordingStatus.Stopped:
        {
          //await _prepare();
          //await _startRecording();
          break;
        }

      default:
        break;
    }

    //
    setState(() {
      _buttonIcon = _playerIcon(_recording.status);
    });
  }

  var nom_v;
  compteur(){
    var nom_vocal = DateTime.now().millisecondsSinceEpoch.toString()+".wav";
    return nom_vocal;
  }

  //Future ini
  Future _init() async {

    if(nom_v != null){
      var _vocal = await DB.queryVocal(nom_v);
      if (_vocal.isEmpty){
        File audio = File("/storage/emulated/0/Android/data/com.tulipind.bmapp/files/$nom_v");
        await audio.delete();
      }
    }

    nom_v = compteur();
    String customPath = '/'+
        nom_v;
    io.Directory appDocDirectory;
    if (io.Platform.isIOS) {
      appDocDirectory = await getApplicationDocumentsDirectory();
    } else {
      appDocDirectory = await getExternalStorageDirectory();
    }

    // can add extension like ".mp4" ".wav" ".m4a" ".aac"
    customPath = appDocDirectory.path +
        customPath;

    // .wav <---> AudioFormat.WAV
    // .mp4 .m4a .aac <---> AudioFormat.AAC
    // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.

    _recorder = FlutterAudioRecorder(customPath,
        audioFormat: AudioFormat.WAV, sampleRate: 22050);
    await _recorder.initialized;
  }


  //prepare
  Future _prepare() async {
    var hasPermission = await FlutterAudioRecorder.hasPermissions;
    if (hasPermission) {
      await _init();
      var result = await _recorder.current();
      setState(() {
        _recording = result;
        _buttonIcon = _playerIcon(_recording.status);
        _alert = "";
      });
    } else {
      setState(() {
        _alert = "Permission Required.";
      });
    }
  }

  //start recorder
  Future _startRecording() async {
    await _recorder.start();
    var current = await _recorder.current();
    setState(() {
      _recording = current;
    });

    _t = Timer.periodic(Duration(milliseconds: 10), (Timer t) async {
      var current = await _recorder.current();
      setState(() {
        _recording = current;
        _t = t;
      });
    });
  }

  //stop
  Future _stopRecording() async {
    var result = await _recorder.stop();
    _t.cancel();

    setState(() {
      _recording = result;
    });
  }

  //play
  void _play() {
    player.play(_recording.path, isLocal: true);
  }

  //pause
  void _pause() {
    player.pause();
  }

  //_send
  void _send() async{
    //le boutton d'envois
    //customPath +
    //DateTime.now().millisecondsSinceEpoch.toString()
    //Insert info song
    var _tab = await DB.initTabquery();
    if(_tab.isNotEmpty){
      //var
      var _tab = await DB.initTabquery();
      String idvocalgen = _tab[0]["device"]+"-"+randomAlphaNumeric(10);
      var dateNow = DateTime.now();
      //String nom_audio = _tab[0]["device"]+"-"+iud+"-"+dateNow;
      //
      var _vocal = await DB.queryVocal(nom_v);
      if (_vocal.isNotEmpty){

        Fluttertoast.showToast(
            msg: "Votre message a déjà été envoyé !",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );

      } else {
        //
        if (nfc != ""){
          //Verification de l'uid de l'utilisateur
          var ifPersonneExist = await DB.queryWhereUid("personne", nfc);
          //Conditionnnement d'enregistrement
          if(ifPersonneExist.isNotEmpty){
            //Si il est beneficiaire du programme
            await DB.insert("fichier_audio", {
              "id": idvocalgen,
              "uid": nfc,
              "nom_audio": nom_v,
              "date_audio": dateNow.toString(),
              "flagtransmis": "false",
            });

            Fluttertoast.showToast(
                msg: "Votre message a bien été envoyer",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 5,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0
            );

          } else {

            Fluttertoast.showToast(
                msg: "Bracelets non enregistrer !",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 5,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );

          }
        } else {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Authentification"),
                content: Text(
                  'Veuillez Scanner votre bracelet pour confirmer votre identité', style: TextStyle(color: Colors.green,),),
                actions: <Widget>[
                  FlatButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop('oui');
                    },
                  ),
                ],
                //shape: CircleBorder(),
              );
            },
          );
        }
        /*
        if(iud == ""){
          //
        } else {
          await DB.insert("fichier_audio", {
            "id": idvocalgen,
            "iud": iud,
            "nom_audio": nom_v,
            "date_audio": dateNow.toString(),
            "flagtransmis": "false",
          });
          Scaffold
              .of(context)
              .showSnackBar(SnackBar(content: Text(
              'Message Envoyer merci !')));
        }
        */
      }

    } else {

      Fluttertoast.showToast(
          msg: "La tablette n\'a pas d\'identifiant !!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  //play icon
  Widget _playerIcon(RecordingStatus status) {
    switch (status) {
      case RecordingStatus.Initialized:
        {
          //Icon(Icons.settings_voice)
          return Image.asset("images/mic_green.png");
        }
      case RecordingStatus.Recording:
        {
          //Icon(Icons.stop)
          return Image.asset("images/mic_red.png");
        }
      case RecordingStatus.Stopped:
        {
          //Icon(Icons.settings_voice)
          return Image.asset("images/mic_green.png");
        }
      default:
        return Icon(Icons.do_not_disturb_on);
    }
  }

  @override
  Widget build(BuildContext context) {
    //nfc
    FlutterNfcReader.read().then((response) {
      //print(response.id.substring(2));
      _iud = response.id.substring(2);
      nfc = _iud.toUpperCase();
    });

    return Container(
      child: Center(
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RaisedButton(
                child: Text('Ecouter'),
                disabledTextColor: Colors.white,
                disabledColor: Colors.grey.withOpacity(0.5),
                onPressed: _recording?.status == RecordingStatus.Stopped
                    ? _play
                    : null,
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                children: <Widget>[
                  Text('Enregistrement: ${_recording?.duration ?? "-"}'),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    child: _buttonIcon,
                    //onTapDown: _opt,
                    onHorizontalDragDown: (DragDownDetails details) async {
                      switch (_recording.status) {
                        case RecordingStatus.Initialized:
                          {
                            await _startRecording();
                            break;
                          }
                        case RecordingStatus.Recording:
                          {
                            await _stopRecording();
                            break;
                          }
                        case RecordingStatus.Stopped:
                          {
                            await _prepare();
                            await _startRecording();
                            break;
                          }

                        default:
                          break;
                      }

                      //
                      setState(() {
                        _buttonIcon = _playerIcon(_recording.status);
                      });
                    },
                    onHorizontalDragEnd: _opt,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  RaisedButton(
                    child: Text("Envoyer"),
                    disabledTextColor: Colors.white,
                    disabledColor: Colors.grey.withOpacity(0.5),
                    onPressed: _recording?.status == RecordingStatus.Stopped
                        ? _send
                        : null,
                  ),
                ],
              ),
              SizedBox(
                width: 20,
              ),
              RaisedButton(
                child: Text("pause"),
                disabledTextColor: Colors.white,
                disabledColor: Colors.grey.withOpacity(0.5),
                onPressed: _recording?.status == RecordingStatus.Stopped
                    ? _pause
                    : null,
              ),
              Text(''),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '${_alert ?? ""}',
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
