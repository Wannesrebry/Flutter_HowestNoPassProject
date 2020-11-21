import 'package:nopassauthenticationclient/data/dto/response/register_success_res_dto.dart';

class User{
  User(this.firstName, this.lastName, this.identifier, this.birthDate);
  User.fromRegisterSuccessDto(RegisterSuccessDto dto):
      this.firstName = dto.firstName,
      this.lastName = dto.lastName,
      this.identifier = dto.identifier,
      this.birthDate = dto.birthDate;

  final String firstName;
  final String lastName;
  final String identifier;
  final DateTime birthDate;

  @override
  String toString() {
    return "$firstName , $lastName , $identifier";
  }

}
