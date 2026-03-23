import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/my_theme.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/settings_provider.dart';

class ThemeBottomSheet extends StatefulWidget {
  const ThemeBottomSheet({super.key});

  @override
  State<ThemeBottomSheet> createState() => _ThemeBottomSheetState();
}

class _ThemeBottomSheetState extends State<ThemeBottomSheet> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SettingsProvider>(context);
    return Container(
      color: provider.isDark() ? MyTheme.darkColor : MyTheme.whiteColor,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),

      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              provider.changeTheme(ThemeMode.light);
            },
            child: provider.isDark()
                ? unSelectedItem(AppLocalizations.of(context)!.light, provider)
                : selectedItem(AppLocalizations.of(context)!.light),
          ),
          SizedBox(height: 30),
          InkWell(
            onTap: () {
              provider.changeTheme(ThemeMode.dark);
            },
            child: provider.isDark()
                ? selectedItem(AppLocalizations.of(context)!.dark)
                : unSelectedItem(AppLocalizations.of(context)!.dark, provider),
          ),
        ],
      ),
    );
  }

  Widget selectedItem(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: MyTheme.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        Icon(Icons.check, color: MyTheme.primaryColor, size: 30),
      ],
    );
  }

  Widget unSelectedItem(String text, SettingsProvider provider) {
    return Row(
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: provider.isDark() ? MyTheme.whiteColor : MyTheme.blackColor,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ],
    );
  }
}
