import 'package:easystory/src/drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:easystory/src/endpoints/endpoints.dart';
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  final int argument;
  const ProfilePage({Key key, this.argument}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String url = "https://easystory-backend.herokuapp.com/api/";
  Map<String, dynamic> dataUser = {
    'username': '',
    'firstName': '',
    'lastName': '',
  };

  Future<String> getUserById(int id) async {
    var response =
        await http.get(Uri.parse(url + "users/$id"), headers: headers());

    setState(() {
      var extractdata = json.decode(response.body);
      dataUser = extractdata;
      
    });
    print(dataUser);
    return response.body.toString();
  }

  @override
  void initState() {
    super.initState();
    getUserById(widget.argument);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Perfil'),
      ),
      drawer: MyDrawer(),
      body: ListView(
        children: [_profilePicture(), _userDescription()],
      ),
    );
  }

  Widget _profilePicture() {
    return SizedBox(
      child: Column(
          //padding: EdgeInsets.only(left: 0, right: 0),

          children: [
            Stack(
                fit: StackFit.passthrough,
                alignment: Alignment.topCenter,
                children: [
                  Image.asset("lib/src/images/gatito.jpg",
                      fit: BoxFit.fitWidth, width: 500),
                  Container(
                    height: 250,
                  ),
                  Positioned(
                      top: 150,
                      child: CircleAvatar(
                        backgroundImage:
                            AssetImage("lib/src/images/gatito.jpg"),
                        radius: 50.0,
                      ))
                ]),
          ]),
    );
  }

  Widget _userDescription() {
    return Column(
      children: [
        Text(dataUser['username'],
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15)),
        Text(dataUser['firstName'],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))
      ],
    );
  }
}
