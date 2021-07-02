import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:easystory/src/pages/post_details.dart';
import 'package:easystory/src/endpoints/endpoints.dart';
import 'dart:convert';
import 'dart:math';

class AuthorProfilePage extends StatefulWidget {
  final int argument;
  final int authorId;
  const AuthorProfilePage({Key key, this.argument, this.authorId})
      : super(key: key);

  @override
  _AuthorProfilePageState createState() => _AuthorProfilePageState();
}

dynamic gatito = [
  "lib/src/images/gatito.jpg",
  "lib/src/images/gatito2.jpg",
  "lib/src/images/gatito3.jpg",
  "lib/src/images/gatito4.jpg",
  "lib/src/images/gatito5.jpg"
];

final _random = new Random();

class _AuthorProfilePageState extends State<AuthorProfilePage> {
  bool isLoaded = false;
  bool postsLoaded = false;
  bool isSubscribed = false;
  // Map<String, dynamic> dataUser = {
  //   'username': '',
  //   'firstName': '',
  //   'lastName': '',
  // };
  var dataUser;
  List dataPosts = [];
  Map subBody = new Map();
  Future<String> getPosts() async {
    var postResponse = await http.get(
        Uri.parse(url() + "users/${widget.authorId}/posts"),
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

  Future<String> getSubs() async {
    var subsResponse = await http.get(
        Uri.parse(url() + "users/${widget.argument}/subscriptions"),
        headers: headers());
    setState(() {
      var subsExtract = json.decode(subsResponse.body);
      var subsData = subsExtract['content'];
      print("SUSCRIPCIONZASAS:");
      print(subsData);
      for (var item in subsData) {
        if (item['subscribedId'] == widget.authorId) {
          isSubscribed = true;
          break;
        }
      }
    });
    return subsResponse.body.toString();
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
    getSubs();
    getUserById(widget.authorId);
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil de usuario'),
        backgroundColor: Colors.black,
      ),
      // drawer: MyDrawer(argument: widget.argument),
      body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(children: [
            _profilePicture(),
            _userDescription(),
            Divider(),
            _subscribeButton(),
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

  Widget _subscribeButton() {
    return ElevatedButton(
      onPressed: () async {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) =>
              AlertDialog(title: Center(child: CircularProgressIndicator())),
        );
        if (!isSubscribed) {
          subBody = {
            'userId': widget.argument,
            'subscribedId': widget.authorId
          };
          var body = json.encode(subBody);
          http.Response response = await http.post(
              Uri.parse(url() +
                  "users/${widget.argument}/subscriptions/${widget.authorId}"),
              headers: headers(),
              body: body);
          print(response);

          ;
        } else {
          http.Response response = await http.delete(
              Uri.parse(url() +
                  "users/${widget.argument}/subscriptions/${widget.authorId}"),
              headers: headers());
          print(response);
        }
        setState(() {
          isSubscribed = !isSubscribed;
          getSubs();
        });

        Navigator.pop(context);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
        minimumSize: MaterialStateProperty.all(Size(50, 50)),
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(vertical: 0.5, horizontal: 10)),
        shape: MaterialStateProperty.all(new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
        )),
      ),
      child: isSubscribed ? Text('Desuscribirse') : Text('Suscribirse'),
    );
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
