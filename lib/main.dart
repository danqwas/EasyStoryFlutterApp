import 'package:easystory/src/home.dart';
import 'package:easystory/src/pages/bookmarks_page.dart';
import 'package:easystory/src/pages/hashtags_page.dart';
import 'package:easystory/src/pages/notifications_page.dart';
import 'package:easystory/src/pages/post_page.dart';
import 'package:easystory/src/pages/profile_page.dart';
import 'package:easystory/src/pages/settings_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "EasyStory Flutter App",
      initialRoute: '/feed',
      routes: {
        '/feed': (context) => MyHomePage(),
        '/post': (context) => PostPage(),
        '/bookmarks': (context) => BookmarkPage(),
        '/hashtags': (context) => HashtagPage(),
        '/notifications': (context) => NotificationPage(),
        '/profile': (context) => ProfilePage(),
        '/settings': (context) => SettingsPage(),
      },
    );
  }
}
