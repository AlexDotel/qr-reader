import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:qr_reader/src/models/modeloscan.dart';
export 'package:qr_reader/src/models/modeloscan.dart';

class DBProvider{

  static Database _database;
  static final DBProvider db = DBProvider._privado();

  DBProvider._privado();

  Future<Database> get database async {

    if( _database != null ) return _database;

    _database = await initDB();
    return _database;

  }

  //Metodo para inicializar la base de datos
  initDB() async { 

    Directory pathDocumento = await getApplicationDocumentsDirectory(); //Declara o localiza la ruta

    final path = join( pathDocumento.path , 'ScansDB.db' ); // Complementa la ruta con el nombre del archivo


    
    return await openDatabase(  //A continuacion creamos la base de datosy es lo que retornamos
      path,                    
      version: 1,               //Cuando cambiamos algun ajuste, debemos aumentar el numero de version
      onOpen: (db){},
      onCreate: ( Database db, int version ) async {
        await db.execute(
          'CREATE TABLE Scans ('
          ' id INTEGER PRIMARY KEY,'
          ' tipo TEXT,'
          ' valor TEXT'
          ')'
        );

      }

    );

  }


  //CREAR registros con SQL crudo
  nuevoScanRaw(ScanModel nuevoScan) async {

    final db = await database;                    //Llamamos la base de datos ya creada, si no existe, la crea.
    final res = await db.rawInsert(               //Luego con el rawInsert, insertamos en la base de datos los valores llamandolos uno a uno.
      
      "INSERT Into Scans (id, tipo, valor) "
      "VALUES ( ${ nuevoScan.id }, '${ nuevoScan.tipo}', '${ nuevoScan.valor } ')"

    );

    return res;

  }

  nuevoSCan(ScanModel nuevoScan) async {                            //Este metodo ademas de ser mas sencillo es mas seguro

    final db = await database;
    final res = await db.insert('Scans', nuevoScan.toJson());       //Aqui solamente tenemos que nombrar la tabla, y pasar el objeto a Json.

      return res;

  }


  //SELECT - Obtener Informacion
  Future<ScanModel> getScanId( int id ) async {                             //Pedir Scan por id

    final db = await database; //Llamamos la base de datos
    final resp = await db.query('Scans', where: 'id = ?', whereArgs: [id]); //Hacemos una consulta y le mandamos el argumento, 
                                                                            //que nos devolvera un mapa con una lista correspontiente al id.

    return resp.isNotEmpty ? ScanModel.fromJson(resp.first) : null;

  }


  Future<List<ScanModel>> getScanType(ScanModel scan) async {

    final db = await database;
    //Esto retorna un listado de Mapas, segun el tipo, usando el query moderno.
    final resp = await db.query('Scans', where: 'type=?', whereArgs: [scan.tipo]);         
    
    
    //Esto retorna un listado de Mapas, segun el tipo, usando el query tradicional.
    final respRaw = await db.rawQuery("SELECT * FROM Scans WHERE tipo='{$scan.tipo}'");


    List<ScanModel> list = resp.isNotEmpty ? resp.map((c) => ScanModel.fromJson(c)).toList() : [];
    //En esta linea verificamos que la resp no este vacia, si no esta vacia la barremos con un map, y devolvemos instancias de ScanModel
    //creadas con el metodo ScanModel.fromJson, y las metemos en list, en caso que la resp esta vacia, entonces devolvemos una lista vacia.

    return list;
    
  }




  Future<List<ScanModel>> getAllScans() async {

    final db = await database;
    final resp = await db.query('Scans');                                   

    List<ScanModel> list = resp.isNotEmpty ? resp.map((c) => ScanModel.fromJson(c)).toList() : [];

    return list;

  }


  Future<int> updateScan(ScanModel nuevoScan) async {

    final db = await database;
    final resp = await db.update('Scans', nuevoScan.toJson(), where: 'id=?', whereArgs: [nuevoScan.id]);

    return resp;  //Este resp es un integer con la cantidad de registros eliminados, por eso el future espera un int

  }


  Future<int> deleteScan(int id) async {

    final db = await database;
    final resp = await db.delete('Scans', where: 'id=?', whereArgs: [id]);

    return resp;

  }


  Future<int> deleteAll() async {

    final db = await database;
    final resp = await db.delete('Scans');              //Si nos fijamos es igual a la resp del metodo anterior, pero solo mandamos la tabla
    final respRaw = await db.rawDelete('DELETE FROM Scans');

    return resp;

  }


  



}