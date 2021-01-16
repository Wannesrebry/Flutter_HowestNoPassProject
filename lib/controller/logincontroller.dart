import 'package:flutter/cupertino.dart';
import 'package:nopassauthenticationclient/controller/encrypter/store_encryption.dart';
import 'package:nopassauthenticationclient/controller/internet_controller.dart';
import 'package:nopassauthenticationclient/controller/local_storage.dart';
import 'package:nopassauthenticationclient/data/dto/requests/to_activate_session_dto.dart';
import 'package:nopassauthenticationclient/view/components/dialogs/feedback_dialog.dart';
import 'package:nopassauthenticationclient/view/components/dialogs/wait.dart';
import 'package:nopassauthenticationclient/view/screens/auth/toverify.dart';
import 'package:pointycastle/export.dart';

final _keyStore = LocalStoreKeyPair();
final LocalStorageController lSC = LocalStorageController();


class LoginController extends StatefulWidget{
  final InternetController _internetController = InternetController();

  @override
  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }

  onClickLoginRequestsBtn(BuildContext context)async{
    String identifier = await lSC.getKey("identifier");
    try{
      ToActivateSessionDto session = await _internetController.getToActivateSession(identifier.toString());
      lSC.add("verify_token", session.token.toString(), force: true);
      lSC.add("verify_application", session.application.toString(), force: true);
      Navigator.of(context).pushNamed(AuthVerify.routeName);
    }catch(ignore){
      await new FeedbackDialog("No login request detected.").init(context);
    }
  }

  void onClickVerify(String token,String status,  BuildContext context) async{
    PrivateKey privateKey= await _keyStore.getPrivateKey();
    if(status == "ALLOW"){
      await _internetController.respondSession(token, privateKey, status);
    }else{
      await _internetController.respondSession(token, privateKey, status);
    }
    Navigator.of(context).pushNamed("/");
  }
}