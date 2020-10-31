import 'package:flutter/material.dart';
import 'package:nopassauthenticationclient/components/drawer/drawer.dart';


class RecoverScreen extends StatelessWidget{
  static const routeName = "/recover";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recover"),
        backgroundColor: Colors.blue,
      ),
      drawer: LoadDrawer(),
      body: Column(

      ),
    );
  }

}