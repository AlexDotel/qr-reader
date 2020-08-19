import 'package:latlong/latlong.dart';


class ScanModel {
    int id;
    String tipo;
    String valor;

    ScanModel({
        this.id,
        this.tipo,
        this.valor,
    }){

      if(this.valor.contains('http')){
        this.tipo = 'http';
      }else{
        this.tipo = 'geo';
      }

    }

    factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id    : json["id"],
        tipo  : json["tipo"],
        valor : json["valor"],
    );

    Map<String, dynamic> toJson() => {
        "id"    : id,
        "tipo"  : tipo,
        "valor" : valor,
    };

    LatLng getLatLng(){

      final lalo = valor.substring(4)   //Esto omite los primeros 4 caracteres de el string recibido
                        .split(',');    //Esto divide el string en cada parte que haya una coma,
                                        //y nos devuelve una lista de Strings por cada division un item.

      final lat = double.parse( lalo[0] ); //Asignamos al lat el primer valor de la lista generada
      final lng = double.parse( lalo[1] ); //Asignamos al lng el segundo valor de la lista generada

      return LatLng(lat, lng);


    }

}
