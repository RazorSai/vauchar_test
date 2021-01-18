part of 'create_event_bloc.dart';

abstract class CreateEventEvent extends Equatable {
  const CreateEventEvent();
}

class CreateEvent extends CreateEventEvent{

  final EventsModel eventsModel;

  const CreateEvent(this.eventsModel);

  @override
  List<Object> get props => [this.eventsModel];
}
