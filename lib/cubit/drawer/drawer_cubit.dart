import 'package:clinic_medicines/cubit/drawer/drawer_states.dart';
import 'package:clinic_medicines/screens/customers/add_customer.dart';
import 'package:clinic_medicines/screens/medicines/add_medicine_stepper.dart';
// import 'package:clinic_medicines/screens/home_sub_screen.dart';
import 'package:clinic_medicines/screens/medicines/sell_medicine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class DrawerCubit extends Cubit<DrawerStates> {
  DrawerCubit() : super(DrawerStates(NavItem.home));

  static DrawerCubit get(BuildContext context) =>
      BlocProvider.of<DrawerCubit>(context);

  ///
  /// Drawer List
  ///
  final List<NavMenuItem> navScreens = [
    /*NavMenuItem(
      index: 0,
      screen: HomeSubScreen(),
      navItem: NavItem.home,
      title: 'Home',
      icon: Icons.home,
    ),*/
    NavMenuItem(
      index: 1,
      screen: AddMedicineScreen(),
      navItem: NavItem.addMedicine,
      title: 'Add Medicine',
      icon: Icons.medication,
    ),
    NavMenuItem(
      index: 2,
      screen: AddCustomerScreen(),
      navItem: NavItem.addCustomer,
      title: 'Add Customer',
      icon: Icons.person_add_alt,
    ),
    NavMenuItem(
      index: 3,
      screen: SellMedicineScreen(),
      navItem: NavItem.sellMedicine,
      title: 'Sell Medicine',
      icon: Icons.sell_outlined,
    ),
  ];

  NavItem currentPage = NavItem.home;

  void updatePage(ZoomDrawerController controller, NavItem navItem) {
    currentPage = navItem;
    emit(DrawerStates(navItem));
    controller.toggle!();
  }
}

class NavMenuItem {
  final int index;
  final Widget screen;
  final NavItem navItem;
  final String title;
  final IconData? icon;

  NavMenuItem({
    required this.screen,
    required this.navItem,
    required this.title,
    required this.index,
    this.icon,
  });
}
