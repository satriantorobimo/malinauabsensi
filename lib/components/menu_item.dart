import 'package:flutter/material.dart';

class MenuItem {
  const MenuItem({
    required this.text,
  });

  final String text;
}

class MenuItems {
  static const List<MenuItem> firstItems = [profile, ubahPassword];
  static const List<MenuItem> secondItems = [setting, logout];

  static const profile = MenuItem(text: 'Profile');
  static const ubahPassword = MenuItem(text: 'Ubah Password');
  static const setting = MenuItem(text: 'Setting');
  static const logout = MenuItem(text: 'Logout');

  static Widget buildItem(MenuItem item) {
    return Text(
      item.text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    );
  }
}
