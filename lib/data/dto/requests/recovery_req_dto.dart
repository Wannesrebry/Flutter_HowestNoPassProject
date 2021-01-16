
class RecoveryRequestDTO{
  RecoveryRequestDTO(this.username, this.signature, this.singedData);

  final String username;
  final String signature;
  final String singedData;

  toJson() => {
    "username": username,
    "signature": signature,
    "signed_data": singedData
  };

}