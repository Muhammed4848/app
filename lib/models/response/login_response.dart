class LoginResponse {
  LoginData? data;
  String? message;
  bool? status;
  LoginResponse({this.data, this.message, this.status});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
      message: json['message'] != null ? json['message'] : "",
      status: json['status'] != null ? json['status'] : true,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class LoginData {
  String? apiToken;
  int? banned;
  String? contactNumber;
  String? createdAt;
  String? email;
  int? id;
  String? image;
  String? name;
  String? status;
  String? updatedAt;
  String? userType;
  String? userName;

  LoginData({this.apiToken, this.banned, this.contactNumber, this.createdAt, this.email, this.id, this.image, this.name, this.status, this.updatedAt, this.userType, this.userName});

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      apiToken: json['api_token'],
      banned: json['banned'],
      contactNumber: json['contact_number'],
      createdAt: json['created_at'],
      email: json['email'],
      id: json['id'],
      image: json['image'],
      name: json['name'],
      status: json['status'],
      updatedAt: json['updated_at'],
      userType: json['user_type'],
      userName: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['api_token'] = this.apiToken;
    data['banned'] = this.banned;
    data['contact_number'] = this.contactNumber;
    data['created_at'] = this.createdAt;
    data['email'] = this.email;
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    data['user_type'] = this.userType;
    data['username'] = this.userName;
    return data;
  }
}
