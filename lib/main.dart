import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              print("Refresh");
            },
            icon: Icon(Icons.refresh),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  hintText: "Type to search",
                  icon: new Icon(Icons.search),
                ),
                onChanged:(string) {
                  print("Text change");
                },
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(15.0),
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          title: Text("Title"),
                          subtitle: Text("SubTitle"),
                        ),
                        Divider(),
                      ],
                    );
                  }
                ),
              ),
            ],
          ),
          Container(  // Spinner
            alignment: AlignmentDirectional.center,
            child: CircularProgressIndicator(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () {
          print("Add");
        },
      ),
    );
  }
}
