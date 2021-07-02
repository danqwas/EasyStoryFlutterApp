import 'package:easystory/src/drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:easystory/src/pages/post_details.dart';
import 'package:easystory/src/endpoints/endpoints.dart';
import 'dart:convert';
import 'dart:math';

class ProfilePage extends StatefulWidget {
  final int argument;
  const ProfilePage({Key key, this.argument}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

dynamic gatito = [
  "lib/src/images/gatito.jpg",
  "lib/src/images/gatito2.jpg",
  "lib/src/images/gatito3.jpg",
  "lib/src/images/gatito4.jpg",
  "lib/src/images/gatito5.jpg"
];

final _random = new Random();

class _ProfilePageState extends State<ProfilePage> {
  bool isLoaded = false;
  bool postsLoaded = false;
  // Map<String, dynamic> dataUser = {
  //   'username': '',
  //   'firstName': '',
  //   'lastName': '',
  // };
  var dataUser;
  List dataPosts = [];
  Future<String> getPosts() async {
    var postResponse = await http.get(
        Uri.parse(url() + "users/${widget.argument}/posts"),
        headers: headers());
    setState(() {
      var postExtract = json.decode(postResponse.body);
      dataPosts = postExtract['content'];
    });
    // dataPosts.removeWhere((item) => userPosts.contains(item));
    postsLoaded = true;
    print(dataPosts);
    return postResponse.body.toString();
  }

  Future<String> getUserById(int id) async {
    var response =
        await http.get(Uri.parse(url() + "users/$id"), headers: headers());
    setState(() {
      var extractdata = json.decode(response.body);
      dataUser = extractdata;
    });
    isLoaded = true;
    print(dataUser);
    return response.body.toString();
  }

  @override
  void initState() {
    super.initState();
    getUserById(widget.argument);
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Perfil'),
        backgroundColor: Colors.black,
      ),
      drawer: MyDrawer(argument: widget.argument),
      body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(children: [
            _profilePicture(),
            _userDescription(),
            Divider(),
            Center(
              child: Text(
                "Publicaciones del usuario",
                style: TextStyle(color: Colors.blue, fontSize: 20),
              ),
            ),
            Divider(),
            _userPosts()
          ])),
    );
    // );
  }

  Widget _userPosts() {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: dataPosts == null ? 0 : dataPosts.length,
        itemBuilder: (BuildContext context, i) {
          return Card(
              elevation: 1.0,
              margin: EdgeInsets.only(
                  bottom: 2.0, top: 14.0, left: 15.0, right: 15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Column(
                children: [
                  Image(
                    image: AssetImage(gatito[_random.nextInt(gatito.length)]),
                    fit: BoxFit.fill,
                  ),
                  ListTile(
                    title: Text(dataPosts[i]['title']),
                    subtitle: Text(dataPosts[i]['description']),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PostDetails(
                                        argument: widget.argument,
                                        postId: dataPosts[i]['id'])));
                          },
                          child: Text('Leer')),
                    ],
                  )
                ],
              ));
        });
  }

  Widget _profilePicture() {
    return SizedBox(
      child: Column(children: [
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
                    backgroundImage: AssetImage("lib/src/images/gatito.jpg"),
                    radius: 50.0,
                  ))
            ]),
      ]),
    );
  }

  Widget _userDescription() {
    if (!isLoaded) {
      return Center(child: CircularProgressIndicator());
    } else {
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
}
