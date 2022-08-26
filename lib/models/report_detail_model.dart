// ignore_for_file: non_constant_identifier_names

class ReportDetailModel {
  // properties
  late final String cashier_name;
  late final String customer_name;
  late final int order_id;
  late final String order_date;
  late final String product_name;
  late final String product_price;
  late final String product_qty;
  late final int subtotal;

  // constructor
  ReportDetailModel({
    required this.cashier_name,
    required this.customer_name,
    required this.order_id,
    required this.order_date,
    required this.product_name,
    required this.product_price,
    required this.product_qty,
    required this.subtotal,
  });

  // konversi dari json ke map
  factory ReportDetailModel.fromJson(Map<String, dynamic> json) {
    return ReportDetailModel(
      cashier_name: json['cashier_name'],
      customer_name: json['customer_name'],
      order_id: json['order_id'],
      order_date: json['order_date'],
      product_name: json['product_name'],
      product_price: json['product_price'],
      product_qty: json['product_qty'],
      subtotal: json['subtotal'],
    );
  }

  get text => null;

  // konversi dari map ke json
  Map<String, dynamic> toJson() => {
        'cashier_name': cashier_name,
        'customer_name': customer_name,
        'order_id': order_id,
        'order_date': order_date,
        'product_name': product_name,
        'product_price': product_price,
        'product_qty': product_qty,
        'subtotal': subtotal,
      };
}
