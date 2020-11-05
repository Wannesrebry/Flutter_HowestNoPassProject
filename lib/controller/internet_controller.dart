import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nopassauthenticationclient/controller/encrypter/compute_encryption.dart';
import 'package:nopassauthenticationclient/controller/encrypter/prepare_encryption.dart';
import 'package:nopassauthenticationclient/controller/encrypter/store_encryption.dart';
import 'package:pointycastle/asymmetric/api.dart';
final _preEncrypter = PrepareForEncryption();
final _retrieveEncryptionData = RetrieveEncryptionData();
final _keyStore = LocalStoreKeyPair();

class InternetController{
  final String baseUrl = "http://192.168.6.128:8888";
  final String localUrl = "http://10.97.1.128:8888";

  Future<http.Response> startRegistration(String rCode) async {
    final pair = await computeRSAKeyPair(_preEncrypter.secureRandom());
    await _keyStore.addKeyPair(pair);
    return http.post(
      localUrl + "/preregistration",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'registrationCode': rCode,
        'publicKey': await _retrieveEncryptionData.encodePublicKeyToPem(pair.publicKey)
      }),
    );
  }

}


