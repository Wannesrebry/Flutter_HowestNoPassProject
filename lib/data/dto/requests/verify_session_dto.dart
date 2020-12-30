import 'dart:core';

class VerifySessionDto{

  VerifySessionDto(this.application, this.status, this.signature, this.singedData, this.identifier);

  final String application;
  final String status;
  final String signature;
  final String singedData;
  final String identifier;


  Map toJson() => {
    "application": application,
    "status": status,
    "signature": signature,
    "signedData": singedData,
    "identifier": identifier
  };

}