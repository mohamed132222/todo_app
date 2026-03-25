import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../model/task.dart';
import '../../my_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import '../../utils/firebase_utils.dart';
import 'task_update_screen.dart';

class TaskItem extends StatefulWidget {
  final Task task;

  TaskItem({required this.task, super.key});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    var provider = Provider.of<SettingsProvider>(context, listen: false);
    var authProvider = Provider.of<AuthProviderApp>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          // الانتقال لشاشة تحديث المهمة
          Navigator.pushNamed(
            context,
            TaskUpdateScreen.routeName,
            arguments: widget.task,
          );
        },
        child: Slidable(
          key: const ValueKey('task_item'),
          startActionPane: ActionPane(
            extentRatio: 0.25,
            motion: const ScrollMotion(),
            dismissible: DismissiblePane(
              onDismissed: () {
                // يمكن هنا إضافة حذف المهمة بالسحب
              },
            ),
            children: [
              SlidableAction(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                onPressed: (context) {
                  // حذف المهمة من Firebase
                  FirebaseUtils.deleteTask(
                    widget.task,
                    authProvider.currentUser?.id ?? "",
                  ).timeout(
                    const Duration(milliseconds: 500),
                    onTimeout: () => print("task deleted successfully"),
                  );

                  // إعادة تحميل قائمة المهام
                  provider.getAllTask(authProvider.currentUser!.id!);
                },
                backgroundColor: MyTheme.redColor,
                foregroundColor: MyTheme.whiteColor,
                icon: Icons.delete,
                label: AppLocalizations.of(context)!.delete,
              ),
            ],
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: provider.isDark() ? MyTheme.darkColor : MyTheme.whiteColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                // شريط اللون على اليسار
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  width: 4,
                  height: mediaQuery.size.height * 0.08,
                  decoration: BoxDecoration(
                    color: widget.task.isDone!
                        ? MyTheme.greenColor
                        : MyTheme.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                // قسم النصوص
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // عنوان المهمة
                      Text(
                        widget.task.title ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontSize: mediaQuery.size.width * 0.045,
                              fontWeight: FontWeight.w700,
                              color: widget.task.isDone!
                                  ? MyTheme.greenColor
                                  : provider.isDark()
                                  ? MyTheme.whiteColor
                                  : MyTheme.primaryColor,
                            ),
                      ),
                      const SizedBox(height: 5),

                      // وصف المهمة
                      Text(
                        widget.task.description ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontSize: mediaQuery.size.width * 0.045,
                              fontWeight: FontWeight.w700,
                              color: widget.task.isDone!
                                  ? MyTheme.greenColor
                                  : provider.isDark()
                                  ? MyTheme.whiteColor
                                  : MyTheme.blackColor,
                            ),
                      ),
                      const SizedBox(height: 5),

                      // التاريخ
                      Row(
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 18,
                            color: provider.isDark()
                                ? MyTheme.whiteColor
                                : MyTheme.blackColor,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "${widget.task.date?.day}/${widget.task.date?.month}/${widget.task.date?.year}",
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  fontSize: mediaQuery.size.width * 0.035,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // زر علامة "تمت المهمة"
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    // تحديث حالة المهمة في Firebase
                    FirebaseUtils.updateIsDone(
                      widget.task,
                      authProvider.currentUser?.id ?? "",
                    );

                    // تحديث الواجهة
                    setState(() {
                      widget.task.isDone = !widget.task.isDone!;
                    });
                  },
                  child: widget.task.isDone!
                      ? const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "IsDone!",
                            style: TextStyle(
                              color: MyTheme.greenColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          padding: EdgeInsets.symmetric(
                            horizontal: mediaQuery.size.width * 0.04,
                            vertical: mediaQuery.size.height * 0.01,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: MyTheme.primaryColor,
                          ),
                          child: const Icon(Icons.check, color: Colors.white),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
