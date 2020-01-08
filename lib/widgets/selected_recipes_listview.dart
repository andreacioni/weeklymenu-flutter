import 'package:flutter/material.dart';

class SelectedRecipesListView extends StatefulWidget {
  @override
  _SelectedRecipesListViewState createState() => _SelectedRecipesListViewState();
}

class _SelectedRecipesListViewState extends State<SelectedRecipesListView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: <Widget>[
          ListTile(title: Text("Aja"), trailing: IconButton(icon: Icon(Icons.clear), onPressed: () {},),),          ListTile(title: Text("Aja"), trailing: IconButton(icon: Icon(Icons.clear), onPressed: () {},),),
          ListTile(title: Text("Aja"), trailing: IconButton(icon: Icon(Icons.clear), onPressed: () {},),),
          ListTile(title: Text("Aja"), trailing: IconButton(icon: Icon(Icons.clear), onPressed: () {},),),
          ListTile(title: Text("Aja"), trailing: IconButton(icon: Icon(Icons.clear), onPressed: () {},),),
          ListTile(title: Text("Aja"), trailing: IconButton(icon: Icon(Icons.clear), onPressed: () {},),),
          ListTile(title: Text("Aja"), trailing: IconButton(icon: Icon(Icons.clear), onPressed: () {},),),
          ListTile(title: Text("Aja"), trailing: IconButton(icon: Icon(Icons.clear), onPressed: () {},),),
          ListTile(title: Text("Aja"), trailing: IconButton(icon: Icon(Icons.clear), onPressed: () {},),),
          ListTile(title: Text("Aja"), trailing: IconButton(icon: Icon(Icons.clear), onPressed: () {},),),

        ],
      ),
    );
  }
}