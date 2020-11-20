
class UserRegistrationInput{

  String firstName;
  String lastName;
  DateTime birthDate;
  String sessionId;

  @override
  String toString() {
    return firstName + lastName  +birthDate.toString();
  }
}
