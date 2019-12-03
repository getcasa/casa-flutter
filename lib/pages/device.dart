import 'package:flutter/material.dart';
import 'package:casa/request.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DevicePage extends StatefulWidget {
  @override
  _DevicePageState createState() => _DevicePageState();

  final dynamic homeId;
  final dynamic roomId;
  final dynamic device;
  const DevicePage({Key key, this.homeId, this.roomId, this.device}): super(key: key);
}

class _DevicePageState extends State<DevicePage> {
  Request request = new Request();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              MdiIcons.settingsOutline,
            ),
            onPressed: () {
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Text('data')
        ],
      )
    );
  }
}
