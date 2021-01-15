import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nopassauthenticationclient/controller/encrypter/compute_encryption.dart';
import 'package:nopassauthenticationclient/controller/local_storage.dart';
import 'package:nopassauthenticationclient/data/dto/requests/to_activate_session_dto.dart';
import 'package:nopassauthenticationclient/data/dto/requests/validate_registration_req_dto.dart';
import 'package:nopassauthenticationclient/data/dto/requests/verify_session_dto.dart';
import 'package:nopassauthenticationclient/data/user_registration_input.dart';
import 'package:pointycastle/api.dart';

final _retrieveEncryptionData = RetrieveEncryptionData();
final _localStore = LocalStorageController();

class InternetController{
  final String baseUrl = "http://192.168.10.59:8888";
  final Map<String,String> _headers = {
    'Content-Type': 'application/json',
  };

  Future<http.Response> startRegistration(String rCode, AsymmetricKeyPair<PublicKey, PrivateKey> pair) async {
    final encData = _retrieveEncryptionData.generateVerifiableData(pair.privateKey);
    return http.post(
      baseUrl + "/preregistration",
      headers: _headers,
      body: jsonEncode(<String, dynamic>{
        'registrationCode': rCode,
        'publicKeyPEM': await _retrieveEncryptionData.encodePublicKeyToPem(pair.publicKey),
        'signature': encData.signature,
        'signedData': encData.data
      }),
    );
  }

  Future<http.Response> validateRegistration(UserRegistrationInput input,  PrivateKey privateKey) async{
    final encData = _retrieveEncryptionData.generateVerifiableData(privateKey);
    final String registrationCode =   await _localStore.getKey("registrationCode");
    final reqDTO = ValidateRegistrationReqDTO(
      registrationCode,
        input.firstName,
        input.lastName,
        input.birthDate,
        input.sessionId,
        encData.signature,
        encData.data);

    final body = jsonEncode(reqDTO.toJson());
    return http.post(
      baseUrl + "/validate_registration",
      headers: _headers,
      body: body,
    );
  }

  Future<List<String>> getSeeds() async {
    List<String> seedList20 = [];
    await http.get(baseUrl + "/seeds",
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

  Future<ToActivateSessionDto> getToActivateSession(String identifier) async{
    return await http.get(baseUrl + "/mobile/toverify?identifier=$identifier",
        headers: <String, String>{
          'Content-Type': 'application/json',
        }
    ).then((response){
      Map<String, dynamic> jsonResponse = jsonDecode(response.body)["session"];
      ToActivateSessionDto session = ToActivateSessionDto.fromJson(jsonResponse);
      return session;
    });
  }

  Future<void> allowSession(String token,  PrivateKey privateKey) async{
    String application = await _localStore.getKey("verify_application");
    String identifier = await _localStore.getKey("identifier");
    final encData = _retrieveEncryptionData.generateVerifiableData(privateKey);
    VerifySessionDto dto = VerifySessionDto(application.toString(), "ALLOW", encData.signature, encData.data, identifier.toString());
    await http.post(baseUrl + "/mobile/verify?token=$token",
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(dto.toJson())
    ).then((response){

    });
  }

  Future<void> denySession(String token) {

  }
}


