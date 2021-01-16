import 'package:flutter/material.dart';
import 'package:nopassauthenticationclient/controller/recovery_controller.dart';
import 'package:nopassauthenticationclient/view/components/drawer/basic_drawer.dart';

class RecoveryScreen extends StatefulWidget{
  static const routeName = "/recover";

  @override
  RecoveryScreenState createState() => new RecoveryScreenState();
}

class RecoveryScreenState extends State<RecoveryScreen>{
    final RecoveryController recoveryController = new RecoveryController();
    String username;
    String seedString;

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
              Container(
                  padding: EdgeInsets.all(10),
                  child: Text("Recover ur account:",
                    textAlign: TextAlign.center,
                  )
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                  onChanged: (String value) async{
                    setState(() {
                      username = value;
                    });
                  },
                ),
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  child: Text("Please enter your seeds below in the following format: seed,seed,seed,...",
                    textAlign: TextAlign.center,
                  )
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,//Normal textInputField will be displayed
                  maxLines: 5,
                  onChanged: (String value) async{
                    seedString = value;
                  },
                ),
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  child: RaisedButton(
                    child: Text("Recover account"),
                    color: Colors.blue,
                    onPressed: (){
                      recoveryController.onClickRecoveryBtn(username, seedString, context);
                    },
                  )
              ),
            ],
      )
    );
  }
}

