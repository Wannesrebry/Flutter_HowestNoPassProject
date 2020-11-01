
class DataVerifyReqDto{
  DataVerifyReqDto(this.firstName, this.lastName);
  DataVerifyReqDto.fromJson(Map<String, dynamic> json):
        lastName = json["lastName"],
        firstName = json["firstName"];

  final String firstName;
  final String lastName;

  Map toJson() => {
    "firstName": "$firstName",
    "lastName": "$lastName"
  };

  @override
  String toString() {
    return firstName + " "+ lastName;
  }
}