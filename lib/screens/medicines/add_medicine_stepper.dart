import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic_medicines/common/components/loading.dart';
import 'package:clinic_medicines/common/components/textInput.dart';
import 'package:clinic_medicines/common/constants.dart';
import 'package:clinic_medicines/common/styles/colors.dart';
import 'package:clinic_medicines/cubit/general/app_cubit.dart';
import 'package:clinic_medicines/cubit/medicines/medicines_cubit.dart';
import 'package:clinic_medicines/cubit/medicines/medicines_states.dart';
import 'package:clinic_medicines/models/medicine_model.dart';
import 'package:clinic_medicines/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({Key? key, this.medicineModel}) : super(key: key);

  final MedicineModel? medicineModel;

  @override
  _AddMedicineScreenState createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final formKey = GlobalKey<FormState>();

  int currentStep = 0;
  //String warning = '';
  //bool showWarning = false;
  List<int> warnings = [];

  final nameController = TextEditingController();
  final descController = TextEditingController();
  final qtyController = TextEditingController();
  final priceController = TextEditingController();
  final consumerController = TextEditingController();
  late String imageUrl;
  // final categoryController = TextEditingController();
  @override
  void initState() {
    if (widget.medicineModel != null) {
      nameController.text = widget.medicineModel!.medicineName;
      descController.text = widget.medicineModel!.description;
      qtyController.text = '0.0';
      priceController.text = widget.medicineModel!.price.toString();
      consumerController.text = widget.medicineModel!.consumerPrice.toString();
      // categoryController.text = widget.medicineModel!.consumerPrice.toString();
      imageUrl = widget.medicineModel!.imageUrl!;
    }
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    qtyController.dispose();
    priceController.dispose();
    consumerController.dispose();
    // categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MedicinesCubit, MedicinesStates>(
      listener: (context, state) {
        if (state is SuccessAddMedicinesState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('Medicine Added Successfully'),
          //     backgroundColor: defaultColor,
          //   ),
          // );
          Fluttertoast.showToast(
            msg: 'Medicine Added Successfully',
            backgroundColor: Colors.green,
          );
          // MedicinesCubit.get(context).getMedicines();
          Navigator.of(context).pop();
        } else if (state is UploadMedicineImageSuccessState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Image uploaded Successfully'),
              backgroundColor: defaultColor,
            ),
          );
        } else if (state is ErrorMedicinesState) {
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
        final medicineCubit = MedicinesCubit.get(context);
        return WillPopScope(
          onWillPop: () async {
            medicineCubit.medicineImage = null;
            medicineCubit.medicineImageUrl = '';
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text('Add Medicine'),
            ),
            body: (state is! LoadingMedicinesState)
                ? _buildForm(context, medicineCubit)
                : loading(),
          ),
        );
      },
    );
  }

  Widget _buildForm(BuildContext context, MedicinesCubit medicineCubit) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('* is a required field'),
            SizedBox(height: 8),
            if (widget.medicineModel != null) ...[
              Text(
                '- Qty you will add, will be added to the availble quantity',
              ),
              SizedBox(height: 8),
            ],
            //if (showWarning) _warningRow(),
            _stepperForm(context, medicineCubit),
          ],
        ),
      ),
    );
  }

  /*Widget _warningRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Icon(
            Icons.error_outline,
            color: Colors.red,
          ),
        ),
        Expanded(
          child: Text(
            '$warning',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () => setState(() {
            showWarning = false;
          }),
          child: Text(
            'Dismiss'.toUpperCase(),
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }*/

  Widget _stepperForm(BuildContext context, MedicinesCubit medicineCubit) {
    return Form(
      key: formKey,
      child: Stepper(
        physics: BouncingScrollPhysics(),
        type: StepperType.vertical,
        steps: _getSteps(context, medicineCubit),
        currentStep: currentStep,
        onStepContinue: () {
          final lastStep =
              currentStep == _getSteps(context, medicineCubit).length - 1;
          if (lastStep) {
            submit(medicineCubit);
          } else {
            FocusScope.of(context).unfocus();
            setState(() {
              currentStep++;
            });
          }
        },
        // : null,
        onStepCancel: currentStep != 0
            ? () {
                FocusScope.of(context).unfocus();
                setState(() {
                  currentStep--;
                });
              }
            : null,
        onStepTapped: (step) {
          FocusScope.of(context).unfocus();
          setState(() {
            currentStep = step;
          });
        },
        controlsBuilder: _controlsBuilder,
      ),
    );
  }

  Widget _controlsBuilder(context, {onStepContinue, onStepCancel}) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            child: Text(currentStep != 2 ? 'NEXT' : 'SAVE'),
            onPressed: onStepContinue,
          ),
        ),
        if (currentStep != 0)
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: ElevatedButton(
                    child: Text('PREVIOUS'),
                    onPressed: onStepCancel,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  List<Step> _getSteps(BuildContext context, MedicinesCubit medicineCubit) => [
        Step(
          state: currentStep > 0 &&
                  /*!warning.contains('Name') &&
                  !warning.contains('Desc') &&
                  !warning.contains('Category')*/
                  !warnings.contains(0)
              ? StepState.complete
              : /*warning.contains('Name') ||
                      warning.contains('Desc') ||
                      warning.contains('Category')*/
              warnings.contains(0)
                  ? StepState.error
                  : StepState.indexed,
          isActive: currentStep >= 0,
          title: Text(
            'Name, Description & Category',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: currentStep == 0 ? defaultColor : Colors.grey,
            ),
          ),
          content: _nameDesc(),
        ),
        Step(
          state: currentStep > 1 &&
                  /*!warning.contains('Price') &&
                  !warning.contains('Quantity')*/
                  !warnings.contains(1)
              ? StepState.complete
              : warnings.contains(
                      1) //warning.contains('Price') || warning.contains('Quantity')
                  ? StepState.error
                  : StepState.indexed,
          isActive: currentStep >= 1,
          title: Text(
            'Prices & Quantity',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: currentStep == 1 ? defaultColor : Colors.grey,
            ),
          ),
          content: _qtyPrice(),
        ),
        Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: Text(
            'Image (Optional)',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: currentStep == 2 ? defaultColor : Colors.grey,
            ),
          ),
          content: _buildImageCompenent(context, medicineCubit),
        ),
      ];

  Widget _nameDesc() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          textInput(
            controller: nameController,
            hintText: 'Name*',
            keyboardType: TextInputType.text,
            readOnly: widget.medicineModel != null,
            label: 'Name*',
            validate: (val) {
              if (val != null && val.trim().isEmpty) {
                //warning += 'Medicine Name \n';
                warnings.add(0);
                return 'Please Enter Medicine Name';
              }
              return null;
            },
            maxLines: 1,
          ),
          SizedBox(
            height: 8,
          ),
          textInput(
            controller: descController,
            hintText: 'Description*',
            keyboardType: TextInputType.text,
            label: 'Description*',
            validate: (val) {
              if (val != null && val.trim().isEmpty) {
                //warning += 'Medicine Description \n';
                warnings.add(0);

                return 'Please Enter Medicine Description';
              }
              return null;
            },
            maxLines: 5,
          ),
          SizedBox(
            height: 8,
          ),
          /*textInput(
            controller: categoryController,
            hintText: 'Category*',
            keyboardType: TextInputType.text,
            label: 'Category*',
            validate: (val) {
              if (val != null && val.trim().isEmpty) {
                //warning += 'Medicine Category \n';
                warnings.add(0);

                return 'Please Enter Medicine Category';
              }
              return null;
            },
            maxLines: 1,
          ),*/
        ],
      ),
    );
  }

  Widget _qtyPrice() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 12,
                child: textInput(
                  controller: priceController,
                  hintText: 'List Price*',
                  keyboardType: TextInputType.number,
                  label: 'List Price*',
                  validate: (val) {
                    if (val != null && val.trim().isEmpty) {
                      //warning += 'List Price \n';
                      warnings.add(1);

                      return 'Please Enter List Price';
                    }
                    return null;
                  },
                  maxLines: 1,
                ),
              ),
              Spacer(),
              Expanded(
                flex: 12,
                child: textInput(
                  controller: consumerController,
                  hintText: 'Consumer Price*',
                  keyboardType: TextInputType.number,
                  label: 'Consumer Price*',
                  validate: (val) {
                    if (val != null && val.trim().isEmpty) {
                      //warning += 'Consumer Price \n';
                      warnings.add(1);

                      return 'Please Enter Consumer Price';
                    }
                    return null;
                  },
                  maxLines: 1,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                flex: 12,
                child: textInput(
                  controller: qtyController,
                  hintText: 'Quantity*',
                  keyboardType: TextInputType.number,
                  label: 'Quantity*',
                  validate: (val) {
                    if (val != null && val.trim().isEmpty) {
                      //warning += 'Quantity \n';
                      warnings.add(1);

                      return 'Please Enter Quantity';
                    }
                    return null;
                  },
                  maxLines: 1,
                ),
              ),
              Spacer(
                flex: 13,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void submit(MedicinesCubit _medicinesCubit) async {
    // warning = '';
    warnings.clear();

    if (formKey.currentState!.validate()) {
      final UserModel? userModel = AppCubit.get(context).userModel;

      MedicineModel medicineModel = MedicineModel(
        uid: widget.medicineModel?.uid,
        medicineName: nameController.text.trim(),
        description: descController.text.trim(),
        price: double.tryParse(priceController.text.trim()) ?? 0.0,
        consumerPrice: double.tryParse(consumerController.text.trim()) ?? 0.0,
        qty: double.tryParse(qtyController.text.trim()) ?? 0.0,
        createdOn: DateTime.now(),
        createdByName: userModel!.name,
        createdById: userModel.uid!,
        modifiedOn: DateTime.now(),
        modifiedByName: userModel.name,
        modifiedById: userModel.uid!,
        imageUrl: widget.medicineModel?.imageUrl,
        soldAmount: widget.medicineModel?.soldAmount,
        soldQty: widget.medicineModel?.soldQty,
      );

      await _medicinesCubit.addEditMedicine(medicineModel);
    } else {
      //warning += 'is (are) required';
      //showWarning = true;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required field'),
          backgroundColor: Colors.red,
        ),
      );
      //_warningBanner();
    }
  }

  void _clearImageUrl() {
    setState(() {
      imageUrl = '';
    });
  }

  Widget _buildImageCompenent(
    BuildContext context,
    MedicinesCubit medicineCubit,
  ) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: medicineCubit.medicineImage != null
                  ? FileImage(medicineCubit.medicineImage!)
                  : widget.medicineModel != null && imageUrl.isNotEmpty
                      ? CachedNetworkImageProvider(imageUrl)
                      : placeholderImage as ImageProvider,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            medicineCubit.medicineImage != null
                ? medicineCubit.removeMedicineImage()
                : (widget.medicineModel != null && imageUrl.isNotEmpty)
                    ? _clearImageUrl()
                    : _showPicker(context, medicineCubit);
          },
          icon: CircleAvatar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            radius: 25,
            child: Icon(
              (medicineCubit.medicineImage != null) ||
                      (widget.medicineModel != null && imageUrl.isNotEmpty)
                  ? Icons.close
                  : Icons.camera_alt_outlined,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  void _showPicker(
    BuildContext context,
    MedicinesCubit medicineCubit,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.photo_library),
                  title: new Text('Photo Library'),
                  onTap: () {
                    medicineCubit.getMedicineGalleryImage();
                    Navigator.of(context).pop();
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    medicineCubit.getMedicineCameraImage();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
