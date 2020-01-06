import 'dart:convert';

import 'package:flutter_book/util/event_bus.dart';
import 'package:flutter_book/pref.dart';

const String EventUserLogin = 'EventUserLogin';
const String EventUserLogout = 'EventUserLogout';

class UserManager {
  static UserManager _instance;
  static UserManager get instance {
    if (_instance ==null) {
      _instance =UserManager();
      _instance.loadUserFromLocal();
    }
    return _instance;
  }

  User user;
  // 获取当前用户
  static User get currentUser {
    return UserManager.instance.user;
  }

  //logout
  logout() {
    this.user = null;
    preferences.remove('user');
    eventBus.emit(EventUserLogout);
  }

  //login 
  login(Map<String, dynamic> userJson) {
    var user =User.fromJson(userJson);
    //用户赋值
    this.user = user;
    //保存登录用户信息
    saveUser();

    eventBus.emit(EventUserLogin);
  }

  // 从本地获取保存的用户信息
  loadUserFromLocal() {
    String userJson =preferences.getString('user');
    if (userJson != null) {
      user =User.fromJson(json.decode(userJson));
    }
  }

  void saveUser() async {
    var data =json.encode(user);
    preferences.setString('user', data);
  }

  // 用户是否已经登录
  bool get isLogin {
    return user != null;
  }
}

class User {
  String token;
  int id;
  String nickname;
  String avatarUrl;
  bool isVip;
  double wealth;
  int coupon;
  int monthlyTicket;

  User.fromJson(Map json) {
    token = json['token'];
    id = json['id'];
    nickname = json['nickname'];
    avatarUrl = json['avatar'];
    isVip = json['is_vip'] == 1;
    wealth = json['wealth'];
    coupon = json['coupon'];
    monthlyTicket = json['ticket'];
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'id': id,
      'nickname': nickname,
      'avatar': avatarUrl,
      'is_vip': isVip ? 1 : 0,
      'wealth': wealth,
      'coupon': coupon,
      'ticket': monthlyTicket,
    };
  }
}
