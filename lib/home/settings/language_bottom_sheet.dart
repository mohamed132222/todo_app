import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/my_theme.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/settings_provider.dart';

class LanguageBottomSheet extends StatefulWidget {
  const LanguageBottomSheet({super.key});

  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
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
              provider.changeLanguage("ar");
            },
            child: provider.appLanguage == "ar"
                ? selectedItem(AppLocalizations.of(context)!.arabic)
                : unSelectedItem(
                    AppLocalizations.of(context)!.arabic,
                    provider,
                  ),
          ),
          SizedBox(height: 30),
          InkWell(
            onTap: () {
              provider.changeLanguage("en");
            },
            child: provider.appLanguage == "en"
                ? selectedItem(AppLocalizations.of(context)!.english)
                : unSelectedItem(
                    AppLocalizations.of(context)!.english,
                    provider,
                  ),
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
