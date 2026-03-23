import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/home/settings/language_bottom_sheet.dart';
import 'package:todo_app/home/settings/theme_bottom_sheet.dart';
import 'package:todo_app/my_theme.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/settings_provider.dart';

class SettingsTab extends StatelessWidget {
  static const String routeName = '/settings';

  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Consumer<SettingsProvider>(
        builder: (context, provider, child) {
          final isDark = provider.isDark();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSettingItem(
                context: context,
                title: AppLocalizations.of(context)!.language,
                value: provider.appLanguage == "ar"
                    ? AppLocalizations.of(context)!.arabic
                    : AppLocalizations.of(context)!.english,
                onTap: () => showLanguageBottomSheet(context),
                isDark: isDark,
                textTheme: textTheme,
              ),
              const SizedBox(height: 30),
              buildSettingItem(
                context: context,
                title: AppLocalizations.of(context)!.theme,
                value: provider.appTheme == ThemeMode.light
                    ? AppLocalizations.of(context)!.light
                    : AppLocalizations.of(context)!.dark,
                onTap: () => showThemeBottomSheet(context),
                isDark: isDark,
                textTheme: textTheme,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildSettingItem({
    required BuildContext context,
    required String title,
    required String value,
    required VoidCallback onTap,
    required bool isDark,
    required TextTheme textTheme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? MyTheme.whiteColor : MyTheme.blackColor,
          ),
        ),
        const SizedBox(height: 20),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? MyTheme.darkColor : MyTheme.whiteColor,
              border: Border.all(color: MyTheme.primaryColor, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: textTheme.titleSmall?.copyWith(
                    color: MyTheme.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down_outlined,
                  size: 25,
                  color: MyTheme.primaryColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const LanguageBottomSheet(),
    );
  }

  void showThemeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const ThemeBottomSheet(),
    );
  }
}
