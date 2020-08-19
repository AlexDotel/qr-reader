import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:qr_reader/src/models/modeloscan.dart';

abrirScan(BuildContext context, ScanModel scan) async {

  if(scan.tipo == 'http'){

    final url = scan.valor;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('No se puede cargar $url');
      throw 'Could not launch $url';
    }

  }else{

    print('GEO................');
    Navigator.pushNamed(context, 'mapa', arguments: scan);

  }


}
