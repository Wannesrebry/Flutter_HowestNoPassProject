// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nopassauthenticationclient/main.dart';
import 'package:nopassauthenticationclient/models/encrypter.dart';
import 'package:pointycastle/asymmetric/api.dart';

void main() {

  test("test", () async{
    TestWidgetsFlutterBinding.ensureInitialized();
    final Encrypter enc = Encrypter();

    final seed = ["test", "test", "test", "test", "test", "test", "test", "test"];

    await enc.createAndStoreKeyPairFrom(seed);


    var msg = enc.toSignMsgToUint8("VERIFY THIS");
    var signature = await enc.sign(msg);
    enc.verify(msg, signature);

/*
    RSAPrivateKey foo = RSAPrivateKey(
      privateKey.n,
      privateKey.d,
      privateKey.p,
      privateKey.q,
    );
    RSAPublicKey bar = RSAPublicKey(publicKey.n, publicKey.e);
*/

  });
}

