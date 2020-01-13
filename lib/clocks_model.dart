import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:alarm/time_helper.dart';

class CityTimeItem {
  final String name;

  const CityTimeItem(this.name);
}

class ClocksModel extends ChangeNotifier {
  var timeHelperService = TimeHelperService();

  final List<CityTimeItem> _items = [
    CityTimeItem("America/New_York"),
    CityTimeItem("London"),
    CityTimeItem("Europe/Moscow"),
    CityTimeItem("LOS_ANGELES"),
    CityTimeItem("PARIS")
  ];

  int _selectedItem = 0;

  UnmodifiableListView<CityTimeItem> get items => UnmodifiableListView(_items);
  int get selectedItem => _selectedItem;

  void setSelection(int index) {
    _selectedItem = index;
    notifyListeners();
  }

  void add(CityTimeItem item) {
    _items.add(item);
    notifyListeners();
  }

  void remove(CityTimeItem item) {
    _items.remove(item);
    notifyListeners();
  }
}
