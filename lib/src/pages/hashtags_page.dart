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
  final int argument;
  const HashtagPage({Key key, this.argument}) : super(key: key);
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
        backgroundColor: Colors.black,
      ),
      body:            
      ListView(         
        scrollDirection: Axis.vertical,
        shrinkWrap: false,
        
        children: <Widget>[
          GridView.count(
            padding: EdgeInsets.all(10),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            crossAxisCount: 3,
            childAspectRatio: 1.5,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
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
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade300),                   
                    minimumSize: MaterialStateProperty.all(Size(188, 136)),
                    padding: MaterialStateProperty.all(EdgeInsets.all(20)), 
                    shape: MaterialStateProperty.all(new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          )),
                    
                  ),
                  
                  child: 
                  Text(
                    ('#' + dataHashtags[index]['name']).toLowerCase(),
                    style: TextStyle(
                        color: Colors.black,
                      ),
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
        backgroundColor: Colors.black,
      ),
      
      body: Container(                    
          child: ListView.builder(
            itemCount: dataPost == null ? 0 : dataPost.length,            
            itemBuilder: (BuildContext context, i) {
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