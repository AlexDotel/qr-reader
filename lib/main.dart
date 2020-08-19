import 'package:flutter/material.dart';
import 'package:qr_reader/src/pages/homepage.dart';
import 'package:qr_reader/src/pages/mapa_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        fontFamily: 'Opificio',
        primaryColor: Colors.purple   
      ),

      title: 'QR_Scanner',

      initialRoute: '/',
      
      routes: {

        '/'     : (BuildContext context)=> HomePage(),
        'mapa'  : (BuildContext context)=> MapaPage(),

      }
    );
  }
}