import 'package:clinic_medicines/common/styles/colors.dart';
import 'package:clinic_medicines/cubit/customer/customer_cubit.dart';
import 'package:clinic_medicines/cubit/customer/customer_states.dart';
import 'package:clinic_medicines/cubit/medicines/medicines_cubit.dart';
import 'package:clinic_medicines/cubit/sell_medicine/sell_medicine_cubit.dart';
import 'package:clinic_medicines/cubit/sell_medicine/sell_medicine_state.dart';
import 'package:clinic_medicines/models/customer_model.dart';
import 'package:clinic_medicines/models/medicine_model.dart';
import 'package:clinic_medicines/models/order_item_model.dart';
import 'package:clinic_medicines/screens/medicines/sell_medicine_confirm.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SellMedicineScreen extends StatefulWidget {
  const SellMedicineScreen({Key? key}) : super(key: key);

  @override
  State<SellMedicineScreen> createState() => _SellMedicineScreenState();
}

class _SellMedicineScreenState extends State<SellMedicineScreen> {
  final addNewItemKey = UniqueKey();
  final addDiscountKey = UniqueKey();
  final itemsSummeryKey = UniqueKey();
  final medicineKey = GlobalKey<DropdownSearchState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerCubit, CustomerState>(
      listener: (context, state) {},
      builder: (context, state) {
        final customerCubit = CustomerCubit.get(context);
        return BlocConsumer<SellMedicineCubit, SellMedicineState>(
          listener: (context, state) {
            var cubit = SellMedicineCubit.get(context);
            if (state is ChangeNewItemState) {
              medicineKey.currentState?.clear();
            }
            if (state is ChangeQuantityErrorState) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error!),
                  backgroundColor: Colors.red,
                ),
              );
            }
            cubit.orderModel.items?.map((e) => print(e.qty));
          },
          builder: (context, state) {
            final sellMedicineCubit = SellMedicineCubit.get(context);
            if (state is SellMedicineInitState) sellMedicineCubit.initOrdrer();
            return Scaffold(
              appBar: AppBar(
                title: Text('Sell medicine'),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextButton(
                      onPressed: sellMedicineCubit.orderModel.items!.isNotEmpty
                          ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SellMedicineConfirmScreen(),
                                ),
                              );
                            }
                          : null,
                      child: Text('CONTINUE'),
                    ),
                  ),
                ],
              ),
              body: WillPopScope(
                onWillPop: () async {
                  sellMedicineCubit.initOrdrer();
                  return true;
                },
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            child: Column(
                              children: [
                                _chooseCustomer(
                                    customerCubit, sellMedicineCubit),
                                if (sellMedicineCubit.orderModel.customerId !=
                                        null &&
                                    sellMedicineCubit
                                        .orderModel.customerId!.isNotEmpty)
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 12,
                                      ),
                                      _addItemCard(sellMedicineCubit, context),
                                      SizedBox(
                                        height: 12,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (sellMedicineCubit.orderModel.items != null &&
                        sellMedicineCubit.orderModel.items!.length > 0)
                      _summeryCard(sellMedicineCubit),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _addItemCard(
    SellMedicineCubit sellMedicineCubit,
    BuildContext context,
  ) {
    return Card(
      child: ExpansionTile(
        onExpansionChanged: (onChange) {
          if (!onChange) sellMedicineCubit.clearMedidicineModel();
        },
        key: addNewItemKey,
        title: Text(
          'Add New Item',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: defaultColor,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _chooseMedicine(
              context,
              sellMedicineCubit,
            ),
          ),
          if (sellMedicineCubit.medicineModel != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _textWithAmount(
                          'List Price:',
                          sellMedicineCubit.medicineModel?.price,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(
                                FontAwesomeIcons.minusCircle,
                                size: 16,
                              ),
                              onPressed: () => sellMedicineCubit.changeQty(-1),
                            ),
                            Text(
                              sellMedicineCubit.quantity.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                color: defaultColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                FontAwesomeIcons.plusCircle,
                                size: 16,
                              ),
                              onPressed: () => sellMedicineCubit.changeQty(1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  _textWithAmount(
                    'Consumer Price:',
                    sellMedicineCubit.medicineModel?.consumerPrice,
                  ),
                  SizedBox(height: 12),
                  _textWithAmount(
                    'Total Amount:',
                    sellMedicineCubit.medicineModel!.consumerPrice *
                        sellMedicineCubit.quantity,
                  ),
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => sellMedicineCubit.addMedicine(),
                      child: Text(
                        'Add Item',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _textWithAmount(String title, double? amount) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          child: Text(
            '${amount?.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              color: defaultColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _summeryCard(SellMedicineCubit sellMedicineCubit) {
    return Card(
      child: ExpansionTile(
        key: itemsSummeryKey,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Items -- Summery',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: defaultColor,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Totals: '),
                Text(
                  '${sellMedicineCubit.orderModel.getSubTotal().toStringAsFixed(2)}',
                ),
              ],
            ),
          ],
        ),
        children: sellMedicineCubit.orderModel.items!.length == 0
            ? [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('There is no Items yet!'),
                ),
              ]
            : sellMedicineCubit.orderModel.items!
                .map(
                  (element) => _summeryItemRow(element, sellMedicineCubit),
                )
                .toList(),
      ),
    );
  }

  Widget _summeryItemRow(
          OrderItemModel element, SellMedicineCubit sellMedicineCubit) =>
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          key: ValueKey(element.medicineId),
          children: [
            Expanded(
              flex: 4,
              child: Text(
                element.medicineName,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                '${element.qty} x ${element.unitConsumerPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 16,
                ),
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(
                maxHeight: 16,
                maxWidth: 16,
              ),
              onPressed: () {
                sellMedicineCubit.deleteItem(element.medicineId);
              },
              icon: Icon(FontAwesomeIcons.trashAlt),
              color: defaultColor,
              iconSize: 16,
            ),
          ],
        ),
      );

  Widget _chooseCustomer(
    CustomerCubit customerCubit,
    SellMedicineCubit sellMedicineCubit,
  ) {
    return Row(
      children: [
        Expanded(
          child: DropdownSearch<CustomerModel>(
            items: customerCubit.customers,
            itemAsString: (CustomerModel? u) => u!.name,
            maxHeight: 300,
            onFind: (String? filter) =>
                customerCubit.getCustomersByName(filter),
            dropdownSearchDecoration: InputDecoration(
              hintText: 'Choose a Customer',
              labelText: 'Customer',
              prefixIcon: Icon(FontAwesomeIcons.user),
              contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
              border: OutlineInputBorder(),
            ),
            onChanged: (data) {
              sellMedicineCubit.chooseCustomer(data!);
            },
            showSearchBox: true,
          ),
        ),
      ],
    );
  }

  Widget _chooseMedicine(
    BuildContext context,
    SellMedicineCubit sellMedicineCubit,
  ) {
    MedicinesCubit medicineCubit = MedicinesCubit.get(context);
    return Row(
      children: [
        Expanded(
          child: DropdownSearch<MedicineModel>(
            items: medicineCubit.medicines,
            itemAsString: (MedicineModel? u) => u!.medicineName,
            maxHeight: 300,
            onFind: (String? filter) =>
                medicineCubit.getMedicinesByName(filter),
            dropdownSearchDecoration: InputDecoration(
              hintText: 'Choose a Medicine',
              labelText: 'Medicine',
              prefixIcon: Icon(FontAwesomeIcons.bookMedical),
              contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
              border: OutlineInputBorder(),
            ),
            onChanged: (data) {
              if (data != null) {
                sellMedicineCubit.chooseItem(data);
              }
            },
            key: medicineKey,
            showSearchBox: true,
          ),
        ),
      ],
    );
  }
}
