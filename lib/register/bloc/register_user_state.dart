part of 'register_user_bloc.dart';

abstract class RegisterUserState extends Equatable {
  const RegisterUserState();
}

class RegisterUserInitial extends RegisterUserState {
  @override
  List<Object> get props => [];
}

class RegisterUserLoading extends RegisterUserState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class RegistrationSuccessful extends RegisterUserState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class UserExists extends RegisterUserState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class RegistrationFailed extends RegisterUserState{

  final String message;

  const RegistrationFailed(this.message);

  @override
  // TODO: implement props
  List<Object> get props => [this.message];

}
