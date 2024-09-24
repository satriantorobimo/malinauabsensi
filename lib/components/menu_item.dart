import 'package:flutter/material.dart';

class MenuItem {
  const MenuItem({
    required this.text,
  });

  final String text;
}

class MenuItems {
  static const List<MenuItem> firstItems = [setting];
  static const List<MenuItem> secondItems = [logout];

  static const setting = MenuItem(text: 'Setting');
  static const logout = MenuItem(text: 'Logout');

  static Widget buildItem(MenuItem item) {
    return Text(
      item.text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    );
  }

  static void onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.setting:
        //Do something
        break;
      case MenuItems.logout:
        //Do something
        break;
    }
  }
}
