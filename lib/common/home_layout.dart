import 'package:clinic_medicines/common/network/shared_pref_helper.dart';
import 'package:clinic_medicines/screens/splash_screen.dart';
import 'package:clinic_medicines/cubit/general/app_cubit.dart';
import 'package:clinic_medicines/cubit/general/app_states.dart';
import 'package:clinic_medicines/screens/home/home_screen.dart';
import 'package:clinic_medicines/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? uid = SharedPrefHelper.getData(key: 'uid') as String?;
    final Widget startWidget = uid == null ? LoginScreen() : HomeScreen();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is! AppSplashFinished && AppCubit.get(context).isSplash)
          return SplashScreen();
        return startWidget;
      },
    );
  }
}
