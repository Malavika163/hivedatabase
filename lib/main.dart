import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hivedatabase/curdoperations.dart';
import 'package:hivedatabase/modelclass.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
  await Hive.openBox<Person>('peopleBox');
  runApp( MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:PersonPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StoredataPage {
}