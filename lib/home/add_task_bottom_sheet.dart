import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/task.dart';

import '../l10n/app_localizations.dart';
import '../my_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/dialog_utils.dart';
import '../utils/firebase_utils.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  late var provider;
  DateTime selectedDate = DateTime.now();
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<SettingsProvider>(context);
    final mediaQuery = MediaQuery.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: provider.isDark() ? MyTheme.darkColor : MyTheme.whiteColor,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: mediaQuery.size.width * 0.06, // responsive padding
        vertical: mediaQuery.size.height * 0.02,
      ),
      width: double.infinity,
      height: mediaQuery.size.height * 0.6,
      // slightly flexible
      child: SingleChildScrollView(
        // ✅ prevents overflow
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  AppLocalizations.of(context)!.add_new_task,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: mediaQuery.size.width * 0.05, // responsive font
                  ),
                ),
              ),
              const SizedBox(height: 25),

              /// Title
              TextFormField(
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: provider.isDark()
                      ? MyTheme.whiteColor
                      : MyTheme.blackColor,
                ),
                controller: titleController,
                validator: (text) {
                  if (text == null || text.trim().isEmpty) {
                    return AppLocalizations.of(context)!.enter_your_task_title;
                  }
                  return null;
                },
                decoration: _inputDecoration(
                  context,
                  AppLocalizations.of(context)!.enter_your_task_title,
                ),
              ),

              const SizedBox(height: 20),

              /// Description
              TextFormField(
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: provider.isDark()
                      ? MyTheme.whiteColor
                      : MyTheme.blackColor,
                ),
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
                  AppLocalizations.of(context)!.enter_your_task_description,
                ),
              ),

              const SizedBox(height: 25),

              /// Date Label
              Text(
                AppLocalizations.of(context)!.select_time,
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 10),

              /// Date Picker
              InkWell(
                onTap: () => showCalender(context),
                child: Center(
                  child: Text(
                    "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: MyTheme.greyColor,
                      fontSize: mediaQuery.size.width * 0.045,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// Button
              Center(
                child: SizedBox(
                  width: mediaQuery.size.width * 0.6, // responsive width
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyTheme.primaryColor,
                      foregroundColor: MyTheme.whiteColor,
                      padding: EdgeInsets.symmetric(
                        vertical: mediaQuery.size.height * 0.02,
                      ),
                    ),
                    onPressed: addTask,
                    child: Text(
                      AppLocalizations.of(context)!.add_task,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
    );
  }

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

  void addTask() {
    if (formKey.currentState!.validate()) {
      final title = titleController.text;
      final desc = descController.text;
      Task task = Task(title: title, description: desc, date: selectedDate);
      DialogUtils.showLoading(context);
      var authProvider = Provider.of<AuthProviderApp>(context, listen: false);
      FirebaseUtils.addTask(task, authProvider.currentUser?.id ?? "")
          .then((value) {
            DialogUtils.hideLoading(context);
            DialogUtils.showMessage(
              context,
              message: "task added success",
              posActionName: "ok",
              posAction: () {
                Navigator.pop(context);
              },
            );
          })
          .timeout(
            onTimeout: () {
              print("task added success");
            },
            Duration(milliseconds: 500),
          );
      provider.getAllTask();
      titleController.clear();
      descController.clear();
      Navigator.pop(context);
    }
  }
}
