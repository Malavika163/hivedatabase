import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hivedatabase/modelclass.dart';

class PersonPage extends StatefulWidget {
   PersonPage({super.key});

  @override
  _PersonPageState createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  final _box = Hive.box<Person>('peopleBox');
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Person CRUD')),
      body: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _ageController,
            decoration: InputDecoration(labelText: 'Age'),
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
            onPressed: () {
              final name = _nameController.text;
              final age = int.tryParse(_ageController.text) ?? 0;
              _addPerson(Person(name: name, age: age));
            },
            child: Text('Add Person'),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _box.listenable(),
              builder: (context, Box<Person> box, _) {
                if (box.values.isEmpty) {
                  return Center(child: Text('No people added'));
                }
                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final person = box.getAt(index);
                    return ListTile(
                      title: Text('${person?.name}, Age: ${person?.age}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _showUpdateDialog(index, person!),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deletePerson(index),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addPerson(Person person) {
    _box.add(person);
    _nameController.clear();
    _ageController.clear();
  }

  void _deletePerson(int index) {
    _box.deleteAt(index);
  }

  void _showUpdateDialog(int index, Person person) {
    // Pre-fill the dialog with the existing values
    _nameController.text = person.name;
    _ageController.text = person.age.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Person'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final updatedName = _nameController.text;
                final updatedAge = int.tryParse(_ageController.text) ?? person.age;

                _updatePerson(index, Person(name: updatedName, age: updatedAge));
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _updatePerson(int index, Person updatedPerson) {
    _box.putAt(index, updatedPerson);
     // Update person in Hive box
    _nameController.clear();
    _ageController.clear();
  }
}

