import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:literowanie/Litery.dart';
import 'package:requests/requests.dart';

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
  Future<List<String>> hyphenated;
  Litery _radioValue = Litery.OBIE;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    hyphenated = createFuture();
    _controller = TextEditingController();
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
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
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Radio(
                      value: Litery.MALE,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                    new Text(
                      'małe\nlitery',
                      style: new TextStyle(fontSize: 16.0),
                    ),
                    new Radio(
                      value: Litery.DUZE,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                    new Text(
                      'DUŻE\nlitery',
                      style: new TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    new Radio(
                      value: Litery.OBIE,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                    new Text(
                      'małe i\nDUŻE',
                      style: new TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Wpisz słowo do literowania',
                      ),
                    )),
                Row(
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text(_controller.text),
                            );
                          },
                        );
                      },
                      child: Text("Sylabizuj"),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    RaisedButton(
                      onPressed: () {},
                      child: Text("Literuj"),
                    ),
                  ],
                ),
                FutureBuilder(
                  future: hyphenated,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data.toString());
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

  void _handleRadioValueChange(Object value) {
    setState(() {
      _radioValue = value;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  Future<List<String>> getIt() async {
    String url = 'https://www.ushuaia.pl/hyphen/';
    String hostname = Requests.getHostname(url);
    var r = await Requests.get(url);
    r.raiseForStatus();
    Future<Map<String, String>> cookies = Requests.getStoredCookies(hostname);
    r = await Requests.get(
        'https://www.ushuaia.pl/hyphen/hyphenate.php?word=test&lang=pl_PL',
        verify: false);
    r.raiseForStatus();
    if (r.statusCode == 200) {
      return r.content().split(new RegExp('<span class="hyphen">•</span>'));
    } else {
      throw Exception('Failed to load page');
    }
  }

  Future<List<String>> createFuture() {
//  return Future.delayed(Duration(milliseconds: 10),()=> ["lis","ta"]);
  return Future<List<String>>.value(["lis","tsa"]);
  }
}
/*
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(todo: todos[index]),
 */