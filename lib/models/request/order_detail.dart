class OrderDetail {
    var book_id;
    var cash_on_delivery;
    var discount;
    var gstnumber;
    var is_hard_copy;
    OtherDetail? other_detail;
    var payment_type;
    var quantity;
    var shipping_cost;
    var total_amount;
    var price;
    var user_id;

    OrderDetail({this.book_id, this.cash_on_delivery, this.discount, this.gstnumber, this.is_hard_copy, this.other_detail, this.payment_type, this.quantity, this.shipping_cost, this.total_amount, this.price, this.user_id});

    factory OrderDetail.fromJson(Map<String, dynamic> json) {
        return OrderDetail(
            book_id: json['book_id'], 
            cash_on_delivery: json['cash_on_delivery'], 
            discount: json['discount'], 
            gstnumber: json['gstnumber'], 
            is_hard_copy: json['is_hard_copy'], 
            other_detail: json['other_detail'] != null ? OtherDetail.fromJson(json['other_detail']) : null, 
            payment_type: json['payment_type'], 
            quantity: json['quantity'], 
            shipping_cost: json['shipping_cost'], 
            total_amount: json['total_amount'], 
            price: json['price'], 
            user_id: json['user_id'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['book_id'] = this.book_id;
        data['cash_on_delivery'] = this.cash_on_delivery;
        data['discount'] = this.discount;
        data['gstnumber'] = this.gstnumber;
        data['is_hard_copy'] = this.is_hard_copy;
        data['payment_type'] = this.payment_type;
        data['quantity'] = this.quantity;
        data['shipping_cost'] = this.shipping_cost;
        data['total_amount'] = this.total_amount;
        data['price'] = this.price;
        data['user_id'] = this.user_id;
        if (this.other_detail != null) {
            data['other_detail'] = this.other_detail!.toJson();
        }
        return data;
    }
}

class OtherDetail {
    List<BookData>? data;

    OtherDetail({this.data});

    factory OtherDetail.fromJson(Map<String, dynamic> json) {
        return OtherDetail(
            data: json['data'] != null ? (json['data'] as List).map((i) => BookData.fromJson(i)).toList() : null,
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

class BookData {
    var book_id;
    var discount;
    var price;

    BookData({this.book_id, this.discount,this.price});

    factory BookData.fromJson(Map<String, dynamic> json) {
        return BookData(
            book_id: json['book_id'], 
            discount: json['discount'], 
            price: json['price'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['book_id'] = this.book_id;
        data['discount'] = this.discount;
        data['price'] = this.price;
        return data;
    }
}