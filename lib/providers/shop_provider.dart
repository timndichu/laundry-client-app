import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:laundry_client_app/models/product.dart';
import 'package:laundry_client_app/models/service.dart';


class ShopProvider extends ChangeNotifier {
  // String baseurl = "https://victorycakes.co.ke";
  String baseurl = "http://localhost:3000";

  String formatter(String url) {
    return baseurl + url;
  }

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  List<Product> _products = [];

  List<Product> get products {
    return List.from(_products);
  }

  List<Service> _services = [];

  List<Service> get services {
    return List.from(_services);
  }

  Future getServices() async {
    Map<String, dynamic> responseData = {};
    List<Service> fetchedServices = [];
     _isLoading = true;
      notifyListeners();
    String url = formatter('/laundry/getServices');

    var response = await http.get(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      responseData = json.decode(response.body);
      responseData['services'].forEach((dynamic item) {
        final Service service = Service(
          id: item['id'],
          title: item['title'],
          imageUrl: item['imageUrl'],
        );
        fetchedServices.add(service);
      });
      _services = fetchedServices;

      _isLoading = false;
      notifyListeners();
    } else {
      responseData = json.decode(response.body);

      _isLoading = false;
      notifyListeners();
    }
  }

    Future getProducts() async {
    Map<String, dynamic> responseData = {};
    List<Product> fetchedProducts = [];
     _isLoading = true;
      notifyListeners();
    String url = formatter('/laundry/getProducts');

    var response = await http.get(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      responseData = json.decode(response.body);
      responseData['products'].forEach((dynamic item) {
        final Product product = Product(
          id: item['id'],
          title: item['title'],
          image: item['image'],
          price: item['price'],
          serviceId: item['serviceId']
        );
        fetchedProducts.add(product);
      });
      _products = fetchedProducts;

      _isLoading = false;
      notifyListeners();
    } else {
      responseData = json.decode(response.body);

      _isLoading = false;
      notifyListeners();
    }
  }

  Future<dynamic> postProduct(String productName, String price,
      String serviceType, PlatformFile image) async {
    var url = formatter('/laundry/postProduct');
    var uri = Uri.parse(url);
    bool hasError = true;
    String message = 'Something went wrong';

    if (image != null) {
      var request = new http.MultipartRequest('POST', uri);
      request.headers.addAll({
        "Content-type": "multipart/form-data",
      });

      request.fields['productName'] = productName;
      request.fields['price'] = price;
      request.fields['serviceType'] = serviceType;

      print('IMAGE IS HERE');

      var multipartFile = new http.MultipartFile(
          "image", image.readStream, image.size,
          filename: image.name);

      request.files.add(multipartFile);
      var response = await request.send();

      if (response.statusCode == 200) {
        print("Image Uploaded");
        hasError = false;
      } else {
        print("Upload Failed");
        hasError = true;
        message = "Upload failed";
      }
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    } else {
      hasError = true;
      message = "No image Selected";
    }

    return {'success': !hasError, 'message': message};
  }

  Future<dynamic> postService(String serviceName, PlatformFile image) async {
    var url = formatter('/laundry/postService');
    var uri = Uri.parse(url);
    bool hasError = true;
    String message = 'Something went wrong';

    if (image != null) {
      var request = new http.MultipartRequest('POST', uri);
      request.headers.addAll({
        "Content-type": "multipart/form-data",
      });

      request.fields['serviceName'] = serviceName;

      print('IMAGE IS HERE');

      var multipartFile = new http.MultipartFile(
          "image", image.readStream, image.size,
          filename: image.name);

      request.files.add(multipartFile);
      var response = await request.send();

      if (response.statusCode == 200) {
        print("Image Uploaded");
        hasError = false;
      } else {
        print("Upload Failed");
        hasError = true;
        message = "Upload failed";
      }
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    } else {
      hasError = true;
      message = "No image Selected";
    }

    return {'success': !hasError, 'message': message};
  }
}
