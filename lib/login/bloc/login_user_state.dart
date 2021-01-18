part of 'login_user_bloc.dart';

abstract class LoginUserState extends Equatable {
  const LoginUserState();
}

class LoginUserInitial extends LoginUserState {
  @override
  List<Object> get props => [];
}

class LoginUserLoading extends LoginUserState{
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class NoUserFound extends LoginUserState{
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class LoginSuccessful extends LoginUserState{
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class LoginFailed extends LoginUserState{

  final String message;

  const LoginFailed(this.message);

  @override
  // TODO: implement props
  List<Object> get props => [this.message];

}
