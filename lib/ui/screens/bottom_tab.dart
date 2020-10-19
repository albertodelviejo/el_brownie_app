import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:flutter/material.dart';

class BottomTabBarr extends StatefulWidget {
  Widget widgetoutside;
  BottomTabBarr({this.widgetoutside});

  @override
  _BottomTabBarrState createState() => _BottomTabBarrState();
}

class _BottomTabBarrState extends State<BottomTabBarr> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List _widgetOptions = [
    // HomeScreen(),
    // PrintScreen(),
    // SettingScreen(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: widget.widgetoutside ?? _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 30,
          selectedItemColor: Mystyle.primarycolo,
          unselectedItemColor: Colors.grey[400],
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              title: Text('Projects'),
              icon: Icon(Icons.library_books),
            ),
            BottomNavigationBarItem(
              title: Text('Settings'),
              icon: Icon(Icons.settings),
            ),
            BottomNavigationBarItem(
              title: Text('More'),
              icon: Icon(Icons.more),
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
