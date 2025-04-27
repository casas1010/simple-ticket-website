import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:simple_ticket/components/navigator.dart';

import 'pages/doc_page.dart';
import 'pages/main_page.dart';

const Color _primary_color = Color.fromARGB(255, 144, 162, 182);
const Color _secondary_color = Color(0xFF35495F);
const double MOBILE_SCREEN_WIDTH = 350.0;

const String GITHUB_TOKEN = "ghp_FQfrl9xHDPHPi" + "89UME9YvAKbBnC77u2eYWkD";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: ".env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: _secondary_color,
        colorScheme: const ColorScheme.light(
          primary: _secondary_color,
          secondary: _primary_color,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: _secondary_color,
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: _secondary_color,
        ),
      ),
      home: const NavigatorScreen(),
    );
  }
}
