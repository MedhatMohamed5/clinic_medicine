class CustomerModel {
  late String name;
  String? uid;
  String? email;
  late String phone;
  double? paidAmount;
  double? purchasedAmount;
  double? balanceAmount;

  CustomerModel({
    this.uid,
    required this.name,
    required this.phone,
    this.email,
    this.paidAmount,
    this.purchasedAmount,
    this.balanceAmount,
  });

  void copyFrom(CustomerModel _customerModel) {
    this.uid = _customerModel.uid;
    this.name = _customerModel.name;
    this.phone = _customerModel.phone;
    this.email = _customerModel.email;
    this.paidAmount = _customerModel.paidAmount;
    this.purchasedAmount = _customerModel.purchasedAmount;
    this.balanceAmount = _customerModel.balanceAmount;
  }

  CustomerModel.fromJson(String uid, Map<String, dynamic>? json) {
    this.uid = uid;
    this.name = json?['name'] ?? '';
    this.phone = json?['phone'] ?? '';
    this.email = json?['email'] ?? '';
    this.paidAmount = json?['paidAmount'] ?? 0;
    this.purchasedAmount = json?['balanceAmount'] ?? 0;
    this.balanceAmount = json?['balanceAmount'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['paidAmount'] = this.paidAmount;
    data['balanceAmount'] = this.balanceAmount;
    data['purchasedAmount'] = this.purchasedAmount;
    return data;
  }
}
