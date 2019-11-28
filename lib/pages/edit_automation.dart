import 'package:casa/components/dialog.dart';
import 'package:casa/components/styled_components.dart';
import 'package:casa/pages/select_automations.dart';
import 'package:flutter/material.dart';
import 'package:casa/request.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EditAutomationPage extends StatefulWidget {
  @override
  _EditAutomationPageState createState() => _EditAutomationPageState();

  final dynamic homeId;
  final dynamic automation;
  const EditAutomationPage({Key key, this.homeId, this.automation}): super(key: key);
}

class _EditAutomationPageState extends State<EditAutomationPage> {
  Request request = new Request();
  Dialogs dialogs = new Dialogs();
  final automationNameController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      automationNameController.text = widget.automation['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              MdiIcons.trashCanOutline,
              color: Colors.red,
            ),
            onPressed: () {
              dialogs.confirm(context, "You really want to delete " + widget.automation['name'] + " automation?", () async {
                await request.deleteAutomation(widget.homeId, widget.automation['id']);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SelectAutomationsPage(homeId: widget.homeId))
                );
              });
            },
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              alignment: Alignment.centerLeft,
              child: StyledTitle('Na_me'),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              child: Material(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                  child: TextField(
                    controller: automationNameController,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                elevation: 20.0,
                shadowColor: Color.fromRGBO(0, 0, 0, 0.4),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40.0, right: 20.0),
              alignment: Alignment.centerRight,
              child: Container(
                height: 45,
                child: Material(
                  child: FlatButton(
                    padding: EdgeInsets.only(top: 4.0),
                    onPressed: () async {
                      var body = {
                        "name": automationNameController.text
                      };
                      try {
                        await request.editAutomation(widget.homeId, widget.automation['id'], body);
                      } catch (e) {
                        final snackBar = SnackBar(content: Text(e));
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                        return;
                      }
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      )
                    ),
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
                  ),
                  color: Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
                  elevation: 20.0,
                  shadowColor: Color.fromRGBO(0, 0, 0, 0.4),
                ),
              )
            )
          ],
        )
      )
    );
  }
}
