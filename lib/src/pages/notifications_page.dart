// import 'package:easystory/src/drawer.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final int argument;
  const NotificationPage({Key key, this.argument}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EasyStory'),
      ),
      body: Center(
        child: Text('No tienes notificaciones nuevas.'),
      ),
    );
  }
}