import 'package:clinic_medicines/cubit/customer/customer_states.dart';
import 'package:clinic_medicines/models/customer_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerCubit extends Cubit<CustomerState> {
  CustomerCubit() : super(CustomerInitState());

  static CustomerCubit get(BuildContext context) =>
      BlocProvider.of<CustomerCubit>(context);

  late List<CustomerModel> customers;

  // Add (Edit) Customer Function
  Future<void> addEditCustomer(CustomerModel _customerModel) async {
    emit(CustomerAddLoadingState());
    try {
      final existedCustomerQuery = await FirebaseFirestore.instance
          .collection("customers")
          .where('name', isEqualTo: _customerModel.name)
          .get();

      if (existedCustomerQuery.docs.isNotEmpty) {
        final existedCustomer = await FirebaseFirestore.instance
            .collection("customers")
            .doc(existedCustomerQuery.docs.first.id)
            .get();

        var customerModel = CustomerModel.fromJson(
          existedCustomerQuery.docs.first.id,
          existedCustomer.data(),
        );

        customerModel.name = _customerModel.name;
        customerModel.phone = _customerModel.phone;
        customerModel.email = _customerModel.email;
        customerModel.modifiedById = _customerModel.modifiedById;
        customerModel.modifiedByName = _customerModel.modifiedByName;

        await FirebaseFirestore.instance
            .collection("customers")
            .doc(customerModel.uid)
            .update(customerModel.toJson());

        customers
            .where((element) => element.uid == _customerModel.uid)
            .first
            .copyFrom(customerModel);
      } else {
        await FirebaseFirestore.instance
            .collection("customers")
            .add(_customerModel.toJson());
        await getCustomers();
      }

      emit(CustomerAddSuccessState());
    } on FirebaseException catch (error) {
      emit(CustomerAddErrorState(error.message));
    } catch (err) {
      emit(CustomerAddErrorState(err.toString()));
    }
  }

  ///
  /// Get Customers
  ///
  Future<void> getCustomers() async {
    emit(CustomersGetLoadingState());
    customers = [];
    try {
      var customersQuery = await FirebaseFirestore.instance
          .collection('customers')
          .orderBy('name')
          .get();

      print(customersQuery.docs.length);

      if (customersQuery.docs.length > 0) {
        customersQuery.docs.map(
          (element) {
            customers.add(CustomerModel.fromJson(element.id, element.data()));
          },
        ).toList();
        print(customers);
      }

      emit(CustomersGetSuccessState());
    } on FirebaseException catch (error) {
      print(error.toString());
      emit(CustomersGetErrorState(error.message));
    } on Exception catch (error) {
      print(error.toString());
      emit(CustomersGetErrorState(error.toString()));
    }
  }
}
