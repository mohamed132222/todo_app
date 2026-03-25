import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/home/todo_list/task_item.dart';
import 'package:todo_app/my_theme.dart';
import 'package:todo_app/providers/auth_provider.dart';

import '../../providers/settings_provider.dart';

class TodoListTab extends StatefulWidget {
  static const String routeName = '/todo_list';
  const TodoListTab({super.key});

  @override
  State<TodoListTab> createState() => _TodoListTabState();
}

class _TodoListTabState extends State<TodoListTab> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SettingsProvider>(context);
    var authProvider = Provider.of<AuthProviderApp>(context);

    // 🔹 Load tasks if empty
    if (provider.taskList.isEmpty) {
      provider.getAllTask(authProvider.currentUser?.id ?? "");
    }

    return Column(
      children: [
        // ================= Calendar Timeline =================
        CalendarTimeline(
          initialDate: provider.selectedDate,
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          onDateSelected: (date) {
            if (date != null) {
              provider.changeDateTime(date);
              provider.getAllTask(authProvider.currentUser?.id ?? "");
            }
          },
          leftMargin: 20,
          monthColor: MyTheme.blackColor,
          dayColor: MyTheme.blackColor,
          activeDayColor: MyTheme.primaryColor,
          activeBackgroundDayColor: MyTheme.whiteColor,
          selectableDayPredicate: (date) => true,
          locale: 'en_ISO',
        ),

        const SizedBox(height: 10),

        // ================= Task List =================
        Expanded(
          child: provider.taskList.isEmpty
              ? const Center(
                  child: Text(
                    "No tasks for this day",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: provider.taskList.length,
                  itemBuilder: (context, index) {
                    return TaskItem(task: provider.taskList[index]);
                  },
                ),
        ),
      ],
    );
  }
}
