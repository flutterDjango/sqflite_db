import 'package:flutter/material.dart';
import 'package:sqflite_db/database/db_helper.dart';

import 'package:sqflite_db/models/student_model.dart';

class StudentProvider extends ChangeNotifier {
  List<StudentModel> studentItem = [];

  Future<void> selectData() async {
    final dataList = await DBHelper.selectAll(DBHelper.tableName);
    studentItem = dataList
        .map(
          (item) => StudentModel(
            id: item['id'],
            lastName: item['lastName'],
            firstName: item['firstName'],
          ),
        )
        .toList();
    notifyListeners();
  }

  Future insertData(
    String lastName,
    String firstName,
  ) async {
    final newStudent = StudentModel(
      id: null,
      lastName: lastName,
      firstName: firstName,
    );
    studentItem.add(newStudent);
    await DBHelper.insert(
      DBHelper.tableName,
      {
        'lastName': newStudent.lastName,
        'firstName': newStudent.firstName,
      },
    );
    notifyListeners();
  }

  Future updateLastName(int id, String lastName) async {
    await DBHelper.update(DBHelper.tableName, 'lastName', lastName, id);
    notifyListeners();
  }

  Future updateFirstName(int id, String firstName) async {
    await DBHelper.update(DBHelper.tableName, 'firstName', firstName, id);
    notifyListeners();
  }

  Future deleteById(int id) async {
    await DBHelper.deleteById(DBHelper.tableName, 'id', id);
    notifyListeners();
  }
}
