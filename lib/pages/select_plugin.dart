import 'package:casa/pages/discovered_devices.dart';
import 'package:flutter/material.dart';
import 'package:casa/request.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SelectPlugin extends StatefulWidget {
  @override
  _SelectPluginState createState() => _SelectPluginState();

  final dynamic homeId;
  final List<dynamic> rooms;
  const SelectPlugin({Key key, this.homeId, this.rooms}): super(key: key);
}

class _SelectPluginState extends State<SelectPlugin> {
  Request request = new Request();

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> _getPlugins() async {
    var plugins = await request.getAvailablePlugins(widget.homeId);
    return plugins;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0
      ),
      body: FutureBuilder(
        future: _getPlugins(),
        builder: (context, projectSnap) {
          if (projectSnap == null || projectSnap.data == null) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: projectSnap.data.length,
            itemBuilder: (context, index) {
              var plugin = projectSnap.data[index];
              return Container(
                margin: EdgeInsets.only(bottom: 5),
                child: ListTile(
                  title: Text(plugin['Name']),
                  subtitle: Text(plugin['Description']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DiscoveredDevices(homeId: widget.homeId, rooms: widget.rooms, plugin: plugin)),
                    );
                  },
                  trailing: Icon(MdiIcons.arrowRight),
                )
              );
            },
          );
        },
      ),
    );
  }
}
