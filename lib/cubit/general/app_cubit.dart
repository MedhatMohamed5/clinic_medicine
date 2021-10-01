import 'dart:async';

import 'package:clinic_medicines/common/network/shared_pref_helper.dart';
import 'package:clinic_medicines/cubit/general/app_states.dart';
import 'package:clinic_medicines/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitState());

  static AppCubit get(BuildContext context) =>
      BlocProvider.of<AppCubit>(context);

  ///
  /// Splash Screen
  ///
  bool isSplash = true;
  Future<void> showSplash() async {
    await Future.delayed(
      Duration(seconds: 5),
    );
    isSplash = false;
    emit(AppSplashFinished());
  }

  ///
  /// User Data
  ///
  UserModel? userModel;
  bool isSignedOut = false;

  void getUserData() async {
    emit(GetUserLoadingState());
    if (FirebaseAuth.instance.currentUser != null) {
      try {
        var currentUser = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get();

        print(currentUser.id);
        print(currentUser.data());
        userModel = UserModel.fromJson(currentUser.id, currentUser.data());
        emit(GetUserSuccessState());
      } on Exception catch (error) {
        print(error.toString());
        emit(GetUserErrorState(error.toString()));
      }
    }
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    await SharedPrefHelper.removeData(key: 'uid');
    userModel = null;
    isSignedOut = true;
    emit(UserSignedOut());
  }
}
