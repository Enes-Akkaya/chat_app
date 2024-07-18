import 'package:flutter/material.dart';

import '../services/auth/auth_service.dart';
import '../pages/settings_page.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  void logout() {
    final _auth = AuthService();
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              //Logo
              DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.message,
                    size: 70,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),

              //home
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: ListTile(
                  title: const Text(
                    "HOME",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  leading: Icon(Icons.home),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              //Settings
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: ListTile(
                  title: const Text(
                    "SETTINGS",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  leading: Icon(Icons.settings),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsPage()));
                  },
                ),
              ),
            ],
          ),

          //Logout
          Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 10),
            child: ListTile(
              title: const Text(
                "LOGOUT",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              leading: const Icon(Icons.logout),
              onTap: logout,
            ),
          ),
        ],
      ),
    );
  }
}
