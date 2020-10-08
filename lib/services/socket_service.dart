

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus{
  Online,
  OffLine,
  Connecting
}


class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Connecting;

  IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;

  IO.Socket get socket => this._socket;

  SocketService(){
    this._initConfig();
  }

  void _initConfig(){
    print('Entro');
  // Dart client
    this._socket = IO.io('http://192.168.0.12:3000', <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': {'foo': 'bar'},
      'autoConnect': true
    });
    this._socket.on('connect', (_) {
     print('connect');
     this._serverStatus = ServerStatus.Online;
     notifyListeners();
    });
    this._socket.on('disconnect', (_) {
      print('disconnect');
     this._serverStatus = ServerStatus.OffLine;
     notifyListeners();      
     });

     //Escuchar mensaje del servidor

  /*socket.on('nuevo mensaje', ( payload ) {
      print('nuevo mensaje');
      print(payload.containsKey('edad')?'nombre: ${payload['nombre']}':'No hay mensaje');
      print(payload.containsKey('edad')?'edad: ${payload['edad']}':'No hay mensaje');

      this._serverStatus = ServerStatus.OffLine;
      notifyListeners();      
     }); */


  }

}