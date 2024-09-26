part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class SignInUser extends UserEvent {
  final UserModel params;
  SignInUser(this.params);
}

class SignUpUser extends UserEvent {
  final SignUpParams params;
  SignUpUser(this.params);
}

class SignOutUser extends UserEvent {}

class CheckUser extends UserEvent {}

class UpdateUser extends UserEvent {
  final UserModel params;
  UpdateUser(this.params);
}
