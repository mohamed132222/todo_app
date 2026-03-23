import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../my_theme.dart';
import '../../providers/settings_provider.dart';

class TaskUpdateScreen extends StatefulWidget {
  static const String routeName = '/task_update';

  TaskUpdateScreen({super.key});

  @override
  State<TaskUpdateScreen> createState() => _TaskUpdateScreenState();
}

class _TaskUpdateScreenState extends State<TaskUpdateScreen> {
  DateTime selectedDate = DateTime.now();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SettingsProvider>(context);
    final mediaQuery = MediaQuery.of(context);

    final titleController = TextEditingController();
    final descController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: MyTheme.whiteColor),
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
      body: Center(
        child: Container(
          width: mediaQuery.size.width * .82,
          height: mediaQuery.size.height * .7,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: provider.isDark() ? MyTheme.darkColor : MyTheme.whiteColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.edit_task,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: provider.isDark()
                          ? MyTheme.whiteColor
                          : MyTheme.blackColor,
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                /// Title
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

                /// Description
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

                const SizedBox(height: 100),

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

  void updateTask() {
    if (formKey.currentState!.validate() == true) {
      //task update logic
    }
  }
}
