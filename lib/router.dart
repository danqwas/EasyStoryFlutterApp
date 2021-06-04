import 'package:easystory/src/home.dart';
import 'package:easystory/src/pages/bookmarks_page.dart';
import 'package:easystory/src/pages/hashtags_page.dart';
import 'package:easystory/src/pages/login_page.dart';
import 'package:easystory/src/pages/notifications_page.dart';
import 'package:easystory/src/pages/post_page.dart';
import 'package:easystory/src/pages/profile_page.dart';
import 'package:easystory/src/pages/settings_page.dart';
import 'package:easystory/src/pages/register_page.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case 'login':
      return MaterialPageRoute(builder: (context) => LoginPage());
    case 'register':
      return MaterialPageRoute(builder: (context) => RegisterPage());
    case 'feed':
      return MaterialPageRoute(builder: (context) => MyHomePage());
    case 'post':
      return MaterialPageRoute(builder: (context) => PostPage());
    case 'bookmarks':
      return MaterialPageRoute(builder: (context) => BookmarkPage());
    case 'hashtags':
      return MaterialPageRoute(builder: (context) => HashtagPage());
    case 'notifications':
      return MaterialPageRoute(builder: (context) => NotificationPage());
    case 'profile':
      var userId = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => ProfilePage(argument: userId));
    case 'settings':
      return MaterialPageRoute(builder: (context) => SettingsPage());
    default:
      return MaterialPageRoute(builder: (context) => MyHomePage());
  }
}
