import 'dart:io';

import 'package:clinic_medicines/cubit/drawer/drawer_cubit.dart';
import 'package:clinic_medicines/cubit/drawer/drawer_states.dart';
import 'package:clinic_medicines/cubit/general/app_cubit.dart';
import 'package:clinic_medicines/cubit/general/app_states.dart';
import 'package:clinic_medicines/screens/home/home_sub_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class MyZoomDrawer extends StatefulWidget {
  const MyZoomDrawer({Key? key}) : super(key: key);

  @override
  _MyZoomDrawerState createState() => _MyZoomDrawerState();
}

class _MyZoomDrawerState extends State<MyZoomDrawer> {
  final _drawerController = ZoomDrawerController();

  // int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DrawerCubit, DrawerStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final drawerCubit = DrawerCubit.get(context);
        return Scaffold(
          body: ZoomDrawer(
            controller: _drawerController,
            style: DrawerStyle.Style1,
            menuScreen: MenuScreen(
              drawerCubit.navScreens,
              callback: (index) {
                drawerCubit.updatePage(
                  _drawerController,
                  drawerCubit.navScreens[index - 1].navItem,
                );

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        drawerCubit.navScreens[index - 1].screen,
                  ),
                );
              },
              current: drawerCubit.currentPage.index,
            ),
            mainScreen: HomeSubScreen(),
            borderRadius: 24.0,
            showShadow: true,
            angle: 0.0,
            backgroundColor: Colors.grey.shade300,
            slideWidth: MediaQuery.of(context).size.width * 0.65,
            openCurve: Curves.fastOutSlowIn,
            closeCurve: Curves.fastOutSlowIn,
          ),
        );
      },
    );
  }
}

class MenuScreen extends StatefulWidget {
  final List<NavMenuItem> mainMenu;
  final Function(int)? callback;
  final int? current;

  MenuScreen(
    this.mainMenu, {
    Key? key,
    this.callback,
    this.current,
  });

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final widthBox = SizedBox(
    width: 16.0,
  );

  @override
  Widget build(BuildContext context) {
    final TextStyle androidStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    final TextStyle iosStyle = const TextStyle(color: Colors.white);
    final style = Platform.isAndroid ? androidStyle : iosStyle;

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Colors.indigo,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 24.0,
                      left: 24.0,
                      right: 24.0,
                    ),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                        image: AppCubit.get(context).userModel != null
                            ? DecorationImage(
                                image: NetworkImage(
                                  '${AppCubit.get(context).userModel?.image}',
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 36.0, left: 24.0, right: 24.0),
                    child: AppCubit.get(context).userModel != null
                        ? Text(
                            '${AppCubit.get(context).userModel?.name}',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          )
                        : Text(''),
                  ),
                  BlocSelector<DrawerCubit, DrawerStates, NavItem>(
                    selector: (state) {
                      // return selected state based on the provided state.
                      return state.navItem;
                    },
                    builder: (context, navItem) {
                      // return widget here based on the selected state.
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ...widget.mainMenu
                              .map(
                                (item) => MenuItemWidget(
                                  key: Key(item.index.toString()),
                                  item: item,
                                  callback: widget.callback,
                                  widthBox: widthBox,
                                  style: style,
                                  selected: navItem.index == item.index,
                                ),
                              )
                              .toList()
                        ],
                      );
                    },
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                    child: OutlinedButton(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Logout',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white, width: 2.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        textStyle: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => AppCubit.get(context).signOut(),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class MenuItemWidget extends StatelessWidget {
  final NavMenuItem? item;
  final Widget? widthBox;
  final TextStyle? style;
  final Function? callback;
  final bool? selected;

  final white = Colors.white;

  const MenuItemWidget({
    Key? key,
    this.item,
    this.widthBox,
    this.style,
    this.callback,
    this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => callback!(item!.index),
      /*style: TextButton.styleFrom(
        primary: selected! ? Color(0x44000000) : null,
      ),*/
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            item!.icon,
            color: white,
            size: 24,
          ),
          widthBox!,
          Expanded(
            child: Text(
              item!.title,
              style: style,
            ),
          )
        ],
      ),
    );
  }
}
/*
class MenuItem {
  final String title;
  final IconData icon;
  final int index;

  const MenuItem(this.title, this.icon, this.index);
}
*/
