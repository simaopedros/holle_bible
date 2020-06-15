import 'package:flutter/material.dart';

import 'package:holle_bible/pages/home_page.dart';
import 'package:holle_bible/pages/leitura_page.dart';
import 'package:holle_bible/pages/lista_capitulos_page.dart';
import 'package:holle_bible/pages/lista_numero_capitulos.dart';
import 'package:holle_bible/pages/versiculo_dia.dart';
import 'package:holle_bible/providers/biblia_provider.dart';
import 'package:holle_bible/providers/preferencias.dart';
import 'package:holle_bible/providers/push_notifications_provider.dart';

void main() async {
  runApp(MyApp());
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  bool verificaDBInstall;
  BibliaProvider provider = new BibliaProvider();

  @override
  void initState() {

    provider.iniDataBase();
    provider.statusDowloadStream.listen((event) {
      navigatorKey.currentState.pushNamed("inicialPage");
    });
    super.initState();
    final pushProvider = new PushNotificationProvider();
    pushProvider.initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: "inicialPage",
      // initialRoute: 'versiculoDia',
      routes: {
        '/': (BuildContext context) => HomePage(),
        'leitura': (BuildContext context) => LeituraPage(),
        'listaCapitulo': (BuildContext context) => ListaCapitulosPage(),
        'listaNumeroCapitulos': (BuildContext context) =>
            ListaNumeroCapitulos(),
        'inicialPage': (BuildContext context) => _inicialPage(context),
        'versiculoDia' : (BuildContext context) => VersiculoDia(),
      },
    );
  }

  Widget _inicialPage(BuildContext context) {
    return StreamBuilder(
      stream: provider.statusDowloadStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return HomePage();
        } else {
          return Scaffold(
              body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: FractionalOffset(0.0, 0.6),
                  end: FractionalOffset(0.0, 1.0),
                  colors: [
                    Color.fromRGBO(54, 55, 149, 1.0),
                    Color.fromRGBO(0, 92, 151, 1.0)
                  ]),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Center(
                      child: Text(
                        "Aguarde, isso só acontece uma vez!",
                        style: TextStyle(fontSize: 25.0, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Visibility(
                    visible:
                        snapshot.data != "Concluido" && snapshot.data != "erro",
                    child: Container(
                      height: 80.0,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Center(
                        child: Text(
                          snapshot.data,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: snapshot.data == "Concluido",
                      child: FlatButton(
                        onPressed: () {
                          Navigator.popAndPushNamed(context, "/");
                        },
                        child: Container(
                            padding: EdgeInsets.all(10.0),
                            height: 80.0,
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                                color: Colors.lightGreen,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Text(
                                  "Concluido",
                                  style: TextStyle(
                                      fontSize: 25.0, color: Colors.black),
                                )),
                                Icon(
                                  Icons.navigate_next,
                                  size: 50.0,
                                  color: Colors.black,
                                )
                              ],
                            )),
                      ))
                ],
              ),
            ),
          ));
        }
      },
    );
  }
}
