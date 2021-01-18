import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vauchar_test/create_event/controller/create_event_screen.dart';
import 'package:vauchar_test/event_list/bloc/event_list_bloc.dart';
import 'package:vauchar_test/event_list/model/events_model.dart';
import 'package:vauchar_test/global/global.dart';

class EventListScreen extends StatefulWidget {
  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {

  EventListBloc _eventListBloc;

  List<EventsModel> eventsList = List();

  CategoriesFilter categorySelected = CategoriesFilter.All;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _eventListBloc = EventListBloc();
    getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Events"
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt, color: Colors.white),
            onPressed: (){
              filterDialog(context);
            },
          )
        ],
      ),
      body: BlocProvider(
        create: (_) => _eventListBloc,
        child: BlocListener<EventListBloc, EventListState>(
          listener: (_, _state){

          },
          child: BlocBuilder<EventListBloc, EventListState>(
            builder: (context, state){
              if(state is EventListLoading){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              else if(state is NoEventList){
                return Center(
                  child: Container(
                    child: Text(
                        "No Events created."
                    ),
                  ),
                );
              }
              else if(state is EventListLoaded){
                this.eventsList = state.eventsList;
                print("Event list length is ${state.eventsList.length}");
              }
              return ListView.builder(
                itemBuilder: (context, index){
                  EventsModel eventsModel = eventsList[index];
                  return ExpansionTile(
                    title: Wrap(
                      direction: Axis.vertical,
                      children: [
                        Text(
                          "Event : ${eventsModel.eventName}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 6.0),
                          child: Text(
                            "Location : ${eventsModel.eventLocation}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0
                            ),
                          ),
                        )
                      ],
                    ),
                    initiallyExpanded: false,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 15.0, top: 2.0, right: 15.0),
                          child: Text(
                            "Description : ${eventsModel.eventDescription}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 15.0, top: 6.0, right: 15.0),
                          child: Text(
                            "Duration : ${eventsModel.eventStartDate} To ${eventsModel.eventEndDate}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 15.0, top: 6.0, bottom: 10.0, right: 15.0),
                          child: Text(
                            "Event Type : ${eventsModel.eventCategory}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
                itemCount: eventsList.length,
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          openCreateEventPage(context);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  filterDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (dialogContext){
        return AlertDialog(
          title: Text(
            "Filter",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0
            ),
          ),
          content: Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
            child: DropdownButtonFormField(
              items: CategoriesFilter.values.map((e){
                print(e);
                return DropdownMenuItem(
                  child: Text(e.toString().split(".").last),
                  value: e,
                );
              }).toList(),
              value: categorySelected,
              onChanged: (category){
                print(category.toString());
                getCategorySelected(category);
                Navigator.of(dialogContext).pop();
              },
            ),
          ),
        );
      }
    );
  }

  void getCategorySelected(CategoriesFilter category){
    setState(() {
      categorySelected = category;
      if(category == CategoriesFilter.All){
        getEvents();
      }
      else{
        getEventsFiltered(category.toString().split(".").last);
      }
    });
  }

  Future getEvents() async{
    _eventListBloc.add(EventsList());
  }

  Future getEventsFiltered(String filter) async{
    _eventListBloc.add(EventsFilteredList(filter));
  }

  openCreateEventPage(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_){
        return CreateEventScreen();
      }
    )).then((value) => getEvents());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _eventListBloc.close();
  }

}

