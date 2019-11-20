import 'package:casa/components/bottom_navigation.dart';
import 'package:casa/components/styled_components.dart';
import 'package:flutter/material.dart';
import 'package:casa/request.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AutomationsPage extends StatefulWidget {
  @override
  _AutomationsPageState createState() => _AutomationsPageState();

  final dynamic homeId;
  const AutomationsPage({Key key, this.homeId}): super(key: key);
}

class _AutomationsPageState extends State<AutomationsPage> {
  Request request = new Request();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> _getAutomations() async {
    var automations = await request.getAutomations(widget.homeId);
    return automations;
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
              MdiIcons.plus,
            ),
            onPressed: () {
              print('add');
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(right: 20, left: 20),
            child: StyledTitle('Aut_omations')
          ),
          Flexible(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(top: 5),
              height: double.infinity,
              child: FutureBuilder(
                future: _getAutomations(),
                builder: (context, projectSnap) {
                  if (projectSnap == null || projectSnap.data == null) {
                    return Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator()
                    );
                  }
                  return RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: _getAutomations,
                    child: ListView.builder(
                      itemCount: projectSnap.data.length,
                      itemBuilder: (context, index) {
                        var automation = projectSnap.data[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: ListTile(
                            title: Text(automation['name']),
                            onTap: () {
                              print(automation);
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
      ),
      bottomNavigationBar: BottomNavigation(2, widget.homeId)
    );
  }
}
