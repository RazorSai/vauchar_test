part of 'event_list_bloc.dart';

abstract class EventListState extends Equatable {
  const EventListState();
}

class EventListInitial extends EventListState {
  @override
  List<Object> get props => [];
}

class EventListLoading extends EventListState{

  @override
  // TODO: implement props
  List<Object> get props => [];

}

class EventListLoaded extends EventListState{

  final List<EventsModel> eventsList;

  const EventListLoaded(this.eventsList);

  @override
  // TODO: implement props
  List<Object> get props => [this.eventsList];

}

class NoEventList extends EventListState{

  const NoEventList();

  @override
  // TODO: implement props
  List<Object> get props => [];

}

class EventListLoadingFailed extends EventListState{

  final String message;

  const EventListLoadingFailed(this.message);

  @override
  // TODO: implement props
  List<Object> get props => [this.message];

}
