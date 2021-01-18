part of 'login_user_bloc.dart';

abstract class LoginUserEvent extends Equatable {
  const LoginUserEvent();
}

class LoginUser extends LoginUserEvent{

  final String emailId;
  final String password;

  const LoginUser(this.emailId, this.password);

  @override
  // TODO: implement props
  List<Object> get props => [this.emailId, this.password];

}
