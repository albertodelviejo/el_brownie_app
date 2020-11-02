import 'package:el_brownie_app/ui/screens/add/add_comment_screen.dart';
import 'package:el_brownie_app/ui/screens/fav/fav_screen.dart';
import 'package:el_brownie_app/ui/screens/perfil/profile_home_screen.dart';
import 'package:el_brownie_app/ui/utils/mystyle.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

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
    HomeScreen(),
    AddCommentScreen(),
    FavScreen(),
    ProfileHomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: widget.widgetoutside ?? _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 30,
          backgroundColor: Mystyle.primarycolo,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black38,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              title: Text('Buscar'),
              icon: Icon(Icons.search),
            ),
            BottomNavigationBarItem(
              title: Text('Añadir'),
              icon: Icon(Icons.add_circle_outline),
            ),
            BottomNavigationBarItem(
              title: Text('Favoritos'),
              icon: Icon(Icons.bookmark_border),
            ),
            BottomNavigationBarItem(
              title: Text('Perfil'),
              icon: Icon(Icons.person_outline),
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
