import 'package:easystory/src/pages/bookmarks_page.dart';
import 'package:easystory/src/pages/home_page.dart';
import 'package:easystory/src/pages/notifications_page.dart';
import 'package:easystory/src/pages/post_page.dart';
import 'package:easystory/src/pages/hashtags_page.dart';
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
      home: MyHomePage(),
    );
  }
}

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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Image(
                image: AssetImage('lib/src/images/logo.png'),
              ),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('lib/src/images/reading.jpg'))),
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Nueva publicación'),
              onTap: () => {
                Navigator.of(context).pop(),
                setState(() {
                  mainWidget = PostPage();
                })
              },
            ),
            ListTile(
              leading: Icon(Icons.format_list_bulleted),
              title: Text('Feed'),
              onTap: () => {
                Navigator.of(context).pop(),
                setState(() {
                  mainWidget = HomePage();
                })
              },
            ),
            ListTile(
              leading: Icon(Icons.bookmark),
              title: Text('Marcadores'),
              onTap: () => {
                Navigator.of(context).pop(),
                setState(() {
                  mainWidget = BookmarkPage();
                })
              },
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Hashtags'),
              onTap: () => {
                Navigator.of(context).pop(),
                setState(() {
                  mainWidget = HashtagPage();
                })
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notificaciones'),
              onTap: () => {
                Navigator.of(context).pop(),
                setState(() {
                  mainWidget = NotificationPage();
                })
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
              onTap: () => {
                Navigator.of(context).pop(),
                setState(() {
                  mainWidget = ProfilePage();
                })
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
              onTap: () => {
                Navigator.of(context).pop(),
                setState(() {
                  mainWidget = SettingsPage();
                })
              },
            ),
          ],
        ),
      ),
      body: mainWidget,
    );
  }
}
