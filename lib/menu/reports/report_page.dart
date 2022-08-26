// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, avoid_print

import 'package:flutter/material.dart';
import 'package:myflutterapp/menu/reports/report_detail.dart';
import '../../base_url.dart';
import '../../models/reports_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late Future<List<ReportsModel>> reports;
  final reportListKey = GlobalKey<_ReportPageState>();

  @override
  void initState() {
    super.initState();
    reports = getReportsList();
  }

  Future<List<ReportsModel>> getReportsList() async {
    final url = '${BaseUrl.BASE_URL_REPORT}/list_report.php';
    final response = await http.get(Uri.parse(url));
    final items =
        convert.json.decode(response.body).cast<Map<String, dynamic>>();
    // print(items);

    List<ReportsModel> reports = items.map<ReportsModel>((json) {
      return ReportsModel.fromJson(json);
    }).toList();
    return reports;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: reportListKey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                future: reports,
                builder: (BuildContext context,
                    AsyncSnapshot<List<ReportsModel>> snapshot) {
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
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int position) {
                      var data = snapshot.data![position];
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
                                'ID: ${data.order_id} - ${data.customer_name} - ${data.total}',
                              ),
                              onTap: () {
                                // membuka report detail
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ReportDetail(reportDetailModel: data),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
