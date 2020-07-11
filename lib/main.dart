import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Nauka literowania'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  Future<String> hyphenated;
  @override
  void initState() {
    super.initState();
    hyphenated = getIt();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
                Text(
                  "Wybierz rodzaj liter",
                  style: TextStyle(fontSize: 35),
                ),
                ButtonBar(
                  children: <Widget>[
                    FlatButton.icon(
                      padding: EdgeInsets.all(0),
                      icon: Icon(
                        Icons.title,
                        size: 20,
                      ),
                      onPressed: (){},
                      label: Text("Małe litery"),
                    ),
                    FlatButton.icon(
                      padding: EdgeInsets.all(0),
                      icon: Icon(
                        Icons.title,
                        size: 30,
                      ),
                      onPressed: () {},
                      label: Text("Duże litery"),
                    ),
                    FlatButton.icon(
                      padding: EdgeInsets.all(0),
                      icon: Icon(Icons.text_fields),
                      onPressed: () {},
                      label: Text("Duże i małe litery"),
                    ),
                  ],
                ),
                SizedBox(width: 300, child: TextField()),
                Text("Wpisz słowo do literowania"),
                FutureBuilder(
                  future: hyphenated,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return CircularProgressIndicator();
                  },
                )
              ],
            ),
          ],
//          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sort_by_alpha),
            title: Text('Litery'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.replay),
            title: Text('Losowo'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_numbered),
            title: Text('Cyfry'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  Future<String> getIt() async {
    final response =
//    await http.get('https://jsonplaceholder.typicode.com/albums/1');
        await http.get(
            'https://www.ushuaia.pl/hyphen/');

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load album');
    }
  }
}
