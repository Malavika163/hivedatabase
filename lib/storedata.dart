import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StoreddataPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<StoreddataPage> {
  Box? _box;

  TextEditingController _controller = TextEditingController();
  TextEditingController _controller1=TextEditingController();
  String _storedData = "";
  String storeemail="";

  @override
  void initState() {
    super.initState();
    _openBox();  
  }

  Future<void> _openBox() async {
    _box = await Hive.openBox('myBox');
    _getData();
  }

  void _saveData() {
    if (_controller.text.isNotEmpty&&_controller1.text.isNotEmpty) {
      _box!.put('name', _controller.text,);
      _box!.put('email', _controller1.text,);

      _getData();  
    }
  }

  void _getData() {
    setState(() {
      _storedData = _box!.get('name', defaultValue: 'No data saved');
      storeemail=_box!.get('email',defaultValue: 'No data Saved');
    });
  }

  @override
  void dispose() {
    _box?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.blue,
        title: Center(child: Text('Hive data display'))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _controller1,
              decoration: InputDecoration(
                labelText: 'Enter your email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveData,
              
              child: Text('Save data'),
            ),
            SizedBox(height: 20),
            Text('Stored Name: $_storedData'),
            Text('stored email :$storeemail'),
          ],
        ),
      ),
    );
  }
}
