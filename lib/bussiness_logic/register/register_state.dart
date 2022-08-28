part of 'register_cubit.dart';

@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}
class PasswordVisibility extends RegisterState {}
class RegisterLoading extends RegisterState {}
class RegisterSuccess extends RegisterState {}
class RegisterError extends RegisterState {
  final String error;

  RegisterError(this.error);
}
class LoginLoading extends RegisterState {}
class LoginSuccess extends RegisterState {}
class LoginError extends RegisterState {
  final String error;

  LoginError(this.error);
}
class CreateLoading extends RegisterState {}
class CreateSuccess extends RegisterState {}
class CreateError extends RegisterState {
  final String error;

  CreateError(this.error);
}
class UserDataLoading extends RegisterState {}
class UserDataSuccess extends RegisterState {
  final UserModel userModel;

  UserDataSuccess(this.userModel);
}
class UserDataError extends RegisterState {
  final String error;

  UserDataError(this.error);
}
class UpdateUserLoading extends RegisterState {}
class UpdateUserError extends RegisterState {
  final String error;

  UpdateUserError(this.error);
}
