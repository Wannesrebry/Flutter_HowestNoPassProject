
class RegisterSuccessDto{

  RegisterSuccessDto(
      this.registrationCode,
      this.firstName,
      this.lastName,
      this.identifier,
      this.birthDate);
  RegisterSuccessDto.fromRequestBody(Map body):
      this.registrationCode = body["registrationCode"].toString(),
      this.firstName = body["firstName"].toString(),
      this.lastName = body["lastName"].toString(),
      this.identifier = body["identifier"].toString(),
      this.birthDate = DateTime.parse(body["birthDate"].toString());


  final String registrationCode;
  final String firstName;
  final String lastName;
  final String identifier;
  final DateTime birthDate;




}