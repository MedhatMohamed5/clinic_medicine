import 'package:clinic_medicines/cubit/customer/customer_cubit.dart';
import 'package:clinic_medicines/cubit/general/app_cubit.dart';
import 'package:clinic_medicines/cubit/medicines/medicines_cubit.dart';
import 'package:clinic_medicines/cubit/sell_medicine/sell_medicine_state.dart';
import 'package:clinic_medicines/models/customer_model.dart';
import 'package:clinic_medicines/models/medicine_model.dart';
import 'package:clinic_medicines/models/order_item_model.dart';
import 'package:clinic_medicines/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SellMedicineCubit extends Cubit<SellMedicineState> {
  SellMedicineCubit() : super(SellMedicineInitState());

  static SellMedicineCubit get(BuildContext context) =>
      BlocProvider.of<SellMedicineCubit>(context);
  late OrderModel orderModel;
  late MedicineModel? medicineModel;

  late int quantity;

  ///
  /// Choose Customer
  ///
  void chooseCustomer(CustomerModel _customer) {
    orderModel.customerId = _customer.uid;
    orderModel.customerName = _customer.name;

    orderModel.items = [];
    medicineModel = null;
    emit(ChooseCustomerState());
  }

  ///
  /// Choose Item
  ///
  void chooseItem(MedicineModel _medicineModel) {
    medicineModel = _medicineModel;
    quantity = 1;
    emit(ChooseMedicineState());
  }

  void clearMedidicineModel() {
    medicineModel = null;
    emit(ChangeNewItemState());
  }

  void initOrdrer() {
    orderModel = OrderModel();
    orderModel.items = [];
    quantity = 0;
    orderModel.discAmount = 0;
    orderModel.paidAmount = 0;
    medicineModel = null;
  }

  void addMedicine() {
    OrderItemModel? orderItemModel;
    if (quantity > medicineModel!.qty) {
      emit(
        ChangeQuantityErrorState(
          'There is no available quantity, there is only ${medicineModel!.qty.toInt()} available',
        ),
      );
      return;
    }
    try {
      if (orderModel.items!.isNotEmpty)
        orderItemModel = orderModel.items
            ?.firstWhere((element) => element.medicineId == medicineModel!.uid);
    } catch (e) {}

    if (orderItemModel == null) {
      orderModel.items?.add(
        OrderItemModel(
          medicineId: medicineModel!.uid!,
          medicineName: medicineModel!.medicineName,
          unitListPrice: medicineModel!.price,
          unitConsumerPrice: medicineModel!.consumerPrice,
          qty: quantity,
          totalAmount: medicineModel!.consumerPrice * quantity,
        ),
      );
    } else {
      orderItemModel.copyFrom(
        OrderItemModel(
          medicineId: orderItemModel.medicineId,
          medicineName: orderItemModel.medicineName,
          unitListPrice: orderItemModel.unitListPrice,
          unitConsumerPrice: orderItemModel.unitConsumerPrice,
          qty: orderItemModel.qty + quantity,
          totalAmount:
              medicineModel!.consumerPrice * (orderItemModel.qty + quantity),
        ),
      );
    }
    print('Model Totlas : ${orderModel.getTotals()}');
    orderModel.totalAmount = orderModel.getTotals();
    print(orderModel.items);
    emit(AddMedicineState());

    clearMedidicineModel();
  }

  void deleteItem(String medicineId) {
    orderModel.items
        ?.removeWhere((element) => element.medicineId == medicineId);
    orderModel.totalAmount = orderModel.getTotals();
    emit(DeleteItemState());
  }

  void changeQty(int qty) {
    if (quantity + qty > 0) {
      quantity += qty;
      emit(ChangeQuantityState());
    }
  }

  void changeDisc(double discAmount) {
    orderModel.discAmount = discAmount;
    orderModel.totalAmount = orderModel.getTotals();
    emit(ChangeDiscountState());
  }

  void changePaid(double paidAmount) {
    orderModel.paidAmount = paidAmount;
    emit(ChangePaidAmountState());
  }

  void confirmOrder(BuildContext context) async {
    emit(ConfirmOrderLoadingState());
    try {
      var firestore = FirebaseFirestore.instance;
      orderModel.createdById = AppCubit.get(context).userModel?.uid;
      orderModel.createdByName = AppCubit.get(context).userModel?.name;
      orderModel.createdOn = DateTime.now();

      var orderInstance =
          await firestore.collection('orders').add(orderModel.toJson());

      orderModel.items!.forEach((element) async {
        await orderInstance.collection('items').add(element.toJson());
        await MedicinesCubit.get(context)
            .updateMedicineAfterSellMedicine(context, element);
      });

      await CustomerCubit.get(context)
          .updateCustomerAfterSellMedicine(context, orderModel);

      emit(ConfirmOrderSuccessState());
    } on FirebaseException catch (error) {
      emit(ConfirmOrderErrorState(error.message));
    } catch (error) {
      emit(ConfirmOrderErrorState(error.toString()));
    }
  }
}
