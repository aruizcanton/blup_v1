import 'package:flutter/material.dart';
import '../colors.dart';

//const SERVER_IP = 'https://192.168.1.134:9010/server';
const SERVER_IP = 'https://192.168.2.106:9010/server';
//const SERVER_IP = 'https://192.168.1.37:9000/server';
//const SERVER_IP = 'https://ec2-3-83-228-250.compute-1.amazonaws.com:9000/server';
//const SERVER_IP = 'https://3.83.228.250:9000/server';
//const SERVER_IP = 'http://192.168.43.79:9000/server';
//const SERVER_IP = 'http://192.168.1.133:9000/server';
//const SERVER_IP = 'http://192.168.43.235:9000/server';
class AccentColorOverride extends StatelessWidget {
  const AccentColorOverride({Key key, this.color, this.child})
      : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: child,
      data: Theme.of(context).copyWith(
        accentColor: color,
        brightness: Brightness.dark,
      ),
    );
  }
}
class ScreenArguments {
  final String user_name;

  ScreenArguments(this.user_name);
}

class PleaseWaitWidget extends StatelessWidget {
  PleaseWaitWidget({
    Key key,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
        color: colorFondo,
    );
  }
}

class PleaseWaitBlueBackGroundWidget extends StatelessWidget {
  PleaseWaitBlueBackGroundWidget({
    Key key,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Container (
        child: Center (
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            backgroundColor: Colors.blue.withOpacity(0.8),
          ),
        ),
        color: Colors.blue.withOpacity(0.8)
    );
  }
}

class PleaseWaitBlueBackGroundLittelDownWidget extends StatelessWidget {
  PleaseWaitBlueBackGroundLittelDownWidget({
    Key key,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Container (
        padding: EdgeInsets.only(top: 35),
        child: Center (
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            backgroundColor: Colors.blue.withOpacity(0.8),
          ),
        ),
        color: Colors.blue.withOpacity(0.8)
    );
  }
}

class PleaseWaitBlueBackGroundDownWidget extends StatelessWidget {
  PleaseWaitBlueBackGroundDownWidget({
    Key key,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 250),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            backgroundColor: Colors.blue.withOpacity(0.8),
          ),
        ),
        color: Colors.blue.withOpacity(0.8));
  }
}

bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return (!regex.hasMatch(value)) ? false : true;
}
class ExpandableContainer extends StatelessWidget {
  final bool expanded;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget child;

  ExpandableContainer({
    @required this.child,
    this.collapsedHeight = 0.0,
    this.expandedHeight = 300.0,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return new AnimatedContainer(
      duration: new Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: expanded ? expandedHeight : collapsedHeight,
      child: new Container(
        child: child,
        //decoration: new BoxDecoration(border: new Border.all(width: 1.0, color: Colors.blue)),
      ),
    );
  }
}


