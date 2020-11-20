import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nopassauthenticationclient/controller/encrypter/compute_encryption.dart';
import 'package:nopassauthenticationclient/controller/encrypter/prepare_encryption.dart';
import 'package:nopassauthenticationclient/controller/encrypter/store_encryption.dart';
import 'package:nopassauthenticationclient/controller/local_storage.dart';
import 'package:nopassauthenticationclient/data/dto/requests/validate_registration_req_dto.dart';
import 'package:nopassauthenticationclient/data/user_registration_input.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/api.dart';

final _preEncrypter = PrepareForEncryption();
final _retrieveEncryptionData = RetrieveEncryptionData();
final _keyStore = LocalStoreKeyPair();
final _localStore = LocalStorageController();

class InternetController{
  final String baseUrl = "http://192.168.6.128:8888";
  final String localUrl = "http://10.97.1.128:8887";
  final Map<String,String> _headers = {
    'Content-Type': 'application/json',
  };

  Future<http.Response> startRegistration(String rCode, AsymmetricKeyPair<PublicKey, PrivateKey> pair) async {
    final encData = _retrieveEncryptionData.generateVerifiableData(pair.privateKey);
    return http.post(
      localUrl + "/preregistration",
      headers: _headers,
      body: jsonEncode(<String, dynamic>{
        'registrationCode': rCode,
        'publicKeyPEM': await _retrieveEncryptionData.encodePublicKeyToPem(pair.publicKey),
        'signature': encData.signature,
        'signedData': encData.data
      }),
    );
  }

  Future<http.Response> validateRegistration(UserRegistrationInput input, PrivateKey privateKey) async{
    final encData = _retrieveEncryptionData.generateVerifiableData(privateKey);
    final reqDTO = ValidateRegistrationReqDTO(
        await _localStore.getKey("registrationCode"),
        input.firstName,
        input.lastName,
        input.birthDate,
        input.sessionId,
        encData.signature,
        encData.data);

    final body = jsonEncode(reqDTO.toJson());
    return http.post(
      localUrl + "/validate_registration",
      headers: _headers,
      body: body,
    );
  }



  Future<List<String>> getSeeds() async {
    List<String> seedList20 = [];
    await http.get(localUrl + "/seeds",
    headers: <String, String>{
        'Content-Type': 'application/json',
        }
    ).then((response){
      List<dynamic> jsonList = jsonDecode(response.body)["data"];
      jsonList.forEach((element) {seedList20.add(element.toString());});

    });
    seedList20.shuffle();
    List<String> seedList8 = [];
    seedList20.take(8).forEach((element) {
      seedList8.add(element.toString().toLowerCase());
    });
    return seedList8;
  }



}


