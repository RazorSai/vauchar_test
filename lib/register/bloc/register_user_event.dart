part of 'register_user_bloc.dart';

abstract class RegisterUserEvent extends Equatable {
  const RegisterUserEvent();
}

class RegisterUser extends RegisterUserEvent{

  final RegisterUserModel registerUserModel;

  const RegisterUser(this.registerUserModel);

  @override
  // TODO: implement props
  List<Object> get props => [this.registerUserModel];

}
