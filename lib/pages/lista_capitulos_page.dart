import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:holle_bible/pages/lista_numero_capitulos.dart';
import 'package:holle_bible/providers/biblia_provider.dart';

class ListaCapitulosPage extends StatelessWidget {

  final int capitluloInicial;
  final int capituloFinal;

  const ListaCapitulosPage({Key key, this.capitluloInicial,this.capituloFinal}) : super(key: key);

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
          _listaCapitulos(capitluloInicial, capituloFinal, context),
        ],
      ),
    ));
  }

  Widget _listaCapitulos(int capInicial, int capFinal, BuildContext context) {
    BibliaProvider biblia = new BibliaProvider();
    List<String> livros = biblia.listaLivros(capInicial, capFinal);
    
    return Column(
      children: <Widget>[
        //!Aqui------------------------
        for(var i = 0; i < livros.length; i++)
          FlatButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ListaNumeroCapitulos(
                  livro: capInicial+i+1,
                )
              )
            ),
            child: _nomeLivro(livros[i], context)),
        SizedBox(height: 80,)
      ],
    );
    
  }
  Widget _nomeLivro(String livro,context){
    return Container(
        margin: EdgeInsets.all(5.0),
        height: 50,
        width: MediaQuery.of(context).size.width*0.8,
        child: Center(child: Text(livro, style: TextStyle(color: Colors.white),)),
        decoration: BoxDecoration(
    color: Colors.black,
    borderRadius: BorderRadius.circular(10.0)
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
