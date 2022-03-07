class BookRating {
  var bookId;
  var userId;
  var updatedAt;
  var createdAt;
  var profileImage;
  var rating;
  var ratingId;
  var review;
  var userName;
  var isCollapsed = true;

  BookRating({this.bookId, this.userId, this.updatedAt, this.createdAt, this.profileImage, this.rating, this.ratingId, this.review, this.userName});

  factory BookRating.fromJson(Map<String, dynamic> json) {
    return BookRating(
      bookId: json['book_id'] != null ? json['book_id'] : null,
      userId: json['user_id'] != null ? json['user_id'] : null,
      updatedAt: json['updated_at'] != null ? json['updated_at'] : null,
      createdAt: json['created_at'],
      profileImage: json['profile_image'],
      rating: json['rating'],
      ratingId: json['rating_id'],
      review: json['review'],
      userName: json['user_name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['profile_image'] = this.profileImage;
    data['rating'] = this.rating;
    data['rating_id'] = this.ratingId;
    data['review'] = this.review;
    data['user_name'] = this.userName;
    return data;
  }
}
