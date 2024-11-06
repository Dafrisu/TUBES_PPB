import 'package:flutter/material.dart';
import 'user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = UserModel(
    id: "109238",
    fullName: "Asep Lengkap",
    email: "AsepL@email.co.id",
    phone: "129384751782",
    address: "Jalan Boulevard",
    username: "AsepL",
    password: "AsepL1onzz",
    displayName: "Asep Montir",
    profileImageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWW0xcyFQPL6DIne-s-4nHzmBuIMCN12FioA&s",
  );

  UserModel get user => _user;

  void updateUser(UserModel newUser) {
    _user = newUser;
    notifyListeners();
  }

  void signOut() {
    // Add sign out logic here
    notifyListeners();
  }

  void deleteAccount() {
    // Add account deletion logic here
    notifyListeners();
  }
}