import 'package:flutter/material.dart';

class PostPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        child: TextField(
          maxLines: 40,
          minLines: 10,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Escribe una publicación',
          ),
        ),
      ),
    );
  }
}

class PostPage extends StatefulWidget {
  //PostPage({Key key}) : super(key: key);
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: <Widget>[
        Divider(),
        TextField(
          maxLines: 40,
          minLines: 10,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Escribe una publicación',
          ),
        ),
        ElevatedButton(onPressed: () {}, child: const Text('Siguiente'))
      ]),

      /*body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Divider(),
            TextField(
              maxLines: 40,
              minLines: 10,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Escribe una publicación',
              ),
            ),
            ElevatedButton(onPressed: () {}, child: const Text('Siguiente'))
          ]),*/
    );
  }
}
