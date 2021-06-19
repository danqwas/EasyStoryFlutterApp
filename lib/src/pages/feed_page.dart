import 'dart:convert';
import 'package:easystory/src/endpoints/endpoints.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../drawer.dart';

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
    var bookmarkResponse = await http.get(Uri.parse(url() + "users/${widget.argument}/bookmarks"), headers: headers());
    var postResponse = await http.get(Uri.parse(url() + "posts"), headers: headers());
    setState(() {
      var bookmarkExtract = json.decode(bookmarkResponse.body);
      var postExtract = json.decode(postResponse.body);
      dataPosts = postExtract['content'];
      for (var itemA in dataPosts){
        itemA['isBookmarked'] = false;
        for (var itemB in bookmarkExtract['content']) {
          if (itemB['postId'] == itemA['id']){
            itemA['isBookmarked'] = true;
          }
        }
        if (itemA['userId'] == widget.argument){
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
    }
    else {
      return Icon(Icons.bookmark_add_outlined);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed principal'),
      ),
      drawer: MyDrawer(argument: widget.argument),
      body: _dataPosts()
    );
  }
  Widget _dataPosts() {
    if (!isLoaded) {
      return Center(
        child: CircularProgressIndicator()
      );
    }
    else{
      return Container(
        padding: EdgeInsets.all(40.0),
        child: ListView.builder(
        itemCount: dataPosts == null ? 0 : dataPosts.length,
        itemBuilder: (BuildContext context, i){
         return Card(
                  elevation: 10.0,
                  child: Column(
                    children: [
                      Image(
                        image: AssetImage('lib/src/images/gatito.jpg'),
                      ),
                      ListTile(
                        title: Text(dataPosts[i]['title']),
                        subtitle: Text(dataPosts[i]['content']),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(onPressed: () async {
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Center(child:CircularProgressIndicator()),
                              ),
                            );
                            int postId = dataPosts[i]['id'];
                            if (!(dataPosts[i]['isBookmarked'])){
                              http.Response response = await http.post(Uri.parse(url() + "users/${widget.argument}/posts/$postId/bookmarks"), headers: headers(), body: json.encode({}));
                              print(response);
                            }
                            else {
                              http.Response response = await http.delete(Uri.parse(url() + "users/${widget.argument}/posts/$postId/bookmarks"), headers: headers());
                              print(response);
                            }
                            Navigator.pop(context);
                            setState(() {
                              dataPosts[i]['isBookmarked'] = !(dataPosts[i]['isBookmarked']);
                            });
                          }, icon: getIcon(dataPosts[i]['isBookmarked'])),
                          TextButton(onPressed: () {}, child: Text('Detalles')),
                          TextButton(onPressed: () {}, child: Text('Leer')),
                        ],
                      )
                    ],
                  ),
                );
          },
        )
      );
    } 
  }
}

