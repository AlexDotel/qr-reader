import 'dart:async';

import 'package:qr_reader/src/models/modeloscan.dart';

class Validaciones {

  //Aqui validaremos todo lo que pasa por el stream, y veremos si es de geo o si es de web
  //Segun apliquemos uno de estos StreamTransformers, recibiremos la informacion filtrada

  //  En la siguiente linea declaramos un Stream Transformer llamado 'Validar Geo', y le especificamos que recibira una <List<ScanModel>>
  //  y que devolvera una lista de ScanModel tambien.
  final validarGeo = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: ( scans, sink ){
      // Con el from Handler filtramos la informacion, lo que recibamos sera llamado aqui dentro como scans, que sera una lista de SCANmodels
      // como especificamos en las lineas de arriba, y el sink, es para devolver los valores que pasen la validacion asignada.


      // En la siguiente linea, declaramos geoScans, esta lista tendra dentro los valores que pasen la validacion en el .where que hacemos
      // abajo, basicamente, examinamos los items de 'scans', que es la lista que recibimos, y los elementos que tengan como tipo 'geo'
      // seran los que agregaremos a la lista, geoScans. Luego esta lista filtrada, la devolveremos en el sink.add, que para eso lo llamamos.
      final geoScans = scans.where( (scan) => scan.tipo == 'geo' ).toList();
      sink.add(geoScans);

    }
  );


  // Esto es exactamente igual al validador del geo, pero este caso, con los tipo HTTP
  final validarWeb = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: ( scans, sink ){

      final geoScans = scans.where( (scan) => scan.tipo == 'http' ).toList();
      sink.add(geoScans);

    }
  );


}