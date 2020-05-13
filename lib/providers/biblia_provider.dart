import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dio/dio.dart';

final String bibliaTAble = "pt_nar";
final String idColumn = "id";
final String bookIdColumn = "book_id";
final String chapterColumn = "chapter";
final String verseColumn = "verse";
final String ptNarColumn = "pt_nar";

class BibliaProvider {
  static BibliaProvider _instance;
  static Database _database;

  final _carregandoController = new BehaviorSubject<bool>();
  final _statusDowload = new BehaviorSubject<String>();

  Stream<bool> get carregandoStream => _carregandoController.stream;
  Stream<String> get statusDowloadStream => _statusDowload.stream;

  dispose() {
    _carregandoController?.close();
    _statusDowload?.close();
  }

  BibliaProvider._createInstance();

  factory BibliaProvider() {
    if (_instance == null) {
      _instance = BibliaProvider._createInstance();
    }
    return _instance;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await iniDataBase();
    }
    return _database;
  }

  Future<Database> iniDataBase() async {
    var dataBasePath = await getDatabasesPath();
    var path = join(dataBasePath, "data.db");
    var exist = await databaseExists(path);

    if (!exist) {
      _statusDowload.sink.add("Configurando Banco de dados");
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {
        _statusDowload.sink.add("erro");
      }

      ByteData data = await rootBundle.load(join("assets", "data.db"));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
      _statusDowload.sink.add("Concluido");
    }
    final db = await openDatabase(path, readOnly: true);
    return db;
  }

  // Future<Database> iniDataBase() async {
  //   Directory dataBasePath = await getApplicationDocumentsDirectory();
  //   String path = "${dataBasePath.path}/data.db";

  //   var bibliaDatabase = await openDatabase(path);
  //   if (await bibliaDatabase.getVersion() == 0) {
  //     var bibliaDatabase = await openDatabase(path, onCreate: await baixarDb());
  //     bibliaDatabase.setVersion(1);
  //   }
  //   return bibliaDatabase;
  // }

  baixarDB2() async {}

  baixarDb() async {
    _statusDowload.sink.add("Iniciando dowload do banco de dados");
    final bancoURL =
        // "https://fatecspgov-my.sharepoint.com/personal/simao_silva_fatec_sp_gov_br/_layouts/15/download.aspx?SourceUrl=%2Fpersonal%2Fsimao%5Fsilva%5Ffatec%5Fsp%5Fgov%5Fbr%2FDocuments%2Fdata%2Esqlite";
        // "https://www.dropbox.com/s/v2qb95avdft6i0p/data.sqlite?dl=1";
        "https://www.dropbox.com/s/6cbp5o4anlgocwz/biblia_sagrada_almeida_recebida.sqlite?dl=1";
    Dio dio = Dio();
    try {
      var dir = await getDatabasesPath();
      await dio.download(bancoURL, "$dir/data.db",
          onReceiveProgress: (recebido, total) {
        var porcentagem = ((recebido / total) * 100).toStringAsFixed(2);
        _statusDowload.sink.add("Baixando: $porcentagem %");
      });
      _statusDowload.sink.add("concluido");
    } catch (e) {
      _statusDowload.sink.add("erro");
    }
  }

  Future<int> getQtdVerciculo(int bookId, int capitulo) async {
    _carregandoController.sink.add(false);
    Database dbBiblia = await database;
    final retorno = await dbBiblia.rawQuery(
        'SELECT COUNT(*) FROM pt_nar WHERE book_id = "$bookId" AND chapter = "$capitulo"');
    _carregandoController.sink.add(true);
    return retorno.first.values.first;
  }

  Future<int> getQtdCapitulos(int bookId) async {
    _carregandoController.sink.add(false);
    Database dbBiblia = await database;
    final retorno = await dbBiblia.rawQuery(
        'SELECT COUNT(*) FROM pt_nar WHERE book_id = "$bookId" AND verse = "1"');
    _carregandoController.sink.add(true);
    return retorno.first.values.first;
  }

  Future<List<Biblia>> getLivro(int bookId, int capitulo) async {
    _carregandoController.sink.add(false);
    Database dbBiblia = await database;
    List<Biblia> biblias = new List();
    if (dbBiblia.isOpen) {
      List<Map<String, dynamic>> livros = await dbBiblia.rawQuery(
          'SELECT * FROM "pt_nar" WHERE "book_id" = "$bookId" AND "chapter" = "$capitulo"');
      livros.forEach((v) {
        Biblia bitemp = Biblia.fromMap(v);
        biblias.add(bitemp);
      });
    }
    _carregandoController.sink.add(true);
    return biblias;
  }

  List<String> listaLivros(int capInicial, int capFinal) {
    _carregandoController.sink.add(false);
    List<String> livros = new List();
    for (var i = capInicial; i < capFinal; i++) {
      livros.add(getNomeLivro(i));
    }
    _carregandoController.sink.add(true);
    return livros;
  }

  String getNomeLivro(int numeroLivro) {
    List<String> nomes = new List();
    nomes = [
      "Gênesis",
      "Êxodo",
      "Levítico",
      "Números",
      "Deuteronômio",
      "Josue",
      "Juízes",
      "Rute",
      "I Samuel",
      "II Samuel",
      "1Reis",
      "2Reis",
      "1Crônicas",
      "2Crônicas",
      "Esdras",
      "Neemias",
      "Ester",
      "Jó",
      "Salmos",
      "Provérbios",
      "Eclesiastes",
      "Cantares",
      "Isaías",
      "Jeremias",
      "Lamentações",
      "Ezequiel",
      "Daniel",
      "Oséias",
      "Joel",
      "Amós",
      "Obdias",
      "Jonas",
      "Miquéias",
      "Naum",
      "Habacuc",
      "Sofonias",
      "Ageu",
      "Zacarias",
      "Malaquias",
      "Mateus",
      "Marcos",
      "Lucas",
      "João",
      "Atos dos Apóstolos",
      "Romanos",
      "1Coríntios",
      "2Coríntios",
      "Gálatas",
      "Efésios",
      "Filipenses",
      "Colossenses",
      "1Tessalonicenses",
      "2Tessalonicenses",
      "1Timóteo",
      "2Timóteo",
      "Tito",
      "Filémon",
      "1Pedro",
      "2Pedro",
      "1João",
      "2João",
      "3João",
      "Hebreus",
      "Tiago",
      "Judas",
      "Apocalipse",
    ];
    return nomes[numeroLivro];
  }
}

class Biblia {
  String id;
  String bookId;
  String chapter;
  String verse;
  String ptNar;

  Biblia.fromMap(Map map) {
    id = map[idColumn];
    bookId = map[bookIdColumn];
    chapter = map[chapterColumn];
    verse = map[verseColumn];
    ptNar = map[ptNarColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      bookIdColumn: bookId,
      chapterColumn: chapter,
      verseColumn: verse,
      ptNarColumn: ptNar
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Biblia(id: $id, bookId: $bookId, chapter: $chapter, verse: $verse, ptNar: $ptNar)";
  }
}
