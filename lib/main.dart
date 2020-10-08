//Propios de flutter
import 'package:flutter/material.dart';
import 'package:flutter_band_names/services/socket_service.dart';
//Terceros
//Nuestros
import 'package:flutter_band_names/src/pages/home.dart';
import 'package:flutter_band_names/src/pages/status_page.dart';
import 'package:provider/provider.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => new SocketService(),)
      ],
      child: new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: {
          'home':(BuildContext context) => new HomePage(),
          'status':(BuildContext context) => new StatusPage()

        },
      ),
    );
  }
}