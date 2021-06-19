import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:easystory/src/endpoints/endpoints.dart';
import 'package:http/http.dart' as http;

class PostDetails extends StatefulWidget {
  final int argument;
  final int postId;
  const PostDetails({ Key key, this.argument, this.postId }) : super(key: key);
  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  var postData;
  bool isLoaded = false;
  String authorName;
  int authorId;



  Future<String> getPostById(int id) async {
    var response =
        await http.get(Uri.parse(url() + "posts/$id"), headers: headers());
    setState(() {
      var extractdata = json.decode(response.body);
      postData = extractdata;
      authorId = postData['userId'];
    });
    var userResponse = await http.get(Uri.parse(url() + "users/$authorId"), headers: headers());
    setState(() {
      var extractUserData = json.decode(userResponse.body);
      print("GAAAAAAAAAAAAAAA");
      print(extractUserData);
      authorName = extractUserData['username'].toString();
    });
    isLoaded = true;
    print(postData);
    return response.body.toString();
  }

  @override
  void initState() {
    super.initState();
    getPostById(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leer publicación"),
      ),
      body: Center(child: _postInfo()),
    );
  }

  Widget _postInfo() {
    if (!isLoaded) {
      return Center(child:CircularProgressIndicator());
    }
    else {
      return Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [
            Divider(),
            Text(postData['title'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
            Divider(),
            Row(children: <Widget>[
              Text("Escrito por: ",
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15)),
              Text(authorName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ]),   
            Divider(),
            Text(postData['content'],
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15), textAlign: TextAlign.justify)   
          ],
        )
      );
    }
  }
}