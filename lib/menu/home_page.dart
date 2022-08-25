// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:myflutterapp/menu/tabs/front_page.dart' as front;
import 'package:myflutterapp/menu/tabs/gallery_page.dart' as gallery;
import 'package:myflutterapp/menu/tabs/profile_page.dart' as profile;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          front.FrontPage(),
          gallery.GalleryPage(),
          profile.ProfilePage(),
        ],
      ),
      bottomNavigationBar: Material(
        color: Color.fromRGBO(70, 132, 153, 1),
        child: TabBar(
          controller: tabController,
          tabs: <Tab>[
            Tab(icon: Icon(Icons.home), text: 'Home'),
            Tab(icon: Icon(Icons.camera), text: 'Gallery'),
            Tab(
              icon: Icon(Icons.person),
              text: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
