import 'package:easystory/src/pages/bookmarks_page.dart';
import 'package:easystory/src/pages/hashtags_page.dart';
import 'package:easystory/src/pages/login_page.dart';
import 'package:easystory/src/pages/notifications_page.dart';
import 'package:easystory/src/pages/post_page.dart';
import 'package:easystory/src/pages/profile_page.dart';
import 'package:easystory/src/pages/settings_page.dart';
import 'package:easystory/src/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'src/pages/feed_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  var userId = settings.arguments;
  switch (settings.name) {
    case 'login':
      return MaterialPageRoute(builder: (context) => LoginPage());
    case 'register':
      return MaterialPageRoute(builder: (context) => RegisterPage());
    case 'feed':
      return MaterialPageRoute(builder: (context) => HomePage(argument: userId));
    case 'post':
      return MaterialPageRoute(builder: (context) => PostPage(argument: userId));
    case 'bookmarks':
      return MaterialPageRoute(builder: (context) => BookmarkPage(argument: userId));
    case 'hashtags':
      return MaterialPageRoute(builder: (context) => HashtagPage(argument: userId));
    case 'notifications':
      return MaterialPageRoute(builder: (context) => NotificationPage(argument: userId));
    case 'profile':
      return MaterialPageRoute(
          builder: (context) => ProfilePage(argument: userId));
    case 'settings':
      return MaterialPageRoute(builder: (context) => SettingsPage(argument: userId));
    default:
      return MaterialPageRoute(builder: (context) => HomePage(argument: userId));
  }
}
