class ChangePassword {
  String? newPassword;
  String? oldPassword;

  ChangePassword({this.newPassword, this.oldPassword});

  factory ChangePassword.fromJson(Map<String, dynamic> json) {
    return ChangePassword(
      newPassword: json['new_password'],
      oldPassword: json['old_password'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['new_password'] = this.newPassword;
    data['old_password'] = this.oldPassword;
    return data;
  }
}
