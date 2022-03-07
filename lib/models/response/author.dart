class AuthorDetail {
  var address;
  var author_id;
  var description;
  var designation;
  var education;
  var email_id;
  var image;
  var mobile_no;
  var name;
  var status;

  AuthorDetail(
      {this.address,
      this.author_id,
      this.description,
      this.designation,
      this.education,
      this.email_id,
      this.image,
      this.mobile_no,
      this.name,
      this.status});

  factory AuthorDetail.fromJson(Map<String, dynamic> json) {
    return AuthorDetail(
      address: json['address'],
      author_id: json['author_id'],
      description: json['description'],
      designation: json['designation'],
      education: json['education'],
      email_id: json['email_id'] != null ? json['email_id'] : null,
      image: json['image'],
      mobile_no: json['mobile_no'] != null ? json['mobile_no'] : null,
      name: json['name'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['author_id'] = this.author_id;
    data['description'] = this.description;
    data['designation'] = this.designation;
    data['education'] = this.education;
    data['image'] = this.image;
    data['name'] = this.name;
    data['status'] = this.status;
    if (this.email_id != null) {
      data['email_id'] = this.email_id;
    }
    if (this.mobile_no != null) {
      data['mobile_no'] = this.mobile_no;
    }
    return data;
  }
}
