import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:holle_bible/providers/biblia_provider.dart';
import 'package:holle_bible/providers/preferencias.dart';
import 'package:holle_bible/services/admob_services.dart';


class LeituraPage extends StatefulWidget {
  final List tipoTestamento;
  final int numerodoLivro;
  final int numeroCapitulo;

  const LeituraPage(
      {Key key, this.tipoTestamento, this.numerodoLivro, this.numeroCapitulo})
      : super(key: key);

  @override
  _LeituraPageState createState() => _LeituraPageState();
}

class _LeituraPageState extends State<LeituraPage> {
  final ams = AdmobServices();
  // static const adUnitId = "ca-app-pub-3940256099942544/2247696110"; //TESTE
  double _alturaAds = 0;
  static const adUnitId = "ca-app-pub-6361762260659022/7696609428";//OFICIAL
  
 
  BibliaProvider provider = new BibliaProvider();
  List<Biblia> biblias = new List();

  String nomeDoLivro;
  int bookId;
  int capitulo;
  int qtdVersiculos;
  int qtdCapitulos;
  bool mostrarTela;

  carregarBiblia() async {
    setState(() {
      mostrarTela = false;
    });

    List<Biblia> bibliasLoad = await provider.getLivro(bookId, capitulo);
    nomeDoLivro = provider.getNomeLivro(bookId - 1);
    int qtd = await provider.getQtdVerciculo(bookId, capitulo);
    int qtdC = await provider.getQtdCapitulos(bookId);

    setState(() {
      mostrarTela = true;
      capitulo = capitulo;
      bookId = bookId;
      biblias = bibliasLoad;
      qtdVersiculos = qtd;
      qtdCapitulos = qtdC;
    });
  }

  @override
  void initState() {
    _alturaAds = 90;
    mostrarTela = false;
    bookId = widget.numerodoLivro;
    capitulo = widget.numeroCapitulo;
    biblias = [];
    nomeDoLivro = "";
    qtdVersiculos = 0;
    qtdCapitulos = 0;
    carregarBiblia();
    super.initState();
    
   
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();
    List<String> dados = new List();

    dados.add(widget.tipoTestamento[0]);
    dados.add(widget.tipoTestamento[1]);
    dados.add(bookId.toString());
    dados.add(capitulo.toString());
    prefs.ultimaLeitura = dados;
    print(prefs.ultimaLeitura);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          _fundo(),
          Visibility(
            visible: mostrarTela,
            child: _conteudo(context, biblias),
            replacement: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _conteudo(BuildContext context, List<Biblia> biblias) {
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
          _subTitulo(widget.tipoTestamento),
          _verciculos(),
          SizedBox(
            height: 25.0,
          ),
          _buttonsBackNext(),
          SizedBox(
            height: 25.0,
          ),
        ],
      ),
    ));
  }

  Widget _buttonsBackNext() {
    final _zise = MediaQuery.of(context).size;
    return Container(
      width: _zise.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Visibility(
            visible: capitulo > 1,
            child: FlatButton(
                onPressed: () {
                  setState(() {
                    capitulo = capitulo - 1;
                  });
                  carregarBiblia();
                },
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10.0)),
                  width: 130.0,
                  height: 60.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        Icons.navigate_before,
                        color: Colors.white,
                      ),
                      Expanded(child: Container()),
                      Text("Anterior", style: TextStyle(color: Colors.white))
                    ],
                  ),
                )),
          ),
          Visibility(
            visible: capitulo < qtdCapitulos,
            child: FlatButton(
                onPressed: () {
                  setState(() {
                    capitulo = capitulo + 1;
                  });
                  carregarBiblia();
                },
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  width: 130.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Proximo",
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(
                        Icons.navigate_next,
                        color: Colors.white,
                      )
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }

  Widget _verciculos() {
    final _size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
      padding: EdgeInsets.all(10.0),
      width: _size.width * 0.8,
      child: Column(
        children: <Widget>[
          for (var i = 0; i < biblias.length; i++)
            Column(
              children: <Widget>[
                _cardVersiculo(biblias[i].ptNar),
                Visibility(
                  visible: (i % 10 == 2),
                  child: Card(
                    elevation: 3,
                    child: Container(
                      padding: EdgeInsets.all(5.0),                        
                        height: _alturaAds,
                        child: Text("ADS")),
                  ),
                )
              ],
            ),
        ],
      ),
    );
  }

  Widget _cardVersiculo(String versiculo) {
    return Stack(
      children: <Widget>[
        Card(
          elevation: 3.0,
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Text(versiculo, textAlign: TextAlign.justify),
          ),
        ),
      ],
    );
  }

  Widget _subTitulo(List tipoLivro) {
    final _size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(5.0),
      width: _size.width * 0.8,
      height: 60.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Colors.black),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    widget.tipoTestamento[0],
                    style: GoogleFonts.roboto(
                        color: Colors.white, fontWeight: FontWeight.w200),
                  ),
                  Text(widget.tipoTestamento[1],
                      style: GoogleFonts.roboto(
                          color: Colors.white, fontWeight: FontWeight.bold))
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(nomeDoLivro,
                  style:
                      GoogleFonts.roboto(color: Colors.white, fontSize: 20.0)),
            ],
          ),
          Column(
            children: <Widget>[
              Text("Capitulo", style: GoogleFonts.roboto(color: Colors.white)),
              SizedBox(
                height: 5.0,
              ),
              Text(capitulo.toString(),
                  style:
                      GoogleFonts.roboto(color: Colors.white, fontSize: 20.0)),
            ],
          ),
          Column(
            children: <Widget>[
              Text("Versiculos",
                  style: GoogleFonts.roboto(color: Colors.white)),
              SizedBox(
                height: 5.0,
              ),
              Text(qtdVersiculos.toString(),
                  style:
                      GoogleFonts.roboto(color: Colors.white, fontSize: 20.0)),
            ],
          )
        ],
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
