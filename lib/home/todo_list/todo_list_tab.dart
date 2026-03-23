import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/home/todo_list/task_item.dart';
import 'package:todo_app/my_theme.dart';

class TodoListTab extends StatefulWidget {
  static const String routeName = '/todo_list';

  const TodoListTab({super.key});

  @override
  State<TodoListTab> createState() => _TodoListTabState();
}

class _TodoListTabState extends State<TodoListTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CalendarTimeline(
          initialDate: DateTime.now(),
          firstDate: DateTime.now().subtract(Duration(days: 365)),
          lastDate: DateTime.now().add(Duration(days: 365)),
          onDateSelected: (date) => print(date),
          leftMargin: 20,
          monthColor: MyTheme.blackColor,
          dayColor: MyTheme.blackColor,
          activeDayColor: MyTheme.primaryColor,
          activeBackgroundDayColor: MyTheme.whiteColor,

          selectableDayPredicate: (date) => true,
          locale: 'en_ISO',
        ),
        SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) => TaskItem(),
            itemCount: 20,
          ),
        ),
      ],
    );
  }
}
