import 'package:hive/hive.dart';
 part 'modelclass.g.dart';

@HiveType(typeId: 0)
class Person {
  @HiveField(0)
  String name;

  @HiveField(1)
  int age;

  Person({required this.name, required this.age});
}