import 'package:flutter/material.dart';
import 'package:simple_ticket/pages/doc_page.dart';
import 'package:simple_ticket/pages/main_page.dart';
import '../pages/privacy_page.dart';
import 'carousel.dart';
import 'custom_app_bar.dart';
import 'dart:html' as html;

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({super.key});

  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  bool showImage = false;
  String currentRoute = '/'; // Default route to display

  @override
  void initState() {
    super.initState();
    // Grabbing the current route from the browser
    currentRoute = html.window.location.pathname!;

    // Optionally, you can adjust it here if you want to ensure no leading slash
    currentRoute = currentRoute.isEmpty || currentRoute == '/' ? '/' : currentRoute;

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        showImage = true;
      });
    });
  }

  // Function to update the URL in the browser
  void _update_url(String route) {
    setState(() {
      currentRoute = route;
    });

    html.window.history.pushState(null, '', route);
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    switch (currentRoute) {
      case '/privacy':
        body = PrivacyPage();
        break;
      case '/docs':
        body = DocsPage();
        break;

      default:
        body = MainScreen();
        break;
    }

    return Scaffold(
      appBar: CustomAppBar(
        showImage: showImage,
        onNavigation: (route) {
          // Navigate to the new route and update the URL
          _update_url(route);
        },
      ),
      body: body, // Display the body based on the current route
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('Navigation Menu', style: TextStyle(fontSize: 24)),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            // ListTile(
            //   title: Text('Docs'),
            //   onTap: () {
            //     _update_url('/docs');
            //     Navigator.pop(context);
            //   },
            // ),
            ListTile(
              title: Text('Privacy'),
              onTap: () {
                _update_url('/privacy');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Main'),
              onTap: () {
                _update_url('/');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
