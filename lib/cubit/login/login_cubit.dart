import 'package:clinic_medicines/common/network/shared_pref_helper.dart';
import 'package:clinic_medicines/cubit/login/login_states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(BuildContext context) =>
      BlocProvider.of<LoginCubit>(context);

  ///
  /// Show Password
  ///
  IconData suffixIcon = Icons.remove_red_eye;
  bool isPassword = true;

  void tooglePassword() {
    isPassword = !isPassword;
    suffixIcon =
        isPassword ? Icons.remove_red_eye : Icons.remove_red_eye_outlined;

    emit(LoginShowPasswordState());
  }

  ///
  /// User Login
  ///
  Future<void> userLogin({
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingState());
    try {
      var userCredintial = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredintial.user != null) {
        print(userCredintial.user.toString());

        SharedPrefHelper.saveData(
          key: 'uid',
          value: userCredintial.user?.uid,
        );

        emit(LoginSuccessState());
      } else {
        emit(
          LoginErrorState('Cann\'t sign in right now. Please try again later'),
        );
      }
      print(userCredintial);
    } on FirebaseAuthException catch (error) {
      print(error.message.toString());
      emit(LoginErrorState(error.message.toString()));
    }
  }
}
