import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showImage;
  final Function(String) onNavigation;
  CustomAppBar({required this.showImage, required this.onNavigation});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          // Open the drawer when the menu button is pressed
          Scaffold.of(context).openDrawer();
        },
      ),
      title: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: showImage
            ? Image.network(
                'https://i.imgur.com/8nDAzf1.png"',
                height: 20,
                key: ValueKey<int>(1),
              )
            : Text(
                'Welcome to',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                key: ValueKey<int>(0),
              ),
      ),
      actions: [],
    );
  }
}