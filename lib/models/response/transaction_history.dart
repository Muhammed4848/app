import 'dart:convert';

class TransactionHistory {
  List<Transaction>? transcationData;

  TransactionHistory({this.transcationData});

  factory TransactionHistory.fromJson(Map<String, dynamic> json) {
    return TransactionHistory(
      transcationData: json['data'] != null ? (json['data'] as List).map((i) => Transaction.fromJson(i)).toList() : null,
    );
  }
}

/*class Transaction {
  int bookId;
  String bookName;
  String bookTitle;
  String front_cover;
  double cgst;
  double igst;
  int isHardCopy;
  String otherTransactionDetail;
  String paymentStatus;
  int quantity;
  double sgst;
  double shippingCost;
  double totalAmount;
  String txnId;
  int userId;

  Transaction(
      {this.bookId,
      this.bookName,
      this.bookTitle,
      this.cgst,
      this.igst,
      this.isHardCopy,
      this.otherTransactionDetail,
      this.paymentStatus,
      this.quantity,
      this.sgst,
      this.shippingCost,
      this.totalAmount,
      this.txnId,
      this.userId,this.front_cover});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      bookId: json['book_id'],
      bookName: json['book_name'],
      bookTitle: json['book_title'],
      cgst: json['cgst'],
      igst: json['igst'],
      isHardCopy: json['is_hard_copy'],
      otherTransactionDetail: json['other_transaction_detail'],
      paymentStatus: json['payment_status'],
      quantity: json['quantity'],
      sgst: json['sgst'],
      shippingCost: json['shipping_cost'],
      totalAmount: json['total_amount'],
      txnId: json['txn_id'],
      userId: json['user_id'],
      front_cover: json['front_cover'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['book_id'] = this.bookId;
    data['book_name'] = this.bookName;
    data['book_title'] = this.bookTitle;
    data['cgst'] = this.cgst;
    data['igst'] = this.igst;
    data['is_hard_copy'] = this.isHardCopy;
    data['other_transaction_detail'] = this.otherTransactionDetail;
    data['payment_status'] = this.paymentStatus;
    data['quantity'] = this.quantity;
    data['sgst'] = this.sgst;
    data['shipping_cost'] = this.shippingCost;
    data['total_amount'] = this.totalAmount;
    data['txn_id'] = this.txnId;
    data['user_id'] = this.userId;
    return data;
  }
}


*/

class Transaction {
  var book_id;
  var bookName;
  var book_title;
  var front_cover;
  var price;
  var discount;
  var total_amount;
  var payment_type;
  var txn_id;
  var payment_status;
  OtherDetail? other_transaction_detail;

  Transaction({this.book_id, this.bookName, this.book_title, this.front_cover, this.price, this.discount, this.total_amount, this.payment_type, this.txn_id, this.payment_status, this.other_transaction_detail});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      book_id: json['book_id'],
      bookName: json['book_name'],
      book_title: json['book_title'],
      front_cover: json['front_cover'] != null ? json['front_cover'] : null,
      price: json['price'],
      discount: json['discount'],
      total_amount: json['total_amount'],
      payment_type: json['payment_type'],
      txn_id: json['txn_id'],
      payment_status: json['payment_status'],
      other_transaction_detail: json['other_transaction_detail'] != null ? OtherDetail.fromJson(jsonDecode(json['other_transaction_detail'])) : null,
    );
  }
}

class OtherDetail {
  String? bANKNAME;
  String? TXN_ORDER_ID;
  String? tXNAMOUNT;
  String? tXNDATE;
  String? mID;
  String? TXNID;
  String? pAYMENTMODE;
  String? cURRENCY;
  String? bANKTXNID;
  String? gATEWAYNAME;
  String? rESPMSG;
  String? sTATUS;
  String? TXN_PAYMENT_ID;

  OtherDetail({this.bANKNAME, this.TXN_ORDER_ID, this.tXNAMOUNT, this.tXNDATE, this.mID, this.TXNID, this.pAYMENTMODE, this.cURRENCY, this.bANKTXNID, this.gATEWAYNAME, this.rESPMSG, this.sTATUS, this.TXN_PAYMENT_ID});

  factory OtherDetail.fromJson(Map<String, dynamic> json) {
    return OtherDetail(
      bANKNAME: json['BANKNAME'],
      TXN_ORDER_ID: json['TXN_ORDER_ID'],
      tXNAMOUNT: json['TXNAMOUNT'],
      tXNDATE: json['TXNDATE'],
      mID: json['MID'],
      TXNID: json['TXNID'],
      pAYMENTMODE: json['PAYMENTMODE'],
      cURRENCY: json['CURRENCY'],
      bANKTXNID: json['BANKTXNID'],
      gATEWAYNAME: json['GATEWAYNAME'],
      rESPMSG: json['RESPMSG'],
      sTATUS: json['STATUS'],
      TXN_PAYMENT_ID: json['TXN_PAYMENT_ID'],
    );
  }
}
