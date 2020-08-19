import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';

import 'package:qr_reader/src/models/modeloscan.dart';


class MapaPage extends StatefulWidget {

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {

  MapController mapCtrl = MapController();
  String tipoMapa = 'streets';
  int cont = 0;


  @override
  Widget build(BuildContext context) {

    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        title: Text('Coordenadas'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: (){

              mapCtrl.move(scan.getLatLng(), 15);

            },
          ),
        ],  
      ),

      body: crearFlutterMap(scan),
      
      floatingActionButton: _crearBotonFlotante(context),

    );
  }

  crearFlutterMap(ScanModel scan){

    return FlutterMap(
      mapController: mapCtrl,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15,
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores(scan)
      ],
    );

  }

  _crearMapa() {

    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
      '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}', //Enviamos id, zoom, posicion x, pos Y, y alta 
                                                            //resolucion con el @2x.png (El png sera el 
                                                            //formato), y el access token que declaramos abajo
                                                            //Ya que lo demas lo mandamos automaticamente 
                                                            //en nuestro Map Opcions arriba
     
      additionalOptions: {
        'accessToken': 'pk.eyJ1IjoiYWxleGRvdGVsIiwiYSI6ImNrOHAybXdseTB5bGMzZXJ4dHV0ODhyOGcifQ.RrEj4GCCLRm_ngZZelUaeA',
        'id': 'mapbox.$tipoMapa'

        //Acabamos de mandar el api de como acces token en el mapa, y el id, que en este caso usaremos 'mapbox.streets'
        //Los tipos de Mapas son:
        // streets, (que es el que usamos), dark, light, outdoors, satellite
      
      }
    );

  }

  _crearMarcadores(ScanModel scan){

    //Creamos el marcador que se vera en el mapa mostrando la coordenadas

    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 100,
          height: 100,
          point: scan.getLatLng(),
          builder: (context) => Container(
            child: Icon(Icons.location_on, size: 45, color: Theme.of(context).primaryColor)
          )
        )
      ]
    );

  }

  Widget _crearBotonFlotante(BuildContext context) {

    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: (){

        List lista = ['streets', 'dark', 'light', 'outdoors', 'satellite'];

        if(cont <= 3){

          cont++;
          tipoMapa = lista[cont];

        }else{

          cont = 0;
          tipoMapa = lista[cont];

        }

        setState(() {});

        

        

      },
    );

  }
}