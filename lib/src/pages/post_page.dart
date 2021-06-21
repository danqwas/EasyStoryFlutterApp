import 'package:easystory/src/drawer.dart';
import 'package:flutter/material.dart';
import 'package:easystory/src/endpoints/endpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

TextEditingController postText = new TextEditingController();
TextEditingController descriptionText = new TextEditingController();
TextEditingController titleText = new TextEditingController();

Map postBody = new Map();

class PostPage extends StatefulWidget {
  final int argument;
  const PostPage({Key key, this.argument}) : super(key: key);
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool isValid = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EasyStory'),
        backgroundColor: Colors.black,
      ),
      drawer: MyDrawer(argument: widget.argument),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: ListView(children: <Widget>[    
                
          TextField(
            controller: postText,
            maxLines: 40,
            minLines: 10,
            
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Escribe una publicación',
              hintText: 'Contenido',
              errorText: isValid ? null : 'La publicación no puede estar vacía',
              
            ),
          ),
          Divider(),
          Center(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                    postText.text.isNotEmpty ? isValid = true : isValid = false;
                  });
                if (isValid) {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddDetails(argument: widget.argument)),
                );
                
                }
              },
              style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.black),                   
                    minimumSize: MaterialStateProperty.all(Size(400, 50)),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical:10,horizontal:10)), 
                    shape: MaterialStateProperty.all(new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          )),
                    
                  ), 
              child: const Text('Siguiente'),
            ),
          ),
        ]),
      ),
    );
  }
}

class AddDetails extends StatefulWidget {
  final int argument;
  const AddDetails({Key key, this.argument}) : super(key: key);
  @override
  _AddDetailsState createState() => _AddDetailsState();
}

class _AddDetailsState extends State<AddDetails> {
  bool isChecked = false;
  bool titleValid = true;
  bool descValid = true;
  String url = "https://easystory-backend.herokuapp.com/api/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar detalles'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: ListView(children: <Widget>[
        Divider(),
        TextField(
          controller: titleText,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Inserte título',
            hintText: 'Título',
            errorText: titleValid ? null : 'Por favor, ingrese un título',
          ),
        ),
        Divider(),
         TextField(
          controller: descriptionText,
          maxLines: 10,
          minLines: 7,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Inserte descripción',
            hintText: 'Descripción',
            errorText: descValid ? null : 'Por favor, ingrese una descripción',
          ),
        ),
        Divider(),
        Center(
          child: ElevatedButton(
            onPressed: () { Navigator.pop(context); },
            style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.black),                   
                    minimumSize: MaterialStateProperty.all(Size(400, 50)),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical:10,horizontal:10)), 
                    shape: MaterialStateProperty.all(new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          )),
                    
                  ), 
            child: const Text('Editar publicación')
          )
        ),
        Divider(),
        Row(children: <Widget>[
          Checkbox(
          checkColor: Colors.white,
          value: isChecked,
          onChanged: (bool value) {
            setState(() {
              isChecked = value;
            });
          },),
          Text('Comprobación de originalidad')
        ],),
        Divider(),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                    descriptionText.text.isNotEmpty ? descValid = true : descValid = false;
                    titleText.text.isNotEmpty ? titleValid = true : titleValid = false;
                  });
              if (titleValid && descValid) {
                showDialog<String>(
                context: context,
                builder: (BuildContext loadContext) => AlertDialog(
                    title: Text('¿Seguro que deseas publicar?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(loadContext),
                        child: Text('Regresar'),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(loadContext);
                          showDialog<void>(
                            context: loadContext,
                            builder: (BuildContext context) => AlertDialog(
                              title: Center(child:CircularProgressIndicator())
                            ),
                          );
                          postBody = {
                            'title': titleText.text.toString(),
                            'description': descriptionText.text.toString(),
                            'content': postText.text.toString()
                          };
                          var body = json.encode(postBody); 
                          http.Response response = await http.post(Uri.parse(url + "users/${widget.argument}/posts"), headers: headers(), body: body);
                          print(response);
                          Navigator.pop(context);
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text('Publicación realizada'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pushNamed(context, 'feed', arguments: widget.argument);
                                  },
                                  child: Text('OK'),
                                  ),
                              ],
                            ),
                          );
                        },
                        child: Text('Publicar'),
                      ),
                    ],
                  ),
                ); 
              }
            },
            style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.black),                   
                    minimumSize: MaterialStateProperty.all(Size(400, 50)),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical:10,horizontal:10)), 
                    shape: MaterialStateProperty.all(new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          )),
                    
                  ), 
            child: const Text('Publicar')
          )
        ),
      ]),
    ),);
  }
}
