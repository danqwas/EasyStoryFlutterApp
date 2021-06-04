import 'dart:convert';
import 'package:easystory/src/endpoints/endpoints.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String url = "https://easystory-backend.herokuapp.com/api/";
  List dataPosts = [];

  Future<String> getPosts() async {
    var response =
        await http.get(Uri.parse(url + "posts"), headers: headers());

    setState(() {
      var extractdata = json.decode(response.body);

      dataPosts = extractdata['content'];
    });
    print(dataPosts);
    return response.body.toString();
  }
  
  @override
  void initState() {
    super.initState();
    getPosts();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                          TextButton(onPressed: () {}, child: Text('Detalles')),
                          TextButton(onPressed: () {}, child: Text('Leer')),
                        ],
                      )
                    ],
                  ),
                );
        },
      )
    ),);
  }
}