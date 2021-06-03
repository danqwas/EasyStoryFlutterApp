import 'package:easystory/src/drawer.dart';
import 'package:flutter/material.dart';
// import 'package:easystory/src/pages/bookmarks_page.dart';
import 'package:easystory/src/pages/feed_page.dart';
// import 'package:easystory/src/pages/notifications_page.dart';
// import 'package:easystory/src/pages/post_page.dart';
// import 'package:easystory/src/pages/hashtags_page.dart';
// import 'package:easystory/src/pages/profile_page.dart';
// import 'package:easystory/src/pages/settings_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget mainWidget = HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EasyStory'),
      ),
      drawer: MyDrawer(),
      body: mainWidget,
    );
  }
}
