import 'package:flutter/material.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:holle_bible/services/admob_services.dart';

class VersiculoDia extends StatefulWidget {
  final numeroCapitulo;
  final numerodoLivro;
  final tipoTestamento;
  final versiculo;

  const VersiculoDia(
      {Key key,
      this.numeroCapitulo,
      this.numerodoLivro,
      this.tipoTestamento,
      this.versiculo})
      : super(key: key);
  @override
  _VersiculoDiaState createState() => _VersiculoDiaState();
}

class _VersiculoDiaState extends State<VersiculoDia> {
  final _controller = NativeAdmobController();
  final adms = new AdmobServices();
  double _altura;

  @override
  void initState() {
    _altura = 0;
    _controller.stateChanged.listen((event) {
      switch (event) {
        case AdLoadState.loading:
          setState(() {
            _altura = 0;
          });
          break;
        case AdLoadState.loadCompleted:
          setState(() {
            _altura = 200;
          });
          break;
        default:
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: <Widget>[
            _fundo(),
            _conteudo(context),
          ],
        ),
      ),
    );
  }

  Widget _conteudo(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Expanded(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: _altura > 0,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 10.0,
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context)),
                    Expanded(child: Container())
                  ],
                ),
              ),
              _titulo(),
              _versiculoDoDia(),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _versiculoDoDia() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: FlatButton(
        onPressed: () {},
        child: Card(
          elevation: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  widget.versiculo,
                  style: TextStyle(fontSize: 25.0),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(child: Container()),
                  FlatButton(
                      onPressed: () {},
                      child: Row(
                        children: <Widget>[
                          Text("Compartilhar"),
                          SizedBox(
                            width: 10.0,
                          ),
                          Icon(Icons.share),
                        ],
                      )),
                ],
              ),
              Container(
                padding: EdgeInsets.all(10),
                height: _altura,
                child: NativeAdmob(
                  controller: _controller,
                  adUnitID: adms.getBannerAdId,
                  options: NativeAdmobOptions(
                      showMediaContent: true,
                      callToActionStyle: NativeTextStyle(
                          backgroundColor: Color.fromRGBO(54, 55, 151, 1))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _titulo() {
    return Container(
      height: 100.0,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "biblia",
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
