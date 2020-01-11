import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:alarm/time_helper.dart';

var timeHelperService = TimeHelperService();

class CityTimeItem {
  final String name;

  const CityTimeItem(this.name);
}

class ClocksModel extends ChangeNotifier {
  final List<CityTimeItem> _items = [
    CityTimeItem("NEW YORK"),
    CityTimeItem("LONDON"),
    CityTimeItem("LOS ANGELES"),
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
