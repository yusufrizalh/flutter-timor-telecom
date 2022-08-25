// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, avoid_print, use_build_context_synchronously, unused_local_variable

import 'package:flutter/material.dart';
import '../base_url.dart';
import '../form/form_page.dart';
import '../models/products_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:async';

import 'products/product_detail.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class Debouncer {
  // properties
  int? milliseconds;
  VoidCallback? process;
  Timer? timer;
  // method
  running(VoidCallback process) {
    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer(
      Duration(milliseconds: Duration.millisecondsPerSecond),
      process,
    );
  }
}

class _ProductsPageState extends State<ProductsPage> {
  final debouncer = Debouncer();
  List<ProductsModel> productList = []; // nilai awal kosong
  List<ProductsModel> searchProductList = []; // pencarian produk masih kosong

  String url = "${BaseUrl.BASE_URL}/product_list.php";

  Future<List<ProductsModel>> getProductList() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // print(response.body);
        List<ProductsModel> products = parseJson(response.body);
        return products;
      } else {
        throw Exception('Error while getting products...');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static List<ProductsModel> parseJson(String body) {
    final parsedJson = convert.json.decode(body).cast<Map<String, dynamic>>();
    return parsedJson
        .map<ProductsModel>((json) => ProductsModel.fromJson(json))
        .toList();
  }

  /*
    initState: inisialisasi nilai awal
    setState: mengubah nilai awal menjadi nilai baru
  */
  @override
  void initState() {
    super.initState();
    getProductList().then((value) {
      setState(() {
        searchProductList = value;
        productList = searchProductList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // pencarian data dengan searchbar
            Center(
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: TextField(
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Search product',
                    suffixIcon: Icon(Icons.search),
                  ),
                  onChanged: (keyword) {
                    // menuliskan karakter produk yang dicari
                    debouncer.running(() {
                      setState(() {
                        productList = searchProductList
                            .where(
                              (searchedProduct) => (searchedProduct.product_name
                                  .toLowerCase()
                                  .contains(
                                    keyword.toLowerCase(),
                                  )),
                            )
                            .toList();
                      });
                    });
                  },
                ),
              ),
            ),

            // menampilkan List yg berisi products
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(6.0),
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.grey.shade400),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.list),
                          title: Text(
                            productList[index].product_name.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                          subtitle:
                              Text(productList[index].product_price.toString()),
                          onTap: () {
                            // menampilkan ProductDetail
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetail(
                                  productsModel: productList[index],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // membuka form untuk menambah product baru
          showModal(context);
        },
        backgroundColor: Color.fromRGBO(70, 132, 153, 1),
        child: Icon(Icons.add_box),
      ),
    );
  }

  showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 500.0,
          width: double.infinity,
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: Column(
                children: <Widget>[
                  FormPage(
                    formKey: formKey,
                    productNameCtrl: productNameCtrl,
                    productPriceCtrl: productPriceCtrl,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        // proses menyimpan data product
                        onCreateProduct(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(70, 132, 153, 1)),
                    child: Text(
                      'Create Product',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController productNameCtrl = TextEditingController();
  TextEditingController productPriceCtrl = TextEditingController();

  void onCreateProduct(BuildContext context) async {
    await createProduct();
  }

  Future createProduct() async {
    final url = '${BaseUrl.BASE_URL}/product_create.php';
    Map<String, dynamic> params = {
      "product_name": productNameCtrl.text,
      "product_price": productPriceCtrl.text,
    };
    final response = await http.post(
      Uri.parse(url),
      body: params,
    );
    if (response.statusCode != 200) {
      throw Exception(response.body);
    } else {
      final alertMessage = AlertDialog(
        title: Text('Success'),
        content: Text('Success to create new product'),
        actions: [
          ElevatedButton(
              onPressed: () {
                // menutup message
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', (Route<dynamic> route) => false);
              },
              style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(70, 132, 153, 1)),
              child: Text('Ok')),
        ],
      );
      showDialog(
        context: context,
        builder: (context) {
          return alertMessage;
        },
      );
    }
  }
}
