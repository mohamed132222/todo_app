import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../my_theme.dart';
import '../../providers/settings_provider.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    var provider = Provider.of<SettingsProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: InkWell(
        onTap: () {
          // navigate to update screen
          Navigator.pushNamed(context, '/task_update');
        },
        borderRadius: BorderRadius.circular(15),
        child: Slidable(
          key: const ValueKey('task_item'), // ✅ important for performance
          startActionPane: ActionPane(
            extentRatio: 0.25,
            motion: const ScrollMotion(),
            dismissible: DismissiblePane(
              onDismissed: () {
                // delete task
              },
            ),
            children: [
              SlidableAction(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                onPressed: (context) {},
                backgroundColor: MyTheme.redColor,
                foregroundColor: MyTheme.whiteColor,
                icon: Icons.delete,
                label: AppLocalizations.of(context)!.delete,
              ),
            ],
          ),

          child: Container(
            width: double.infinity, // ✅ FIX: remove fixed width
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: provider.isDark() ? MyTheme.darkColor : MyTheme.whiteColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                /// Left color bar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  width: 4,
                  height: mediaQuery.size.height * 0.08, // responsive height
                  decoration: BoxDecoration(
                    color: MyTheme.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                /// Text section
                Expanded(
                  // ✅ prevents overflow
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Play basket ball",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis, // ✅ responsive text
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontSize: mediaQuery.size.width * 0.045,
                              fontWeight: FontWeight.w700,
                              color: MyTheme.primaryColor,
                            ),
                      ),
                      const SizedBox(height: 5),
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
                            "10:00 AM",
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

                /// Done button
                InkWell(
                  onTap: () {
                    // mark as done
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
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
