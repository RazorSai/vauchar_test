import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vauchar_test/global/repository/database_repository.dart';

part 'login_user_event.dart';
part 'login_user_state.dart';

class LoginUserBloc extends Bloc<LoginUserEvent, LoginUserState> {
  LoginUserBloc() : super(LoginUserInitial());

  DatabaseRepository databaseRepository = DatabaseRepository();

  @override
  Stream<LoginUserState> mapEventToState(
    LoginUserEvent event,
  ) async* {
    if(event is LoginUser){
      yield* loginUser(event.emailId, event.password);
    }
  }

  Stream<LoginUserState> loginUser(String emailId, String password) async*{
    yield LoginUserLoading();
    try{
      int userExists = await databaseRepository.loginUser(emailId, password);
      if(userExists > 0){
        yield LoginSuccessful();
      }
      else{
        yield NoUserFound();
      }
    }catch(e){
      yield LoginFailed("Failed to login. Pleae try again later.");
    }
  }

}
