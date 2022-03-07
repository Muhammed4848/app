class Category {
  var categoryId;
  var subCategoryId;
  var createdAt;
  var deletedAt;
  var name;
  var status;
  var updatedAt;

  Category({this.categoryId,this.subCategoryId, this.createdAt, this.deletedAt, this.name, this.status, this.updatedAt});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['category_id'],
      subCategoryId: json['subcategory_id'],
      createdAt: json['created_at'],
      deletedAt: json['deleted_at'] != null ? json['deleted_at'] : null,
      name: json['name'],
      status: json['status'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['created_at'] = this.createdAt;
    data['name'] = this.name;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    if (this.deletedAt != null) {
      data['deleted_at'] = this.deletedAt;
    }
    return data;
  }
}
class SubCategoryResponse {
  List<Category>? data;

  SubCategoryResponse({this.data});

  factory SubCategoryResponse.fromJson(Map<String, dynamic> json) {
    return SubCategoryResponse(
      data: json['data'] != null ? (json['data'] as List).map((i) => Category.fromJson(i)).toList() : null,
    );
  }
}