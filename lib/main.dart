import 'package:flutter/material.dart';
import 'package:easystory/router.dart' as router;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "EasyStory Flutter App",
      initialRoute: 'feed',
      onGenerateRoute: router.generateRoute,
    );
  }
}