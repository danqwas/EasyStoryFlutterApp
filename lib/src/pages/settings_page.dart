import 'package:easystory/src/drawer.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final int argument;
  const SettingsPage({Key key, this.argument}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EasyStory'),
      ),
      drawer: MyDrawer(argument: argument),
      body: Center(
        child: Text('Settings Page'),
      ),
    );
  }
}