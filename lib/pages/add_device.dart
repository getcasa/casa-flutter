import 'package:casa/components/styled_components.dart';
import 'package:flutter/material.dart';
import 'package:casa/request.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AddDevice extends StatefulWidget {
  @override
  _AddDeviceState createState() => _AddDeviceState();

  final dynamic homeId;
  final List<dynamic> rooms;
  final dynamic plugin;
  final dynamic device;
  const AddDevice({Key key, this.homeId, this.rooms, this.plugin, this.device}): super(key: key);
}

class _AddDeviceState extends State<AddDevice> {
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
      ),
      body: Column(
        children: <Widget>[
          Text('data')
        ],
      )
    );
  }
}
