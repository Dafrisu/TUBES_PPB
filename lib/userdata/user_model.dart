class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String username;
  final String password;
  final String displayName;
  final String profileImageUrl;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.username,
    required this.password,
    required this.displayName,
    required this.profileImageUrl,
  });
}