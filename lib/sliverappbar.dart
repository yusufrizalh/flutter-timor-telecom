// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, sort_child_properties_last, use_key_in_widget_constructors

import 'package:flutter/material.dart';

import 'menu/contact_page.dart';
import 'menu/home_page.dart';
import 'menu/products_page.dart';

/*
  # Widget berdasarkan isi didalamnya dibagi menjadi 2 kategori:
    > Stateless Widget: nilai didalam widget bersifat statis
    > Stateful Widget: nilai didalam widget bersifat dinamis
*/

class MySliverAppBar extends StatefulWidget {
  final drawerItems = [
    DrawerItem("Home Page", Icons.home),
    DrawerItem("Products Page", Icons.shopping_cart),
    DrawerItem("Contact Page", Icons.mail),
  ];

  @override
  State<MySliverAppBar> createState() => _MySliverAppBarState();
}

class DrawerItem {
  // properties
  String? title;
  IconData? icon;
  DrawerItem(this.title, this.icon);
}

class _MySliverAppBarState extends State<MySliverAppBar> {
  int selectedItem = 0;
  String profilePicture = "https://i.ibb.co/PxkfQPX/github-avatar.png";

  getDrawerItem(int position) {
    switch (position) {
      case 0:
        return HomePage();
      case 1:
        return ProductsPage();
      case 2:
        return ContactPage();
      default:
        return Text('Page is not found!');
    }
  }

  onSelectedItem(int index) {
    setState(() {
      selectedItem = index;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var menu = 0; menu < widget.drawerItems.length; menu++) {
      var drawer = widget.drawerItems[menu];
      drawerOptions.add(ListTile(
        leading: Icon(drawer.icon),
        title: Text(drawer.title!),
        selected: menu == selectedItem,
        onTap: () => onSelectedItem(menu),
      ));
    }

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Yusuf Rizal'),
              accountEmail: Text('rizal@inixindo.co.id'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(profilePicture),
              ),
            ),
            Column(
              children: drawerOptions,
            )
          ],
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 260.0,
              backgroundColor: Color.fromRGBO(70, 132, 153, 1),
              floating: false,
              snap: false,
              pinned: true,
              leading: IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: Icon(Icons.menu)),
              actions: <Widget>[
                IconButton(
                    onPressed: () => print('search is pressed'),
                    icon: Icon(Icons.search)),
                IconButton(
                    onPressed: () => print('settings is pressed'),
                    icon: Icon(Icons.settings)),
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Custom SliverAppBar',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                background: Image(
                  image:
                      // AssetImage('/images/sliverappbar-background-image.jpg'),
                      NetworkImage(
                          'https://i.ibb.co/BNzWQRt/Bee-Gees-vinyl-1087787-1920.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: getDrawerItem(selectedItem),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Color.fromRGBO(70, 132, 153, 1),
      //   onPressed: () {
      //     showModal(context);
      //   },
      //   child: Icon(Icons.create),
      // ),
    );
  }

  showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 300.0,
          width: double.infinity,
          color: Colors.grey[300],
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close Modal'),
            style: ElevatedButton.styleFrom(
              onPrimary: Colors.white,
              primary: Color.fromRGBO(70, 132, 153, 1),
            ),
          ),
        );
      },
    );
  }
}
