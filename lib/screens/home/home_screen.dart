import 'package:clinic_medicines/common/components/drawer_widget.dart';
import 'package:clinic_medicines/common/network/shared_pref_helper.dart';
import 'package:clinic_medicines/common/styles/colors.dart';
import 'package:clinic_medicines/cubit/general/app_cubit.dart';
import 'package:clinic_medicines/cubit/general/app_states.dart';
// import 'package:clinic_medicines/cubit/home/home_cubit.dart';
// import 'package:clinic_medicines/cubit/home/home_states.dart';
// import 'package:clinic_medicines/screens/home_sub_screen.dart';
import 'package:clinic_medicines/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) async {
        if (state is UserSignedOut) {
          var deleted = await SharedPrefHelper.removeData(
            key: 'uid',
          );
          if (deleted) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Signned Out'),
                backgroundColor: defaultColor,
              ),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
              (route) => false,
            );
          }
        }
      },
      builder: (context, state) {
        return MyZoomDrawer(); //_homeCubitConsumer();
      },
    );
  }

  /*Widget _homeCubitConsumer() {
    return HomeSubScreen();
  }*/
}
