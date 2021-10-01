abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginShowPasswordState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {}

class LoginErrorState extends LoginStates {
  final String error;

  LoginErrorState(this.error);
}
