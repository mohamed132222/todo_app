import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/my_theme.dart';

import '../auth/login_screen.dart';
import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';
import 'add_task_bottom_sheet.dart';
import 'nav_item.dart';
import 'settings/settings_tab.dart';
import 'todo_list/todo_list_tab.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<Widget> tabs = const [TodoListTab(), SettingsTab()];

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SettingsProvider>(context);
    var authProvider = Provider.of<AuthProviderApp>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${AppLocalizations.of(context)!.todo_list} ${authProvider.currentUser?.username ?? ''}",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: provider.isDark()
                ? MyTheme.backgroundPrimaryDarkColor
                : MyTheme.whiteColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              provider.taskList = [];
              authProvider.currentUser = null;
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: IndexedStack(index: selectedIndex, children: tabs),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTaskBottomSheet(context),
        shape: StadiumBorder(
          side: BorderSide(
            color: provider.isDark() ? MyTheme.greyColor : MyTheme.whiteColor,
            width: 5,
          ),
        ),
        backgroundColor: MyTheme.primaryColor,
        child: const Icon(Icons.add, color: MyTheme.whiteColor),
      ),
      bottomNavigationBar: BottomAppBar(
        color: provider.isDark() ? MyTheme.darkColor : MyTheme.whiteColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 15,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildNavItem(
              icon: Icons.list,
              label: AppLocalizations.of(context)!.todo_list,
              index: 0,
            ),
            buildNavItem(
              icon: Icons.settings,
              label: AppLocalizations.of(context)!.settings,
              index: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    return NavItem(
      icon: icon,
      label: label,
      isSelected: selectedIndex == index,
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
    );
  }

  void showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const AddTaskBottomSheet(),
    );
  }
}
