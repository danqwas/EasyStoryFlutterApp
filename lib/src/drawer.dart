import 'package:flutter/material.dart';


class MyDrawer extends StatelessWidget {
  final int argument;
  const MyDrawer({ Key key, this.argument }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userId = argument;
    return Drawer(
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
              Navigator.pushNamed(context, 'post', arguments: userId)
            },
          ),
          ListTile(
            leading: Icon(Icons.format_list_bulleted),
            title: Text('Feed'),
            onTap: () => {
              Navigator.of(context).pop(),
              Navigator.pushNamed(context, 'feed', arguments: userId)
            },
          ),
          ListTile(
            leading: Icon(Icons.bookmark),
            title: Text('Marcadores'),
            onTap: () => {
              Navigator.of(context).pop(),
              Navigator.pushNamed(context, 'bookmarks', arguments: userId)
            },
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Hashtags'),
            onTap: () => {
              Navigator.of(context).pop(),
              Navigator.pushNamed(context, 'hashtags', arguments: userId)
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notificaciones'),
            onTap: () => {
              Navigator.of(context).pop(),
              Navigator.pushNamed(context, 'notifications', arguments: userId)
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Perfil'),
            onTap: () => {
              Navigator.of(context).pop(),
              Navigator.pushNamed(context, 'profile', arguments: userId)
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configuración'),
            onTap: () => {
              Navigator.of(context).pop(),
              Navigator.pushNamed(context, 'settings', arguments: userId)
            },
          ),
        ],
      ),
    );
  }
}