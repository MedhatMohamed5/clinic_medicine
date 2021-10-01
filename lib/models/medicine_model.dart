import 'package:cloud_firestore/cloud_firestore.dart';

class MedicineModel {
  late String? uid;
  late String medicineName;
  late String description;
  late String? imageUrl;
  late double price;
  late double consumerPrice;
  late double qty;
  late double? soldAmount;
  late double? soldQty;
  late DateTime createdOn;
  late String createdByName;
  late String createdById;
  late DateTime modifiedOn;
  late String modifiedByName;
  late String modifiedById;

  MedicineModel({
    this.uid,
    required this.medicineName,
    required this.description,
    this.imageUrl,
    required this.price,
    required this.consumerPrice,
    required this.qty,
    this.soldAmount,
    this.soldQty,
    required this.createdOn,
    required this.createdByName,
    required this.createdById,
    required this.modifiedOn,
    required this.modifiedByName,
    required this.modifiedById,
  });

  void copyFrom(MedicineModel _medicineModel) {
    this.uid = _medicineModel.uid;
    this.medicineName = _medicineModel.medicineName;
    this.description = _medicineModel.description;
    this.imageUrl = _medicineModel.imageUrl;
    this.price = _medicineModel.price;
    this.consumerPrice = _medicineModel.consumerPrice;
    this.qty = _medicineModel.qty;
    this.soldAmount = _medicineModel.soldAmount;
    this.soldQty = _medicineModel.soldQty;
    this.createdOn = _medicineModel.createdOn;
    this.createdByName = _medicineModel.createdByName;
    this.createdById = _medicineModel.createdById;
    this.modifiedOn = _medicineModel.modifiedOn;
    this.modifiedByName = _medicineModel.modifiedByName;
    this.modifiedById = _medicineModel.modifiedById;
  }

  MedicineModel.fromJson(String uid, Map<String, dynamic>? json) {
    this.uid = uid;
    this.medicineName = json?['medicineName'] ?? '';
    this.description = json?['description'] ?? '';
    this.imageUrl = json?['imageUrl'] ?? '';
    this.price = json?['price'] ?? 0.0;
    this.consumerPrice = json?['consumerPrice'] ?? 0.0;
    this.qty = json?['qty'] ?? 0.0;
    this.soldAmount = json?['soldAmount'] ?? 0.0;
    this.soldQty = json?['soldQty'] ?? 0.0;
    this.createdOn = (json?['createdOn'] as Timestamp).toDate();
    this.createdByName = json?['createdByName'] ?? '';
    this.createdById = json?['createdById'] ?? '';
    this.modifiedOn = (json?['modifiedOn'] as Timestamp).toDate();
    this.modifiedByName = json?['modifiedByName'] ?? '';
    this.modifiedById = json?['modifiedById'] ?? '';
  }

  Map<String, dynamic> toJson() {
    late Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicineName'] = this.medicineName;
    data['description'] = this.description;
    data['description'] = this.description;
    data['imageUrl'] = this.imageUrl ?? '';
    data['price'] = this.price;
    data['consumerPrice'] = this.consumerPrice;
    data['qty'] = this.qty;
    data['soldAmount'] = this.soldAmount ?? 0.0;
    data['soldQty'] = this.soldQty ?? 0.0;
    data['createdOn'] = this.createdOn;
    data['createdByName'] = this.createdByName;
    data['createdById'] = this.createdById;
    data['modifiedOn'] = this.modifiedOn;
    data['modifiedByName'] = this.modifiedByName;
    data['modifiedById'] = this.modifiedById;
    return data;
  }
}
