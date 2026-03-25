import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth/login_screen.dart';
import 'auth/register_screen.dart';
import 'firebase_options.dart';
import 'home/home_screen.dart';
import 'home/splash_screen.dart';
import 'home/todo_list/task_update_screen.dart';
import 'l10n/app_localizations.dart';
import 'my_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Optional Firestore settings (commented out)
  // FirebaseFirestore.instance.settings = Settings(
  //   cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  // );
  // await FirebaseFirestore.instance.disableNetwork();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => AuthProviderApp()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      themeMode: provider.appTheme,
      locale: Locale(provider.appLanguage),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        TaskUpdateScreen.routeName: (context) => const TaskUpdateScreen(),
      },
    );
  }
}
