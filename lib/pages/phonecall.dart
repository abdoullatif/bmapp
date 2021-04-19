import 'dart:async';
import 'dart:io' as io;
import 'package:audioplayers/audioplayers.dart';
import 'package:bmapp/database/database.dart';
import 'package:bmapp/database/storageUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
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
  //voice recorder fonc
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
        Scaffold
            .of(context)
            .showSnackBar(SnackBar(content: Text(
            'Votre message a déjà été envoyé !')));
      } else {
        print(nfc);
        if (nfc != ""){
          await DB.insert("fichier_audio", {
            "id": idvocalgen,
            "iud": nfc,
            "nom_audio": nom_v,
            "date_audio": dateNow.toString(),
            "flagtransmis": "false",
          });
          Scaffold
              .of(context)
              .showSnackBar(SnackBar(content: Text(
              'Message Envoyer merci !!')));
        } else {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Authentification"),
                content: Text(
                  'Veuillez Scanner votre bracelet pour confirmer votre identite', style: TextStyle(color: Colors.green,),),
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
      print('pas de donnee parametre');
      Scaffold
          .of(context)
          .showSnackBar(SnackBar(content: Text(
          'La tablette n\'a pas d\'identifiant !!')));
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
  //

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
