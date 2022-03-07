class ClientTokenResponse {
    String? data;
    String? message;
    bool? status;

    ClientTokenResponse({this.data, this.message, this.status});

    factory ClientTokenResponse.fromJson(Map<String, dynamic> json) {
        return ClientTokenResponse(
            data: json['data'],
            message: json['message'],
            status: json['status'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['data'] = this.data;
        data['message'] = this.message;
        data['status'] = this.status;
        return data;
    }
}
class CreateTransactionResponse {
    bool? status;
    String? message;
    Data? data;

    CreateTransactionResponse({this.status, this.message, this.data});

    factory CreateTransactionResponse.fromJson(Map<String, dynamic> json) {
        return CreateTransactionResponse(
            status: json['status'],
            message: json['message'],
            data: json['data'] != null ? Data.fromJson(json['data']) : null,
        );
    }


}

class Data {
    List<Object>? errors;
    Params? params;
    var message;
    var creditCardVerification;
    var transaction;
    var subscription;
    var merchantAccount;
    var verification;

    Data({this.errors, this.params, this.message, this.creditCardVerification, this.transaction, this.subscription, this.merchantAccount, this.verification});

    factory Data.fromJson(Map<String, dynamic> json) {
        return Data(
            errors: json['errors'] != null ? (json['errors'] as List).map((i) => i).toList() as List<Object>? : null,
            params: json['params'] != null ? Params.fromJson(json['params']) : null,
            message: json['message'],
            creditCardVerification: json['creditCardVerification'] ,
            transaction: json['transaction'] !=null?Transaction.fromJson(json['transaction']):null,
            subscription: json['subscription'] ,
            merchantAccount: json['merchantAccount'] ,
            verification: json['verification'],
        );
    }
    
}

class Params {
    Transaction? transaction;

    Params({this.transaction});

    factory Params.fromJson(Map<String, dynamic> json) {
        return Params(
            transaction: json['transaction'] != null ? Transaction.fromJson(json['transaction']) : null,
        );
    }


}
class PaymentNounceResponse {
    String? message;
    String? status;
    String? paymentNonce;

    PaymentNounceResponse({this.message, this.status, this.paymentNonce});

    factory PaymentNounceResponse.fromJson(Map<String, dynamic> json) {
        return PaymentNounceResponse(
            message: json['message'], 
            status: json['status'], 
            paymentNonce: json['paymentNonce'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['message'] = this.message;
        data['status'] = this.status;
        data['paymentNonce'] = this.paymentNonce;
        return data;
    }
}
/*

class Transaction {
    String type;
    String amount;
    String paymentMethodNonce;
    Options options;

    Transaction({this.type, this.amount, this.paymentMethodNonce, this.options});

    factory Transaction.fromJson(Map<String, dynamic> json) {
        return Transaction(
            type: json['type'],
            amount: json['amount'],
            paymentMethodNonce: json['paymentMethodNonce'],
            options: json['options'] != null ? Options.fromJson(json['options']) : null,
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['type'] = this.type;
        data['amount'] = this.amount;
        data['paymentMethodNonce'] = this.paymentMethodNonce;
        if (this.options != null) {
            data['options'] = this.options.toJson();
        }
        return data;
    }
}
*/

class Options {
    String? submitForSettlement;

    Options({this.submitForSettlement});

    factory Options.fromJson(Map<String, dynamic> json) {
        return Options(
            submitForSettlement: json['submitForSettlement'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['submitForSettlement'] = this.submitForSettlement;
        return data;
    }
}
class Transaction {
    String? id;
    String? status;
    String? type;
    String? currencyIsoCode;
    String? amount;
    String? merchantAccountId;
    var subMerchantAccountId;
    var masterMerchantAccountId;
    var orderId;
    UpdatedAt? createdAt;
    UpdatedAt? updatedAt;
    Billing? billing;
    var refundId;
    List<Object>? refundIds;
    var refundedTransactionId;
    List<Object>? partialSettlementTransactionIds;
    var authorizedTransactionId;
    String? settlementBatchId;
    var customFields;
    var avsErrorResponseCode;
    String? avsPostalCodeResponseCode;
    String? avsStreetAddressResponseCode;
    String? cvvResponseCode;
    var gatewayRejectionReason;
    var processorAuthorizationCode;
    String? processorResponseCode;
    String? processorResponseText;
    var additionalProcessorResponse;
    var voiceReferralNumber;
    var purchaseOrderNumber;
    var taxAmount;
    bool? taxExempt;
    CreditCard? creditCard;
    Paypal? paypal;
    List<Object>? statusHistory;
    var planId;
    var subscriptionId;
    Subscription? subscription;
    List<Object>? addOns;
    List<Object>? discounts;
    bool? recurring;
    var channel;
    var serviceFeeAmount;
    var escrowStatus;
    List<Object>? disputes;
    List<Object>? authorizationAdjustments;
    String? paymentInstrumentType;
    String? processorSettlementResponseCode;
    String? processorSettlementResponseText;
    var networkResponseCode;
    var networkResponseText;
    var threeDSecureInfo;
    var shipsFromPostalCode;
    var shippingAmount;
    var discountAmount;
    var networkTransactionId;
    String? processorResponseType;
    UpdatedAt? authorizationExpiresAt;
    List<Object>? refundGlobalIds;
    List<Object>? partialSettlementTransactionGlobalIds;
    var refundedTransactionGlobalId;
    var authorizedTransactionGlobalId;
    String? globalId;
    List<Object>? retryIds;
    var retriedTransactionId;
    var retrievalReferenceNumber;

    Transaction({this.id, this.status, this.type, this.currencyIsoCode, this.amount, this.merchantAccountId, this.subMerchantAccountId, this.masterMerchantAccountId, this.orderId, this.createdAt, this.updatedAt,  this.billing, this.refundId, this.refundIds, this.refundedTransactionId, this.partialSettlementTransactionIds, this.authorizedTransactionId, this.settlementBatchId, this.customFields, this.avsErrorResponseCode, this.avsPostalCodeResponseCode, this.avsStreetAddressResponseCode,
      this.cvvResponseCode, this.gatewayRejectionReason, this.processorAuthorizationCode, this.processorResponseCode, this.processorResponseText, this.additionalProcessorResponse, this.voiceReferralNumber, this.purchaseOrderNumber, this.taxAmount, this.taxExempt, this.creditCard, this.paypal, this.statusHistory, this.planId, this.subscriptionId, this.subscription, this.addOns, this.discounts,
      this.recurring, this.channel, this.serviceFeeAmount, this.escrowStatus,
      this.disputes, this.authorizationAdjustments, this.paymentInstrumentType,
      this.processorSettlementResponseCode, this.processorSettlementResponseText,
      this.networkResponseCode, this.networkResponseText, this.threeDSecureInfo,
      this.shipsFromPostalCode, this.shippingAmount, this.discountAmount,
      this.networkTransactionId, this.processorResponseType,
      this.authorizationExpiresAt, this.refundGlobalIds,
      this.partialSettlementTransactionGlobalIds, this.refundedTransactionGlobalId,
      this.authorizedTransactionGlobalId, this.globalId, this.retryIds, this.retriedTransactionId, this.retrievalReferenceNumber});

    factory Transaction.fromJson(Map<String, dynamic> json) {
        return Transaction(
            id: json['id'], 
            status: json['status'], 
            type: json['type'], 
            currencyIsoCode: json['currencyIsoCode'], 
            amount: json['amount'], 
            merchantAccountId: json['merchantAccountId'], 
            subMerchantAccountId: json['subMerchantAccountId'] ,
            masterMerchantAccountId: json['masterMerchantAccountId'] ,
            orderId: json['orderId'] != null ,
            createdAt: json['createdAt'] != null ? UpdatedAt.fromJson(json['createdAt']) : null,
            updatedAt: json['updatedAt'] != null ? UpdatedAt.fromJson(json['updatedAt']) : null, 
            billing: json['billing'] != null ? Billing.fromJson(json['billing']) : null,
            refundId: json['refundId'],
            refundIds: json['refundIds'] != null ? (json['refundIds'] as List).map((i) =>i).toList() as List<Object>? : null,
            refundedTransactionId: json['refundedTransactionId'] ,
            partialSettlementTransactionIds: json['partialSettlementTransactionIds'] != null ? (json['partialSettlementTransactionIds'] as List).map((i) => i).toList() as List<Object>? : null,
            authorizedTransactionId: json['authorizedTransactionId'] ,
            settlementBatchId: json['settlementBatchId'], 
            customFields: json['customFields'] ,
            avsErrorResponseCode: json['avsErrorResponseCode'] ,
            avsPostalCodeResponseCode: json['avsPostalCodeResponseCode'], 
            avsStreetAddressResponseCode: json['avsStreetAddressResponseCode'], 
            cvvResponseCode: json['cvvResponseCode'], 
            gatewayRejectionReason: json['gatewayRejectionReason'] ,
            processorAuthorizationCode: json['processorAuthorizationCode'],
            processorResponseCode: json['processorResponseCode'], 
            processorResponseText: json['processorResponseText'], 
            additionalProcessorResponse: json['additionalProcessorResponse'] ,
            voiceReferralNumber: json['voiceReferralNumber'] ,
            purchaseOrderNumber: json['purchaseOrderNumber'] ,
            taxAmount: json['taxAmount'] ,
            taxExempt: json['taxExempt'], 
            creditCard: json['creditCard'] != null ? CreditCard.fromJson(json['creditCard']) : null, 
            paypal: json['paypal'] != null ? Paypal.fromJson(json['paypal']) : null, 
            statusHistory: json['statusHistory'] != null ? (json['statusHistory'] as List).map((i) =>i).toList() as List<Object>? : null,
            planId: json['planId'] ,
            subscriptionId: json['subscriptionId'] ,
            subscription: json['subscription'] != null ? Subscription.fromJson(json['subscription']) : null, 
            addOns: json['addOns'],
            discounts: json['discounts'],
            recurring: json['recurring'],
            channel: json['channel'] ,
            serviceFeeAmount: json['serviceFeeAmount'] ,
            escrowStatus: json['escrowStatus'] ,
            disputes: json['disputes'] != null ? (json['disputes'] as List).map((i) => i).toList() as List<Object>? : null,
            authorizationAdjustments: json['authorizationAdjustments'] != null ? (json['authorizationAdjustments'] as List).map((i) => i).toList() as List<Object>? : null,
            paymentInstrumentType: json['paymentInstrumentType'], 
            processorSettlementResponseCode: json['processorSettlementResponseCode'], 
            processorSettlementResponseText: json['processorSettlementResponseText'], 
            networkResponseCode: json['networkResponseCode'] ,
            networkResponseText: json['networkResponseText'] ,
            threeDSecureInfo: json['threeDSecureInfo'] ,
            shipsFromPostalCode: json['shipsFromPostalCode'] ,
            shippingAmount: json['shippingAmount'] ,
            discountAmount: json['discountAmount'],
            networkTransactionId: json['networkTransactionId'] ,
            processorResponseType: json['processorResponseType'], 
            authorizationExpiresAt: json['authorizationExpiresAt'] != null ? UpdatedAt.fromJson(json['authorizationExpiresAt']) : null,
            refundGlobalIds: json['refundGlobalIds'] != null ? (json['refundGlobalIds'] as List).map((i) => i).toList() as List<Object>? : null,
            partialSettlementTransactionGlobalIds: json['partialSettlementTransactionGlobalIds'] != null ? (json['partialSettlementTransactionGlobalIds'] as List).map((i) => i).toList() as List<Object>? : null,
            refundedTransactionGlobalId: json['refundedTransactionGlobalId'] ,
            authorizedTransactionGlobalId: json['authorizedTransactionGlobalId'] ,
            globalId: json['globalId'], 
            retryIds: json['retryIds'] != null ? (json['retryIds'] as List).map((i) => i).toList() as List<Object>? : null,
            retriedTransactionId: json['retriedTransactionId'],
            retrievalReferenceNumber: json['retrievalReferenceNumber'],
        );
    }

}


class Subscription {
    var billingPeriodEndDate;
    var billingPeriodStartDate;

    Subscription({this.billingPeriodEndDate, this.billingPeriodStartDate});

    factory Subscription.fromJson(Map<String, dynamic> json) {
        return Subscription(
            billingPeriodEndDate: json['billingPeriodEndDate'] ,
            billingPeriodStartDate: json['billingPeriodStartDate'] ,
        );
    }


}

class Billing {
    var id;
    var firstName;
    var lastName;
    var company;
    var streetAddress;
    var extendedAddress;
    var locality;
    var region;
    var postalCode;
    var countryName;
    var countryCodeAlpha2;
    var countryCodeAlpha3;
    var countryCodeNumeric;

    Billing({this.id, this.firstName, this.lastName, this.company, this.streetAddress, this.extendedAddress, this.locality, this.region, this.postalCode, this.countryName, this.countryCodeAlpha2, this.countryCodeAlpha3, this.countryCodeNumeric});

    factory Billing.fromJson(Map<String, dynamic> json) {
        return Billing(
            id: json['id'] ,
            firstName: json['firstName'] ,
            lastName: json['lastName'] ,
            company: json['company'] ,
            streetAddress: json['streetAddress'] ,
            extendedAddress: json['extendedAddress'] ,
            locality: json['locality'] ,
            region: json['region'] ,
            postalCode: json['postalCode'] ,
            countryName: json['countryName'] ,
            countryCodeAlpha2: json['countryCodeAlpha2'] ,
            countryCodeAlpha3: json['countryCodeAlpha3'] ,
            countryCodeNumeric: json['countryCodeNumeric'] ,
        );
    }

}




class Paypal {
    var token;
    var payerEmail;
    var paymentId;
    var authorizationId;
    var imageUrl;
    var debugId;
    var payeeId;
    var payeeEmail;
    var customField;
    var payerId;
    var payerFirstName;
    var payerLastName;
    var payerStatus;
    var sellerProtectionStatus;
    var captureId;
    var refundId;
    var transactionFeeAmount;
    var transactionFeeCurrencyIsoCode;
    var refundFromTransactionFeeAmount;
    var refundFromTransactionFeeCurrencyIsoCode;
    var description;
    var shippingOptionId;
    var globalId;
    var cobrandedCardLabel;

    Paypal({this.token, this.payerEmail, this.paymentId, this.authorizationId, this.imageUrl, this.debugId, this.payeeId, this.payeeEmail, this.customField, this.payerId, this.payerFirstName, this.payerLastName, this.payerStatus, this.sellerProtectionStatus, this.captureId, this.refundId, this.transactionFeeAmount, this.transactionFeeCurrencyIsoCode, this.refundFromTransactionFeeAmount, this.refundFromTransactionFeeCurrencyIsoCode, this.description, this.shippingOptionId, this.globalId, this.cobrandedCardLabel});

    factory Paypal.fromJson(Map<String, dynamic> json) {
        return Paypal(
            token: json['token'] ,
            payerEmail: json['payerEmail'], 
            paymentId: json['paymentId'], 
            authorizationId: json['authorizationId'], 
            imageUrl: json['imageUrl'], 
            debugId: json['debugId'], 
            payeeId: json['payeeId'] ,
            payeeEmail: json['payeeEmail'] ,
            customField: json['customField'] ,
            payerId: json['payerId'], 
            payerFirstName: json['payerFirstName'], 
            payerLastName: json['payerLastName'], 
            payerStatus: json['payerStatus'], 
            sellerProtectionStatus: json['sellerProtectionStatus'], 
            captureId: json['captureId'], 
            refundId: json['refundId'] ,
            transactionFeeAmount: json['transactionFeeAmount'], 
            transactionFeeCurrencyIsoCode: json['transactionFeeCurrencyIsoCode'], 
            refundFromTransactionFeeAmount: json['refundFromTransactionFeeAmount'],
            refundFromTransactionFeeCurrencyIsoCode: json['refundFromTransactionFeeCurrencyIsoCode'] ,
            description: json['description'] ,
            shippingOptionId: json['shippingOptionId'],
            globalId: json['globalId'] ,
            cobrandedCardLabel: json['cobrandedCardLabel'] ,
        );
    }

}

class UpdatedAt {
    String? date;
    int? timezone_type;
    String? timezone;

    UpdatedAt({this.date, this.timezone_type, this.timezone});

    factory UpdatedAt.fromJson(Map<String, dynamic> json) {
        return UpdatedAt(
            date: json['date'], 
            timezone_type: json['timezone_type'], 
            timezone: json['timezone'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['date'] = this.date;
        data['timezone_type'] = this.timezone_type;
        data['timezone'] = this.timezone;
        return data;
    }
}


class CreditCard {
    var token;
    var bin;
    var last4;
    var cardType;
    var expirationMonth;
    var expirationYear;
    var customerLocation;
    var cardholderName;
    var imageUrl;
    var prepaid;
    var healthcare;
    var debit;
    var durbinRegulated;
    var commercial;
    var payroll;
    var issuingBank;
    var countryOfIssuance;
    var productId;
    var globalId;
    var accountType;
    var uniqueNumberIdentifier;
    bool? venmoSdk;

    CreditCard({this.token, this.bin, this.last4, this.cardType, this.expirationMonth, this.expirationYear, this.customerLocation, this.cardholderName, this.imageUrl, this.prepaid, this.healthcare, this.debit, this.durbinRegulated, this.commercial, this.payroll, this.issuingBank, this.countryOfIssuance, this.productId, this.globalId, this.accountType, this.uniqueNumberIdentifier, this.venmoSdk});

    factory CreditCard.fromJson(Map<String, dynamic> json) {
        return CreditCard(
            token: json['token'] ,
            bin: json['bin'] ,
            last4: json['last4'],
            cardType: json['cardType'] ,
            expirationMonth: json['expirationMonth'] ,
            expirationYear: json['expirationYear'],
            customerLocation: json['customerLocation'],
            cardholderName: json['cardholderName'] ,
            imageUrl: json['imageUrl'], 
            prepaid: json['prepaid'], 
            healthcare: json['healthcare'], 
            debit: json['debit'], 
            durbinRegulated: json['durbinRegulated'], 
            commercial: json['commercial'], 
            payroll: json['payroll'], 
            issuingBank: json['issuingBank'], 
            countryOfIssuance: json['countryOfIssuance'], 
            productId: json['productId'], 
            globalId: json['globalId'] ,
            accountType: json['accountType'] ,
            uniqueNumberIdentifier: json['uniqueNumberIdentifier'] ,
            venmoSdk: json['venmoSdk'], 
        );
    }

}
