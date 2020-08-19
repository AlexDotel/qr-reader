import 'package:flutter/material.dart';

import 'package:qr_reader/src/bloc/scans_bloc.dart';
import 'package:qr_reader/src/models/modeloscan.dart';
import 'package:qr_reader/src/utils/utils.dart' as utils;

class Direcciones extends StatelessWidget {

  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {
    
    scansBloc.obtenerSCans();

    return StreamBuilder(
      stream: scansBloc.scanStreamWeb,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {

        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator());
        }

        final scan = snapshot.data;

        if(scan.length == 0) return Center(child: Text('Realiza tu primer escaneo'),);

        return ListView.builder(
          itemCount: scan.length,
          itemBuilder: (context, i){

            return Dismissible(
              background: Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.centerLeft,
                child: Icon(Icons.delete, color: Colors.white,),
                color: Theme.of(context).primaryColor
              ),              
              key: UniqueKey(),       //Nos genera una llave unica con Flutter
              child: ListTile(
                leading: Icon(Icons.cloud, color: Theme.of(context).primaryColor),
                title: Text(scan[i].valor,style: TextStyle(color: Colors.black)),
                subtitle: Text('ID: ${scan[i].id}'),
                trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                onTap: () { utils.abrirScan(context, scan[i],); },
              ),
              onDismissed: ( direccion ) => scansBloc.borrarScan(scan[i].id),
              
            );

          }
        );


      }
      
    );
    


  }
}