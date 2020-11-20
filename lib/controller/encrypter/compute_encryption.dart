import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nopassauthenticationclient/controller/encrypter/prepare_encryption.dart';
import 'file:///C:/Users/wannes-nzxt/AndroidStudioProjects/nopassauthenticationclient/lib/data/encrypt_data.dart';
import 'package:pointycastle/export.dart';

final Map<String, String> _digestIntifierHexes = {
  "MD2": "06082a864886f70d0202",
  "MD4": "06082a864886f70d0204",
  "MD5": "06082a864886f70d0205",
  "RIPEMD-128": "06052b24030202",
  "RIPEMD-160": "06052b24030201",
  "RIPEMD-256": "06052b24030203",
  "SHA-1": "06052b0e03021a",
  "SHA-224": "0609608648016503040204",
  "SHA-256": "0609608648016503040201",
  "SHA-384": "0609608648016503040202",
  "SHA-512": "0609608648016503040203"
};

Future<AsymmetricKeyPair<PublicKey, PrivateKey>> computeRSAKeyPair(
    SecureRandom secureRandom) async {
  return await compute(_generateRSAkeyPair, secureRandom);
}

Future<AsymmetricKeyPair<PublicKey, PrivateKey>> _generateRSAkeyPair(
    SecureRandom secureRandom) async{
  var rsapars = new RSAKeyGeneratorParameters(BigInt.from(65537), 2048, 5);
  var params = new ParametersWithRandom(rsapars, secureRandom);
  var keyGenerator = new RSAKeyGenerator();
  keyGenerator.init(params);
  return keyGenerator.generateKeyPair();
}

String rsaSign(Uint8List uint8Message, RSAPrivateKey privateKey) {
  var signer = RSASigner(SHA256Digest(), _digestIntifierHexes["SHA-256"]);
  signer.init(true, PrivateKeyParameter<RSAPrivateKey>(privateKey));
  return  base64Encode(signer.generateSignature(uint8Message).bytes);
}

bool rsaVerify(String signedMessage, Uint8List message, RSAPublicKey publicKey) {
  var signer = RSASigner(SHA256Digest(), _digestIntifierHexes["SHA-256"]);
  signer.init(false, PublicKeyParameter<RSAPublicKey>(publicKey));
  return signer.verifySignature(message, RSASignature(base64Decode(signedMessage)));
}

class RetrieveEncryptionData{

  encodePrivateKeyToPem(RSAPrivateKey privateKey) {
    var version = ASN1Integer(BigInt.from(0));

    var algorithmSeq = new ASN1Sequence();
    var algorithmAsn1Obj = new ASN1Object.fromBytes(Uint8List.fromList([0x6, 0x9, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0xd, 0x1, 0x1, 0x1]));
    var paramsAsn1Obj = new ASN1Object.fromBytes(Uint8List.fromList([0x5, 0x0]));
    algorithmSeq.add(algorithmAsn1Obj);
    algorithmSeq.add(paramsAsn1Obj);

    var privateKeySeq = new ASN1Sequence();
    var modulus = ASN1Integer(privateKey.n);
    var publicExponent = ASN1Integer(BigInt.parse('65537'));
    var privateExponent = ASN1Integer(privateKey.d);
    var p = ASN1Integer(privateKey.p);
    var q = ASN1Integer(privateKey.q);
    var dP = privateKey.d % (privateKey.p - BigInt.from(1));
    var exp1 = ASN1Integer(dP);
    var dQ = privateKey.d % (privateKey.q - BigInt.from(1));
    var exp2 = ASN1Integer(dQ);
    var iQ = privateKey.q.modInverse(privateKey.p);
    var co = ASN1Integer(iQ);

    privateKeySeq.add(version);
    privateKeySeq.add(modulus);
    privateKeySeq.add(publicExponent);
    privateKeySeq.add(privateExponent);
    privateKeySeq.add(p);
    privateKeySeq.add(q);
    privateKeySeq.add(exp1);
    privateKeySeq.add(exp2);
    privateKeySeq.add(co);
    var publicKeySeqOctetString = new ASN1OctetString(Uint8List.fromList(privateKeySeq.encodedBytes));

    var topLevelSeq = new ASN1Sequence();
    topLevelSeq.add(version);
    topLevelSeq.add(algorithmSeq);
    topLevelSeq.add(publicKeySeqOctetString);
    var dataBase64 = base64.encode(topLevelSeq.encodedBytes);

    return """-----BEGIN PRIVATE KEY-----\r\n$dataBase64\r\n-----END PRIVATE KEY-----""";
  }

  encodePublicKeyToPem(RSAPublicKey publicKey) {
    var algorithmSeq = new ASN1Sequence();
    var algorithmAsn1Obj = new ASN1Object.fromBytes(Uint8List.fromList([0x6, 0x9, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0xd, 0x1, 0x1, 0x1]));
    var paramsAsn1Obj = new ASN1Object.fromBytes(Uint8List.fromList([0x5, 0x0]));
    algorithmSeq.add(algorithmAsn1Obj);
    algorithmSeq.add(paramsAsn1Obj);

    var publicKeySeq = new ASN1Sequence();
    publicKeySeq.add(ASN1Integer(publicKey.modulus));
    publicKeySeq.add(ASN1Integer(publicKey.exponent));
    var publicKeySeqBitString = new ASN1BitString(Uint8List.fromList(publicKeySeq.encodedBytes));

    var topLevelSeq = new ASN1Sequence();
    topLevelSeq.add(algorithmSeq);
    topLevelSeq.add(publicKeySeqBitString);
    var dataBase64 = base64.encode(topLevelSeq.encodedBytes);

    return """-----BEGIN PUBLIC KEY-----\r\n$dataBase64\r\n-----END PUBLIC KEY-----""";
  }



  parsePublicKeyFromPem(pemString) {
    List<int> publicKeyDER = decodePEM(pemString);
    var asn1Parser = new ASN1Parser(publicKeyDER);
    var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    var publicKeyBitString = topLevelSeq.elements[1];

    var publicKeyAsn = new ASN1Parser(publicKeyBitString.contentBytes());
    ASN1Sequence publicKeySeq = publicKeyAsn.nextObject();
    var modulus = publicKeySeq.elements[0] as ASN1Integer;
    var exponent = publicKeySeq.elements[1] as ASN1Integer;

    RSAPublicKey rsaPublicKey = RSAPublicKey(
        modulus.valueAsBigInteger,
        exponent.valueAsBigInteger
    );

    return rsaPublicKey;
  }

  parsePrivateKeyFromPem(pemString) {
    List<int> privateKeyDER = decodePEM(pemString);
    var asn1Parser = new ASN1Parser(privateKeyDER);
    var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    var version = topLevelSeq.elements[0];
    var algorithm = topLevelSeq.elements[1];
    var privateKey = topLevelSeq.elements[2];

    asn1Parser = new ASN1Parser(privateKey.contentBytes());
    var pkSeq = asn1Parser.nextObject() as ASN1Sequence;

    version = pkSeq.elements[0];
    var modulus = pkSeq.elements[1] as ASN1Integer;
    var publicExponent = pkSeq.elements[2] as ASN1Integer;
    var privateExponent = pkSeq.elements[3] as ASN1Integer;
    var p = pkSeq.elements[4] as ASN1Integer;
    var q = pkSeq.elements[5] as ASN1Integer;
    var exp1 = pkSeq.elements[6] as ASN1Integer;
    var exp2 = pkSeq.elements[7] as ASN1Integer;
    var co = pkSeq.elements[8] as ASN1Integer;

    RSAPrivateKey rsaPrivateKey = RSAPrivateKey(
        modulus.valueAsBigInteger,
        privateExponent.valueAsBigInteger,
        p.valueAsBigInteger,
        q.valueAsBigInteger
    );

    return rsaPrivateKey;
  }

  List<int> decodePEM(String pem) {
    var startsWith = [
      "-----BEGIN PUBLIC KEY-----",
      "-----BEGIN PRIVATE KEY-----",
      "-----BEGIN PGP PUBLIC KEY BLOCK-----\r\nVersion: React-Native-OpenPGP.js 0.1\r\nComment: http://openpgpjs.org\r\n\r\n",
      "-----BEGIN PGP PRIVATE KEY BLOCK-----\r\nVersion: React-Native-OpenPGP.js 0.1\r\nComment: http://openpgpjs.org\r\n\r\n",
    ];
    var endsWith = [
      "-----END PUBLIC KEY-----",
      "-----END PRIVATE KEY-----",
      "-----END PGP PUBLIC KEY BLOCK-----",
      "-----END PGP PRIVATE KEY BLOCK-----",
    ];
    bool isOpenPgp = pem.indexOf('BEGIN PGP') != -1;

    for (var s in startsWith) {
      if (pem.startsWith(s)) {
        pem = pem.substring(s.length);
      }
    }

    for (var s in endsWith) {
      if (pem.endsWith(s)) {
        pem = pem.substring(0, pem.length - s.length);
      }
    }

    if (isOpenPgp) {
      var index = pem.indexOf('\r\n');
      pem = pem.substring(0, index);
    }

    pem = pem.replaceAll('\n', '');
    pem = pem.replaceAll('\r', '');

    return base64.decode(pem);
  }

  EncryptData generateVerifiableData(RSAPrivateKey pkey){
    final pEnc = PrepareForEncryption();
    String toSignData = _getRandomString(32);
    Uint8List uint8ToSignData = pEnc.stringToUint8([toSignData]);
    final signature = rsaSign(uint8ToSignData, pkey);
    EncryptData res = EncryptData(toSignData, signature);
    return res;
  }
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();
String _getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));