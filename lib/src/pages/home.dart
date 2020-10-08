import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_band_names/services/socket_service.dart';
import 'package:flutter_band_names/src/models/band_models.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    /* //Cargar informacion o inicializar el modelo Band
    new Band(id: '1', name: 'Metallica', votes: 5),
    //Cargar informacion o inicializar el modelo Band
    new Band(id: '2', name: 'Queen', votes: 4),
    //Cargar informacion o inicializar el modelo Band
    new Band(id: '3', name: 'Heroes del Silencio', votes: 8),
    //Cargar informacion o inicializar el modelo Band
    new Band(id: '4', name: 'Bon Jovi', votes: 1), */
  ];

  @override
  void initState() { 
    final socketService = Provider.of<SocketService>(context, listen: false);
    
    socketService.socket.on('active-bands', _handleActiveBands);
    super.initState();    
  }

  _handleActiveBands(dynamic payload){
      print(payload);
      this.bands = (payload as List)
          .map((band) => Band.fromMap(band))
          .toList();

      print(this.bands);
      setState(() {});
  }

  /* @override
  void dispose() { 
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  } */


  @override
  Widget build(BuildContext context) {
    final serverStatus = Provider.of<SocketService>(context).serverStatus;

    return new Scaffold(
      appBar: new AppBar(
        elevation: 1,
        centerTitle: true,
        title: new Text(
          'BandNames',
          style: new TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        actions: [
          new Container(
            margin: EdgeInsets.only(right: 10),
            child: (serverStatus == ServerStatus.Online)
                  ? new Icon(Icons.check, color: Colors.blue,)
                  :new Icon(Icons.offline_bolt, color: Colors.red,),

          )
        ],
      ),
      body: new Column(
        
        children: [
        _showGraph(),
        new Expanded(
          child: new ListView.builder(
          itemCount: bands.length,
          itemBuilder: (BuildContext context, int index) =>
              _bandTile(bands[index]),
      ),
        )
      ],),
      floatingActionButton: new FloatingActionButton(
        onPressed: addNewBand,
        elevation: 1,
        child: new Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context,listen: false);
    return new Dismissible(
      key: new Key(band.id),//UniqueKey(),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction)=>_removeBand(band.id),
      background: new Container(
        padding: EdgeInsets.only(left:8.0),
        color: Colors.red,
        child: new Align(
          alignment: Alignment.centerLeft,
          child: new Text('Delete Band',style: new TextStyle(
            color: Colors.white
          ),)
        ),
      ),
      child: new ListTile(
        leading: new CircleAvatar(
          child: new Text(band.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: new Text(band.name),
        trailing: new Text(
          '${band.votes}',
          style: new TextStyle(fontSize: 20),
        ),
        onTap: () => socketService.socket.emit('vote-band',{'id':band.id}),
      ),
    );
  }

  addNewBand() {
    final textController = new TextEditingController();

    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: new Text('New band name'),
            content: new TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                  child: new Text('Add'),
                  elevation: 5,
                  textColor: Colors.blue,
                  onPressed: () => addBandToList(textController.text))
            ],
          );
        },
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return new CupertinoAlertDialog(
            title: new Text('New band name'),
            content: new CupertinoTextField(
              controller: textController,
            ),
            actions: [
              new CupertinoDialogAction(
                isDefaultAction: true,
                child: new Text('add'),
                onPressed: () => addBandToList(textController.text),
              ),
              new CupertinoDialogAction(
                isDestructiveAction: true,
                child: new Text('Dismiss'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    }
  }

  void addBandToList(String name) {
    final socketService = Provider.of<SocketService>(context,listen: false);

    if (name.length > 1) {
      //podemos agregar
      socketService.socket.emit('add-band',{'name':name});
    }
    Navigator.pop(context);
  }

  void _removeBand(String id) {
    final socketService = Provider.of<SocketService>(context,listen: false);
     socketService.socket.emit('delete-band',{'id': id}); 
  }

 Widget _showGraph() {
  Map<String, double> dataMap = new Map();
  bands.forEach((band) { 
    dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
  });

  return new Container(
    //height: 200,
    width: double.infinity,
    child: dataMap.isEmpty? new Container(): new PieChart(dataMap: dataMap)
  ); 
 }
}
