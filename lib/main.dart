import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:interactive_map/Backend/Login.dart';
import 'package:interactive_map/Homepages/firstPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:interactive_map/theme/colors.dart';
import 'Backend/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await signOut();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      locale: const Locale('ar', 'MA'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ar', 'MA'),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Interactive Map',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.text,
          centerTitle: true,
        ),
        cardColor: AppColors.card,
        dividerColor: AppColors.border,
        useMaterial3: true,
      ),
      home: const FirstPage(),
    );
  }
}
