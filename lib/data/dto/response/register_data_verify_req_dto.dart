
class ToVerifyDataResDto{
  ToVerifyDataResDto(this.firstName, this.lastName, this.sessionId);
  ToVerifyDataResDto.fromJson(Map<String, dynamic> json):
        lastName = json["lastName"],
        firstName = json["firstName"],
        sessionId= json["sessionId"];

  final String firstName;
  final String lastName;
  final String sessionId;

  Map toJson() => {
    "firstName": "$firstName",
    "lastName": "$lastName"
  };

  @override
  String toString() {
    return firstName + " "+ lastName;
  }
}