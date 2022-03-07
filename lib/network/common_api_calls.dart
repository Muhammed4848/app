import 'dart:convert';

import 'package:granth_flutter/models/response/base_response.dart';
import 'package:granth_flutter/models/response/cart_response.dart';
import 'package:granth_flutter/models/response/login_response.dart';
import 'package:granth_flutter/models/response/wishlist_response.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/screens/home_screen.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../app_localizations.dart';

addRemoveWishList(context, var id, var isWishList) async {
  toast('processing');
  await isNetworkAvailable().then((bool) {
    if (bool) {
      var request = {"book_id": id, "is_wishlist": isWishList};
      addFavourite(request).then((result) {
        BaseResponse response = BaseResponse.fromJson(result);
        if (response.status) {
          LiveStream().emit(WISH_DATA_ITEM_CHANGED, true);
        }
      }).catchError((error) {
        toast(error.toString());
      });
    } else {
      toast(keyString(context, "error_network_no_internet"));
    }
  });
}

removeBookFromCart(context, CartItem cartItem, {addToWishList = false}) async {
  toast('processing');
  await isNetworkAvailable().then((bool) {
    if (bool) {
      var request = {
        "id": cartItem.cart_mapping_id,
      };
      removeFromCart(request).then((result) {
        BaseResponse response = BaseResponse.fromJson(result);
        if (response.status) {
          LiveStream().emit(CART_ITEM_CHANGED, true);
          if (addToWishList) {
            addRemoveWishList(context, cartItem.book_id, "1");
          }
        }
      }).catchError((error) {
        toast(error.toString());
      });
    } else {
      toast(keyString(context, "error_network_no_internet"));
    }
  });
}

fetchCartData(context) async {
  isNetworkAvailable().then((bool) {
    if (bool) {
      getCart().then((result) async {
        print(result);
        CartResponse response = CartResponse.fromJson(result);
        await setValue(CART_DATA, jsonEncode(result));
        await setValue(CART_COUNT, response.data!.length);
        LiveStream().emit(CART_COUNT_ACTION, response.data!.length);
        LiveStream().emit(CART_DATA_CHANGED, response.data);
      }).catchError((error) {
        print(error);
        toast(error.toString());
      });
    } else {
      toast(keyString(context, "error_network_no_internet"));
    }
  });
}

Future<void> fetchWishListData(context) async {
  isNetworkAvailable().then((bool) {
    if (bool) {
      getBookmarks().then((result) async {
        print(result);
        WishListResponse response = WishListResponse.fromJson(result);
        await setValue(WISH_LIST_DATA, jsonEncode(result));
        await setValue(WISH_LIST_COUNT_CHANGED, response.data!.length);
        print("wishllist count" + response.data!.length.toString());
        LiveStream().emit(WISH_LIST_COUNT_CHANGED, response.data!.length);
        LiveStream().emit(WISH_LIST_DATA_CHANGED, response.data);
        return response;
      }).catchError((error) {
        print(error);

        toast(error.toString());
      });
    } else {
      toast(keyString(context, "error_network_no_internet"));
    }
  });
}

doLogout(context) async {
  await isNetworkAvailable().then((bool) {
    if (bool) {
      logout().then((result) async {
        await removeKey(TOKEN);
        await removeKey(USERNAME);
        await removeKey(NAME);
        await removeKey(LAST_NAME);
        await removeKey(USER_DISPLAY_NAME);
        await removeKey(USER_ID);
        await removeKey(USER_EMAIL);
        await removeKey(USER_PROFILE);
        await removeKey(USER_CONTACT_NO);
        await removeKey(CART_DATA);
        await removeKey(CART_COUNT);
        await removeKey(WISH_LIST_DATA);
        await removeKey(WISH_LIST_COUNT);
        await removeKey(LIBRARY_DATA);

        await setValue(IS_LOGGED_IN, false);
        HomeScreen().launch(context);
      }).catchError((error) {
        toast(error.toString());
      });
    } else {
      toast(keyString(context, "error_network_no_internet"));
    }
  });
}

saveUserData(LoginData data) async {
  await setValue(IS_LOGGED_IN, true);
  await setValue(TOKEN, data.apiToken);
  await setValue(USERNAME, data.userName);
  await setValue(NAME, data.name);
  await setValue(USER_EMAIL, data.email);
  await setValue(USER_PROFILE, data.image);
  await setValue(USER_CONTACT_NO, data.contactNumber);
  await setValue(USER_ID, data.id);
}

onReadNotification(var notificationId) {
  isNetworkAvailable().then((bool) {
    if (bool) {
      var request = {"notification_id": notificationId};
      readNotification(request).then((result) {}).catchError((error) {
        toast(error.toString());
      });
    } else {}
  });
}
