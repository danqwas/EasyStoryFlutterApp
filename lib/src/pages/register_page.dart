import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:easystory/src/endpoints/endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String url = "https://easystory-backend.herokuapp.com/api/";
  TextEditingController userText = new TextEditingController();
  TextEditingController passText = new TextEditingController();
  TextEditingController firstNameText = new TextEditingController();
  TextEditingController lastNameText = new TextEditingController();
  TextEditingController emailText = new TextEditingController();
  TextEditingController phoneText = new TextEditingController();
  TextEditingController repeatPassText = new TextEditingController();
  Map userBody = new Map();
  bool userValid = true;
  bool passValid = true;
  bool firstNameValid = true;
  bool lastNameValid = true;
  bool emailValid = true;
  bool phoneValid = true;
  bool repeatPassValid = true;
  bool conditionsAccepted = false;
  @override
  Widget build(BuildContext context) {
    //var userId;
    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image(
            image: AssetImage('lib/src/images/fondo.png'),
            fit: BoxFit.cover,
            color: Colors.black54,
            colorBlendMode: BlendMode.darken,
          ),
          ListView(
            padding: EdgeInsets.only(top: 50, left:40, right:40, bottom:40),
            children: <Widget>[
              Image.asset(
                'lib/src/images/libro2.png',
                height: 100,
                width: 100,
              ),
              Form(
                  child: Theme(
                data: ThemeData(
                    brightness: Brightness.dark,
                    primarySwatch: Colors.blue,
                    inputDecorationTheme: InputDecorationTheme(
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 20))),
                child: Container(
                  padding: EdgeInsets.only(bottom:40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        controller: emailText,
                        decoration: InputDecoration(
                          labelText: "Correo",
                          errorText: emailValid ? null : 'Ingrese su correo',
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              child: TextFormField(
                                controller: firstNameText,
                                decoration: InputDecoration(
                                  labelText: "Nombre",
                                  errorText: firstNameValid
                                      ? null
                                      : 'Ingrese su nombre',
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                            Spacer(),
                            Flexible(
                              child: TextFormField(
                                controller: lastNameText,
                                decoration: InputDecoration(
                                  labelText: "Apellido",
                                  errorText: lastNameValid
                                      ? null
                                      : 'Ingrese su apellido',
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                          ]),
                      TextFormField(
                        controller: phoneText,
                        decoration: InputDecoration(
                          labelText: "Teléfono",
                          errorText: phoneValid ? null : 'Ingrese su telefono',
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      TextFormField(
                        controller: userText,
                        decoration: InputDecoration(
                          labelText: "Usuario",
                          errorText: userValid ? null : 'Ingrese su usuario',
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      TextFormField(
                        controller: passText,
                        decoration: InputDecoration(
                          labelText: "Contraseña",
                          errorText: passValid ? null : 'Ingrese su contraseña',
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                      ),
                      TextFormField(
                        controller: repeatPassText,
                        decoration: InputDecoration(
                          labelText: "Repita contraseña",
                          errorText: repeatPassValid
                              ? null
                              : 'Las contraseñas no coinciden',
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Checkbox(
                            activeColor: Colors.blue,
                            value: conditionsAccepted,
                            onChanged: (bool value) {
                              setState(() {
                                conditionsAccepted = value;
                              });
                            },
                          ),
                          Text(
                            'Acepto los términos y condiciones',
                            style: const TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      userText.text.isNotEmpty
                          ? userValid = true
                          : userValid = false;
                      passText.text.isNotEmpty
                          ? passValid = true
                          : passValid = false;
                      firstNameText.text.isNotEmpty
                          ? firstNameValid = true
                          : firstNameValid = false;
                      lastNameText.text.isNotEmpty
                          ? lastNameValid = true
                          : lastNameValid = false;
                      emailText.text.isNotEmpty
                          ? emailValid = true
                          : emailValid = false;
                      phoneText.text.isNotEmpty
                          ? phoneValid = true
                          : phoneValid = false;
                      repeatPassText.text == passText.text
                          ? repeatPassValid = true
                          : repeatPassValid = false;
                    });
                    if (conditionsAccepted &&
                        userValid &&
                        passValid &&
                        firstNameValid &&
                        lastNameValid &&
                        emailValid &&
                        phoneValid &&
                        repeatPassValid) {
                      userBody = {
                        'username': userText.text.toString(),
                        'password': passText.text.toString(),
                        'firstName': firstNameText.text.toString(),
                        'lastName': lastNameText.text.toString(),
                        'email': emailText.text.toString(),
                        'telephone': phoneText.text.toString(),
                      };
                      var body = json.encode(userBody);
                      http.Response response = await http.post(
                          Uri.parse(url + "users"),
                          headers: headers(),
                          body: body);

                      Navigator.pushNamed(context, 'login');
                    }
                  },
                  style: ButtonStyle(                                 
                    minimumSize: MaterialStateProperty.all(Size(500, 50)),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical:10,horizontal:10)), 
                    shape: MaterialStateProperty.all(new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          )),
                    
                  ),
                  child: const Text('Registrar'),
                ),
              ),
              Divider(),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: '¿Ya tienes una cuenta? ¡Inicia sesión!',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, 'login');
                      },
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
