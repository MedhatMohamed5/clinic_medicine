abstract class MedicinesStates {}

class InitMedicinesState extends MedicinesStates {}

class LoadingMedicinesState extends MedicinesStates {}

class SuccessMedicinesState extends MedicinesStates {}

class ErrorMedicinesState extends MedicinesStates {
  final String? error;

  ErrorMedicinesState(this.error);
}

class LoadingGetMedicinesState extends MedicinesStates {}

class SuccessGetMedicinesState extends MedicinesStates {}

class ErrorGetMedicinesState extends MedicinesStates {
  final String? error;

  ErrorGetMedicinesState(this.error);
}

class LoadingAddMedicinesState extends LoadingMedicinesState {}

class SuccessAddMedicinesState extends SuccessMedicinesState {}

class ErrorAddMedicinesState extends ErrorMedicinesState {
  final String? error;

  ErrorAddMedicinesState(this.error) : super(error);
}

class SelectMedicineImageSuccessState extends SuccessMedicinesState {}

class SelectMedicineImageErrorState extends ErrorMedicinesState {
  final String? error;

  SelectMedicineImageErrorState(this.error) : super(error);
}

class UploadMedicineImageSuccessState extends SuccessMedicinesState {}

class UploadMedicineImageErrorState extends ErrorMedicinesState {
  final String? error;

  UploadMedicineImageErrorState(this.error) : super(error);
}

class MedicineImageRemoveState extends SuccessMedicinesState {}
