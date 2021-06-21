import 'dart:convert';
import 'package:easystory/src/endpoints/endpoints.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../drawer.dart';
import 'post_details.dart';

class BookmarkPage extends StatefulWidget {
   final int argument;
   const BookmarkPage({Key key, this.argument}) : super(key: key);
 
   @override
   _BookmarkPageState createState() => _BookmarkPageState();
 }
 
 class _BookmarkPageState extends State<BookmarkPage> {
   bool isLoaded = false;
   bool isEmpty = true;
   List<dynamic> dataBookmarks = [];
   
   Future<String> getBookmarks() async {
      var bookmarkResponse = await http.get(Uri.parse(url() + "users/${widget.argument}/bookmarks"), headers: headers());
      var postResponse = await http.get(Uri.parse(url() + "posts"), headers: headers());
      setState(() {
        var bookmarkExtract = json.decode(bookmarkResponse.body);
        var postExtract = json.decode(postResponse.body);
        for (var itemA in bookmarkExtract['content']){
          for (var itemB in postExtract['content']) {
            if (itemB['id'] == itemA['postId']){
              dataBookmarks.add(itemB);
            }
          }
        }
      });
      isLoaded = true;
      if (dataBookmarks.isEmpty){ isEmpty = true; }
      else { isEmpty = false; }
      print(isEmpty);
      return bookmarkResponse.body.toString();
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
        title: Text('Tus marcadores'),
        backgroundColor: Colors.black,
      ),
      drawer: MyDrawer(argument: widget.argument),
      body: Center(
        child: _userBookmarks()
      ),
    );
   }

   Widget _userBookmarks() {
     if (!isLoaded) {
       return Center(child:CircularProgressIndicator());
     }
     else {
      if (isEmpty){
        return Text('No tienes marcadores. ¡Empieza añadiendo algunos!');
      }
      else {
        return Container(
          child: ListView.builder(
            itemCount: dataBookmarks == null ? 0 : dataBookmarks.length,
            itemBuilder: (BuildContext context, i){
            return Card(
                      elevation: 1.0,
                      margin: EdgeInsets.only(bottom:2.0,top:14.0,left:15.0,right:15.0),
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      ),
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Column(
                        children: [
                          Image(
                            image: AssetImage('lib/src/images/gatito.jpg'),
                            fit: BoxFit.fill,
                          ),
                          ListTile(
                            title: Text(dataBookmarks[i]['title']),
                            subtitle: Text(dataBookmarks[i]['description']),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(onPressed: () {
                                showDialog<void>(
                                  context: context,
                                  builder: (BuildContext loadContext) => AlertDialog(
                                    title: Text('¿Quieres eliminar este marcador?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(loadContext);
                                          showDialog<void>(
                                            context: loadContext,
                                            builder: (BuildContext context) => AlertDialog(
                                              title: Center(child:CircularProgressIndicator())
                                            ),
                                          );
                                          int postId = dataBookmarks[i]['id'];
                                          http.Response response = await http.delete(Uri.parse(url() + "users/${widget.argument}/posts/$postId/bookmarks"), headers: headers());
                                          print(response);
                                          setState(() {
                                            dataBookmarks.remove(dataBookmarks[i]);
                                            if (dataBookmarks.isEmpty){isEmpty=true;}
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text('Sí'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('No'),
                                      ),
                                    ]
                                  )
                                );
                              }, icon: Icon(Icons.delete)),
                              TextButton(onPressed: () {
                                Navigator.push(context,
                                  MaterialPageRoute(
                                    builder: (context) => PostDetails(
                                      argument: widget.argument, 
                                      postId: dataBookmarks[i]['id']
                                    )
                                  )
                                );
                             }, child: Text('Leer')),
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
 }
