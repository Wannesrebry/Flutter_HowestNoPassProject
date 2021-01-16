import 'package:flutter/material.dart';
import 'package:nopassauthenticationclient/controller/local_storage.dart';
import 'package:nopassauthenticationclient/controller/logincontroller.dart';
import 'package:nopassauthenticationclient/view/components/drawer/auth_drawer.dart';

class AuthVerify extends StatefulWidget{
  static const routeName = "/verify";

  @override
  VerifyState createState() => VerifyState();

}

class VerifyState extends State<AuthVerify>{
  final loginController = LoginController();
  final repo = LocalStorageController();

  String token = "";
  String application = "";

   void _loadToValidateSessionData()async{
     String _app = await repo.getKey("verify_application");
     String _token= await repo.getKey("verify_token");

    setState((){
      application = _app;
      token = _token;
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadToValidateSessionData();
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
              child: Text("$application",
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              child : RaisedButton(
                child: Text("allow"),
                color: Colors.green,
                onPressed: (){
                  //navigate to route
                  loginController.onClickVerify(token,"ALLOW", context);
                },
              ),
            ),
            Container(
                child: RaisedButton(
                  child: Text("decline"),
                  color: Colors.red,
                  onPressed: (){
                    loginController.onClickVerify(token, "DENY", context);
                  },
                )
            )
          ]
      ),
    );
  }
}