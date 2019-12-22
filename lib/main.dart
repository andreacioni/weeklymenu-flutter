import 'package:flutter/material.dart';

import './app_bar.dart';
import './page.dart';

void main() => runApp(WMApp());

class WMApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weekly Menu',
      home: WMHomePage(),
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.yellow,
        accentColor: Colors.yellowAccent,

        // Define the default font family.
        fontFamily: 'Aerial',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
    );
  }
}

class WMHomePage extends StatefulWidget {
  WMHomePage({Key key}) : super(key: key);

  @override
  _WMHomePageState createState() => _WMHomePageState();
}

class _WMHomePageState extends State<WMHomePage> {
  final _pageController = new PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WMAppBar(),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4.0,
        icon: const Icon(Icons.calendar_today),
        label: const Text('TODAY'),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.delete_outline),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {},
            )
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
            height: double.infinity,
            width: double.infinity,
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: PageView(
              controller: _pageController,
              children: <Widget>[
                MenuPage("Mon. 7 Dec."),
                MenuPage("Today"),
                MenuPage("Mon. 9 Dec.")
              ],
            ),
          )
        ],
      ),
    );
  }
}
