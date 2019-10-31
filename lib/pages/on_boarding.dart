import 'package:casa/components/dialog.dart';
import 'package:casa/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:casa/request.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> with SingleTickerProviderStateMixin {
  Request request = new Request();
  Dialogs dialogs = new Dialogs();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TabController _tabController;
  final tabsNbr = 3;
  final homeNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _tabController = TabController(vsync: this, length: tabsNbr);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: DefaultTabController(
        length: tabsNbr,
        child: Scaffold(
          body: TabBarView(
            controller: _tabController,
            children: [
              Container(
                color: Theme.of(context).accentColor,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: "Welcome to "
                          ),
                          TextSpan(
                            text: "Casa",
                            style: TextStyle(
                              color: Colors.white,
                            )
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "Smart home automations",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ]
                )
              ),
              Container(
                color: Theme.of(context).accentColor,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: "All accessories in a single "
                          ),
                          TextSpan(
                            text: "app",
                            style: TextStyle(
                              color: Colors.white,
                            )
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10.0),
                            margin: EdgeInsets.only(right: 10.0),
                            child: Icon(
                              MdiIcons.lightbulbOutline,
                              size: 30,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            margin: EdgeInsets.only(right: 10.0),
                            child: Icon(
                              MdiIcons.radiator,
                              size: 30,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            margin: EdgeInsets.only(right: 10.0),
                            child: Icon(
                              MdiIcons.fan,
                              size: 30,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            margin: EdgeInsets.only(right: 10.0),
                            child: Icon(
                              MdiIcons.powerSocketDe,
                              size: 30,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(
                              MdiIcons.fridgeOutline,
                              size: 30,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                            ),
                          )
                        ],
                      )
                    )
                  ]
                )
              ),
              Container(
                color: Theme.of(context).accentColor,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: "That's it, now choose a name for your "
                          ),
                          TextSpan(
                            text: "Home",
                            style: TextStyle(
                              color: Colors.white,
                            )
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        right: 20.0,
                        left: 20.0
                      ),
                      margin: EdgeInsets.only(top: 20.0),
                      child: Material(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                          child: TextField(
                            controller: homeNameController,
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
                  ]
                )
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          switch (_tabController.index) {
            case 0:
              _tabController.animateTo(1);
              break;
            case 1:
              _tabController.animateTo(2);
              break;
            case 2:
              try {
                  await request.addHome({
                  'name': homeNameController.text
                });
                } catch (e) {
                  final snackBar = SnackBar(content: Text(e));
                  _scaffoldKey.currentState.showSnackBar(snackBar);
                  return;
                }
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage(homeId: '')),
                );
              break;
            default:
          }
        },
        child: Icon(
          MdiIcons.chevronRight,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
