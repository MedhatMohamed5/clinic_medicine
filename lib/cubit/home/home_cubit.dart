import 'package:clinic_medicines/cubit/home/home_states.dart';
import 'package:clinic_medicines/screens/customers/customers_screen.dart';
import 'package:clinic_medicines/screens/medicines/medicines_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeSCreensTitle {
  final String title;
  final Widget screen;

  HomeSCreensTitle({required this.title, required this.screen});
}

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInit());

  static HomeCubit get(BuildContext context) =>
      BlocProvider.of<HomeCubit>(context);

  ///
  /// Bottom Navigation Bar
  ///
  List<Widget> navIcons = [
    Tooltip(
      message: 'Medicines',
      child: Icon(
        Icons.list,
        size: 20,
        color: Colors.white,
      ),
    ),
    Tooltip(
      message: 'Customers',
      child: Icon(
        Icons.contacts_rounded,
        size: 20,
        color: Colors.white,
      ),
    ),
  ];

  List<HomeSCreensTitle> navScreens = [
    HomeSCreensTitle(title: 'Medicines', screen: MedicinesScreen()),
    HomeSCreensTitle(title: 'Cutomers', screen: CustomersScreen()),
  ];
  int currentIndex = 0;

  void changeNavIndex(int _index) {
    currentIndex = _index;
    print(_index);
    print(navScreens[currentIndex].title);
    emit(HomeChangeBottomNav());
  }

  ///

}
