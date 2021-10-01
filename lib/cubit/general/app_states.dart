abstract class AppStates {}

class AppInitState extends AppStates {}

class AppSplashFinished extends AppStates {}

class GetUserLoadingState extends AppStates {}

class GetUserSuccessState extends AppStates {}

class GetUserErrorState extends AppStates {
  final String error;
  GetUserErrorState(this.error);
}

class UserSignedOut extends AppStates {}
