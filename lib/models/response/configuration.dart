class  Configuration {
  String? createdAt;
  int? id;
  String? key;
  String? updatedAt;
  String? value;

  Configuration({this.createdAt, this.id, this.key, this.updatedAt, this.value});

  factory Configuration.fromJson(Map<String, dynamic> json) {
    return Configuration(
      createdAt: json['created_at'] != null ? json['created_at'] : null,
      id: json['id'],
      key: json['key'],
      updatedAt: json['updated_at'] != null ? json['updated_at'] : null,
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['key'] = this.key;
    data['value'] = this.value;
    if (this.createdAt != null) {
      data['created_at'] = this.createdAt;
    }
    if (this.updatedAt != null) {
      data['updated_at'] = this.updatedAt;
    }
    return data;
  }
}
