import 'package:flutter/material.dart';
import 'package:nopassauthenticationclient/view/components/drawer.dart';

class AuthHome extends StatefulWidget{
  static const routeName = "/authhome";

  @override
  AuthHomeState createState() => AuthHomeState();

}

class AuthHomeState extends State<AuthHome>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MarsNoPass Auth"),
        backgroundColor: Colors.blue,
      ),
      drawer: AuthDrawer(),
      body: Column(
        children: [
          Text("Mars NoPass Auth",
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}