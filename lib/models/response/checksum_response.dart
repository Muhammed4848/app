class CheckSumResponse {
  CheckSum? data;

  CheckSumResponse({this.data});

  factory CheckSumResponse.fromJson(Map<String, dynamic> json) {
    return CheckSumResponse(
      data: json['data'] != null ? CheckSum.fromJson(json['data']) : null,
    );
  }
}

class CheckSum {
  OrderData? order_data;
  ChecksumData? checksum_data;

  CheckSum({this.order_data, this.checksum_data});

  factory CheckSum.fromJson(Map<String, dynamic> json) {
    return CheckSum(
      order_data: json['order_data'] != null ? OrderData.fromJson(json['order_data']) : null,
      checksum_data: json['checksum_data'] != null ? ChecksumData.fromJson(json['checksum_data']) : null,
    );
  }
}

class ChecksumData {
  var cHECKSUMHASH;
  var oRDER_ID;
  var payt_STATUS;

  ChecksumData({this.cHECKSUMHASH, this.oRDER_ID, this.payt_STATUS});

  factory ChecksumData.fromJson(Map<String, dynamic> json) {
    return ChecksumData(
      cHECKSUMHASH: json['CHECKSUMHASH'],
      oRDER_ID: json['ORDER_ID'],
      payt_STATUS: json['PAYT_STATUS'],
    );
  }
}

class OrderData {
  var mID;
  var oRDER_ID;
  var cUST_ID;
  var iNDUSTRY_TYPE_ID;
  var cHANNEL_ID;
  var tXN_AMOUNT;
  var cALLBACK_URL;
  var wEBSITE;
  var eMAIL;
  var mOBILE_NO;

  OrderData({this.mID, this.oRDER_ID, this.cUST_ID, this.iNDUSTRY_TYPE_ID, this.cHANNEL_ID, this.tXN_AMOUNT, this.cALLBACK_URL, this.wEBSITE, this.eMAIL, this.mOBILE_NO});

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      mID: json['MID'],
      oRDER_ID: json['ORDER_ID'],
      cUST_ID: json['CUST_ID'],
      iNDUSTRY_TYPE_ID: json['INDUSTRY_TYPE_ID'],
      cHANNEL_ID: json['CHANNEL_ID'],
      tXN_AMOUNT: json['TXN_AMOUNT'],
      cALLBACK_URL: json['CALLBACK_URL'],
      wEBSITE: json['WEBSITE'],
      eMAIL: json['EMAIL'],
      mOBILE_NO: json['MOBILE_NO'],
    );
  }
}
