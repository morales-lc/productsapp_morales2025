import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login.dart';
import 'models/background_model.dart';
import 'models/language_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Backgroundmodel()),
        ChangeNotifierProvider(create: (_) => LanguageModel()),
      ],
      child: const MyApp(),
    ),
  );
}

// =================== MAIN APP ENTRY ===================
/// MyApp
///
/// The root widget of the application. Sets up providers for theme and language,
/// and configures the MaterialApp with the current theme and home screen.
/// All global app-level configuration and theming is handled here.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Backgroundmodel>(
      builder: (context, bgModel, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: LoginScreen(),
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarTheme(
              backgroundColor: bgModel.appBar,
              foregroundColor: Colors.white,
            ),
            colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: bgModel.accent,
            ),
          ),
        );
      },
    );
  }
}
// =================== END MAIN APP ENTRY ===================
