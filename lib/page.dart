import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  final _title;

  MenuPage(this._title);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              _title,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 30),
            ),
            IconButton(
              icon: Icon(
                Icons.mode_edit,
                size: 20.0,
                color: Colors.black,
              ),
              onPressed: () => {print("edit menu")},
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                size: 20.0,
                color: Colors.black,
              ),
              onPressed: () => {print("delete menu")},
            ),
          ],
        ),
        Card(
          elevation: 6,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "Lunch",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Divider(),
                Container(
                  height: 400,
                  width: double.infinity,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "Dinner",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 200,
                  width: double.infinity,
                ),
              ],
            ),
          ),
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        )
      ],
    );
  }
}
