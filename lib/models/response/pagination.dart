class Pagination {
  int? currentPage;
  int? from;
  String? nextPage;
  int? perPage;
  int? previousPage;
  int? to;
  int? totalPages;
  int? totalItems;

  Pagination({this.currentPage, this.from, this.nextPage, this.perPage, this.previousPage, this.to, this.totalPages, this.totalItems});

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['currentPage'],
      from: json['from'],
      nextPage: json['next_page'],
      perPage: json['per_page'],
      previousPage: json['previousPage'] != null ? json['previousPage'] : null,
      to: json['to'],
      totalPages: json['totalPages'],
      totalItems: json['total_items'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentPage'] = this.currentPage;
    data['from'] = this.from;
    data['next_page'] = this.nextPage;
    data['per_page'] = this.perPage;
    data['to'] = this.to;
    data['totalPages'] = this.totalPages;
    data['total_items'] = this.totalItems;
    if (this.previousPage != null) {
      data['previousPage'] = this.previousPage;
    }
    return data;
  }
}
