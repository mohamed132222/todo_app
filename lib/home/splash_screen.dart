import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/my_theme.dart';

import '../auth/register_screen.dart';
import '../providers/settings_provider.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // الانتقال بعد 2 ثانية إلى شاشة التسجيل
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, RegisterScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      backgroundColor: provider.isDark()
          ? MyTheme.backgroundPrimaryDarkColor
          : MyTheme.backgroundPrimaryColor,
      body: Center(child: Image.asset('assets/images/logo.png')),
    );
  }
}
