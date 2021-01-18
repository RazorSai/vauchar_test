import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vauchar_test/event_list/model/events_model.dart';
import 'package:vauchar_test/global/repository/database_repository.dart';

part 'event_list_event.dart';
part 'event_list_state.dart';

class EventListBloc extends Bloc<EventListEvent, EventListState> {
  EventListBloc() : super(EventListInitial());

  DatabaseRepository databaseRepository = DatabaseRepository();

  @override
  Stream<EventListState> mapEventToState(
    EventListEvent event,
  ) async* {
    if(event is EventsList){
      yield* getEvents();
    }
    else if (event is EventsFilteredList){
      yield* getEventsFiltered(event.filter);
    }
  }

  Stream<EventListState> getEvents() async*{
    yield EventListLoading();
    try{
      List<EventsModel> eventsList = await databaseRepository.getEvents();
      if(eventsList.length > 0){
        yield EventListLoaded(eventsList);
      }
      else{
        yield NoEventList();
      }
    }catch(e){
      yield EventListLoadingFailed("Failed to load list. Please try again later.");
    }
  }

  Stream<EventListState> getEventsFiltered(String filter) async*{
    yield EventListLoading();
    try{
      List<EventsModel> eventsList = await databaseRepository.getEventsFiltered(filter);
      if(eventsList.length > 0){
        yield EventListLoaded(eventsList);
      }
      else{
        yield NoEventList();
      }
    }catch(e){
      yield EventListLoadingFailed("Failed to load list. Please try again later.");
    }
  }

}
