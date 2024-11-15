class LoginRequestModel {
  final String email;
  final String nip;
  final String password;

  LoginRequestModel(
      {required this.email, required this.nip, required this.password});
}
