import 'package:flutter/material.dart';
import 'package:nopassauthenticationclient/view/components/drawer/basic_drawer.dart';

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
      drawer: BasicDrawer(),
      body: Column(
            children: [

            ],
      )
    );
  }
}

