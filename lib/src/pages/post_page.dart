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
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool isValid = true;

  
  // @override
  // void initState() {
  //   super.initState();
  //   futureAlbum = fetchAlbum();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EasyStory'),
      ),
      drawer: MyDrawer(),
      body: Container(
        padding: EdgeInsets.all(40.0),
        child: ListView(children: <Widget>[
          Divider(),
          Divider(),
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
                    MaterialPageRoute(builder: (context) => AddDetails()),
                );
                }
              }, 
              child: const Text('Siguiente'),
            ),
          ),
        ]),
      ),
    );
  }
}

class AddDetails extends StatefulWidget {
  @override
  _AddDetailsState createState() => _AddDetailsState();
}

class _AddDetailsState extends State<AddDetails> {
  bool isChecked = false;
  String url = "https://easystory-backend.herokuapp.com/api/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar detalles'),
      ),
      body: Container(
        padding: EdgeInsets.all(40.0),
        child: ListView(children: <Widget>[
        Divider(),
        TextField(
          controller: titleText,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Inserte título',
            hintText: 'Título'
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
            hintText: 'Descripción'
          ),
        ),
        Divider(),
        Center(
          child: ElevatedButton(
            onPressed: () { Navigator.pop(context); },
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
            onPressed: () { showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                  title: Text('¿Seguro que deseas publicar?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Regresar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        postBody = {
                           'title': titleText.text.toString(),
                           'description': descriptionText.text.toString(),
                           'content': postText.text.toString()
                        };
                        var body = json.encode(postBody); 
                        http.Response response = await http.post(Uri.parse(url + "users/1/posts"), headers: headers(), body: body);
                        Navigator.pop(context);
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text('Publicación realizada'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, '/feed');
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
            },
            child: const Text('Publicar')
          )
        ),
      ]),
    ),);
  }
}
