import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  late String name;
  late String? uid;
  late String? email;
  late String phone;
  late double? paidAmount;
  late double? purchasedAmount;
  late double? balanceAmount;
  late DateTime createdOn;
  late String createdByName;
  late String createdById;
  late DateTime modifiedOn;
  late String modifiedByName;
  late String modifiedById;

  CustomerModel({
    this.uid,
    required this.name,
    required this.phone,
    this.email,
    this.paidAmount,
    this.purchasedAmount,
    this.balanceAmount,
    required this.createdOn,
    required this.createdByName,
    required this.createdById,
    required this.modifiedOn,
    required this.modifiedByName,
    required this.modifiedById,
  });

  void copyFrom(CustomerModel _customerModel) {
    this.uid = _customerModel.uid;
    this.name = _customerModel.name;
    this.phone = _customerModel.phone;
    this.email = _customerModel.email;
    this.paidAmount = _customerModel.paidAmount;
    this.purchasedAmount = _customerModel.purchasedAmount;
    this.balanceAmount = _customerModel.balanceAmount;
    this.createdOn = _customerModel.createdOn;
    this.createdByName = _customerModel.createdByName;
    this.createdById = _customerModel.createdById;
    this.modifiedOn = _customerModel.modifiedOn;
    this.modifiedByName = _customerModel.modifiedByName;
    this.modifiedById = _customerModel.modifiedById;
  }

  CustomerModel.fromJson(String uid, Map<String, dynamic>? json) {
    this.uid = uid;
    this.name = json?['name'] ?? '';
    this.phone = json?['phone'] ?? '';
    this.email = json?['email'] ?? '';
    this.paidAmount = double.tryParse('${json?['paidAmount']}') ?? 0.0;
    this.purchasedAmount =
        double.tryParse('${json?['purchasedAmount']}') ?? 0.0;
    this.balanceAmount = double.tryParse('${json?['balanceAmount']}') ?? 0.0;
    this.createdOn = (json?['createdOn'] as Timestamp).toDate();
    this.createdByName = json?['createdByName'] ?? '';
    this.createdById = json?['createdById'] ?? '';
    this.modifiedOn = (json?['modifiedOn'] as Timestamp).toDate();
    this.modifiedByName = json?['modifiedByName'] ?? '';
    this.modifiedById = json?['modifiedById'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['paidAmount'] = this.paidAmount;
    data['balanceAmount'] = this.balanceAmount;
    data['purchasedAmount'] = this.purchasedAmount;
    data['createdOn'] = this.createdOn;
    data['createdByName'] = this.createdByName;
    data['createdById'] = this.createdById;
    data['modifiedOn'] = this.modifiedOn;
    data['modifiedByName'] = this.modifiedByName;
    data['modifiedById'] = this.modifiedById;
    return data;
  }

  bool isEqual(CustomerModel? t) {
    return this.uid == t?.uid;
  }
}
