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

  Future<void> addKeyPair(AsymmetricKeyPair<PublicKey, PrivateKey> pair, List<String> seeds)async {
    await _storage.write(key: "privateKeyPEM", value: encHelper.encodePrivateKeyToPem(pair.privateKey));
    await _storage.write(key: "publicKeyPEM", value: encHelper.encodePublicKeyToPem(pair.publicKey));
  }

  Future<void> addSeeds(List<String> seeds)async{
    await _storage.write(key: "seeds", value: seeds.toString());
  }

  Future<List<String>> getSeeds()async{
    String seedString = await _storage.read(key: "seeds");
    return stringToList(seedString);
  }

  Future<void> clearLocalKeyPair() async{
    await _storage.deleteAll();
  }

}

List<String> stringToList(String s){
  List<String> res = s.split(",");
  res[0] = res[0].replaceAll("[", "");
  res[res.length-1] = res[res.length-1].replaceAll("]", "");
  return res;
}