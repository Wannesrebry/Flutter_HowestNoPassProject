import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nopassauthenticationclient/controller/new/register_controller.dart';
import 'file:///C:/Users/wannes-nzxt/AndroidStudioProjects/nopassauthenticationclient/lib/view/components/drawer.dart';
import 'package:nopassauthenticationclient/controller/registercontroller.dart';
import 'package:nopassauthenticationclient/view/components/dialogs/wait.dart';
import 'package:nopassauthenticationclient/view/screens/recover.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


class RegisterScreen extends StatefulWidget{
  static const routeName = "/register";

  @override
  _RegisterScreen createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen>{
  final textController = TextEditingController();
  final registerController = RegisterController();
  final registerControllerNew = RegisterControllerNew();

  String userRCode;

  String rCodeValidationHolder = "";
  var rCodeValidationHolderColor = Colors.red;
  BuildContext _popupCtx;

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
                    //showLoadingScreen(context);
                    registerControllerNew.onClickRegistrationButton(userRCode, context);
                    //_renderWaitDialog("Test message");
                    //_startRegistrationProcess();
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


  _renderWaitDialog(String msg)async{
    final Wait popup = new Wait("test");
    showDialog(
      context: context,
      barrierDismissible: true, // set false for not closing on outside border.
      builder: (_) => popup.build(context)
    );
  }

  //https://flutterawesome.com/a-collection-of-loading-indicators-animated-with-flutter/

  void _startRegistrationProcess() async{
    //var ctxPopup = showWaitingDialog();
    //await lSC.add("registrationCode", userRCode, force: true);
    //registerController.showToValidateData(userRCode, ctxPopup, context);

  }

  showLoadingScreen(BuildContext context)async{
    await new Wait("loading").init(context);
  }



}



