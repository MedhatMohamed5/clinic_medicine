import 'package:clinic_medicines/common/bloc_observer.dart';
import 'package:clinic_medicines/common/home_layout.dart';
import 'package:clinic_medicines/common/network/shared_pref_helper.dart';
// import 'package:clinic_medicines/common/splash_screen.dart';
import 'package:clinic_medicines/common/styles/themes.dart';
import 'package:clinic_medicines/cubit/customer/customer_cubit.dart';
import 'package:clinic_medicines/cubit/drawer/drawer_cubit.dart';
import 'package:clinic_medicines/cubit/general/app_cubit.dart';
import 'package:clinic_medicines/cubit/home/home_cubit.dart';
import 'package:clinic_medicines/cubit/login/login_cubit.dart';
import 'package:clinic_medicines/cubit/medicines/medicines_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefHelper.init();

  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppCubit()
            ..getUserData()
            ..showSplash(),
        ),
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => HomeCubit(),
        ),
        BlocProvider(
          create: (context) => DrawerCubit(),
        ),
        BlocProvider(
          create: (context) => MedicinesCubit()..getMedicines(),
        ),
        BlocProvider(
          create: (context) => CustomerCubit()..getCustomers(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Clinic Medicines',
        theme: lightTheme(context),
        darkTheme: darkTheme(context),
        themeMode: ThemeMode.light,
        home: HomeLayout(),
      ),
    );
  }
}
