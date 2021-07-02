import 'package:flutter/material.dart';
import 'package:easystory/src/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:easystory/src/endpoints/endpoints.dart';
import 'dart:convert';

import 'author_profile_page.dart';

class SubscriptionsPage extends StatefulWidget {
  final int argument;
  const SubscriptionsPage({Key key, this.argument}) : super(key: key);
  @override
  _SubscriptionsPageState createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  var subsData;

  Future<String> getSubs() async {
    var subsResponse = await http.get(
        Uri.parse(url() + "users/${widget.argument}/subscriptions"),
        headers: headers());
    setState(() {
      var subsExtract = json.decode(subsResponse.body);
      subsData = subsExtract['content'];
    });
    var userResponse =
        await http.get(Uri.parse(url() + "users"), headers: headers());
    setState(() {
      var extractUserData = json.decode(userResponse.body);
      print(extractUserData);
      var usersData = extractUserData['content'];
      for (var user in usersData) {
        for (var sub in subsData) {
          if (user['id'] == sub['subscribedId']) {
            sub['name'] = user['username'];
          }
        }
      }
    });
    return subsResponse.body.toString();
  }

  @override
  void initState() {
    super.initState();
    getSubs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Mis suscripciones'),
          backgroundColor: Colors.black,
        ),
        drawer: MyDrawer(argument: widget.argument),
        body: _subscriptions());
  }

  Widget _subscriptions() {
    return Container(
      padding: EdgeInsets.all(40.0),
      child: ListView.builder(
        itemCount: subsData == null ? 0 : subsData.length,
        itemBuilder: (BuildContext context, i) {
          return Row(children: <Widget>[
            Text("${subsData[i]['name']}"),
            IconButton(
              icon: Icon(Icons.remove_red_eye),
              onPressed: () {
                Divider();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AuthorProfilePage(
                        argument: widget.argument,
                        authorId: subsData[i]['subscribedId']),
                  ),
                );
              },
            ),
          ]);
        },
      ),
    );
  }
}
