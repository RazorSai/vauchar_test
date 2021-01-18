import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vauchar_test/create_event/bloc/create_event_bloc.dart';
import 'package:vauchar_test/event_list/model/events_model.dart';
import 'package:vauchar_test/global/global.dart';

class CreateEventScreen extends StatefulWidget {
  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {

  TextEditingController _eventNameController = TextEditingController();
  TextEditingController _eventLocationController = TextEditingController();
  TextEditingController _eventStartDateController = TextEditingController();
  TextEditingController _eventEndDateController = TextEditingController();
  TextEditingController _eventDescriptionController = TextEditingController();

  DateTime startDate = DateTime.now();

  Categories categorySelected = Categories.Seminar;

  GlobalKey<FormState> _formState = GlobalKey();

  CreateEventBloc _createEventBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createEventBloc = CreateEventBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Event",
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: BlocProvider(
            create: (_) => _createEventBloc,
            child: BlocListener<CreateEventBloc, CreateEventState>(
              listener: (context, state){
                if(state is CreateEventLoading){
                  showSnackBarLoading(context, "Registering, please wait...");
                }
                else if(state is EventCreatedSuccessfully){
                  hideSnackBar(context);
                  resetFormFields();
                  showSnackBar(context, "Event created successfully.");
                }
                else if(state is EventCreateFailed){
                  hideSnackBar(context);
                  showSnackBar(context, "Failed to register. Please try again later.");
                }
              },
              child: BlocBuilder<CreateEventBloc, CreateEventState>(
                builder: (context, state){
                  return Form(
                    key: _formState,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            controller: _eventNameController,
                            validator: (name){
                              return name == "" ? "Please enter event name" : null;
                            },
                            decoration: InputDecoration(
                              labelText: "Event Name",
                            ),
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                          child: TextFormField(
                            controller: _eventLocationController,
                            validator: (name){
                              return name == "" ? "Please enter event location" : null;
                            },
                            decoration: InputDecoration(
                              labelText: "Location",
                            ),
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _eventStartDateController,
                                  validator: (name){
                                    return name == "" ? "Please select start date." : null;
                                  },
                                  onTap: (){
                                    FocusScope.of(context).requestFocus(new FocusNode());
                                    openDatePicker(context, 1);//1 for start date
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Start Date",
                                  ),
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _eventEndDateController,
                                  validator: (name){
                                    return name == "" ? "Please select end date." : null;
                                  },
                                  onTap: (){
                                    FocusScope.of(context).requestFocus(new FocusNode());
                                    openDatePicker(context, 2);//2 for end date
                                  },
                                  decoration: InputDecoration(
                                    labelText: "End Date",
                                  ),
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                          child: TextFormField(
                            controller: _eventDescriptionController,
                            validator: (name){
                              return name == "" ? "Please enter event description" : null;
                            },
                            minLines: 2,
                            maxLines: 5,
                            decoration: InputDecoration(
                              labelText: "Description",
                            ),
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                          child: DropdownButtonFormField(
                            items: Categories.values.map((e){
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
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          createEvent();
        },
        child: Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }

  void getCategorySelected(Categories category){
    setState(() {
      categorySelected = category;
    });
  }

  void resetFormFields(){
    _eventNameController.text = "";
    _eventDescriptionController.text = "";
    _eventEndDateController.text = "";
    _eventStartDateController.text = "";
    _eventLocationController.text = "";
    setState(() {
      categorySelected = Categories.Seminar;
    });
  }

  void createEvent(){
    if(_formState.currentState.validate()){
      EventsModel createEventModel = EventsModel();

      createEventModel.eventName = _eventNameController.text;
      createEventModel.eventCategory = categorySelected.toString().split(".").last;
      createEventModel.eventDescription = _eventDescriptionController.text;
      createEventModel.eventEndDate = _eventEndDateController.text;
      createEventModel.eventStartDate = _eventStartDateController.text;
      createEventModel.eventLocation = _eventLocationController.text;

      _createEventBloc.add(CreateEvent(createEventModel));
    }
  }
  
  openDatePicker(BuildContext context, int datePickerType) async{
    
    DateTime selectedDate = await showDatePicker(
        context: context,
        initialDate: datePickerType == 1 ? DateTime.now() : startDate,
        firstDate: datePickerType == 1 ? DateTime.now() : startDate,
        lastDate: DateTime(2100)
    );

    if(selectedDate != null){
      DateFormat dateFormat = DateFormat("dd-MM-yyyy");
      if(datePickerType == 1){
        startDate = selectedDate;
        _eventStartDateController.text = dateFormat.format(selectedDate);
      }
      else{
        _eventEndDateController.text = dateFormat.format(selectedDate);
      }
      print("Date is ${selectedDate.toIso8601String()}");
    }
    
  }


  void showSnackBarLoading(BuildContext context, String message){
    Scaffold.of(context)
        .showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Text(
                    message
                ),
              ),
              CircularProgressIndicator()
            ],
          ),
          duration: Duration(hours: 22),
        )
    );
  }

  void hideSnackBar(BuildContext context){
    Scaffold.of(context).hideCurrentSnackBar();
  }

  void showSnackBar(BuildContext context, String message){
    Scaffold.of(context)
        .showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Text(
                    message
                ),
              )
            ],
          ),
          duration: Duration(seconds: 2),
        )
    );
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _createEventBloc.close();
  }
  
}

