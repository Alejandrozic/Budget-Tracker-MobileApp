class User{
  final userName;
  final password;

  User({required this.userName, required this.password});

  bool validateCredentials(){
    // TMP DEMO IMPLEMENTATION
    return userName == 'demo' && password == 'demo';
  }
}