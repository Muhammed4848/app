class CartResponse {
  List<CartItem>? data;

  CartResponse({this.data});

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      data: json['data'] != null ? (json['data'] as List).map((i) => CartItem.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartItem {
  var addedQty;
  var author_name;
  var book_id;
  var cart_mapping_id;
  var cash_on_delivery;
  var cgst;
  var discount;
  var front_cover;
  var igst;
  var in_stock;
  var inventory_id;
  var name;
  var price;
  var sgst;
  var shipping_cost;
  var title;
  var user_id;

  CartItem(
      {this.addedQty,
      this.author_name,
      this.book_id,
      this.cart_mapping_id,
      this.cash_on_delivery,
      this.cgst,
      this.discount,
      this.front_cover,
      this.igst,
      this.in_stock,
      this.inventory_id,
      this.name,
      this.price,
      this.sgst,
      this.shipping_cost,
      this.title,
      this.user_id});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      addedQty: json['added_qty'],
      author_name: json['author_name'],
      book_id: json['book_id'],
      cart_mapping_id: json['cart_mapping_id'],
      cash_on_delivery: json['cash_on_delivery'],
      cgst: json['cgst'],
      discount: json['discount'],
      front_cover: json['front_cover'],
      igst: json['igst'],
      in_stock: json['in_stock'],
      inventory_id: json['inventory_id'],
      name: json['name'],
      price: json['price'],
      sgst: json['sgst'],
      shipping_cost: json['shipping_cost'],
      title: json['title'],
      user_id: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['added_qty'] = this.addedQty;
    data['author_name'] = this.author_name;
    data['book_id'] = this.book_id;
    data['cart_mapping_id'] = this.cart_mapping_id;
    data['cash_on_delivery'] = this.cash_on_delivery;
    data['cgst'] = this.cgst;
    data['discount'] = this.discount;
    data['front_cover'] = this.front_cover;
    data['igst'] = this.igst;
    data['in_stock'] = this.in_stock;
    data['inventory_id'] = this.inventory_id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['sgst'] = this.sgst;
    data['shipping_cost'] = this.shipping_cost;
    data['title'] = this.title;
    data['user_id'] = this.user_id;
    return data;
  }
}
