import 'package:shared_preferences/shared_preferences.dart';

/*
  Recordar instalar el paquete de:
    shared_preferences:
  Inicializar en el main
    final prefs = new PreferenciasUsuario();
    await prefs.initPrefs();
    
    Recuerden que el main() debe de ser async {...
*/

class PreferenciasUsuario {

  static final PreferenciasUsuario _instancia = new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // Obtem a ultima leitura
  get ultimaLeitura {
    return _prefs.getStringList('ultimaLeitura') ?? [];
  }
  set ultimaLeitura( List<String> value ) {
    _prefs.setStringList('ultimaLeitura', value);
  }

  // Obter favoritos
  get versiculosFavoritos {
    return _prefs.getStringList('versiculos') ?? [];
  }

  set versiculosFavoritos(List<String> value ) {
    _prefs.setStringList('versiculos', value);
  }
}
