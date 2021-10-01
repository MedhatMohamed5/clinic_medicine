abstract class CustomerState {}

class CustomerInitState extends CustomerState {}

class CustomerLoadingState extends CustomerState {}

class CustomerSuccessState extends CustomerState {}

class CustomerErrorState extends CustomerState {
  final String? error;

  CustomerErrorState(this.error);
}

class CustomerAddLoadingState extends CustomerLoadingState {}

class CustomerAddSuccessState extends CustomerSuccessState {}

class CustomerAddErrorState extends CustomerErrorState {
  final String? error;

  CustomerAddErrorState(this.error) : super(error);
}

class CustomersGetLoadingState extends CustomerLoadingState {}

class CustomersGetSuccessState extends CustomerSuccessState {}

class CustomersGetErrorState extends CustomerErrorState {
  final String? error;

  CustomersGetErrorState(this.error) : super(error);
}
