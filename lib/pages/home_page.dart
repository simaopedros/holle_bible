import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:holle_bible/pages/leitura_page.dart';
import 'package:holle_bible/pages/lista_capitulos_page.dart';
// import 'package:holle_bible/providers/biblia_provider.dart';
// import 'package:holle_bible/providers/preferencias.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _fundo(),
          _conteudo(context),
        ],
      ),
    );
  }

  Widget _conteudo(context) {
    // final prefs = new PreferenciasUsuario();
    // final provider = new BibliaProvider();
    // List ultimaLeitura = prefs.ultimaLeitura;
    // List favoritosList = prefs.versiculosFavoritos;
    // List listaDeFavoritos = new List();
    // favoritosList.forEach((element) {
    //   print(element);
    //  });

    // final nomeLivro = provider.getNomeLivro(int.tryParse(ultimaLeitura[2]) - 1);

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
            // _subTitulo("continuar", "Leitura", context),
            // _ultimaLeirua(context, ultimaLeitura, nomeLivro),            
              // _subTitulo("leituras", "Salvas", context),
              // for(var i =0; i < favoritosList.length; i++)
            // _ultimaLeirua(context, ultimaLeitura, nomeLivro),
          ],
        ),
      ),
    );
  }

  // Widget _ultimaLeirua(
  //     BuildContext context, List<String> leitura, String nomedoLivro) {
  //   final _size = MediaQuery.of(context).size;
  //   return FlatButton(
  //     child: Container(
  //       alignment: Alignment.centerLeft,
  //       padding: EdgeInsets.all(15.0),
  //       margin: EdgeInsets.all(10.0),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10.0),
  //         color: Colors.black,
  //       ),
  //       width: _size.width * 0.8,
  //       height: 70.0,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: <Widget>[
  //           Text("$nomedoLivro - ${leitura[3]}",
  //               style: GoogleFonts.roboto(color: Colors.white, fontSize: 20.0)),
  //           Icon(
  //             Icons.more_horiz,
  //             color: Colors.white,
  //           )
  //         ],
  //       ),
  //     ),


  //     onPressed: () => Navigator.of(context).push(MaterialPageRoute(
  //                 builder: (context) => LeituraPage(
  //                       numeroCapitulo: int.tryParse(leitura[3]),
  //                       numerodoLivro: int.tryParse(leitura[2]),
  //                       tipoTestamento:["${leitura[0]}", "${leitura[1]}"],
  //                     )
  //                     )
  //                     ),

  //   );
  // }

  // Widget _subTitulo(String firtName, String secondName, BuildContext context) {
  //   final _size = MediaQuery.of(context).size;

  //   return Container(
  //     width: _size.width * 0.8,
  //     child: Row(
  //       children: <Widget>[
  //         Text(
  //           firtName,
  //           style: GoogleFonts.roboto(
  //               color: Colors.white,
  //               fontWeight: FontWeight.w200,
  //               fontSize: 20.0),
  //         ),
  //         Text(
  //           secondName,
  //           style: GoogleFonts.roboto(
  //               color: Colors.white,
  //               fontWeight: FontWeight.bold,
  //               fontSize: 20.0),
  //         )
  //       ],
  //     ),
  //   );
  // }

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
