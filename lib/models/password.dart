class Password {
  String loginSite;
  String emailOrUsername;
  String password;
  DateTime created;
  String image;

  Password(
      {required this.loginSite,
      required this.emailOrUsername,
      required this.password,
      required this.created,
      required this.image});

  String get imageUrl {
    return image;
  }
}
