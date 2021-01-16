import 'package:flutter_test/flutter_test.dart';
import 'package:nopassauthenticationclient/controller/encrypter/store_encryption.dart';


void main() {

  test("test", () async{

    /*
    final preEncryption = PrepareForEncryption();
    final secureRandom = preEncryption.secureRandom();
    final pair = await computeRSAKeyPair(secureRandom);
    print(pair);
    final retrieveEncData = RetrieveEncryptionData();
    final dataPrivateKey = retrieveEncData.encodePrivateKeyToPem(pair.privateKey);
    final dataPublicKey = retrieveEncData.encodePublicKeyToPem(pair.publicKey);

    final data = preEncryption.stringToUint8(["test", "test", "test", "test", "test", "test", "test", "test"]);
    print(data);
    final signature = rsaSign(data, retrieveEncData.parsePrivateKeyFromPem(dataPrivateKey));

    print(signature);
    print(rsaVerify(signature, data, retrieveEncData.parsePublicKeyFromPem(dataPublicKey)));
*/
    String list = "[test,test,test,test]";
    List<String> test = stringToList(list);
    print(test);

    String args = "2020-01-07 00:00";
    String date = args.split(" ")[0];
    List<String> parts = date.split("-");
    List<int> partsInt =  [];
    parts.forEach((element) {partsInt.add(int.parse(element));});
    print(DateTime(partsInt[0], partsInt[1], partsInt[2]));

    print(DateTime.parse(args));

  });
}

