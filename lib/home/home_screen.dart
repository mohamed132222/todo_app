import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/home/settings/settings_tab.dart';
import 'package:todo_app/home/todo_list/todo_list_tab.dart';
import 'package:todo_app/my_theme.dart';

import '../l10n/app_localizations.dart';
import '../providers/settings_provider.dart';
import 'nav_item.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      appBar: AppBar(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add, color: MyTheme.whiteColor),
        shape: StadiumBorder(
          side: BorderSide(
            color: provider.isDark() ? MyTheme.greyColor : MyTheme.whiteColor,
            width: 5,
          ),
        ),
        backgroundColor: MyTheme.primaryColor,
      ),
      bottomNavigationBar: BottomAppBar(
        color: provider.isDark() ? MyTheme.darkColor : MyTheme.whiteColor,
        shape: CircularNotchedRectangle(), // ✅ notch
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
      body: IndexedStack(index: selectedIndex, children: tabs),
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

  List<Widget> tabs = const [TodoListTab(), SettingsTab()];
}
