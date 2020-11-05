// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nopassauthenticationclient/controller/encrypter/prepare_encryption.dart';
import 'package:nopassauthenticationclient/controller/encrypter/compute_encryption.dart';


void main() {

  test("test", () async{
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


  });
}

