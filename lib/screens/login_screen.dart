import 'package:clinic_medicines/common/components/textInput.dart';
import 'package:clinic_medicines/common/constants.dart';
import 'package:clinic_medicines/common/network/shared_pref_helper.dart';
import 'package:clinic_medicines/common/styles/colors.dart';
import 'package:clinic_medicines/cubit/general/app_cubit.dart';
import 'package:clinic_medicines/cubit/login/login_cubit.dart';
import 'package:clinic_medicines/cubit/login/login_states.dart';
import 'package:clinic_medicines/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) async {
          if (state is LoginErrorState) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is LoginSuccessState) {
            var saved = await SharedPrefHelper.saveData(
              key: 'uid',
              value: FirebaseAuth.instance.currentUser!.uid,
            );
            if (saved) {
              /*ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Logged in successfully'),
                  backgroundColor: defaultColor,
                ),
              );*/
              Fluttertoast.showToast(msg: 'Logged in successfully');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
                (route) => false,
              );
            }
          }
        },
        builder: (context, state) {
          final loginCubit = LoginCubit.get(context);
          return state is LoginLoadingState
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _buildContent(loginCubit);
        },
      ),
    );
  }

  Widget _buildContent(LoginCubit loginCubit) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Medicines',
              style: GoogleFonts.pacifico(
                color: defaultColor,
                fontSize: 48,
              ),
            ),
            SizedBox(
              height: 44,
            ),
            textInput(
              controller: emailController,
              hintText: 'Email',
              keyboardType: TextInputType.emailAddress,
              label: 'Email',
              validate: (val) {
                if (val != null && !emailRegEx.hasMatch(val.trim())) {
                  return 'Please enter valid email';
                }
                return null;
              },
            ),
            SizedBox(
              height: 8,
            ),
            textInput(
              controller: passwordController,
              hintText: 'Password',
              keyboardType: TextInputType.text,
              label: 'Password',
              validate: (val) {
                if (val == null) return 'Please Enter password';
                if (val.length < 6) {
                  return 'Password must be more than 6 letters';
                }
                return null;
              },
              isPassword: loginCubit.isPassword,
              suffix: loginCubit.suffixIcon,
              suffixPressed: loginCubit.tooglePassword,
              maxLines: 1,
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              child: ElevatedButton(
                onPressed: () {
                  _login(loginCubit);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 8,
                  ),
                  child: Text(
                    'Login',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              width: double.infinity,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Didn\'t have accont?'),
                TextButton(
                  onPressed: () {},
                  child: Text('Register Now!'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _login(LoginCubit loginCubit) async {
    if (formKey.currentState!.validate()) {
      await loginCubit.userLogin(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      AppCubit.get(context).getUserData();
    }
  }
}
