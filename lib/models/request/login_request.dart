class LoginRequest {
  String? deviceId;
  String? email;
  String? loginFrom;
  String? password;
  String? registrationId;

  LoginRequest({this.deviceId, this.email, this.loginFrom, this.password, this.registrationId});

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      deviceId: json['device_id'],
      email: json['email'],
      loginFrom: json['login_from'],
      password: json['password'],
      registrationId: json['registration_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['device_id'] = this.deviceId;
    data['email'] = this.email;
    data['login_from'] = this.loginFrom;
    data['password'] = this.password;
    data['registration_id'] = this.registrationId;
    return data;
  }
}
