import 'dart:convert';
import 'package:easystory/src/endpoints/endpoints.dart';
import 'package:easystory/src/pages/post_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../drawer.dart';
import 'dart:math';

dynamic gatito = [
  "lib/src/images/gatito.jpg",
  "lib/src/images/gatito2.jpg",
  "lib/src/images/gatito3.jpg",
  "lib/src/images/gatito4.jpg",
  "lib/src/images/gatito5.jpg"
];
// generates a new Random object
final _random = new Random();

class HomePage extends StatefulWidget {
  final int argument;
  const HomePage({Key key, this.argument}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoaded = false;

  List dataPosts = [];
  List dataBookmarks = [];
  List userPosts = [];

  Future<String> getPosts() async {
    var bookmarkResponse = await http.get(
        Uri.parse(url() + "users/${widget.argument}/bookmarks"),
        headers: headers());
    var postResponse =
        await http.get(Uri.parse(url() + "posts"), headers: headers());
    setState(() {
      var bookmarkExtract = json.decode(bookmarkResponse.body);
      var postExtract = json.decode(postResponse.body);
      dataPosts = postExtract['content'];
      for (var itemA in dataPosts) {
        itemA['isBookmarked'] = false;
        for (var itemB in bookmarkExtract['content']) {
          if (itemB['postId'] == itemA['id']) {
            itemA['isBookmarked'] = true;
          }
        }
        if (itemA['userId'] == widget.argument) {
          userPosts.add(itemA);
        }
      }
    });
    dataPosts.removeWhere((item) => userPosts.contains(item));
    isLoaded = true;
    print(dataPosts);
    return postResponse.body.toString();
  }

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  Icon getIcon(bool isActive) {
    if (isActive) {
      return Icon(Icons.bookmark_added_outlined);
    } else {
      return Icon(Icons.bookmark_add_outlined);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Feed principal'),
          backgroundColor: Colors.black,
        ),
        drawer: MyDrawer(argument: widget.argument),
        body: _dataPosts());
  }

  Widget _dataPosts() {
    if (!isLoaded) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Container(
          child: ListView.builder(
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
                    IconButton(
                        onPressed: () async {
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Center(child: CircularProgressIndicator()),
                            ),
                          );
                          int postId = dataPosts[i]['id'];
                          if (!(dataPosts[i]['isBookmarked'])) {
                            http.Response response = await http.post(
                                Uri.parse(url() +
                                    "users/${widget.argument}/posts/$postId/bookmarks"),
                                headers: headers(),
                                body: json.encode({}));
                            print(response);
                          } else {
                            http.Response response = await http.delete(
                                Uri.parse(url() +
                                    "users/${widget.argument}/posts/$postId/bookmarks"),
                                headers: headers());
                            print(response);
                          }
                          Navigator.pop(context);
                          setState(() {
                            dataPosts[i]['isBookmarked'] =
                                !(dataPosts[i]['isBookmarked']);
                          });
                        },
                        icon: getIcon(dataPosts[i]['isBookmarked'])),
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
            ),
          );
        },
      ));
    }
  }
}
