import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "package:pointycastle/export.dart";
final _storage = FlutterSecureStorage();

class Encrypter{
  final _LocalStoreKeyPair _store = _LocalStoreKeyPair();

  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAkeyPair(SecureRandom secureRandom, {int bitLength = 2048}) {
    // Create an RSA key generator and initialize it

    final keyGen = RSAKeyGenerator()
      ..init(
          ParametersWithRandom(
            RSAKeyGeneratorParameters(
                BigInt.parse('65537'),
                bitLength, 64)
              , secureRandom)
      );

    // Use the generator

    final pair = keyGen.generateKeyPair();

    // Cast the generated key pair into the RSA key types

    final myPublic = pair.publicKey as RSAPublicKey;
    final myPrivate = pair.privateKey as RSAPrivateKey;

    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(myPublic, myPrivate);
  }

  SecureRandom _secureRandom() {
    final secureRandom = FortunaRandom();

    final seedSource = Random.secure();
    final seeds = <int>[];
    for (int i = 0; i < 32; i++) {
      seeds.add(seedSource.nextInt(255));
    }
    print(seeds);
    print(seeds.length);
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));

    return secureRandom;
  }

  SecureRandom _secureSeed(List<String> seeds){
    final secureRandom = FortunaRandom();
    List<int> uInt8Seed = _stringToUint8(seeds);
    if(uInt8Seed != null){
      secureRandom.seed(KeyParameter(uInt8Seed));
      return secureRandom;
    }else return null;
  }

  Uint8List _stringToUint8(List<String> stringArray){
    List<int> res = [];
    stringArray.forEach((word) {
      word.runes.forEach((char) {
        var temp = char.toString().toLowerCase();
        var uint8 = int.parse(temp) %256;
        res.add(uint8);
      });
    });
  if(res.length == 32)
    return Uint8List.fromList(res);
  else return null;
  }

  Uint8List _rsaSign(RSAPrivateKey privateKey, Uint8List dataToSign) {

    final signer = RSASigner(SHA256Digest(), '0609608648016503040201');

    signer.init(true, PrivateKeyParameter<RSAPrivateKey>(privateKey)); // true=sign

    final sig = signer.generateSignature(dataToSign);

    return sig.bytes;
  }

  bool _rsaVerify(RSAPublicKey publicKey, Uint8List signedData, Uint8List signature) {
    final sig = RSASignature(signature);

    final verifier = RSASigner(SHA256Digest(), '0609608648016503040201');

    verifier.init(false, PublicKeyParameter<RSAPublicKey>(publicKey)); // false=verify

    try {
      return verifier.verifySignature(signedData, sig);
    } on ArgumentError {
      return false; // for Pointy Castle 1.0.2 when signature has been modified
    }
  }

  Future<void> createAndStoreRandomKeyPair()async {
    final pair = generateRSAkeyPair(_secureRandom());
    _store.addKeyPair(pair);
  }

  Future<void> createAndStoreKeyPairFrom(List<String> seed)async {
    final pair = generateRSAkeyPair(_secureSeed(seed));
    _store.addKeyPair(pair);
  }

  Future<Uint8List> sign(Uint8List toSignData)async{
    return _rsaSign(
        await _store.getPrivateKey(),
        toSignData);
  }

  Future<bool> verify(Uint8List singedData, Uint8List signature)async{
    return _rsaVerify(
        await _store.getPublicKey(),
        singedData,
        signature);
  }

  Uint8List toSignMsgToUint8(String msg){
    List<int> intList = [];
    msg.runes.forEach((char) {
      var temp = char.toString().toLowerCase();
      var uint8 = int.parse(temp) % 256;
      intList.add(uint8);
    });
    return Uint8List.fromList(intList);
  }

}

class _LocalStoreKeyPair{

  Future<RSAPrivateKey> getPrivateKey() async{
    Map<String, String> allValues = await _storage.readAll();
    return RSAPrivateKey(
      BigInt.parse(allValues["private_n"]),
      BigInt.parse(allValues["private_d"]),
      BigInt.parse(allValues["private_p"]),
      BigInt.parse(allValues["private_q"])
    );
  }

  Future<RSAPublicKey> getPublicKey() async{
    Map<String, String> allValues = await _storage.readAll();
    return RSAPublicKey(
        BigInt.parse(allValues["public_n"]),
        BigInt.parse(allValues["public_e"])
    );
  }

  void addKeyPair(AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> pair)async {
    await _storage.write(key: "private_n", value: pair.privateKey.n.toString());
    await _storage.write(key: "private_d", value: pair.privateKey.d.toString());
    await _storage.write(key: "private_p", value: pair.privateKey.p.toString());
    await _storage.write(key: "private_q", value: pair.privateKey.q.toString());
    await _storage.write(key: "public_n", value: pair.publicKey.n.toString());
    await _storage.write(key: "public_e", value: pair.publicKey.e.toString());
  }

  void clearLocalKeyPair() async{
    await _storage.deleteAll();
  }

}