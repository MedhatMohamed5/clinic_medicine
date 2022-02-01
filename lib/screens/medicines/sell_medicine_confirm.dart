import 'package:clinic_medicines/common/components/loading.dart';
import 'package:clinic_medicines/common/components/textInput.dart';
import 'package:clinic_medicines/common/styles/colors.dart';
import 'package:clinic_medicines/cubit/sell_medicine/sell_medicine_cubit.dart';
import 'package:clinic_medicines/cubit/sell_medicine/sell_medicine_state.dart';
import 'package:clinic_medicines/models/order_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SellMedicineConfirmScreen extends StatefulWidget {
  const SellMedicineConfirmScreen({Key? key}) : super(key: key);

  @override
  State<SellMedicineConfirmScreen> createState() =>
      _SellMedicineConfirmScreenState();
}

class _SellMedicineConfirmScreenState extends State<SellMedicineConfirmScreen> {
  final discController = TextEditingController();
  final paidAmountController = TextEditingController();
  @override
  void dispose() {
    discController.dispose();
    paidAmountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    discController.text =
        SellMedicineCubit.get(context).orderModel.discAmount.toString();

    SellMedicineCubit.get(context).orderModel.paidAmount =
        SellMedicineCubit.get(context).orderModel.paidAmount == 0
            ? SellMedicineCubit.get(context).orderModel.totalAmount
            : SellMedicineCubit.get(context).orderModel.paidAmount;
    paidAmountController.text =
        SellMedicineCubit.get(context).orderModel.paidAmount.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SellMedicineCubit, SellMedicineState>(
      listener: (context, state) {
        if (state is ConfirmOrderSuccessState) {
          SellMedicineCubit.get(context).initOrdrer();
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Order Added Successfully'),
              backgroundColor: defaultColor,
            ),
          );
          Navigator.popUntil(context, (route) => route.isFirst);
        } else if (state is ConfirmOrderErrorState) {
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
        var sellMedicineCubit = SellMedicineCubit.get(context);
        var screenOrientation = MediaQuery.of(context).orientation;
        var itemsHeight = screenOrientation == Orientation.landscape
            ? MediaQuery.of(context).size.height * .30
            : null;

        return state is ConfirmOrderLoadingState
            ? Scaffold(body: loading())
            : _scaffoldScreen(sellMedicineCubit, itemsHeight);
      },
    );
  }

  Scaffold _scaffoldScreen(
    SellMedicineCubit sellMedicineCubit,
    double? itemsHeight,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Order'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton(
              onPressed: () {
                sellMedicineCubit.confirmOrder(context);
              },
              child: Text('CONFIRM'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _screenBody(sellMedicineCubit, itemsHeight),
        ),
      ),
    );
  }

  Widget _screenBody(SellMedicineCubit sellMedicineCubit, double? itemsHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Customer',
            ),
            Spacer(),
            Text(
              sellMedicineCubit.orderModel.customerName!,
              style: TextStyle(
                color: defaultColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          'Items:',
          style: TextStyle(
            color: defaultColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: itemsHeight,
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) =>
                itemRow(sellMedicineCubit.orderModel.items![index]),
            itemCount: sellMedicineCubit.orderModel.items!.length,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Text(
              'Subtotal:',
            ),
            Spacer(),
            Text(
              sellMedicineCubit.orderModel.getSubTotal().toStringAsFixed(2),
              style:
                  TextStyle(color: defaultColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Text(
              'Total:',
            ),
            Spacer(),
            Text(
              '${sellMedicineCubit.orderModel.getTotals().toStringAsFixed(2)}',
              style: TextStyle(
                color: defaultColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                'Discount:',
              ),
            ),
            Expanded(
              child: textInput(
                controller: discController,
                hintText: 'Discount',
                keyboardType: TextInputType.number,
                label: 'Discount',
                validate: (val) {},
                onChange: (val) {
                  if (double.tryParse(discController.text) != null)
                    sellMedicineCubit
                        .changeDisc(double.tryParse(discController.text)!);
                  else
                    sellMedicineCubit.changeDisc(0);
                },
              ),
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                'Paid Amount:',
              ),
            ),
            Expanded(
              child: textInput(
                controller: paidAmountController,
                hintText: 'Paid Amount',
                keyboardType: TextInputType.number,
                label: 'Paid Amount',
                validate: (val) {},
                onChange: (val) {
                  if (double.tryParse(paidAmountController.text) != null)
                    sellMedicineCubit.changePaid(
                        double.tryParse(paidAmountController.text)!);
                  else
                    sellMedicineCubit.changePaid(0);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget itemRow(OrderItemModel orderItemModel) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(
              orderItemModel.medicineName,
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 16,
              ),
            ),
            Spacer(),
            Text(
              '${orderItemModel.qty} x ${orderItemModel.unitConsumerPrice.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
}
