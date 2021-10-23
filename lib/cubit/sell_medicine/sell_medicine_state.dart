abstract class SellMedicineState {}

class SellMedicineInitState extends SellMedicineState {}

class SellMedicineLoadingState extends SellMedicineState {}

class SellMedicineSuccessState extends SellMedicineState {}

class SellMedicineErrorState extends SellMedicineState {
  final String? error;

  SellMedicineErrorState(this.error);
}

class ConfirmOrderLoadingState extends SellMedicineLoadingState {}

class ConfirmOrderSuccessState extends SellMedicineSuccessState {}

class ConfirmOrderErrorState extends SellMedicineErrorState {
  final String? error;

  ConfirmOrderErrorState(this.error) : super(error);
}

class ChooseCustomerState extends SellMedicineState {}

class DeleteItemState extends SellMedicineState {}

class ChooseMedicineState extends SellMedicineState {}

class AddMedicineState extends SellMedicineState {}

class ChangeQuantityState extends SellMedicineState {}

class ChangeQuantityErrorState extends SellMedicineErrorState {
  final String? error;

  ChangeQuantityErrorState(this.error) : super(error);
}

class ChangeDiscountState extends SellMedicineState {}

class ChangePaidAmountState extends SellMedicineState {}

class ChangeNewItemState extends SellMedicineState {}
