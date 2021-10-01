import 'dart:io';

import 'package:clinic_medicines/cubit/medicines/medicines_states.dart';
import 'package:clinic_medicines/models/medicine_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;

class MedicinesCubit extends Cubit<MedicinesStates> {
  MedicinesCubit() : super(InitMedicinesState());

  static MedicinesCubit get(BuildContext context) =>
      BlocProvider.of<MedicinesCubit>(context);

  ///
  /// Image Process
  ///

  final ImagePicker picker = ImagePicker();

  File? medicineImage;
  String medicineImageUrl = '';

  Future<File> compressImage(File imageFile) async {
    //File imageFile = await ImagePicker.pickImage();
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = new Math.Random().nextInt(10);
    var fileBytes = await imageFile.readAsBytes();
    Im.Image? image = Im.decodeImage(fileBytes);
    Im.Image smallerImage = Im.copyResize(image!, width: 500);
    // choose the size here, it will maintain aspect ratio
    final resizedBytes = Im.encodeJpg(smallerImage, quality: 62);

    var compressedImage = File(
      '$path/img_$rand${p.extension(imageFile.path)}',
    );
    compressedImage = await compressedImage.writeAsBytes(resizedBytes);

    return compressedImage;
  }

  Future getMedicineGalleryImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      medicineImage = File(pickedFile.path);

      print('${(await medicineImage!.length())}');
      //print(medicineImage!.path);
      emit(SelectMedicineImageSuccessState());
    } else {
      print('No Image Selected');
      emit(SelectMedicineImageErrorState('No Image Selected'));
    }
  }

  Future getMedicineCameraImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );

    if (pickedFile != null) {
      medicineImage = File(pickedFile.path);
      print('${(await medicineImage!.length())}');
      emit(SelectMedicineImageSuccessState());
    } else {
      print('No Image Selected');
      emit(SelectMedicineImageErrorState('No Image Selected'));
    }
  }

  void removeMedicineImage() {
    medicineImage = null;
    medicineImageUrl = '';
    emit(MedicineImageRemoveState());
  }

  Future<void> uploadMedicineImage(String _name) async {
    if (medicineImage != null) {
      var ref = FirebaseStorage.instance.ref().child(
            'medicines/$_name${p.extension(medicineImage!.path)}',
          );
      try {
        print('${(await medicineImage!.length())}');

        if ((await medicineImage!.length()) > 1000000) {
          medicineImage = await compressImage(medicineImage!);
        }
        await ref.putFile(medicineImage!);
        String downloadUrl = await ref.getDownloadURL();
        if (downloadUrl.isNotEmpty) {
          medicineImageUrl = downloadUrl;
          print("Mine $medicineImageUrl");
          emit(UploadMedicineImageSuccessState());
          emit(LoadingAddMedicinesState());
        } else {
          emit(UploadMedicineImageErrorState(
              'Error wihle uploading medicine image'));
        }
      } catch (err) {
        emit(UploadMedicineImageErrorState(err.toString()));
      }
    }
  }

  // Add (Edit) Medicine Function
  Future<void> addEditMedicine(MedicineModel _medicineModel) async {
    emit(LoadingAddMedicinesState());
    try {
      await uploadMedicineImage(_medicineModel.medicineName);

      final existedMedicineQuery = await FirebaseFirestore.instance
          .collection("medicines")
          .where('medicineName', isEqualTo: _medicineModel.medicineName)
          .get();

      if (existedMedicineQuery.docs.isNotEmpty) {
        final existedMedicine = await FirebaseFirestore.instance
            .collection("medicines")
            .doc(existedMedicineQuery.docs.first.id)
            .get();

        var medicineModel = MedicineModel.fromJson(
          existedMedicineQuery.docs.first.id,
          existedMedicine.data(),
        );

        medicineModel.consumerPrice = _medicineModel.consumerPrice;
        medicineModel.modifiedById = _medicineModel.modifiedById;
        medicineModel.modifiedByName = _medicineModel.modifiedByName;
        medicineModel.modifiedOn = _medicineModel.modifiedOn;
        medicineModel.imageUrl = _medicineModel.imageUrl;
        medicineModel.qty += _medicineModel.qty;
        medicineModel.price = _medicineModel.price;
        medicineModel.description = _medicineModel.description;
        medicineModel.imageUrl = medicineImageUrl.isNotEmpty
            ? medicineImageUrl
            : _medicineModel.imageUrl;

        await FirebaseFirestore.instance
            .collection("medicines")
            .doc(medicineModel.uid)
            .update(medicineModel.toJson());

        medicines
            .where((element) => element.uid == _medicineModel.uid)
            .first
            .copyFrom(medicineModel);
      } else {
        _medicineModel.imageUrl = medicineImageUrl;
        await FirebaseFirestore.instance
            .collection("medicines")
            .add(_medicineModel.toJson());
      }

      medicineImage = null;
      medicineImageUrl = '';

      emit(SuccessAddMedicinesState());
    } on FirebaseException catch (error) {
      emit(ErrorAddMedicinesState(error.message));
    } catch (err) {
      emit(ErrorAddMedicinesState(err.toString()));
    }
  }

  ///
  /// Get Medicines List
  ///
  late List<MedicineModel> medicines;
  Future<void> getMedicines() async {
    emit(LoadingGetMedicinesState());
    medicines = [];
    try {
      var medicinesQuery = await FirebaseFirestore.instance
          .collection('medicines')
          .orderBy('medicineName')
          .get();

      print(medicinesQuery.docs.length);

      if (medicinesQuery.docs.length > 0) {
        medicinesQuery.docs.map(
          (element) {
            medicines.add(MedicineModel.fromJson(element.id, element.data()));
          },
        ).toList();
        print(medicines);
      }

      emit(SuccessGetMedicinesState());
    } on FirebaseException catch (error) {
      print(error.toString());
      emit(ErrorGetMedicinesState(error.message));
    } on Exception catch (error) {
      print(error.toString());
      emit(ErrorGetMedicinesState(error.toString()));
    }
  }
}
