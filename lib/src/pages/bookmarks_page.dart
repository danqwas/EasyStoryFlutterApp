import 'dart:convert';
import 'package:easystory/src/endpoints/endpoints.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../drawer.dart';

class BookmarkPage extends StatefulWidget {
   final int argument;
   const BookmarkPage({Key key, this.argument}) : super(key: key);
 
   @override
   _BookmarkPageState createState() => _BookmarkPageState();
 }
 
 class _BookmarkPageState extends State<BookmarkPage> {
    var dataBookmarks;

    Future<String> getBookmarks() async {
      var response = await http.get(Uri.parse(url() + "users/${widget.argument}/bookmarks"), headers: headers());
      setState(() {
        var extractdata = json.decode(response.body);
        dataBookmarks = extractdata['content'];
      });
      print(dataBookmarks.runtimeType);
      print(dataBookmarks);
      return response.body.toString();
    }

   @override
   void initState() {
      super.initState();
      getBookmarks();
   }
   
   @override
   Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text('EasyStory'),
      ),
      drawer: MyDrawer(argument: widget.argument),
      body: Center(
        child: Text('No tienes marcadores. Eres el usuario con ID ${widget.argument}'),
      ),
    );
   }
 }
