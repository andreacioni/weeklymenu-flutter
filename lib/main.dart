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
