import 'package:flutter/material.dart';

/// 全局用户信息服务
class UserService extends ChangeNotifier {
  static final UserService _instance = UserService._internal();

  factory UserService() {
    return _instance;
  }

  UserService._internal();

  String _userName = '次元2631';
  String _userBio = '热爱二次元，分享日常碎片';
  String _userAvatar = 'assets/images/img_j.jpg';

  String get userName => _userName;
  String get userBio => _userBio;
  String get userAvatar => _userAvatar;

  void updateUserProfile({
    String? name,
    String? bio,
    String? avatar,
  }) {
    if (name != null) _userName = name;
    if (bio != null) _userBio = bio;
    if (avatar != null) _userAvatar = avatar;
    notifyListeners();
  }

  void updateAvatar(String avatarPath) {
    _userAvatar = avatarPath;
    notifyListeners();
  }

  void reset() {
    _userName = '次元2631';
    _userBio = '热爱二次元，分享日常碎片';
    _userAvatar = 'assets/images/img_j.jpg';
    notifyListeners();
  }
}
