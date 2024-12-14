class LoginRequestModel {
  final String email;
  final String nip;
  final String password;
  final bool isNip;

  LoginRequestModel({
    required this.isNip,
    required this.email,
    required this.nip,
    required this.password,
  });
}
