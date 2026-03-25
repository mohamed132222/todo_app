import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/task.dart';
import '../utils/firebase_utils.dart';

class SettingsProvider extends ChangeNotifier {
  // اللغة الحالية للتطبيق
  String appLanguage = "en";

  void changeLanguage(String newLanguage) {
    if (appLanguage == newLanguage) return;
    appLanguage = newLanguage;
    notifyListeners();
  }

  // الثيم الحالي
  ThemeMode appTheme = ThemeMode.light;

  void changeTheme(ThemeMode newTheme) {
    if (appTheme == newTheme) return;
    appTheme = newTheme;
    notifyListeners();
  }

  bool isDark() => appTheme == ThemeMode.dark;

  // المهام
  List<Task> taskList = [];
  DateTime selectedDate = DateTime.now();

  void changeDateTime(DateTime newDateTime) {
    selectedDate = newDateTime;
    notifyListeners();
  }

  Future<void> getAllTask(String userId) async {
    QuerySnapshot<Task> querySnapshot = await FirebaseUtils.getTaskCollection(
      userId,
    ).get();

    // تحويل المستندات إلى List<Task>
    taskList = querySnapshot.docs.map((doc) => doc.data()).toList();

    // تصفية المهام حسب التاريخ المحدد
    taskList = taskList.where((task) {
      final taskDate = task.date;
      return taskDate != null &&
          taskDate.day == selectedDate.day &&
          taskDate.month == selectedDate.month &&
          taskDate.year == selectedDate.year;
    }).toList();

    // ترتيب المهام حسب الوقت
    taskList.sort((task1, task2) => task1.date!.compareTo(task2.date!));

    notifyListeners();
  }
}
