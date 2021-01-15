import 'package:flutter/material.dart';
import 'package:nopassauthenticationclient/controller/logincontroller.dart';
import 'package:nopassauthenticationclient/view/components/drawer.dart';

class AuthHome extends StatefulWidget{
  static const routeName = "/authhome";

  @override
  AuthHomeState createState() => AuthHomeState();

}

class AuthHomeState extends State<AuthHome>{
  final loginController = LoginController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MarsNoPass Auth"),
        backgroundColor: Colors.blue,
      ),
      drawer: AuthDrawer(),
      body: ListView(
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(10),
                child: RaisedButton(
                  child: Text("Check for login requests"),
                  color: Colors.blue,
                  onPressed: (){
                    //navigate to route
                    loginController.onClickLoginRequestsBtn(context);
                  },
                )
            ),
          ]
      ),
    );
  }
}