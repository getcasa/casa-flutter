import 'package:casa/components/styled_components.dart';
import 'package:casa/pages/add_device.dart';
import 'package:flutter/material.dart';
import 'package:casa/request.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DiscoveredDevicesPage extends StatefulWidget {
  @override
  _DiscoveredDevicesPageState createState() => _DiscoveredDevicesPageState();

  final dynamic homeId;
  final List<dynamic> rooms;
  final dynamic plugin;
  const DiscoveredDevicesPage({Key key, this.homeId, this.rooms, this.plugin}): super(key: key);
}

class _DiscoveredDevicesPageState extends State<DiscoveredDevicesPage> {
  Request request = new Request();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> _getDevices() async {
    var devices;
    try {
      devices = await request.getDiscoveredDevices(widget.homeId, widget.plugin['name']);
    } catch (e) {
      final snackBar = SnackBar(content: Text(e));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return [];
    }
    return devices;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(right: 20, left: 20),
            child: StyledTitle('Dev_ices')
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(right: 20, left: 20, top: 5),
            child: Text(
              'This is all of ' + widget.plugin['name'] + ' devices discovered on your network. Select a device to add it to Casa.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54
              )
            )
          ),
          Flexible(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(top: 10),
              height: double.infinity,
              child: FutureBuilder(
                future: _getDevices(),
                builder: (context, projectSnap) {
                  if (projectSnap == null || projectSnap.data == null) {
                    return Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator()
                    );
                  }
                  if (projectSnap.data.length == 0) {
                    return Container(
                      alignment: Alignment.center,
                      child: Text('No devices found')
                    );
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
                                MaterialPageRoute(builder: (context) => AddDevicePage(homeId: widget.homeId, rooms: widget.rooms, device: device)),
                              );
                            },
                            trailing: Icon(MdiIcons.arrowRight),
                          )
                        );
                      },
                    )
                  );
                },
              )
            )
          )
        ]
      )
    );
  }
}
