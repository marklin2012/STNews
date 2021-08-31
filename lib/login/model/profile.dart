import 'package:stnews/login/model/user.dart';

class Profile {
  User? user;
  bool? isLogin;
  String? token;

  Profile({
    this.user,
    this.isLogin = false,
    this.token,
  });

  Profile.fromJson(Map<String, dynamic> json) {
    if (json['user'] != null && json['user'] is Map<String, dynamic>) {
      final userMap = json['user'] as Map<String, dynamic>;
      user = User.fromJson(userMap);
    }
    isLogin = json['isLogin'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isLogin'] = this.isLogin;
    data['token'] = this.token;
    if (this.user != null) {
      Map<String, dynamic> userMap = this.user!.toJson();
      data['user'] = userMap;
    }
    return data;
  }
}
