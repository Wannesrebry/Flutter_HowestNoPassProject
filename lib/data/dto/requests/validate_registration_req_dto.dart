class ValidateRegistrationReqDTO{
  ValidateRegistrationReqDTO(
      this.registrationCode,
      this.firstName,
      this.lastName,
      this.birthDate,
      this.sessionId,
      this.signature,
      this.singedData);

  final String registrationCode;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final String sessionId;
  final String signature;
  final String singedData;

  Map toJson() => {
    'registrationCode': "$registrationCode",
    'firstName': "$firstName",
    'lastName': '$lastName',
    'birthDate': '${birthDate.toString()}',
    'sessionId': '$sessionId',
    'signature': '$signature',
    'signedData': '$singedData'
  };


}