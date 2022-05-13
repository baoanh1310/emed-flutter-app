class AppSetting {
  String userId;
  String userName;

  AppSetting({this.userId, this.userName});

  AppSetting.fromMap(Map<String, dynamic> map) {
    userId = map['userId'];
    userName = map['userName'];
  }
}