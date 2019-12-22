import 'package:flutter/material.dart';

class MealHead extends StatelessWidget {

  final String _title;

  MealHead(this._title);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            _title,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                tooltip: "Add recipe",
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.delete_outline),
                tooltip: "Delete meal",
                onPressed: () {},
              )
            ],
          ),
        ],
      ),
    );
  }
}
