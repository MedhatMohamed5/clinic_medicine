// import 'package:clinic_medicines/common/components/drawer_widget.dart';
import 'package:clinic_medicines/common/styles/colors.dart';
import 'package:clinic_medicines/cubit/general/app_cubit.dart';
import 'package:clinic_medicines/cubit/home/home_cubit.dart';
import 'package:clinic_medicines/cubit/home/home_states.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class HomeSubScreen extends StatelessWidget {
  const HomeSubScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final homeCubit = HomeCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              homeCubit.navScreens[homeCubit.currentIndex].title,
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            leading: Transform.rotate(
              angle: 0.0,
              child: IconButton(
                icon: Icon(
                  Icons.menu,
                  color: defaultColor,
                ),
                onPressed: () {
                  ZoomDrawer.of(context)!.toggle();
                },
              ),
            ),
            //backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  color: defaultColor,
                ),
                onPressed: AppCubit.get(context).signOut,
              ),
            ],
          ),
          body: homeCubit.navScreens[homeCubit.currentIndex].screen,
          bottomNavigationBar: CurvedNavigationBar(
            animationDuration: Duration(
              milliseconds: 500,
            ),
            animationCurve: Curves.linear,
            color: defaultColor,
            height: 55,
            backgroundColor: Colors.white,
            buttonBackgroundColor: defaultColor,
            items: homeCubit.navIcons,
            onTap: (index) {
              homeCubit.changeNavIndex(index);
            },
          ),
        );
      },
    );
  }
}
