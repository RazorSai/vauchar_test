part of 'create_event_bloc.dart';

abstract class CreateEventState extends Equatable {
  const CreateEventState();
}

class CreateEventInitial extends CreateEventState {
  @override
  List<Object> get props => [];
}

class CreateEventLoading extends CreateEventState{
  @override
  List<Object> get props => [];
}

class EventCreatedSuccessfully extends CreateEventState{
  @override
  List<Object> get props => [];
}

class EventCreateFailed extends CreateEventState{
  @override
  List<Object> get props => [];
}
