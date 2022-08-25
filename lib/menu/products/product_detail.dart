// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../../base_url.dart';
import '../../form/form_page.dart';
import '../../models/products_model.dart';
import 'package:http/http.dart' as http;

class ProductDetail extends StatefulWidget {
  final ProductsModel productsModel;
  const ProductDetail({super.key, required this.productsModel});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail | ID: ${widget.productsModel.product_id}'),
        backgroundColor: Color.fromRGBO(70, 132, 153, 1),
        actions: <Widget>[
          IconButton(
              onPressed: () => confirmToDelete(context),
              icon: Icon(
                Icons.delete,
              )),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Product name: ${widget.productsModel.product_name}"),
            Text("Product price: ${widget.productsModel.product_price}"),
            Text("Created at: ${widget.productsModel.created_at}"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // membuka form untuk mengubah product
          showModal(context);
        },
        backgroundColor: Color.fromRGBO(70, 132, 153, 1),
        child: Icon(Icons.edit),
      ),
    );
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController productNameCtrl = TextEditingController();
  TextEditingController productPriceCtrl = TextEditingController();

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
                        // proses mengubah data product
                        onUpdateProduct(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(70, 132, 153, 1)),
                    child: Text(
                      'Update Product',
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

  @override
  void initState() {
    super.initState();
    productNameCtrl = TextEditingController(
        text: widget.productsModel.product_name.toString());
    productPriceCtrl = TextEditingController(
        text: widget.productsModel.product_price.toString());
  }

  void onUpdateProduct(BuildContext context) async {
    await updateProduct();
  }

  Future updateProduct() async {
    final url = '${BaseUrl.BASE_URL}/product_update.php';
    Map<String, dynamic> params = {
      "product_id": widget.productsModel.product_id.toString(),
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
        content: Text('Success to update product'),
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

  void confirmToDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Product'),
          content: Text('Are you sure want to delete this product?'),
          actions: [
            ElevatedButton(
                onPressed: () {
                  // cancel
                  Navigator.of(context).pop();
                },
                child: Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                // yes
                deleteProduct(context);
              },
              style: ElevatedButton.styleFrom(primary: Colors.red.shade500),
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void deleteProduct(BuildContext context) async {
    final url = '${BaseUrl.BASE_URL}/product_delete.php';
    Map<String, dynamic> params = {
      "product_id": widget.productsModel.product_id.toString(),
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
        content: Text('Success to delete product'),
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
