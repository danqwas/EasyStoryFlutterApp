import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:easystory/src/endpoints/endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:math';

double roundDouble(double value, int places) {
  double mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

TextEditingController commentText = new TextEditingController();

class PostDetails extends StatefulWidget {
  final int argument;
  final int postId;
  const PostDetails({Key key, this.argument, this.postId}) : super(key: key);
  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  var postData;
  var ratingData;
  var commentsData;
  bool isLoaded = false;
  bool commentValid = true;
  bool commentsLoaded = false;
  String authorName;
  int authorId;
  var currentRating = 3.0;
  var averageRating = 0.0;
  Map ratingBody = new Map();
  bool alreadyVoted = false;

  Future<String> getPostById(int id) async {
    var response =
        await http.get(Uri.parse(url() + "posts/$id"), headers: headers());
    setState(() {
      var extractdata = json.decode(response.body);
      postData = extractdata;
      authorId = postData['userId'];
    });
    var userResponse = await http.get(Uri.parse(url() + "users/$authorId"),
        headers: headers());
    setState(() {
      var extractUserData = json.decode(userResponse.body);
      print(extractUserData);
      authorName = extractUserData['username'].toString();
    });
    var ratingResponse = await http
        .get(Uri.parse(url() + "posts/$id/qualifications"), headers: headers());
    setState(() {
      var extractRatingData = json.decode(ratingResponse.body);
      ratingData = extractRatingData['content'];
      if (ratingData.length == 0) {
        averageRating = 0.0;
      } else {
        double sum = 0;
        var total = 0;
        for (var item in ratingData) {
          total += 1;
          sum += item['qualification'];
          print(item['qualification'].runtimeType);
          if (item['userId'] == widget.argument) {
            alreadyVoted = true;
            currentRating = item['qualification'];
          }
        }
        // averageRating = sum / total;
        averageRating = roundDouble((sum / total), 2);
      }
    });
    isLoaded = true;
    print(postData);
    return response.body.toString();
  }

  Future<String> getCommentsByPostId(int postId) async {
    commentsData = [];
    commentsLoaded = false;
    var response = await http.get(Uri.parse(url() + "posts/$postId/comments"),
        headers: headers());
    var allUsersResponse =
        await http.get(Uri.parse(url() + "users"), headers: headers());
    setState(() {
      var extractdata = json.decode(response.body);
      var extractUsersData = json.decode(allUsersResponse.body);
      List usersData = extractUsersData['content'];
      commentsData = extractdata['content'];
      for (var itemA in commentsData) {
        for (var itemB in usersData) {
          if (itemA['userId'] == itemB['id']) {
            itemA['username'] = itemB['username'];
          }
        }
      }
    });
    commentsLoaded = true;
    print("COMENTARIAZOS: $commentsData");
    return response.body.toString();
  }

  @override
  void initState() {
    super.initState();
    getPostById(widget.postId);
    getCommentsByPostId(widget.postId);
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
      return Center(child: CircularProgressIndicator());
    } else {
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
                    style:
                        TextStyle(fontWeight: FontWeight.w300, fontSize: 15)),
                Text(authorName,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ]),
              Divider(),
              Row(children: <Widget>[
                Text("Calificación promedio: ",
                    style:
                        TextStyle(fontWeight: FontWeight.w300, fontSize: 15)),
                Text("$averageRating",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ]),
              Divider(),
              Text(postData['content'],
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
                  textAlign: TextAlign.justify),
              Divider(),
              RatingBar.builder(
                initialRating: currentRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  currentRating = rating;
                  print(rating);
                },
              ),
              ElevatedButton(
                child: Text("Calificar"),
                onPressed: () async {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Center(child: CircularProgressIndicator()),
                    ),
                  );
                  ratingBody = {'qualification': currentRating.round()};
                  var body = json.encode(ratingBody);
                  if (alreadyVoted) {
                    http.Response response = await http.put(
                        Uri.parse(url() +
                            "users/${widget.argument}/posts/${widget.postId}/qualifications"),
                        headers: headers(),
                        body: body);
                    print(response);
                  } else {
                    http.Response response = await http.post(
                        Uri.parse(url() +
                            "users/${widget.argument}/posts/${widget.postId}/qualifications"),
                        headers: headers(),
                        body: body);
                    print(response);
                  }
                  // total += 1;
                  // averageRating = currentRating.round();
                  Navigator.pop(context);
                },
              ),
              Divider(),
              TextButton(
                child: Text("Ver comentarios"),
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Comentarios"),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                showDialog<void>(
                                    context: context,
                                    builder: (BuildContext loadContext) =>
                                        AlertDialog(
                                          title: TextField(
                                            maxLines: 7,
                                            minLines: 1,
                                            controller: commentText,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Ingresa comentario',
                                              hintText: 'Comentario',
                                              errorText: commentValid
                                                  ? null
                                                  : 'Por favor, escriba un comentario',
                                            ),
                                          ),
                                          content: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                TextButton(
                                                  child: Text("Comentar"),
                                                  onPressed: () async {
                                                    commentText.text.isNotEmpty
                                                        ? commentValid = true
                                                        : commentValid = false;
                                                    if (commentValid) {
                                                      Navigator.pop(
                                                          loadContext);
                                                      showDialog<void>(
                                                        context: loadContext,
                                                        builder: (BuildContext
                                                                context) =>
                                                            AlertDialog(
                                                                title: Center(
                                                                    child:
                                                                        CircularProgressIndicator())),
                                                      );
                                                      Map commentBody = {
                                                        'content': commentText
                                                            .text
                                                            .toString()
                                                      };
                                                      var body = json
                                                          .encode(commentBody);
                                                      print("CUERPAZO: $body");
                                                      http.Response response =
                                                          await http.post(
                                                              Uri.parse(url() +
                                                                  "users/${widget.argument}/posts/${widget.postId}/comments"),
                                                              headers:
                                                                  headers(),
                                                              body: body);
                                                      print(response);
                                                      commentText.text = '';
                                                      setState(() {
                                                        getCommentsByPostId(
                                                            widget.postId);
                                                      });

                                                      Navigator.pop(context);
                                                      // commentsData.add({
                                                      //   'userId': widget.argument,
                                                      //   'content':
                                                      // })
                                                    }
                                                  },
                                                ),
                                                TextButton(
                                                    child: Text("Cancelar"),
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          loadContext);
                                                    })
                                              ]),
                                        ));
                              },
                            ),
                          ]),
                      content: _comments(),
                    ),
                  );
                },
              ),
            ],
          ));
    }
  }

  Widget _comments() {
    if (!commentsLoaded) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Container(
        height: 300.0,
        width: 300.0,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: commentsData == null ? 0 : commentsData.length,
          itemBuilder: (BuildContext context, int i) {
            return ListTile(
              title: Text(commentsData[i]['username']),
              subtitle: Text(commentsData[i]['content']),
            );
          },
        ),
      );
    }
  }
}
