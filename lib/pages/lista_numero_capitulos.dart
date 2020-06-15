import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:holle_bible/pages/leitura_page.dart';
import 'package:holle_bible/providers/biblia_provider.dart';

class ListaNumeroCapitulos extends StatefulWidget {
  final int livro;

  const ListaNumeroCapitulos({Key key, this.livro}) : super(key: key);

  @override
  _ListaNumeroCapitulosState createState() => _ListaNumeroCapitulosState();
}

class _ListaNumeroCapitulosState extends State<ListaNumeroCapitulos> {

  static final MobileAdTargetingInfo targetingInfo = new MobileAdTargetingInfo(
    keywords: ["Biblia", "Critão", "Evangelico", "Livros Evangelicos", "Musica", "Gospel", "Igreja"],
    testDevices: <String>[
      "FC819F38909485567ABCC171138A71FA",
      "441D51944CC1BB47847FA05D37484958"
    ],
    childDirected: true,
    nonPersonalizedAds: false,
  );

  BannerAd _bannerAd;

    BannerAd createBannerAd(){
    return new BannerAd(
      adUnitId: "ca-app-pub-6361762260659022/2532870515", 
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event){
        print("Banner Event: $event");
      }
    );
  }

  BibliaProvider bibliaProvider = new BibliaProvider();
  int qtsCapitulos;
  bool exibirTela;

  contaCapitulos() async {
    setState(() {
      exibirTela = false;
    });
    int qtd = await bibliaProvider.getQtdCapitulos(widget.livro);
    setState(() {
      qtsCapitulos = qtd;
      exibirTela = true;
    });
  }

  @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: "ca-app-pub-6361762260659022~5299383088");
     _bannerAd = createBannerAd()
     ..load()
     ..show();
    exibirTela = false;
    qtsCapitulos = 0;
    contaCapitulos();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _fundo(),
          Visibility(
            visible: exibirTela,
            child: _conteudo(context),
            replacement: Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }

  Widget _conteudo(context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context)),
              Expanded(child: Container())
            ],
          ),
          _titulo(),
          for (var c = 1; c < qtsCapitulos; c = c + 4)
            _listaNumeroCapitulos(c, context),
          SizedBox(
            height: 60.0,
          )
        ],
      ),
    ));
  }

  Widget _listaNumeroCapitulos(int numero, BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (var i = numero; i < numero + 4; i++)
          Visibility(
            visible: i <= qtsCapitulos,
            child: FlatButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LeituraPage(
                        numeroCapitulo: i,
                        numerodoLivro: widget.livro,
                        tipoTestamento: i < 40
                            ? ["antigo", "Testamento"]
                            : ["novo", "Testamento"],
                      ))),
              child: Container(
                margin: EdgeInsets.only(bottom: 10.0),
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.15,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Center(
                    child: Text(
                  i.toString(),
                  style: TextStyle(color: Colors.white),
                )),
              ),
            ),
          ),
      ],
    ));
  }

  Widget _titulo() {
    return Container(
      height: 100.0,
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
