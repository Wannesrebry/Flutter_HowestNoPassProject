
class RecoveryRequestDTO{
  RecoveryRequestDTO(this.username, this.signature, this.singed_data);

  final String username;
  final String signature;
  final String singed_data;

  toJson() => {
    "username": username,
    "signature": signature,
    "signed_data": singed_data
  };

}