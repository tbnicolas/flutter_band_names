import 'package:flutter/material.dart';
import 'package:flutter_band_names/services/socket_service.dart';
import 'package:provider/provider.dart';


class StatusPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return new Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Text('ServerStatus: ${socketService.serverStatus}')
        ],)
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.message),
        onPressed: (){
          socketService.socket.emit('emitir-mensaje', {
            'nombre':'Flutter',
            'mensaje': 'Hola desde FLUTTER'
          });

        }
      ),
   );
  }
}