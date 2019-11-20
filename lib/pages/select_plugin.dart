import 'package:casa/components/styled_components.dart';
import 'package:casa/pages/discovered_devices.dart';
import 'package:flutter/material.dart';
import 'package:casa/request.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SelectPluginPage extends StatefulWidget {
  @override
  _SelectPluginPageState createState() => _SelectPluginPageState();

  final dynamic homeId;
  final List<dynamic> rooms;
  const SelectPluginPage({Key key, this.homeId, this.rooms}): super(key: key);
}

class _SelectPluginPageState extends State<SelectPluginPage> {
  Request request = new Request();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

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
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(right: 20, left: 20),
            child: StyledTitle('Plu_gins')
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(right: 20, left: 20, top: 5),
            child: Text(
              'Select the mark or category of your device',
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
                future: _getPlugins(),
                builder: (context, projectSnap) {
                  if (projectSnap == null || projectSnap.data == null) {
                    return Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator()
                    );
                  }
                  return RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: _getPlugins,
                    child: ListView.builder(
                      itemCount: projectSnap.data.length,
                      itemBuilder: (context, index) {
                        var plugin = projectSnap.data[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: ListTile(
                            title: Text(plugin['name']),
                            subtitle: Text(plugin['description']),
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
