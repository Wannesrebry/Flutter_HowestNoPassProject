import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nopassauthenticationclient/controller/internet_controller.dart';
import 'package:nopassauthenticationclient/main.dart';
import 'package:nopassauthenticationclient/models/dto/requests/register_data_verify_req_dto.dart';

final InternetController api = InternetController();

class RegisterController extends StatefulWidget{
  String blurredFirstName = "";
  String blurredLastName = "";


  String text;

  RegisterController();

  onClick(String rCode){

  }


  formatValidation(String code){
    String resultMsg = "";
    if(isCodeFormatValid(code)){
      resultMsg = ("Checking code...");
    }else{
      resultMsg = ("Invalid code.");
    }
    return resultMsg;
  }

  isCodeFormatValid(String code){
    return code.length == 10;
  }

  MaterialColor validationColor(String code) {
    if(isCodeFormatValid(code)){return Colors.orange;}
    else{
      return Colors.red;
    }
  }

  showToValidateData(String rCode, BuildContext context, BuildContext mainContext) async{
    api.startRegistration(rCode).then(
      (response){
        DataVerifyReqDto reqDto = DataVerifyReqDto.fromJson(jsonDecode(response.body)["res"]);
        Navigator.of(context).pop();
        _showDataVerificationDialog(mainContext, reqDto);
    });
  }

  _showDataVerificationDialog(var mainContext, DataVerifyReqDto reqDto) async {
    showDialog(
        context: mainContext,
        barrierDismissible: false, // set false for not closing on outside border.
        builder: (_) => new AlertDialog(
            content: Container(
                width: MediaQuery.of(mainContext).size.width,
                height: MediaQuery.of(mainContext).size.height,
                child: ListView(
                  padding: const EdgeInsets.all(4),
                  children: [
                    Text("Verify data",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Complete the data in order to succeed registration.",
                      textAlign: TextAlign.center,
                    ),
                    Text("First name: ${reqDto.firstName}",
                      textAlign: TextAlign.left,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'First name',
                        ),
                      ),
                    ),
                    Text("Last name: ${reqDto.lastName}",
                      textAlign: TextAlign.left,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Last name',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: InputDatePickerFormField(
                        firstDate: new DateTime(new DateTime.now().year -100),
                        lastDate: new DateTime.now(),
                        fieldLabelText: "Birthday",
                      )
                    ),
                    RaisedButton(
                      color: Colors.green,
                      child: Text('Verify',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        // send to server.
                      })
                  ])
            ), actions: [
            FlatButton(
                child: Text('Cancel',
                    style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.of(mainContext).pop();
                })
        ],
        ),);
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

}