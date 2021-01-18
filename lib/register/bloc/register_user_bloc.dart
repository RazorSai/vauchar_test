import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vauchar_test/global/repository/database_repository.dart';
import 'package:vauchar_test/register/model/register_user_model.dart';

part 'register_user_event.dart';
part 'register_user_state.dart';

class RegisterUserBloc extends Bloc<RegisterUserEvent, RegisterUserState> {
  RegisterUserBloc() : super(RegisterUserInitial());

  DatabaseRepository databaseRepository = DatabaseRepository();

  @override
  Stream<RegisterUserState> mapEventToState(
    RegisterUserEvent event,
  ) async* {
    if(event is RegisterUser){
      yield* registerUser(event.registerUserModel);
    }
  }

  Stream<RegisterUserState> registerUser(RegisterUserModel registerUserModel) async*{
    yield RegisterUserLoading();
    try{
      int userExists = await databaseRepository.userExists(registerUserModel.emailId);
      if(userExists > 0){
        yield UserExists();
      }
      else{
        int registered = await databaseRepository.registerUser(registerUserModel);
        if(registered > 0){
          yield RegistrationSuccessful();
        }
        else{
          yield RegistrationFailed("Failed to register. Please try again later");
        }
      }
    }
    catch(e){
      yield RegistrationFailed("Failed to register. Please try again later");
    }
  }

}
