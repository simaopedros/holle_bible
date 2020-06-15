import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:holle_bible/pages/lista_capitulos_page.dart';
import 'package:holle_bible/pages/versiculo_dia.dart';
import 'package:holle_bible/providers/push_notifications_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isNotification;
  List dadosNotificacao = new List();
  final provider = new PushNotificationProvider();
  @override
  void initState() {
    
    isNotification = false;
    provider.initNotifications();
    provider.versiculoDoDia.listen((event) {
      setState(() {
        isNotification = true;
        event.forEach((element) {
          dadosNotificacao.add(element);
          print("Elemento $element");
        });
        
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(54, 55, 149, 1.0),
        elevation: 0,
        actions: <Widget>[
          Visibility(
            visible: isNotification,
            child: IconButton(
                onPressed: () {
                  //!-------
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => VersiculoDia(
                        numeroCapitulo: dadosNotificacao[0],
                        numerodoLivro: dadosNotificacao[1],
                        tipoTestamento: dadosNotificacao[3],
                        versiculo: dadosNotificacao[4],
                      )));
                  //!-------
                }, icon: Icon(Icons.notification_important)
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          _fundo(),
          _conteudo(context),
        ],
      ),
    );
  }

  Widget _conteudo(context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: _titulo(),
            ),
            SizedBox(),
            FlatButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ListaCapitulosPage(
                          capitluloInicial: 39,
                          capituloFinal: 66,
                        ))),
                child: _caixaLivro("novo", "Testamento", context)),
            FlatButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ListaCapitulosPage(
                          capitluloInicial: 0,
                          capituloFinal: 39,
                        ))),
                child: _caixaLivro("antigo", "Testamento", context)),
          ],
        ),
      ),
    );
  }

  Widget _caixaLivro(String firtNome, String secundNome, context) {
    final _size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.black,
      ),
      margin: EdgeInsets.symmetric(vertical: 10.0),
      width: _size.width * 0.8,
      height: 150.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            firtNome,
            style: GoogleFonts.roboto(
                color: Colors.white,
                fontWeight: FontWeight.w200,
                fontSize: 24.0),
          ),
          Text(
            secundNome,
            style: GoogleFonts.roboto(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24.0),
          )
        ],
      ),
    );
  }

  Widget _titulo() {
    return Container(
      height: 190.0,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Biblia",
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w300,
                color: Colors.white,
                fontSize: 25.0),
          ),
          Text("Sagrada",
              style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 25.0)),
        ],
      ),
    );
  }

  Widget _fundo() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: FractionalOffset(0.0, 0.6),
            end: FractionalOffset(0.0, 1.0),
            colors: [
              Color.fromRGBO(54, 55, 149, 1.0),
              Color.fromRGBO(0, 92, 151, 1.0)
            ]),
      ),
    );
  }
}
