import 'package:flutter/cupertino.dart';
import 'package:nopassauthenticationclient/controller/register_controller.dart';
import 'package:nopassauthenticationclient/data/dto/requests/recovery_req_dto.dart';
import 'package:nopassauthenticationclient/view/components/dialogs/feedback_dialog.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'encrypter/compute_encryption.dart';
import 'encrypter/prepare_encryption.dart';
import 'internet_controller.dart';

class RecoveryController extends  StatefulWidget{

  final _preEncrypter = PrepareForEncryption();
  final PopupController _popupController = PopupController();
  final _retrieveEncryptionData = RetrieveEncryptionData();
  final InternetController _internetController = InternetController();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

  onClickRecoveryBtn(String username, String seedsString, BuildContext context)async {
    if(username == null || username == "" || seedsString == null || seedsString == ""){
        await FeedbackDialog("Invalid data").init(context);
    }
    await _popupController.init(ProgressDialog(
        context,
        type: ProgressDialogType.Normal,
        isDismissible: false,
        showLogs: false));
    try{
      List<String> seeds = stringToArray(seedsString, ",");
      final pair = await computeRSAKeyPair(_preEncrypter.secureSeed(seeds));
      final encData = _retrieveEncryptionData.generateVerifiableData(pair.privateKey);
      RecoveryRequestDTO dto = RecoveryRequestDTO(username, encData.signature, encData.data);
      final bool success = await _internetController.recoverUser(dto);
      await _popupController.closeActive();
      if(success){
        Navigator.of(context).pushNamed("/");
      }else{
        await FeedbackDialog("Unable to recover user").init(context);
      }
    }catch(ignore){
      await _popupController.closeActive();
      await FeedbackDialog("Invalid data").init(context);
    }
  }

  List<String> stringToArray(String s, String seperator){
    return s.split(seperator);
  }

}