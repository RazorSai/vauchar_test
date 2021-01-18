import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vauchar_test/event_list/model/events_model.dart';
import 'package:vauchar_test/global/repository/database_repository.dart';

part 'create_event_event.dart';
part 'create_event_state.dart';

class CreateEventBloc extends Bloc<CreateEventEvent, CreateEventState> {
  CreateEventBloc() : super(CreateEventInitial());

  DatabaseRepository databaseRepository = DatabaseRepository();

  @override
  Stream<CreateEventState> mapEventToState(
    CreateEventEvent event,
  ) async* {
    if(event is CreateEvent){
      yield* createEvent(event.eventsModel);
    }
  }

  Stream<CreateEventState> createEvent(EventsModel eventsModel) async*{
    yield CreateEventLoading();
    try{
      int eventCreated = await databaseRepository.createEvent(eventsModel);
      if(eventCreated > 0){
        yield EventCreatedSuccessfully();
      }
      else{
        yield EventCreateFailed();
      }
    }catch(e){
      yield EventCreateFailed();
    }
  }

}
