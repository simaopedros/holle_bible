import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider{

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _messagemStreamController = StreamController<List<dynamic>>.broadcast();
  Stream<List<dynamic>> get versiculoDoDia => _messagemStreamController.stream;

  initNotifications(){
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((token){
      print("========FCM TOKEN =======");
      print(token);
    });
  _firebaseMessaging.configure(
    onMessage: (info) async {
      
      final numeroCapitulo   = info['data']['numeroCapitulo'];
      final numeroLivro      = info["data"]["numeroLivro"];
      final numeroVersiculo  = info["data"]["numeroVersiculo"];
      final tipoTestamento   = info["data"]["tipoTestamento"];
      final versiculo        = info["data"]["versiculo"];
      
      _messagemStreamController.sink.add([
        numeroCapitulo,
        numeroLivro,
        numeroVersiculo,
        tipoTestamento,
        versiculo
      ]);

    },

    onLaunch: (info) async {
      
      
      final numeroCapitulo   = info['data']['numeroCapitulo'];
      final numeroLivro      = info["data"]["numeroLivro"];
      final numeroVersiculo  = info["data"]["numeroVersiculo"];
      final tipoTestamento   = info["data"]["tipoTestamento"];
      final versiculo        = info["data"]["versiculo"];
      
      _messagemStreamController.sink.add([
        numeroCapitulo,
        numeroLivro,
        numeroVersiculo,
        tipoTestamento,
        versiculo
      ]);

      
    },

    onResume: (info) async {
      
      final numeroCapitulo   = info['data']['numeroCapitulo'];
      final numeroLivro      = info["data"]["numeroLivro"];
      final numeroVersiculo  = info["data"]["numeroVersiculo"];
      final tipoTestamento   = info["data"]["tipoTestamento"];
      final versiculo        = info["data"]["versiculo"];
      
      _messagemStreamController.sink.add([
        numeroCapitulo,
        numeroLivro,
        numeroVersiculo,
        tipoTestamento,
        versiculo
      ]);
    }

  );  
  }

  dispose(){
    _messagemStreamController?.close();
  }

}
