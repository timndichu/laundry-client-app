import 'package:flutter/material.dart';
import 'package:laundry_client_app/providers/user_provider.dart';
import 'package:laundry_client_app/views/landing_page.dart';
import 'package:provider/provider.dart';

import 'providers/shop_provider.dart';

void main() {
    runApp( MultiProvider(
        child: MyApp(),
        providers: [
          ChangeNotifierProvider<UserProvider>(
            create: (BuildContext context) {
              return UserProvider();
            },
          ),
          ChangeNotifierProvider<ShopProvider>(
            create: (BuildContext context) {
              return ShopProvider();
            },
          ),
          ]));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Usafi Laundry',
      theme: ThemeData(
        
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.deepPurple)
      ),
      home: WelcomePage(),
    );
  }
}
