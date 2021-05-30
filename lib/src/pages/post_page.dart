import 'package:easystory/src/drawer.dart';
// import 'package:easystory/src/models/album.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'dart:convert';

TextEditingController postText = new TextEditingController();
TextEditingController descriptionText = new TextEditingController();
TextEditingController titleText = new TextEditingController();

// Future<Album> fetchAlbum() async {
//   final response =
//       await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     return Album.fromJson(jsonDecode(response.body));
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load album');
//   }
// }

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  // Future<Album> futureAlbum;
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
          // FutureBuilder<Album>(
          //   future: futureAlbum,
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       postText.text = snapshot.data.userId.toString();
          //       return Text('');
          //     } else if (snapshot.hasError) {
          //       return Text("${snapshot.error}");
          //     }

          //     // By default, show a loading spinner.
          //     return CircularProgressIndicator();
          //   },
          // ),
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
                      onPressed: () {
                        Navigator.pop(context);
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text('Publicación realizada'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
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
