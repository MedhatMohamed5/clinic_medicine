import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic_medicines/common/components/image_container.dart';
import 'package:clinic_medicines/common/components/loading.dart';
import 'package:clinic_medicines/common/constants.dart';
import 'package:clinic_medicines/common/styles/colors.dart';
import 'package:clinic_medicines/cubit/medicines/medicines_cubit.dart';
import 'package:clinic_medicines/cubit/medicines/medicines_states.dart';
import 'package:clinic_medicines/models/medicine_model.dart';
import 'package:clinic_medicines/screens/medicines/medicine_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MedicinesScreen extends StatelessWidget {
  const MedicinesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MedicinesCubit, MedicinesStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final medicineCubit = MedicinesCubit.get(context);

        return (state is! LoadingMedicinesState)
            ? medicineCubit.medicines.length > 0
                ? _medicinesList(medicineCubit)
                : Center(
                    child: Text('There is no items'),
                  )
            : loading();
      },
    );
  }

  RefreshIndicator _medicinesList(MedicinesCubit medicineCubit) {
    return RefreshIndicator(
      onRefresh: medicineCubit.getMedicines,
      child: ListView.separated(
        // physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MedicineDetailsScreen(
                  uid: medicineCubit.medicines[index].uid!,
                ),
              ),
            );
          },
          child: _medicineItemView(context, medicineCubit, index),
        ),
        separatorBuilder: (context, index) => Divider(
          height: 0,
        ),
        itemCount: medicineCubit.medicines.length,
      ),
    );
  }

  Widget _medicineItemView(
    BuildContext context,
    MedicinesCubit medicineCubit,
    int index,
  ) {
    final currentItem = medicineCubit.medicines[index];
    return Padding(
      key: ValueKey(currentItem.uid),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _medicineImage(currentItem),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${currentItem.medicineName}',
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
                            TextSpan(text: 'Available Qty: '),
                            TextSpan(
                              text: '${currentItem.qty.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: currentItem.qty < 5 ? Colors.red : null,
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
                            TextSpan(text: 'Consumer Price: '),
                            TextSpan(
                              text:
                                  '${currentItem.consumerPrice.toStringAsFixed(2)}',
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

  Widget _medicineImage(MedicineModel currentItem) {
    var _placeholderImage = ImageContainer(
      imageProvider: placeholderImage,
      width: 50,
      height: 50,
    );
    return Hero(
      tag: currentItem.uid!,
      child: currentItem.imageUrl!.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: currentItem.imageUrl!,
              imageBuilder: (context, imageProvider) => ImageContainer(
                imageProvider: imageProvider,
                width: 50,
                height: 50,
              ),
              placeholder: (context, _) => _placeholderImage,
              errorWidget: (context, _, __) => _placeholderImage,
            )
          : _placeholderImage,
    );
  }

  // Widget _medicineImage(MedicineModel currentItem) {
  //   return Hero(
  //     tag: currentItem.uid!,
  //     child: Container(
  //       width: 50,
  //       height: 50,
  //       decoration: BoxDecoration(
  //         border: Border.all(
  //           width: 1.0,
  //           color: defaultColor.shade700, //Colors.blueGrey,
  //         ),
  //         shape: BoxShape.rectangle,
  //         borderRadius: BorderRadius.circular(8),
  //         image: DecorationImage(
  //           fit: BoxFit.cover,
  //           image: currentItem.imageUrl!.isNotEmpty
  //               ? CachedNetworkImageProvider(currentItem.imageUrl!)
  //               //NetworkImage(currentItem.imageUrl!)
  //               : placeholderImage as ImageProvider,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
