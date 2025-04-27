import 'package:flutter/material.dart';
import 'package:simple_ticket/pages/doc_page.dart';
import 'package:simple_ticket/pages/guide_page.dart';
import 'package:simple_ticket/pages/main_page.dart';
import '../pages/about_us_page.dart';
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
  bool _show_image = false;
  String _current_route = '/'; // Default route to display

  final List<Map<String, dynamic>> _modules = [
    {
      "route": "/about-us",
      "widget": AboutUsPage(),
      "label": "About us",
    },
    {
      "route": "/privacy",
      "widget": PrivacyPage(),
      "label": "Privacy",
    },
    {
      "route": "/docs",
      "widget": DocsPage(),
      "label": "Docs",
    },
    {
      "route": "/guide",
      "widget": GuidePage(),
      "label": "Guide",
    },
    {
      "route": "/",
      "widget": MainScreen(),
      "label": "Main",
    }
  ];

  @override
  Widget build(BuildContext context) {
    // Find the module corresponding to the current route
    Widget body = _modules.firstWhere(
      (module) => module['route'] == _current_route,
      orElse: () => _modules.firstWhere((module) => module['route'] == '/')['widget'], // Default to MainScreen
    )['widget'];

    return Scaffold(
      appBar: CustomAppBar(
        showImage: _show_image,
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
            ..._modules.map((module) {
              return ListTile(
                title: Text(module['label']),
                onTap: () {
                  _update_url(module['route']);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Grabbing the current route from the browser
    _current_route = html.window.location.pathname!;

    // Optionally, you can adjust it here if you want to ensure no leading slash
    _current_route = _current_route.isEmpty || _current_route == '/' ? '/' : _current_route;

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _show_image = true;
      });
    });
  }

  // Function to update the URL in the browser
  void _update_url(String route) {
    setState(() {
      _current_route = route;
    });

    html.window.history.pushState(null, '', route);
  }
}
