import 'package:flutter/material.dart';
import 'package:nopassauthenticationclient/controller/register_controller.dart';
import '../recover.dart';
import 'package:nopassauthenticationclient/view/components/dialogs/wait.dart';
import 'package:nopassauthenticationclient/view/components/drawer/basic_drawer.dart';


class RegisterScreen extends StatefulWidget{
  static const routeName = "/register";

  @override
  _RegisterScreen createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen>{
  final textController = TextEditingController();
  final registerControllerNew = RegisterController();

  String userRCode;

  String rCodeValidationHolder = "";
  var rCodeValidationHolderColor = Colors.red;

  @override
  void dispose(){
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: Colors.blue,
      ),
      drawer: BasicDrawer(),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(10),
                child: Text("Please enter your registration code, this code was provided by officials on arrival and is 10 charachters long.",
                  textAlign: TextAlign.center,
                )
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                maxLength: 10,
                maxLengthEnforced: true,
                controller: textController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Registration code',
                ),
                onChanged: (String value) async{
                  setState(() {
                    userRCode = value;
                    rCodeValidationHolder = registerControllerNew.formatValidation(value);
                    rCodeValidationHolderColor = registerControllerNew.validationColor(value);
                  });
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text("$rCodeValidationHolder",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: rCodeValidationHolderColor
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.all(10),
                child: OutlineButton(
                  child: Text("Register"),
                  onPressed: (){
                    setState(() {
                    });
                    registerControllerNew.onClickRegistrationButton(userRCode, context);
                  },
                )
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text("Already registered but device lost? ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.blue
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.all(10),
                child: RaisedButton(
                  child: Text("Recover"),
                  color: Colors.blue,
                  onPressed: (){
                    Navigator.of(context).pushNamed(RecoveryScreen.routeName);
                  },
                )
            ),
          ],
        ),
      ),
    );
  }

  showLoadingScreen(BuildContext context)async{
    await new Wait("loading").init(context);
  }



}



