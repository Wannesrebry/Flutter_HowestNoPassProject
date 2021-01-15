import 'package:nopassauthenticationclient/controller/encrypter/store_encryption.dart';

final LocalStoreKeyPair _localStoreKeyPair = LocalStoreKeyPair();

class EncryptionController{

  void removeEncryptionKeys(){
    _localStoreKeyPair.clearLocalKeyPair();
  }

}