import 'package:flutter/material.dart';
import 'package:casa/request.dart';
import 'package:casa/pages/edit_device.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DevicePage extends StatefulWidget {
  @override
  _DevicePageState createState() => _DevicePageState();

  final dynamic homeId;
  final dynamic device;
  const DevicePage({Key key, this.homeId, this.device}) : super(key: key);
}

class _DevicePageState extends State<DevicePage>
    with SingleTickerProviderStateMixin {
  Request request = new Request();
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    setState(() {
      _tabController = TabController(
          vsync: this, length: widget.device['pluginActions'].length);
    });
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
              MdiIcons.eyeSettingsOutline,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditDevicePage(
                        homeId: widget.homeId, device: widget.device)),
              );
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: widget.device['pluginActions'].length,
        child: TabBarView(
          controller: _tabController,
          children: List<Widget>.generate(widget.device['pluginActions'].length,
              (int index) {
            var action = widget.device['pluginActions'][index];

            return ListView(children: <Widget>[Text(action['name'])]);
          }),
        ),
      ),
    );
  }
}
