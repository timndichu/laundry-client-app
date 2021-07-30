import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  String _email = '';

  String _phone = '';

  String get email {
    return _email;
  }

  String get phone {
    return _phone;
  }

  Map<String, dynamic> _user = {};

  Map<String, dynamic> get user {
    return Map.from(_user);
  }

  User _loggedUser;

  User get loggedUser {
    return _loggedUser;
  }

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  String _firstName = '';

  String get firstName {
    return _firstName;
  }

  bool _hasError = false;

  bool get hasError {
    return _hasError;
  }

  String baseurl = "https://victorycakes.co.ke";

  String formatter(String url) {
    return baseurl + url;
  }

  Future<dynamic> postSignUp(String url, Map<String, String> body) async {
    url = formatter(url);
  
      bool hasError = true;
    String message = 'Something went wrong';
    var response = await http.post(url,
        headers: {"Content-type": "application/json"}, body: json.encode(body))  .catchError((error) {
        return {
          'message': message + 'Check your Internet connection',
          'success': hasError
        };
      });

    final Map<String, dynamic> responseData = json.decode(response.body);

    String token = '';

    Map<String, dynamic> userData = {};
    Map<String, dynamic> fetchedUser = {};

    if (response.statusCode == 403) {
      hasError = true;
      message = responseData['msg'];
    } else if (response.statusCode == 401 ||
        response.statusCode == 500) {
      hasError = true;
      message = responseData['msg'];
    } else if (response.statusCode == 200) {
      hasError = false;
      message = responseData['msg'];

      userData = responseData['user'];

      print(
          '===========////////////////////////////LOGGED USER///////////////////////////==============');

      final User theUser = User(
          firstname: userData['firstName'],
          lastname: userData['lastName'],
          email: userData['email'],
          phone: userData['phone'],
          residence: userData['residence']);
      fetchedUser['user'] = theUser;
      _user = fetchedUser;

      _loggedUser = theUser;

      _isLoading = false;
      notifyListeners();
    } else {
      message = 'Something went wrong, Check your network';
      _isLoading = false;
      notifyListeners();
    }

    return {'success': !hasError, 'message': message};
  }

  Future<dynamic> postLogin(String url, Map<String, String> body) async {
    url = formatter(url);

    bool hasError = true;
    String message = 'Something went wrong';
    String token = '';
  
  try{
      var response = await http.post(url,
        headers: {"Content-type": "application/json"}, body: json.encode(body));
      print(response.body);
      final Map<String, dynamic> responseData = new Map<String, dynamic>.from(json.decode(response.body));
      Map<String, dynamic> userData = {};
      Map<String, dynamic> fetchedUser = {};

      if (response.statusCode == 403) {
        hasError = true;
        message = responseData['msg'];
      } else if (response.statusCode == 401 ||
          response.statusCode == 500) {
        hasError = true;
        message = responseData['msg'];
      } else if (response.statusCode == 200) {
        hasError = false;
        message = responseData['msg'];
     
      

        print(
            '===========////////////////////////////LOGGED USER///////////////////////////==============');

      
        _isLoading = false;
        notifyListeners();
      } else {
        message = 'Something went wrong, Check your network';
        _isLoading = false;
        notifyListeners();
      }

      return {'success': !hasError, 'message': message};
    } catch (err) {
      print(err);
    }
  }
/*
  Future<dynamic> changePassword(String url, Map<String, String> body) async {
    url = formatter(url);

    bool hasError = true;
    String message = 'Something went wrong';

    try {
      var response = await http
          .post(url,
              headers: {"Content-type": "application/json"},
              body: json.encode(body))
          .catchError((error) {
        return {
          'message': message + 'Check your Internet connection',
          'success': hasError
        };
      });

      final Map<String, dynamic> responseData = json.decode(response.body);

      print(responseData);
      log.d(responseData);

      //log.i(responseData);

      if (response.statusCode == 200) {
        hasError = false;
        message = 'Success';
      } else {
        hasError = true;
        message = responseData['msg'];
      }

      return {'success': !hasError, 'message': message};
    } catch (err) {
      print(err);
    }

    // log.d(response.statusCode);
    // log.d(response.body);
    //   log.i(response.body);
    //   return [json.decode(response.body), response.statusCode ];
  }

 

  Future fetchTheUser() async {
    Map<String, dynamic> fetchedUser = {};
    final List<Cart> fetchedCart = [];
    // final List<Order> fetchedOrders = [];
    List<Shoe> fetchedItems = [];
    List<DeliveryAddress> fetchedAddress = [];

    _isLoading = true;
    notifyListeners();
    try {
      //Get user from Profile
      final Map<String, dynamic> userData =
          await getProfile().catchError((error) => log.i(error));

      if (userData.isEmpty) {
        _user = fetchedUser;
        _isLoading = false;

        _hasError = true;
        notifyListeners();
      } else {
        final User theUser = User(
            firstname: userData['firstname'],
            lastname: userData['lastname'],
            email: userData['email'],
            profilePhoto: userData['profilePhoto'],
            phone: userData['phone'],
            cart: userData['cart'],
            likedItems: userData['likedItems'],
            deliveryAddresses: userData['deliveryAddresses']);
        fetchedUser['user'] = theUser;
        _user = fetchedUser;
        _email = userData['email'];
        // log.i(_user);

        //Get Cart
        final Map<String, dynamic> cartData = userData['cart'];

        _totalPrice = cartData['totalPrice'];

        cartData['items'].forEach((dynamic cartItem) {
          final Cart cart = Cart(
              productId: cartItem['productId'],
              item: cartItem['item'],
              qty: cartItem['qty'],
              size: cartItem['size'],
              price: cartItem['price'],
              totalPrice: cartData['totalPrice'],
              totalQty: cartData['totalQty']);

          fetchedCart.add(cart);
        });
        _cart = fetchedCart;

        //Get delivery Addresses
        userData['deliveryAddresses'].forEach((dynamic theAddress) {
          final DeliveryAddress address = DeliveryAddress(
              isDefault: theAddress['isDefault'],
              id: theAddress['id'],
              name: theAddress['name'],
              email: theAddress['email'],
              phone: theAddress['phone'],
              region: theAddress['region'],
              city: theAddress['city'],
              estate: theAddress['estate'],
              landmark: theAddress['landmark']);

          fetchedAddress.add(address);
        });

        _deliveryAdd = fetchedAddress;

        //Get likedItems
        userData['likedItems'].forEach((dynamic likedItems) {
          final Shoe shoe = Shoe(
            id: likedItems['_id'],
            title: likedItems['title'],
            shortDesc: likedItems['shortDesc'],
            longDesc: likedItems['longDesc'],
            images: likedItems['images'],
            price: likedItems['price'],
            reviews: likedItems['reviews'],
            sizes: likedItems['sizes'],
            category: likedItems['category'],
            subcategory: likedItems['subcategory'],
            isFeatured: likedItems['isFeatured'],
          );
          fetchedItems.add(shoe);
        });

        _likedItems = fetchedItems;

        _isLoading = false;
        notifyListeners();
      }
    } catch (err) {
      print(err);
    }
  }
*/

}
