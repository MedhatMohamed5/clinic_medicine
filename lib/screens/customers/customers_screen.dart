import 'package:clinic_medicines/common/components/loading.dart';
import 'package:clinic_medicines/common/styles/colors.dart';
import 'package:clinic_medicines/cubit/customer/customer_cubit.dart';
import 'package:clinic_medicines/cubit/customer/customer_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerCubit, CustomerState>(
      listener: (context, state) {},
      builder: (context, state) {
        final customerCubit = CustomerCubit.get(context);

        return (state is! CustomersGetLoadingState)
            ? customerCubit.customers.length > 0
                ? _customersList(customerCubit)
                : Center(
                    child: Text('There is no items'),
                  )
            : loading();
      },
    );
  }

  Widget _customersList(CustomerCubit customerCubit) {
    return RefreshIndicator(
      onRefresh: customerCubit.getCustomers,
      child: ListView.separated(
        ///Refresh indicator is not working with physics for small records
        // physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            /*Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MedicineDetailsScreen(
                  uid: customerCubit.customers[index].uid!,
                ),
              ),
            );*/
          },
          child: _customerItemView(context, customerCubit, index),
        ),
        separatorBuilder: (context, index) => Divider(
          height: 0,
        ),
        itemCount: customerCubit.customers.length,
      ),
    );
  }

  Widget _customerItemView(
      BuildContext context, CustomerCubit customerCubit, int index) {
    final currentCustomer = customerCubit.customers[index];
    final orderCount = customerCubit.numberOfOrders[currentCustomer.uid];
    return Padding(
      key: ValueKey(currentCustomer.uid),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${currentCustomer.name}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: defaultColor.shade700,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // Spacer(),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(text: 'Balance Amount: '),
                            TextSpan(
                              text:
                                  '${currentCustomer.balanceAmount?.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: currentCustomer.balanceAmount! > 5.0
                                    ? Colors.red
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(text: 'Number of Orders: '),
                            TextSpan(
                              text: '$orderCount',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
