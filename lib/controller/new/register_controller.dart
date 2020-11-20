import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:nopassauthenticationclient/controller/encrypter/compute_encryption.dart';
import 'package:nopassauthenticationclient/controller/encrypter/prepare_encryption.dart';
import 'package:nopassauthenticationclient/controller/encrypter/store_encryption.dart';
import 'package:nopassauthenticationclient/controller/internet_controller.dart';
import 'package:nopassauthenticationclient/controller/local_storage.dart';
import 'package:nopassauthenticationclient/data/dto/response/register_data_verify_req_dto.dart';
import 'package:nopassauthenticationclient/data/user_registration_input.dart';
import 'package:nopassauthenticationclient/view/components/dialogs/wait.dart';
import 'package:nopassauthenticationclient/view/screens/register/validate_registration.dart';
import 'package:pointycastle/export.dart';
import 'package:progress_dialog/progress_dialog.dart';


final _preEncrypter = PrepareForEncryption();
final _retrieveEncryptionData = RetrieveEncryptionData();
final _keyStore = LocalStoreKeyPair();
final LocalStorageController lSC = LocalStorageController();


class RegisterControllerNew extends StatefulWidget{
  final PopupController _popupController = PopupController();
  final InternetController _internetController = InternetController();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }


  onClickRegistrationButton(String rCode, BuildContext context)async{
    await _popupController.init(ProgressDialog(
        context,
        type: ProgressDialogType.Normal,
        isDismissible: false,
        showLogs: false));
    //await compute(sleep, Duration(seconds: 2));
    // get Key seeds:
    List<String> seeds = await _internetController.getSeeds();
    //create a keyPair
    final pair = await computeRSAKeyPair(_preEncrypter.secureSeed(seeds));
    //store the keypair
    await _keyStore.addKeyPair(pair, seeds);
    await _keyStore.addSeeds(seeds);
    await lSC.add("registrationCode", rCode);
    //get registrationInfo
    await _popupController.update("connecting to server");

    _internetController.startRegistration(rCode, pair).then(
            (response) async{
            ToVerifyDataResDto reqDto = ToVerifyDataResDto.fromJson(jsonDecode(response.body)["res"]);
            await lSC.add("sessionId", reqDto.sessionId, force: true);
            await lSC.add("blurredFirstName", reqDto.firstName, force: true);
            await lSC.add("blurredLastName", reqDto.lastName, force: true);
            await _popupController.closeActive();
            //Go to new page:
            Navigator.of(context).pushNamed(ValidateRegistration.routeName);
        });

    // close waiting popup

    // Go to Validate data screen:

  }

  Future<ToVerifyDataResDto> getToVerifyData()async{
    final String bFirstName = await lSC.getKey("blurredFirstName");
    final String bLastName = await lSC.getKey("blurredLastName");
    final String sessionId = await lSC.getKey("sessionId");
    return ToVerifyDataResDto(bFirstName, bLastName, sessionId);
  }

  Future<void> verifyData(UserRegistrationInput input) async{
    PrivateKey privateKey= await _keyStore.getPrivateKey();
    _internetController.validateRegistration(input, privateKey).then((response){
      print(response.body);
      if(response.statusCode == 200){
        // redirect to show seed page:

      }else{
        // Bad request route:

      }
    }).catchError((error){
      print(error);
    });

  }

}

class PopupController{
  ProgressDialog active;

  Future<void> init(ProgressDialog pr)async{
    active = pr;
    pr.style(
        message: "Creating KeyPairs"
    );
    await pr.show();
  }

  Future<void> closeActive(){
    return active.hide();
  }

  Future<void> update(String msg){
    active.update(
      message: msg
    );
  }



}