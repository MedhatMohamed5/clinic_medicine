class OrderItemModel {
  late String? uid;
  late String medicineId;
  late String medicineName;
  late double unitListPrice;
  late double unitConsumerPrice;
  late int qty;
  late double totalAmount;

  OrderItemModel({
    this.uid,
    required this.medicineId,
    required this.medicineName,
    required this.unitListPrice,
    required this.unitConsumerPrice,
    required this.qty,
    required this.totalAmount,
  });

  void copyFrom(OrderItemModel _orderItemModel) {
    this.uid = _orderItemModel.uid;
    this.medicineId = _orderItemModel.medicineId;
    this.medicineName = _orderItemModel.medicineName;
    this.unitListPrice = _orderItemModel.unitListPrice;
    this.unitConsumerPrice = _orderItemModel.unitConsumerPrice;
    this.qty = _orderItemModel.qty;
    this.totalAmount = _orderItemModel.totalAmount;
  }

  OrderItemModel.fromJson(String uid, Map<String, dynamic>? json) {
    this.uid = uid;
    this.medicineId = json?['medicineId'] ?? '';
    this.medicineName = json?['medicineName'] ?? '';
    this.unitListPrice = json?['unitListPrice'] ?? 0.0;
    this.unitConsumerPrice = json?['unitConsumerPrice'] ?? 0.0;
    this.qty = json?['qty'] ?? 0.0;
    this.totalAmount = json?['totalAmount'] ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    late Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicineName'] = this.medicineName;
    data['medicineId'] = this.medicineId;
    data['unitListPrice'] = this.unitListPrice;
    data['unitConsumerPrice'] = this.unitConsumerPrice;
    data['qty'] = this.qty;
    data['totalAmount'] = this.totalAmount;
    return data;
  }
}
