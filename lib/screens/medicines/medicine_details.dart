import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic_medicines/common/components/image_container.dart';
import 'package:clinic_medicines/common/components/loading.dart';
import 'package:clinic_medicines/common/constants.dart';
import 'package:clinic_medicines/common/styles/colors.dart';
import 'package:clinic_medicines/cubit/medicines/medicines_cubit.dart';
import 'package:clinic_medicines/cubit/medicines/medicines_states.dart';
import 'package:clinic_medicines/models/medicine_model.dart';
import 'package:clinic_medicines/screens/medicines/add_medicine_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MedicineDetailsScreen extends StatelessWidget {
  const MedicineDetailsScreen({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MedicinesCubit, MedicinesStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final medicineCubit = MedicinesCubit.get(context);
        final medicineModel = medicineCubit.medicines
            .where((element) => element.uid == uid)
            .first;
        return (state is! LoadingMedicinesState)
            ? _medicineDetails(context, medicineModel)
            : loading();
      },
    );
  }

  Widget _itemRow(String title, String data, {Color color = defaultColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            flex: 3,
          ),
          Expanded(
            child: Text(
              data,
              style: TextStyle(
                fontSize: 20,
                color: color,
              ),
            ),
            flex: 4,
          ),
        ],
      ),
    );
  }

  Widget _medicineDetails(BuildContext context, MedicineModel medicineModel) {
    final List<Widget> details = [
      _itemRow(
        'Name: ',
        medicineModel.medicineName,
      ),
      _itemRow(
        'List Price: ',
        medicineModel.price.toStringAsFixed(2),
      ),
      _itemRow(
        'Consumer Price: ',
        medicineModel.consumerPrice.toStringAsFixed(2),
      ),
      _itemRow(
        'Available Qty: ',
        medicineModel.qty.toStringAsFixed(2),
        color: medicineModel.qty < 5 ? Colors.red : defaultColor,
      ),
      _itemRow(
        'Overall Sold Qty: ',
        medicineModel.soldQty!.toStringAsFixed(2),
      ),
      _itemRow(
        'Overall Sold Amount: ',
        medicineModel.soldAmount!.toStringAsFixed(2),
      ),
      _itemRow(
        'Added By: ',
        medicineModel.createdByName,
      ),
      _itemRow(
        'Added At: ',
        DateFormat.yMMMMd().format(medicineModel.createdOn),
      ),
      _itemRow(
        'Last Modified By: ',
        medicineModel.modifiedByName,
      ),
      _itemRow(
        'Last Modified At: ',
        DateFormat.yMMMMd().format(medicineModel.modifiedOn),
      ),
      /*
      Table(
        children: [
          TableRow(
            children: [
              Text(
                'Name',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                medicineModel.medicineName,
                style: TextStyle(
                  fontSize: 20,
                  color: defaultColor,
                ),
              ),
            ],
          )
        ],
      ),
      */
      /*DataTable(
        columns: [
          DataColumn(label: Text('RollNo')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Class')),
        ],
        rows: [
          DataRow(cells: [
            DataCell(Text('1')),
            DataCell(Text('Arya')),
            DataCell(Text('6')),
          ]),
          DataRow(cells: [
            DataCell(Text('12')),
            DataCell(Text('John')),
            DataCell(Text('9')),
          ]),
          DataRow(cells: [
            DataCell(Text('42')),
            DataCell(Text('Tony')),
            DataCell(Text('8')),
          ]),
        ],
      ),*/
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('${medicineModel.medicineName}'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: defaultColor),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddMedicineScreen(
                    medicineModel: medicineModel,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _medicineImage(medicineModel),
              SizedBox(height: 16),
              ...details
            ],
          ),
        ),
      ),
    );
  }

  Widget _medicineImage(MedicineModel medicineModel) {
    var _placeholderImage = ImageContainer(
      imageProvider: placeholderImage,
      width: double.infinity,
      height: 400,
      boxFit: BoxFit.fitHeight,
    );
    return Hero(
      tag: medicineModel.uid!,
      child: medicineModel.imageUrl!.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: medicineModel.imageUrl!,
              imageBuilder: (context, imageProvider) => ImageContainer(
                imageProvider: imageProvider,
                width: double.infinity,
                height: 400,
                boxFit: BoxFit.fitHeight,
              ),
              placeholder: (context, _) => _placeholderImage,
              errorWidget: (context, _, __) => _placeholderImage,
            )
          : _placeholderImage,
    );
  }
}
