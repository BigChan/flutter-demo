import 'package:flutter/material.dart';

void main() => runApp(MyApp(new List<String>.generate(1000, (i) => 'item $i')));

class MyApp extends StatelessWidget {
  final List<String> items;
  MyApp(this.items);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Hello World'),
        ),
        body: new ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return new ListTile(
              title: new Text('${items[index]}'),
            );
          },
        ),
      ),
    );
  }
}

class MyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        new Container(
          width: 180,
          color: Colors.lightBlue,
        ),
        new Container(
          width: 180,
          color: Colors.amber,
        ),
        new Container(
          width: 180,
          color: Colors.deepOrange,
        ),
        new Container(
          width: 180,
          color: Colors.deepPurpleAccent,
        ),
        new Container(
          width: 180,
          color: Colors.lightBlue,
        ),
      ],
    );
  }
}
