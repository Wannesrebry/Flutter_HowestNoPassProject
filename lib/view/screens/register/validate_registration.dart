import 'package:flutter/material.dart';
import 'file:///C:/Users/wannes-nzxt/AndroidStudioProjects/nopassauthenticationclient/lib/controller/register_controller.dart';
import 'package:nopassauthenticationclient/data/dto/response/register_data_verify_req_dto.dart';
import 'package:nopassauthenticationclient/data/user_registration_input.dart';
import 'package:nopassauthenticationclient/view/components/drawer/basic_drawer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

final registerControllerNew = RegisterController();

class ValidateRegistration extends StatefulWidget{
  static const routeName = "/validate_registration";

  @override
  _ValidateRegistrationState createState() => _ValidateRegistrationState();
}

class _ValidateRegistrationState extends State<ValidateRegistration> {


  _ValidateRegistrationState(){
    loadToVerifyData();
  }

  String blurredFirstName = "";
  String blurredLastName = "";

  UserRegistrationInput input = UserRegistrationInput();

  loadToVerifyData()async{
    ToVerifyDataResDto dto = await registerControllerNew.getToVerifyData();
    input.sessionId = dto.sessionId;
    setState(() {
      blurredFirstName = dto.firstName;
      blurredLastName = dto.lastName;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text("Validate registration"),
          backgroundColor: Colors.blue,
        ),
        drawer: BasicDrawer(),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
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
                  Text("First name: ${blurredFirstName}",
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'First name',
                      ),
                      onChanged: (value){
                        input.firstName = value;
                      },
                    ),
                  ),
                  Text("Last name: ${blurredLastName}",
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Last name',
                      ),
                      onChanged: (value){
                        input.lastName = value;
                      },
                    ),
                  ),
                  Text("BirthDate:",
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    child: SfDateRangePicker(
                        onSelectionChanged: _onSelectionChanged
                    ),
                  ),
                  RaisedButton(
                      color: Colors.green,
                      child: Text('Verify',
                          style: TextStyle(color: Colors.white)),
                      onPressed: ()async {
                        // send to server.
                        registerControllerNew.verifyData(input, context);
                          print(input);
                      })
                ])
        )
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    input.birthDate = args.value;
  }

}

