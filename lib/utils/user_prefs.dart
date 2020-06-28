class UserPrefs {
  static final UserPrefs _userPrefs = UserPrefs._internal();
  
  factory UserPrefs() => _userPrefs;
  
  UserPrefs._internal();

  static UserPrefs get instance => _userPrefs;

  String jwt;
}