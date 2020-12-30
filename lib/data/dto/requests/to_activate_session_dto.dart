
class ToActivateSessionDto{
  ToActivateSessionDto.fromJson(Map<String, dynamic> json):
    this.id = int.parse(json["id"].toString()),
    this.application = json["application"].toString(),
    this.verified = json["verified"].toString() == "true",
    this.token = json["token"].toString();


  final int id;
  final String application;
  final bool verified;
  final String token;


}