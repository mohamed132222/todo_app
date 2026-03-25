import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/providers/auth_provider.dart';
import 'package:todo_app/providers/settings_provider.dart';
import 'package:todo_app/utils/dialog_utils.dart';
import 'package:todo_app/utils/firebase_utils.dart';

import '../../l10n/app_localizations.dart';
import '../../my_theme.dart';

class TaskUpdateScreen extends StatefulWidget {
  static const String routeName = '/task_update';

  const TaskUpdateScreen({super.key});

  @override
  State<TaskUpdateScreen> createState() => _TaskUpdateScreenState();
}

class _TaskUpdateScreenState extends State<TaskUpdateScreen> {
  DateTime selectedDate = DateTime.now();
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Task? task;

  @override
  Widget build(BuildContext context) {
    // تحميل بيانات المهمة عند أول build
    if (task == null) {
      task = ModalRoute.of(context)?.settings.arguments as Task?;
      titleController.text = task!.title!;
      descController.text = task!.description!;
      selectedDate = task!.date!;
    }

    var provider = Provider.of<SettingsProvider>(context);
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: MyTheme.whiteColor),
        title: Text(
          AppLocalizations.of(context)!.todo_list,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: provider.isDark()
                ? MyTheme.backgroundPrimaryDarkColor
                : MyTheme.whiteColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              // الخلفية العلوية
              Container(
                color: MyTheme.primaryColor,
                height: mediaQuery.size.height * 0.1,
              ),

              // حاوية النموذج
              Center(
                child: Container(
                  width: mediaQuery.size.width * 0.82,
                  height: mediaQuery.size.height * 0.7,
                  padding: const EdgeInsets.all(15),
                  margin: EdgeInsets.only(top: mediaQuery.size.height * 0.04),
                  decoration: BoxDecoration(
                    color: provider.isDark()
                        ? MyTheme.darkColor
                        : MyTheme.whiteColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // عنوان الصفحة
                        Center(
                          child: Text(
                            AppLocalizations.of(context)!.edit_task,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: provider.isDark()
                                      ? MyTheme.whiteColor
                                      : MyTheme.blackColor,
                                ),
                          ),
                        ),
                        const SizedBox(height: 25),

                        // حقل العنوان
                        TextFormField(
                          controller: titleController,
                          validator: (text) {
                            if (text == null || text.trim().isEmpty) {
                              return AppLocalizations.of(
                                context,
                              )!.enter_your_task_title;
                            }
                            return null;
                          },
                          decoration: _inputDecoration(
                            context,
                            AppLocalizations.of(context)!.enter_your_task_title,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // حقل الوصف
                        TextFormField(
                          controller: descController,
                          maxLines: 4,
                          validator: (text) {
                            if (text == null || text.trim().isEmpty) {
                              return AppLocalizations.of(
                                context,
                              )!.enter_your_task_description;
                            }
                            return null;
                          },
                          decoration: _inputDecoration(
                            context,
                            AppLocalizations.of(
                              context,
                            )!.enter_your_task_description,
                          ),
                        ),
                        const SizedBox(height: 25),

                        // نص اختيار التاريخ
                        Text(
                          AppLocalizations.of(context)!.select_time,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 10),

                        // التاريخ مع اختيار التاريخ
                        InkWell(
                          onTap: () => showCalender(context),
                          child: Center(
                            child: Text(
                              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: MyTheme.greyColor,
                                    fontSize: mediaQuery.size.width * 0.045,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 100),

                        // زر التحديث
                        Center(
                          child: SizedBox(
                            width: mediaQuery.size.width * 0.6,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MyTheme.primaryColor,
                                foregroundColor: MyTheme.whiteColor,
                                padding: EdgeInsets.symmetric(
                                  vertical: mediaQuery.size.height * 0.02,
                                ),
                              ),
                              onPressed: updateTask,
                              child: Text(
                                AppLocalizations.of(context)!.update,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontSize: mediaQuery.size.width * 0.045,
                                      color: MyTheme.whiteColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // تصميم الحقول
  InputDecoration _inputDecoration(BuildContext context, String hint) {
    return InputDecoration(
      border: const UnderlineInputBorder(),
      hintText: hint,
      hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontSize: MediaQuery.of(context).size.width * 0.045,
        color: MyTheme.greyColor,
      ),
    );
  }

  // اختيار التاريخ
  void showCalender(BuildContext context) async {
    final chosenDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (chosenDate != null && chosenDate != selectedDate) {
      setState(() => selectedDate = chosenDate);
    }
  }

  // تحديث المهمة
  void updateTask() {
    if (formKey.currentState!.validate()) {
      task?.title = titleController.text;
      task?.description = descController.text;
      task?.date = selectedDate;

      var authProvider = Provider.of<AuthProviderApp>(context, listen: false);

      // إظهار Loading
      DialogUtils.showLoading(context);

      FirebaseUtils.updateTask(task!, authProvider.currentUser?.id ?? "")
          .then((value) {
            DialogUtils.hideLoading(context);
          })
          .timeout(
            const Duration(milliseconds: 500),
            onTimeout: () {
              var listProvider = Provider.of<SettingsProvider>(
                context,
                listen: false,
              );
              listProvider.getAllTask(authProvider.currentUser?.id ?? "");
              Navigator.pop(context);
            },
          );
    }
  }
}
