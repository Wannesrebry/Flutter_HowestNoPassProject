import 'package:flutter/material.dart';
import 'package:nopassauthenticationclient/controller/encryption_controller.dart';
import 'package:nopassauthenticationclient/view/components/drawer/auth_drawer.dart';

final EncryptionController _encController = EncryptionController();

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
        children: [
          RaisedButton(
            child: Text("Recover"),
            color: Colors.blue,
            onPressed: (){
              _encController.removeEncryptionKeys();
              //navigate to route
              Navigator.of(context).pushNamed("/");
            },
          )
        ]
      ),
    );
  }
}