import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nopassauthenticationclient/controller/encrypter/compute_encryption.dart';
import 'package:nopassauthenticationclient/controller/encrypter/prepare_encryption.dart';
import 'package:nopassauthenticationclient/controller/encrypter/store_encryption.dart';
import 'package:nopassauthenticationclient/controller/internet_controller.dart';
import 'package:nopassauthenticationclient/controller/local_storage.dart';
import 'package:nopassauthenticationclient/data/dto/response/register_data_verify_req_dto.dart';
import 'package:nopassauthenticationclient/data/dto/response/register_success_res_dto.dart';
import 'package:nopassauthenticationclient/data/user.dart';
import 'package:nopassauthenticationclient/data/user_registration_input.dart';
import 'package:nopassauthenticationclient/view/components/dialogs/feedback_dialog.dart';
import 'package:nopassauthenticationclient/view/screens/auth/seeds.dart';
import 'package:nopassauthenticationclient/view/screens/register/validate_registration.dart';
import 'package:pointycastle/export.dart';
import 'package:progress_dialog/progress_dialog.dart';


final _preEncrypter = PrepareForEncryption();
final _keyStore = LocalStoreKeyPair();
final LocalStorageController lSC = LocalStorageController();


class RegisterController extends StatefulWidget{
  final PopupController _popupController = PopupController();
  final InternetController _internetController = InternetController();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

  formatValidation(String code){
    String resultMsg = "";
    if(isCodeFormatValid(code)){
      resultMsg = ("Valid code format");
    }else{
      resultMsg = ("Invalid code.");
    }
    return resultMsg;
  }

  isCodeFormatValid(String code){
    return code.length == 10;
  }

  MaterialColor validationColor(String code) {
    if(isCodeFormatValid(code)){return Colors.green;}
    else{
      return Colors.red;
    }
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
    await lSC.add("registrationCode", rCode, force: true);
    //get registrationInfo
    await _popupController.update("connecting to server");

    _internetController.startRegistration(rCode, pair).then(
            (response) async{
              if(200 == response.statusCode){
                ToVerifyDataResDto reqDto = ToVerifyDataResDto.fromJson(jsonDecode(response.body)["res"]);
                await lSC.add("sessionId", reqDto.sessionId, force: true);
                await lSC.add("blurredFirstName", reqDto.firstName, force: true);
                await lSC.add("blurredLastName", reqDto.lastName, force: true);
                await _popupController.closeActive();
                //Go to new page:
                Navigator.of(context).pushNamed(ValidateRegistration.routeName);
              }else{
                // when something goes wrong, reload current page.
                await _popupController.closeActive();
                await new FeedbackDialog("No user with given registration code found!").init(context);
              }
        });
  }

  Future<ToVerifyDataResDto> getToVerifyData()async{
    final String bFirstName = await lSC.getKey("blurredFirstName");
    final String bLastName = await lSC.getKey("blurredLastName");
    final String sessionId = await lSC.getKey("sessionId");
    return ToVerifyDataResDto(bFirstName, bLastName, sessionId);
  }

  Future<void> verifyData(UserRegistrationInput input, BuildContext context) async{
    PrivateKey privateKey= await _keyStore.getPrivateKey();
    _internetController.validateRegistration(input, privateKey).then((response)async{
      if(response.statusCode == 200){
        // Save user locally:
        Map jsonBody = json.decode(response.body);
        RegisterSuccessDto dto = RegisterSuccessDto.fromRequestBody(jsonBody);
        User user = User.fromRegisterSuccessDto(dto);
        await LocalUserRepo().addUser(user);
        // redirect to show seed page:
        Navigator.of(context).pushNamed(SeedsScreen.routeName);
      }else{
        // Bad request route:
        Navigator.of(context).pushNamed("/");
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

  Future<void> update(String msg) {
    active.update(
        message: msg
    );
  }
}

class LocalUserRepo{
  final repo = LocalStorageController();

  Future<void> addUser(User user)async{
    await repo.add("firstName", user.firstName);
    await repo.add("lastName", user.lastName);
    await repo.add("identifier", user.identifier);
    await repo.add("birthDate", user.birthDate.toString());
  }

  Future<User> getUser()async{
    Map locals = await repo.getAll();
    User user = new User(
      locals["firstName"],
      locals["lastName"],
      locals["identifier"],
      DateTime.parse(locals["birthDate"])
    );
    return user;
  }

  Future<bool> isUserAuth()async{
    try{
      User user = await getUser();
      if(user != null){
        return true;
      }else
        return false;
    }catch(ignore){
      return false;
    }
  }
}