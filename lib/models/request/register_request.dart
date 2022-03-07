class RegisterRequest {
  String? contactNumber;
  String? email;
  String? id;
  String? message;
  String? name;
  String? password;
  bool? status;
  String? username;

  RegisterRequest({this.contactNumber, this.email, this.id, this.message, this.name, this.password, this.status, this.username});

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      contactNumber: json['contact_number'],
      email: json['email'],
      id: json['id'],
      message: json['message'],
      name: json['name'],
      password: json['password'],
      status: json['status'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contact_number'] = this.contactNumber;
    data['email'] = this.email;
    data['id'] = this.id;
    data['message'] = this.message;
    data['name'] = this.name;
    data['password'] = this.password;
    data['status'] = this.status;
    data['username'] = this.username;
    return data;
  }
}
