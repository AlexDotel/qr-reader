import 'dart:async';

import 'package:qr_reader/src/bloc/validaciones.dart';
import 'package:qr_reader/src/providers/db_provider.dart';



class ScansBloc with Validaciones{
  //Agregamos las validaciones y todo lo que conlleva dentro a esta clase



  static final ScansBloc _singleton = new ScansBloc._internal();
  // Creamos la variable que sera la unica instancia este sera retornado en el constructor
  // llamara el constructor privado, que se encargara de obtener los scans de la base de datos

  factory ScansBloc(){
    return _singleton;
  }// Creamos un constructor que retorna el Singleton

  ScansBloc._internal(){
    // Obtener Scans de la base de datos
    obtenerSCans();

  }




  // Elaboracion del Stream ↓

  final _streamController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>>  get scanStream => _streamController.stream.transform(validarGeo);
  Stream<List<ScanModel>>  get scanStreamWeb => _streamController.stream.transform(validarWeb);

  //Aqui agregamos el transform para que se filtre la informacion segun las validaciones hechas.

  dispose(){
    _streamController?.close();
  }



  //Elaboracion de Metodos del Bloc


  obtenerSCans() async {
    _streamController.sink.add( await DBProvider.db.getAllScans() );      //Aqui llamamos la lista de scans
  }
  
  agregarScan( ScanModel scan ) async {
    await DBProvider.db.nuevoSCan(scan);
    obtenerSCans();
  }

  borrarScan( int id) async {
    await DBProvider.db.deleteScan(id);   //Borramos un scan de determinado id
    obtenerSCans();                       //Volvemos a pedir los Scans
  }

  borrarTodo() async {
    DBProvider.db.deleteAll();
    obtenerSCans();                       //Los Scans ahroa devolveran una lista vacia
  }


}