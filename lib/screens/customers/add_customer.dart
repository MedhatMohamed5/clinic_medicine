import 'package:clinic_medicines/common/components/loading.dart';
import 'package:clinic_medicines/common/components/textInput.dart';
import 'package:clinic_medicines/cubit/customer/customer_cubit.dart';
import 'package:clinic_medicines/cubit/customer/customer_states.dart';
import 'package:clinic_medicines/cubit/general/app_cubit.dart';
import 'package:clinic_medicines/models/customer_model.dart';
import 'package:clinic_medicines/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddCustomerScreen extends StatefulWidget {
  AddCustomerScreen({Key? key, this.customerModel}) : super(key: key);
  final CustomerModel? customerModel;

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    if (widget.customerModel != null) {
      nameController.text = widget.customerModel!.name;
      phoneController.text = widget.customerModel!.phone;
      emailController.text = widget.customerModel!.email ?? '';
    }
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerCubit, CustomerState>(
      listener: (context, state) {
        if (state is CustomerAddSuccessState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          Fluttertoast.showToast(
              msg: 'Customer Added Successfully',
              backgroundColor: Colors.green);
          // MedicinesCubit.get(context).getMedicines();
          Navigator.of(context).pop();
        } else if (state is CustomerAddErrorState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final customerCubit = CustomerCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Add Customer'),
          ),
          body: (state is! CustomerAddLoadingState)
              ? _formBody(context)
              : loading(),
          floatingActionButton: (state is! CustomerAddLoadingState)
              ? FloatingActionButton(
                  onPressed: () {
                    submit(customerCubit);
                  },
                  child: Icon(
                    FontAwesomeIcons.userCheck,
                  ),
                )
              : null,
        );
      },
    );
  }

  void submit(CustomerCubit _customerCubit) async {
    if (formKey.currentState!.validate()) {
      final UserModel? userModel = AppCubit.get(context).userModel;

      CustomerModel customerModel = CustomerModel(
        uid: widget.customerModel?.uid,
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        paidAmount: 0.0,
        purchasedAmount: 0.0,
        balanceAmount: 0.0,
        createdOn: DateTime.now(),
        createdByName: userModel!.name,
        createdById: userModel.uid!,
        modifiedOn: DateTime.now(),
        modifiedByName: userModel.name,
        modifiedById: userModel.uid!,
      );

      await _customerCubit.addEditCustomer(customerModel);
    }
  }

  Widget _formBody(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('* is a required field'),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.10,
              ),
              textInput(
                controller: nameController,
                hintText: 'Enter Name',
                keyboardType: TextInputType.name,
                label: 'Name *',
                textCapitalization: TextCapitalization.words,
                validate: (val) {
                  if (val!.isEmpty) {
                    return 'Please Enter Customer Name';
                  }
                },
              ),
              SizedBox(
                height: 12,
              ),
              textInput(
                controller: phoneController,
                hintText: 'Enter Phone',
                keyboardType: TextInputType.phone,
                label: 'Phone *',
                validate: (val) {
                  if (val!.isEmpty) {
                    return 'Please Enter Customer Name';
                  }
                },
              ),
              SizedBox(
                height: 12,
              ),
              textInput(
                controller: emailController,
                hintText: 'Enter Email (Optional)',
                keyboardType: TextInputType.emailAddress,
                label: 'Email',
                validate: (val) {},
                textCapitalization: TextCapitalization.sentences,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
