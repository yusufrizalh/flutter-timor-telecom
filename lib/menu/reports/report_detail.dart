// ignore_for_file: unused_import, prefer_const_constructors_in_immutables, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:myflutterapp/models/reports_model.dart';
import '../../base_url.dart';
import '../../models/report_detail_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ReportDetail extends StatefulWidget {
  late final ReportsModel reportDetailModel;
  ReportDetail({Key? key, required this.reportDetailModel}) : super(key: key);

  @override
  State<ReportDetail> createState() => _ReportDetailState();
}

class _ReportDetailState extends State<ReportDetail> {
  late Future<List<ReportDetailModel>> reportDetail;
  final reportDetailKey = GlobalKey<_ReportDetailState>();

  @override
  void initState() {
    super.initState();
    reportDetail = getReportDetail();
  }

  Future<List<ReportDetailModel>> getReportDetail() async {
    final url =
        '${BaseUrl.BASE_URL_REPORT}/list_report_detail.php?order_id=${widget.reportDetailModel.order_id}';
    final response = await http.get(Uri.parse(url));
    final items =
        convert.json.decode(response.body).cast<Map<String, dynamic>>();
    print(items);
    List<ReportDetailModel> reportDetail = items.map<ReportDetailModel>((json) {
      return ReportDetailModel.fromJson(json);
    }).toList();
    return reportDetail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order ID: ${widget.reportDetailModel.order_id}'),
        actions: <IconButton>[
          IconButton(
              onPressed: () => print('Print Invoice'), icon: Icon(Icons.print)),
        ],
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.grey.shade400),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(padding: EdgeInsets.all(12.0)),
              ListTile(
                leading: Icon(Icons.list),
                title:
                    Text('Cashier: ${widget.reportDetailModel.cashier_name}'),
              ),
              ListTile(
                leading: Icon(Icons.list),
                title:
                    Text('Customer: ${widget.reportDetailModel.customer_name}'),
              ),
              ListTile(
                leading: Icon(Icons.list),
                title:
                    Text('Order Date: ${widget.reportDetailModel.order_date}'),
              ),
              // menampilkan products yang dibeli
              Expanded(
                child: FutureBuilder(
                  future: reportDetail,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ReportDetailModel>> snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data == null) {
                      return Center(child: Text('Snapshot has no data!'));
                    }
                    if (snapshot.data!.isEmpty) {
                      return Center(child: Text('Data is empty!'));
                    }
                    // ketika connectionState done dan snapshot berisi data
                    return GridView.builder(
                      padding: EdgeInsets.all(8.0),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 1 / 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int position) {
                        var data = snapshot.data![position];
                        return Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            title: Text(data.product_name),
                            subtitle: Text(
                                '${data.product_price} - ${data.product_qty} - ${data.subtotal}'),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Text(
                'Total: ${widget.reportDetailModel.total}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: Colors.black87),
              ),
              Padding(padding: EdgeInsets.only(bottom: 12.0, top: 12.0)),
            ],
          ),
        ),
      ),
    );
  }
}
