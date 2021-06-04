import 'package:easystory/src/drawer.dart';
import 'package:flutter/material.dart';

class HashtagPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EasyStory'),
      ),
      drawer: MyDrawer(),
      body: Center(
        child: Text('Hashtags Page'),
      ),
    );
  }
}
