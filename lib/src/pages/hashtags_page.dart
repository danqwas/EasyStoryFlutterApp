import 'dart:convert';
import 'package:easystory/src/endpoints/endpoints.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String url = "https://easystory-backend.herokuapp.com/api/";
List dataPost = [];
int hashtagId;
List dataHashtags = [];

class HashtagPage extends StatefulWidget {
  @override
  _HashtagPageState createState() => _HashtagPageState();
}

class _HashtagPageState extends State<HashtagPage> {
  Future<String> getHashtags() async {
    var response =
        await http.get(Uri.parse(url + "hashtags"), headers: headers());

    setState(() {
      var extractdata = json.decode(response.body);

      dataHashtags = extractdata['content'];
    });

    return response.body.toString();
  }

  @override
  void initState() {
    super.initState();
    getHashtags();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hashtag List"),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: false,
        children: <Widget>[
          GridView.count(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            crossAxisCount: 3,
            childAspectRatio: 1.5,
            children: List.generate(dataHashtags.length, (index) {
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    dataPost = [];
                    hashtagId = index + 1;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PostHashtagsDetails()),
                    );
                  },
                  child: Text(
                    ('#' + dataHashtags[index]['name']).toLowerCase(),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class PostHashtagsDetails extends StatefulWidget {
  @override
  _PostHashtagsDetailsState createState() => _PostHashtagsDetailsState();
}

class _PostHashtagsDetailsState extends State<PostHashtagsDetails> {
  Future<String> getPostsbyHashtagId(int id) async {
    var response = await http.get(Uri.parse(url + "hashtags/$id/posts"),
        headers: headers());

    setState(() {
      var extractdata = json.decode(response.body);

      dataPost = extractdata['content'];
    });

    return response.body.toString();
  }

  @override
  void initState() {
    super.initState();
    getPostsbyHashtagId(hashtagId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hashtag #' + dataHashtags[hashtagId - 1]['name']),
      ),
      body: Container(
          padding: EdgeInsets.all(40.0),
          child: ListView.builder(
            itemCount: dataPost == null ? 0 : dataPost.length,
            itemBuilder: (BuildContext context, i) {
              return Card(
                elevation: 10.0,
                child: Column(
                  children: [
                    Image(
                      image: AssetImage('lib/src/images/gatito.jpg'),
                    ),
                    ListTile(
                      title: Text(dataPost[i]['title']),
                      subtitle: Text(dataPost[i]['content']),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(onPressed: () {}, child: Text('Detalles')),
                        TextButton(onPressed: () {}, child: Text('Leer')),
                      ],
                    )
                  ],
                ),
              );
            },
          )),
    );
  }
}