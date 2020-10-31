import 'package:flutter/material.dart';
import 'package:nopassauthenticationclient/components/drawer/drawer.dart';
import 'package:nopassauthenticationclient/controller/registercontroller.dart';
import 'package:nopassauthenticationclient/screens/recover.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class RegisterScreen extends StatefulWidget{
  static const routeName = "/register";

  @override
  _RegisterScreen createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen>{
  final textController = TextEditingController();
  final registerController = RegisterController();

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
      drawer: LoadDrawer(),
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
                controller: textController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Registration code',
                ),
                onChanged: (String value) async{
                  setState(() {
                    rCodeValidationHolder = registerController.formatValidation(value);
                    rCodeValidationHolderColor = registerController.validationColor(value);
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
                      //rCodeValidationHolder = rCodeController.onClick(textController.text);
                    });
                    // popup:
                    _showVerifyDialog(context);




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
                    //navigate to route
                    Navigator.of(context).pushNamed(RecoverScreen.routeName);
                  },
                )
            ),
          ],
        ),
      ),
    );

  }

  //https://flutterawesome.com/a-collection-of-loading-indicators-animated-with-flutter/

   _showVerifyDialog(var mainContext) async {
    showDialog(
        context: context,
        barrierDismissible: false, // set false for not closing on outside border.
        builder: (_) => new AlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width /4,
            height: MediaQuery.of(context).size.width /4,
            child: ListView(
              padding: const EdgeInsets.all(4),
              children: [
                SpinKitRotatingCircle(
                  color: Colors.blue,
                  size: 75,
              ),
                Text("Awaiting server response ...",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15)),
              ],
            )
          ),
      ));
    await registerController.showToValidateData(context, mainContext);
  }
}

