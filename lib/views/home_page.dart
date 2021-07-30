import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Homepage extends StatefulWidget {


  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,
      title: Text('Home'),
      actions: [Icon(Icons.logout)],
      ),
      body: Column(children: [Center(child: Text('You made it'))],)
    );
  }
}