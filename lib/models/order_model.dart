import 'package:clinic_medicines/models/order_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  late String? uid;
  late String? customerId;
  late String? customerName;
  late double? discAmount;
  late double? paidAmount;
  late double? totalAmount;
  late List<OrderItemModel>? items;
  late String? createdById;
  late String? createdByName;
  late DateTime? createdOn;

  OrderModel({
    this.uid,
    this.customerId = '',
    this.customerName = '',
    this.discAmount = 0.0,
    this.paidAmount = 0.0,
    this.totalAmount = 0.0,
    this.items = const [],
    this.createdOn,
    this.createdByName,
    this.createdById,
  });

  void copyFrom(OrderModel _orderModel) {
    this.uid = _orderModel.uid;
    this.customerId = _orderModel.customerId;
    this.customerName = _orderModel.customerName;
    this.discAmount = _orderModel.discAmount;
    this.paidAmount = _orderModel.paidAmount;
    this.totalAmount = _orderModel.totalAmount;
    this.items = _orderModel.items;
    this.createdOn = _orderModel.createdOn;
    this.createdByName = _orderModel.createdByName;
    this.createdById = _orderModel.createdById;
  }

  OrderModel.fromJson(String uid, Map<String, dynamic>? json) {
    this.uid = uid;
    this.customerId = json?['customerId'] ?? '';
    this.customerName = json?['customerName'] ?? '';
    this.discAmount = json?['discAmount'] ?? 0.0;
    this.paidAmount = json?['paidAmount'] ?? 0.0;
    this.totalAmount = json?['totalAmount'] ?? 0.0;
    this.createdOn = (json?['createdOn'] as Timestamp).toDate();
    this.createdByName = json?['createdByName'] ?? '';
    this.createdById = json?['createdById'] ?? '';
    this.items = [];
  }

  Map<String, dynamic> toJson() {
    late Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    data['customerName'] = this.customerName;
    data['discAmount'] = this.discAmount;
    data['paidAmount'] = this.paidAmount;
    data['totalAmount'] = this.totalAmount;
    data['totalAmount'] = this.totalAmount;
    data['createdOn'] = this.createdOn;
    data['createdByName'] = this.createdByName;
    data['createdById'] = this.createdById;
    return data;
  }

  double getTotals() {
    return getSubTotal() - this.discAmount!;
  }

  double getSubTotal() {
    double totals = 0.0;
    this.items?.map((e) => totals += (e.totalAmount)).toList();
    return totals;
  }
}
