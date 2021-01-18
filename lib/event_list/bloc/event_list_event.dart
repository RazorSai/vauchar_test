part of 'event_list_bloc.dart';

abstract class EventListEvent extends Equatable {
  const EventListEvent();
}

class EventsList extends EventListEvent{
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class EventsFilteredList extends EventListEvent{

  final String filter;

  const EventsFilteredList(this.filter);

  @override
  // TODO: implement props
  List<Object> get props => [this.filter];

}
