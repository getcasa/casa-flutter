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
        elevation: 0.0
      ),
      body: FutureBuilder(
        future: _getAutomations(),
        builder: (context, projectSnap) {
          if (projectSnap == null || projectSnap.data == null) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
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
          );
        },
      ),
    );
  }
}
