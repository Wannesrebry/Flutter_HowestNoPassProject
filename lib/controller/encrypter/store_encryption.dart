import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nopassauthenticationclient/controller/encrypter/compute_encryption.dart';
import 'package:pointycastle/export.dart';
final _storage = FlutterSecureStorage();
final encHelper = RetrieveEncryptionData();

class LocalStoreKeyPair{

  Future<RSAPrivateKey> getPrivateKey() async{
    String privateKeyPEM = await _storage.read(key: "privateKeyPEM");
    return encHelper.parsePrivateKeyFromPem(privateKeyPEM);
  }

  Future<RSAPublicKey> getPublicKey() async{
    String publicKeyPEM = await _storage.read(key: "publicKeyPEM");
    return encHelper.parsePublicKeyFromPem(publicKeyPEM);
  }

  Future<void> addKeyPair(AsymmetricKeyPair<PublicKey, PrivateKey> pair)async {
    await _storage.write(key: "privateKeyPEM", value: encHelper.encodePrivateKeyToPem(pair.privateKey));
    await _storage.write(key: "publicKeyPEM", value: encHelper.encodePublicKeyToPem(pair.publicKey));
  }

  Future<void> clearLocalKeyPair() async{
    await _storage.deleteAll();
  }

}