import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  TextEditingController postText = new TextEditingController();
  bool isValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: <Widget>[
        Divider(),
        TextField(
          controller: postText,
          maxLines: 40,
          minLines: 10,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Escribe una publicación',
            hintText: 'Contenido',
            errorText: isValid ? 'La publicación no puede estar vacía' : null,
          ),
        ),
        Divider(),
        Center(
          child: ElevatedButton(
            onPressed: () {
               setState(() {
                  postText.text.isEmpty ? isValid = true : isValid = false;
                });
              if (!isValid) {
                Navigator.push(context,
                   MaterialPageRoute(builder: (context) => AddDetails()),
               );
              }
            }, 
            child: const Text('Siguiente'),
          ),
        ),
      ]),
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
      body: ListView(children: <Widget>[
        Divider(),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Inserte título',
            hintText: 'Título'
          ),
        ),
        Divider(),
         TextField(
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
                title: const Text('¿Seguro que deseas publicar?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Regresar'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Publicar'),
                  ),
                ],
              ),
            ); 
          },
            child: const Text('Publicar')
          )
        ),
      ]),
    );
  }
}
