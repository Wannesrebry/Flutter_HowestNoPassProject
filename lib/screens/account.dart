import 'package:flutter/material.dart';
import 'package:nopassauthenticationclient/components/drawer/drawer.dart';

class AccountScreen extends StatelessWidget {
  static const String routeName = "/account";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
        backgroundColor: Colors.blue,
      ),
      drawer: AuthDrawer(),
      body: Column(
      ),
    );
  }
}