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
import 'package:nopassauthenticationclient/data/dto/requests/to_activate_session_dto.dart';
import 'package:nopassauthenticationclient/data/dto/response/register_data_verify_req_dto.dart';
import 'package:nopassauthenticationclient/data/dto/response/register_success_res_dto.dart';
import 'package:nopassauthenticationclient/data/user.dart';
import 'package:nopassauthenticationclient/data/user_registration_input.dart';
import 'package:nopassauthenticationclient/view/components/dialogs/wait.dart';
import 'package:nopassauthenticationclient/view/screens/auth/toverify.dart';
import 'package:nopassauthenticationclient/view/screens/register/validate_registration.dart';
import 'package:pointycastle/export.dart';
import 'package:progress_dialog/progress_dialog.dart';


final _preEncrypter = PrepareForEncryption();
final _retrieveEncryptionData = RetrieveEncryptionData();
final _keyStore = LocalStoreKeyPair();
final LocalStorageController lSC = LocalStorageController();


class LoginController extends StatefulWidget{
  final InternetController _internetController = InternetController();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

  onClickLoginRequestsBtn(BuildContext context)async{
    String identifier = await lSC.getKey("identifier");
    ToActivateSessionDto session = await _internetController.getToActivateSession(identifier.toString());
    lSC.add("verify_token", session.token.toString(), force: true);
    lSC.add("verify_application", session.application.toString());
    Navigator.of(context).pushNamed(AuthVerify.routeName);
  }

  void onClickVerify(String token, BuildContext context) async{
    PrivateKey privateKey= await _keyStore.getPrivateKey();
    if(token != null){
      await _internetController.allowSession(token, privateKey);
    }else{
      //await _internetController.denySession(token);
    }
    Navigator.of(context).pushNamed("/");
  }


}