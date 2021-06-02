import 'dart:convert';
import 'package:easystory/src/endpoints/endpoints.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HashtagPage extends StatefulWidget {
  @override
  _HashtagPageState createState() => _HashtagPageState();
}

class _HashtagPageState extends State<HashtagPage> {
  String url = "https://easystory-backend.herokuapp.com/api/";
  List dataHashtags = [];
  List dataPost = [];

  Future<String> getHashtags() async {
    var response =
        await http.get(Uri.parse(url + "hashtags"), headers: headers());

    setState(() {
      var extractdata = json.decode(response.body);

      dataHashtags = extractdata['content'];
    });

    return response.body.toString();
  }

  Future<String> getPostsbyHashtagId(int id) async {
    var response = await http.get(Uri.parse(url + "hashtags/$id/posts"),
        headers: headers());

    setState(() {
      var extractdata = json.decode(response.body);

      dataPost = extractdata['content'];
    });

    print(dataPost);
    return response.body.toString();
  }

  @override
  void initState() {
    super.initState();
    getHashtags();
  }

  void getData(int id) {
    setState(() {
      getPostsbyHashtagId(id);
    });
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
                    getData(index + 1);
                  },
                  child: Text(
                    ('#' + dataHashtags[index]['name']).toLowerCase(),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              );
            }),
          ),
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
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
              }),
        ],
      ),
    );
  }
}
