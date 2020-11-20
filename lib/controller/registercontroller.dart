import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nopassauthenticationclient/controller/encrypter/compute_encryption.dart';
import 'package:nopassauthenticationclient/controller/internet_controller.dart';
import 'package:nopassauthenticationclient/controller/local_storage.dart';
import 'package:nopassauthenticationclient/data/dto/requests/validate_registration_req_dto.dart';
import 'package:nopassauthenticationclient/data/dto/response/register_data_verify_req_dto.dart';
import 'package:nopassauthenticationclient/view/screens/recover.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'encrypter/store_encryption.dart';


final InternetController api = InternetController();
final LocalStorageController lSC = LocalStorageController();
final _keyStore = LocalStoreKeyPair();
final _retrieveEncData = RetrieveEncryptionData();

class RegisterController extends StatefulWidget{
  String blurredFirstName = "";
  String blurredLastName = "";
  DateTime _birthData;
  String _firstName;
  String _lastName;


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
    /*
    api.startRegistration(rCode).then(
      (response) async{
        ToVerifyDataResDto reqDto = ToVerifyDataResDto.fromJson(jsonDecode(response.body)["res"]);
        await lSC.add("sessionId", reqDto.sessionId, force: true);
        Navigator.of(context).pop();
        _showDataVerificationDialog(mainContext, reqDto);
    });

     */
  }

  showValidatedData(String firstName, String lastName, DateTime birthDate, BuildContext current)async{
    /*
    final reqDto = await prePareForRegistration(firstName, lastName, birthDate);
    await api.validateRegistration(reqDto).then(
        (response)async{
          print(response);
          Navigator.of(current).pop();
          Navigator.of(current).pushNamed(RecoverScreen.routeName);
        }
    );

     */
  }

  _showDataVerificationDialog(var mainContext, ToVerifyDataResDto reqDto) async {

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
                        onChanged: (value){
                          _firstName = value;
                        },
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
                        onChanged: (value){
                          _lastName = value;
                        },
                      ),
                    ),
                    Text("BirthDate:",
                      textAlign: TextAlign.left,
                    ),
                    Container(
                      child: SfDateRangePicker(
                          onSelectionChanged: _onSelectionChanged,
                          view: DateRangePickerView.year
                      ),
                    ),
                    RaisedButton(
                      color: Colors.green,
                      child: Text('Verify',
                          style: TextStyle(color: Colors.white)),
                      onPressed: ()async {
                        // send to server.
                        showValidatedData(
                            _firstName,
                            _lastName,
                            _birthData,
                            mainContext);
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

  Future<ValidateRegistrationReqDTO> prePareForRegistration(String firstName, String lastName, DateTime birthDate) async {
    final Map<String, String> localData = await lSC.getAll();
    String sid = localData["sessionId"];
    String rCode = localData["registrationCode"];
    final RSAPrivateKey privateKey = await _keyStore.getPrivateKey();
    final encData = _retrieveEncData.generateVerifiableData(privateKey);
    return ValidateRegistrationReqDTO(rCode, firstName, lastName, birthDate, sid, encData.signature, encData.data);
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /*
    String date = args.value.split(" ")[0];
    List<String> parts = date.split("-");
    List<int> partsInt =  [];
    parts.forEach((element) {partsInt.add(int.parse(element));});
    _birthData = DateTime(partsInt[0], partsInt[1], partsInt[2]);
       */
    _birthData = args.value;
  }



}

