import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../globals/constants.dart';
import '../add_recipe_modal/add_recipe_to_menu_modal.dart';
import '../app_bar.dart';
import './page.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  PageController _pageController;
  DateTime _day;

  @override
  void initState() {
    var pageIndex = (PAGEVIEW_LIMIT_DAYS / 2).truncate();
    _pageController = new PageController(initialPage: pageIndex);

    var now = DateTime.now();
    _day = DateTime(now.year, now.month, now.day);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Container(
        padding: EdgeInsets.all(10),
        child: PageView.builder(
          itemBuilder: (ctx, index) => MenuPage(_day),
          controller: _pageController,
          onPageChanged: _onPageChanged,
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return BaseAppBar(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.calendar_today),
                SizedBox(
                  width: 5,
                ),
                Text(DateFormat.MMMEd().format(_day)),
              ],
            ),
            onPressed: () => _openDatePicker(context),
          ),
        ],
      ),
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          size: 30.0,
          color: Colors.black,
        ),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.refresh,
            size: 30.0,
            color: Colors.black,
          ),
          onPressed: () => _openAddRecipeModal(context),
        ),
      ],
    );
  }

  void _openDatePicker(BuildContext ctx) {
    showDatePicker(
      context: ctx,
      initialDate: _day,
      firstDate: DateTime.now()
          .subtract(Duration(days: (PAGEVIEW_LIMIT_DAYS / 2).truncate())),
      lastDate: DateTime.now()
          .add((Duration(days: (PAGEVIEW_LIMIT_DAYS / 2).truncate()))),
    ).then(_setNewDate);
  }

  void _onPageChanged(int newPageIndex) {
    print("page changed to $newPageIndex");
    setState(() {
      var now = DateTime.now();
      _day = DateTime(now.year, now.month, now.day).add(
          Duration(days: newPageIndex - (PAGEVIEW_LIMIT_DAYS / 2).truncate()));
    });
  }

  void _setNewDate(DateTime selectedDate) {
    setState(() {
      int oldPageIndex = _pageController.page.truncate();
      if (selectedDate.compareTo(_day) != 0) {
        print(
            "jump length: ${selectedDate.difference(_day).inDays}, from page: ${oldPageIndex} (${_day} to ${selectedDate})");
        int newPageIndex = oldPageIndex + selectedDate.difference(_day).inDays;
        print("jumping to page: $newPageIndex");
        _pageController.jumpToPage(newPageIndex);
      }
      _day = selectedDate;
    });
  }

  void _openAddRecipeModal(ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) => Padding(
        padding: EdgeInsets.all(15),
        child: AddRecipeToMenuModal(
          onSelectionEnd: (_) {},
        ),
      ),
    );
  }
}
