import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google/pages/map.dart';
import 'package:flutter_google/pages/Announcements.dart';
import 'package:flutter_google/pages/Profile.dart';
import 'package:flutter_google/pages/Hotline.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Commodity',
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key }) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage>{
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static  List<Widget> _widgetOptions = <Widget>[
    MapPage(),
    Profile(),
    Hotline(),
  ];
  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Commodity"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: "Map"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile"),
          BottomNavigationBarItem(
              icon: Icon(Icons.phone),
              label: "Hotlines"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ) ,
    );
  }
}
