// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:todo/util/db_helper.dart';
import 'package:uuid/uuid.dart';

import 'package:todo/util/text_model.dart';

class TextProvider with ChangeNotifier {
  List<TextModel> _listOfTexts = [];
  List<TextModel> _archivedTexts = [];

  List get listOfTexts => [..._listOfTexts];
  List get archivedTexts => [..._archivedTexts];

  var _uuid = const Uuid();

  Future<void> removeEleFromList(int index, String id) async {
    final dbHelper = DatabaseHelper.instance;

    _archivedTexts.add(listOfTexts[index]);
    _listOfTexts.removeAt(index);

    // ignore: unused_local_variable
    final rowsDeleted = await dbHelper.delete(id);
    notifyListeners();
    return;
  }

  Future<void> undoRemoveEle(int index) async {
    _listOfTexts.insert(index, _archivedTexts[index]);
    final dbHelper = DatabaseHelper.instance;
    Map<String, dynamic> _row = {
      DatabaseHelper.columnId: _archivedTexts[index].id,
      DatabaseHelper.columnText: _archivedTexts[index].text,
      DatabaseHelper.columnDate: _archivedTexts[index].date,
    };
    // ignore: unused_local_variable
    final _idRow = await dbHelper.insert(_row);
    notifyListeners();
    return;
  }

  Future<void> loadEles() async {
    final dbHelper = DatabaseHelper.instance;
    final allRows = await dbHelper.queryAllRows();

    for (var i = 0; i < allRows.length; i++) {
      List<TextModel> _data = [
        TextModel(
          id: allRows[i]['_id'],
          date: allRows[i]['date'],
          text: allRows[i]['text'],
        ),
      ];
      _listOfTexts.insert(0, _data[0]);
    }
    notifyListeners();
    return;
  }

  Future<void> addEle(String text) async {
    var _id = _uuid.v4();
    final dbHelper = DatabaseHelper.instance;
    final _date = DateTime.now().toString();

    _listOfTexts.add(
      TextModel(
        text: text,
        date: _date,
        id: _id,
      ),
    );

    Map<String, dynamic> _row = {
      DatabaseHelper.columnId: _id,
      DatabaseHelper.columnText: text,
      DatabaseHelper.columnDate: _date,
    };
    // ignore: unused_local_variable
    final _idRow = await dbHelper.insert(_row);
    notifyListeners();
    return;
  }
}
