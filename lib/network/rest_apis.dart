import 'dart:async';
import 'dart:convert';

import 'package:granth_flutter/models/response/author_list.dart';
import 'package:granth_flutter/models/response/book_description.dart';
import 'package:granth_flutter/models/response/book_list.dart';
import 'package:granth_flutter/models/response/book_rating_list.dart';
import 'package:granth_flutter/models/response/category.dart';
import 'package:granth_flutter/models/response/dashboard_response.dart';
import 'package:granth_flutter/models/response/login_response.dart';
import 'package:granth_flutter/models/response/transaction_history.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/network/network_utils.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

Future doLogin(request) async {
  return await handleResponse(await buildHttpResponse('login', request: request, method: HttpMethod.POST));
}

Future register(request) async {
  return await handleResponse(await buildHttpResponse('register', request: request, method: HttpMethod.POST));
}

Future<DashboardResponse> getDashboard() async {
  return DashboardResponse.fromJson(await (handleResponse(await buildHttpResponse('dashboard-detail'))));
}

Future<DashboardResponse> getViewAllBookNextPage(type, page, {categoryId = ''}) async {
  return DashboardResponse.fromJson(await (handleResponse(await buildHttpResponse('dashboard-detail?page=$page&type=$type&category_id=$categoryId'))));
}

Future<BookListResponse> getBookList(page, aAuthorId) async {
  return BookListResponse.fromJson(await (handleResponse(await buildHttpResponse('book-list?page=$page&author_id=$aAuthorId'))));
}

Future searchBook(page, searchText) async {
  return await handleResponse(await buildHttpResponse('book-list?page=$page&search_text=$searchText'));
}

Future getCategoryWiseBookDetail(page, categoryId, subCategoryId) async {
  return await handleResponse(await buildHttpResponse('book-list?page=$page&category_id=$categoryId&subcategory_id=$subCategoryId'));
}

Future<AuthorList> getAuthorList() async {
  return AuthorList.fromJson(await (handleResponse(await buildHttpResponse('author-list'))));
}

Future addBookRating(request) async {
  return await handleResponse(await buildHttpResponse('add-book-rating', request: request, method: HttpMethod.POST));
}

Future updateBookRating(request) async {
  return await handleResponse(await buildHttpResponse('update-book-rating', request: request, method: HttpMethod.POST));
}

Future addFeedback(request) async {
  return await handleResponse(await buildHttpResponse('add-feedback', request: request, method: HttpMethod.POST));
}

Future deleteRating(request) async {
  return await handleResponse(await buildHttpResponse('delete-book-rating', request: request, method: HttpMethod.POST));
}

Future changeUserPassword(request) async {
  return await handleResponse(await buildHttpResponse('change-password', request: request, method: HttpMethod.POST));
}

Future sendForgotPasswordRequest(request) async {
  return await handleResponse(await buildHttpResponse('forgot-password', request: request, method: HttpMethod.POST));
}

Future categoryList() async {
  return await handleResponse(await buildHttpResponse('category-list'));
}

Future<BookRatingList> getReview(request) async {
  return BookRatingList.fromJson(await (handleResponse(await buildHttpResponse('book-rating-list', request: request, method: HttpMethod.POST))));
}

Future addFavourite(request) async {
  return await handleResponse(await buildHttpResponse('add-remove-wishlist-book', request: request, method: HttpMethod.POST));
}

Future addSellWithUs(request) async {
  return await handleResponse(await buildHttpResponse('sell-with-us', request: request, method: HttpMethod.POST));
}

Future addToCart(request) async {
  return await handleResponse(await buildHttpResponse('add-to-cart', request: request, method: HttpMethod.POST));
}

Future removeFromCart(request) async {
  return await handleResponse(await buildHttpResponse('remove-from-cart', request: request, method: HttpMethod.POST));
}

Future getCart() async {
  return await handleResponse(await buildHttpResponse('user-cart'));
}

Future getBookmarks() async {
  return await handleResponse(await buildHttpResponse('user-wishlist-book'));
}

Future<BookDescription> getBookDetail(request) async {
  return BookDescription.fromJson(await (handleResponse(await buildHttpResponse('book-detail', request: request, method: HttpMethod.POST))));
}

Future<TransactionHistory> transactionHistory() async {
  return TransactionHistory.fromJson(await (handleResponse(await buildHttpResponse('get-transaction-history'))));
}

Future purchasedBookList() async {
  return await handleResponse(await buildHttpResponse('user-purchase-book'));
}

Future requestCallBack(request) async {
  return await handleResponse(await buildHttpResponse('save-callrequest', request: request, method: HttpMethod.POST));
}

Future<SubCategoryResponse> subCategories(request) async {
  return SubCategoryResponse.fromJson(await (handleResponse(await buildHttpResponse('sub-category-list', request: request, method: HttpMethod.POST))));
}

Future getNotificationList(request) async {
  return await handleResponse(await buildHttpResponse('notification-history', request: request, method: HttpMethod.POST));
}

Future readNotification(request) async {
  return await handleResponse(await buildHttpResponse('read-notification', request: request, method: HttpMethod.POST));
}

Future logout() async {
  return await handleResponse(await buildHttpResponse('logout', request: null, method: HttpMethod.POST));
}

Future updateUser(userDetail, mSelectedImage) async {
  var request = http.MultipartRequest("POST", Uri.parse('${mBaseUrl}save-user-profile'));
  request.fields['user_detail'] = jsonEncode(userDetail);

  if (mSelectedImage != null) {
    final file = await http.MultipartFile.fromPath('image', mSelectedImage.path);
    request.files.add(file);
  }
  request.headers.addAll(buildHeaderTokens());
  await request.send().then((response) async {
    response.stream.transform(utf8.decoder).listen((value) async {
      LoginResponse loginResponse = LoginResponse.fromJson(jsonDecode(value));

      if (loginResponse.status!) {
        LoginData data = loginResponse.data!;

        await setValue(USERNAME, data.userName);
        await setValue(NAME, data.name);
        await setValue(USER_EMAIL, data.email);
        await setValue(USER_PROFILE, data.image);
        await setValue(USER_CONTACT_NO, data.contactNumber);
      }
      toast(loginResponse.message);
    });
  }).catchError((error) {
    print(error.toString());
    toast(error);
  });
}

Future getChecksum(request) async {
  return await handleResponse(await buildHttpResponse('generate-check-sum', request: request, method: HttpMethod.POST));
}

Future saveTransaction(Map<String, String?> transactionDetails, orderDetails, type, status) async {
  print('transaction_detail ' + jsonEncode(transactionDetails));
  print('order_detail ' + jsonEncode(orderDetails));
  print('type ' + type.toString());
  print('status ' + status.toString());

  var request = http.MultipartRequest("POST", Uri.parse('${mBaseUrl}save-transaction'));
  request.fields['transaction_detail'] = jsonEncode(transactionDetails);
  request.fields['order_detail'] = jsonEncode(orderDetails);
  request.fields['type'] = type.toString();
  request.fields['status'] = status.toString();
  request.headers.addAll(buildHeaderTokens());

  log("request.fields ${request.fields}");
  await request.send().then((res) {
    print(res.statusCode);
    if (transactionDetails['STATUS'] == "TXN_SUCCESS") {
      toast("Transaction Successfully.");
    } else {
      toast("Transaction Failed.");
    }
    LiveStream().emit(CART_ITEM_CHANGED, true);
    return res;
  }).catchError((error) {
    throw error;
  });
}

Future verifyToken(request) async {
  return await handleResponse(await buildHttpResponse('verify-token', request: request, method: HttpMethod.POST));
}

Future resendOtp(request) async {
  return await handleResponse(await buildHttpResponse('resend-otp', request: request, method: HttpMethod.POST));
}

Future updatePassword(request) async {
  return await handleResponse(await buildHttpResponse('update-password', request: request, method: HttpMethod.POST));
}

Future generateClientToken() async {
  return await handleResponse(await buildHttpResponse('generate-client-token'));
}

Future savePayPalTransaction(request) async {
  return await handleResponse(await buildHttpResponse('braintree-payment-process', request: request, method: HttpMethod.POST));
}
