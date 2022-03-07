import 'package:granth_flutter/models/response/base_response.dart';

class WishListResponse extends BaseResponse{
    List<WishListItem>? data;

    WishListResponse({this.data});

    factory WishListResponse.fromJson(Map<String, dynamic> json) {
        return WishListResponse(
            data: json['data'] != null ? (json['data'] as List).map((i) => WishListItem.fromJson(i)).toList() : null,
        );
    }

}

class WishListItem {
    var author_name;
    var back_cover;
    var book_id;
    var category_name;
    var date_of_publication;
    var description;
    var discount;
    var discounted_price;
    var edition;
    var file_path;
    var file_sample_path;
    var format;
    var front_cover;
    var is_wishlist;
    var keywords;
    var language;
    var name;
    var price;
    var publisher;
    var subcategory_name;
    var title;
    var topic_cover;

    WishListItem({this.author_name, this.back_cover, this.book_id, this.category_name, this.date_of_publication, this.description, this.discount, this.discounted_price, this.edition, this.file_path, this.file_sample_path, this.format, this.front_cover, this.is_wishlist, this.keywords, this.language, this.name, this.price, this.publisher, this.subcategory_name, this.title, this.topic_cover});

    factory WishListItem.fromJson(Map<String, dynamic> json) {
        return WishListItem(
            author_name: json['author_name'],
            back_cover: json['back_cover'],
            book_id: json['book_id'],
            category_name: json['category_name'],
            date_of_publication: json['date_of_publication'],
            description: json['description'],
            discount: json['discount'],
            discounted_price: json['discounted_price'],
            edition: json['edition'] != null ,
            file_path: json['file_path'],
            file_sample_path: json['file_sample_path'],
            format: json['format'],
            front_cover: json['front_cover'],
            is_wishlist: json['is_wishlist'],
            keywords: json['keywords'],
            language: json['language'],
            name: json['name'],
            price: json['price'],
            publisher: json['publisher'],
            subcategory_name: json['subcategory_name'],
            title: json['title'],
            topic_cover: json['topic_cover'] != null ,
        );
    }

}