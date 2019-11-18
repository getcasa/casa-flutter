import 'package:casa/pages/add_device.dart';
import 'package:flutter/material.dart';
import 'package:casa/request.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DiscoveredDevices extends StatefulWidget {
  @override
  _DiscoveredDevicesState createState() => _DiscoveredDevicesState();

  final dynamic homeId;
  final List<dynamic> rooms;
  final dynamic plugin;
  const DiscoveredDevices({Key key, this.homeId, this.rooms, this.plugin}): super(key: key);
}

class _DiscoveredDevicesState extends State<DiscoveredDevices> {
  Request request = new Request();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> _getDevices() async {
    var devices = await request.getDiscoveredDevices(widget.plugin['Name']);
    return devices;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0
      ),
      body: FutureBuilder(
        future: _getDevices(),
        builder: (context, projectSnap) {
          if (projectSnap == null || projectSnap.data == null) {
            return CircularProgressIndicator();
          }
          return RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _getDevices,
            child: ListView.builder(
              itemCount: projectSnap.data.length,
              itemBuilder: (context, index) {
                var device = projectSnap.data[index];

                return Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: ListTile(
                    title: Text(device['physicalName']),
                    subtitle: Text(device['physicalId']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddDevice(homeId: widget.homeId, rooms: widget.rooms, plugin: widget.plugin, device: device)),
                      );
                    },
                    trailing: Icon(MdiIcons.arrowRight),
                  )
                );
              },
            )
          );
        },
      ),
    );
  }
}
