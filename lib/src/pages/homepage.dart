import 'dart:io';

import 'package:flutter/material.dart';

import 'package:qr_reader/src/bloc/scans_bloc.dart';
import 'package:qr_reader/src/models/modeloscan.dart';

import 'package:qr_reader/src/pages/direcciones_page.dart';
import 'package:qr_reader/src/pages/mapas_page.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:qr_reader/src/utils/utils.dart' as utils;


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int currentIndex = 0;
  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      appBar: AppBar(
        title: Text('QR Scanner', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            color: Colors.white,
            onPressed: () => scansBloc.borrarTodo(),
          ),
        ],
      ),

      
      body: callPage(currentIndex),


      bottomNavigationBar: _crearBottom(),


      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: _scanQR,
        child: Icon(Icons.filter_center_focus),  
        backgroundColor: Theme.of(context).primaryColor,
      ),


    );
  }


  _scanQR() async {

    // https://www.youtube.com/user/MrDatosCuriosos
    // geo:18.424304476056236,-69.99144688090213

    String futureString = '';

    try{
      futureString = await BarcodeScanner.scan();
    }catch (e){
      futureString = e.toString();
    }

    print('Future String: $futureString');

    if(futureString != null){

      final nuevoScan = ScanModel(valor: futureString);
      scansBloc.agregarScan(nuevoScan);

      if(Platform.isIOS){
        Future.delayed(Duration(milliseconds: 750), utils.abrirScan(context, nuevoScan,));        
      }else{
        utils.abrirScan(context, nuevoScan,);
      }
      

    }

  }


  Widget callPage(int actualP){

    switch(actualP){

      case 0: return Mapas();

      case 1: return Direcciones();

      default: return Mapas();

    }

  }

  Widget _crearBottom() {

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (i){

        setState(() {
          currentIndex = i;
        });

      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.swap_horizontal_circle),
          title: Text('Direcciones')
        )
      ],
    );

  }

}