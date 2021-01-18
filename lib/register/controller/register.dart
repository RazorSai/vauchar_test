import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vauchar_test/event_list/controller/event_list_screen.dart';
import 'package:vauchar_test/global/helper/shared_preference_helper.dart';
import 'package:vauchar_test/register/bloc/register_user_bloc.dart';
import 'package:vauchar_test/register/model/register_user_model.dart';
import 'package:vauchar_test/services/service_locator.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  RegisterUserBloc _registerUserBloc;

  SharedPreferenceHelper _sharedPreferenceHelper = locator<SharedPreferenceHelper>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  RegExp emailRegExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  GlobalKey<FormState> _formState = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._registerUserBloc = RegisterUserBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: BlocProvider(
            create: (_) => _registerUserBloc,
            child: BlocListener<RegisterUserBloc, RegisterUserState>(
              listener: (context, state){
                if(state is RegisterUserLoading){
                  showSnackBarLoading(context, "Registering, please wait...");
                }
                else if(state is RegistrationSuccessful){
                  hideSnackBar(context);
                  showSnackBar(context, "Registration done.");
                  _sharedPreferenceHelper.saveBool("is_active", true);
                  openEventsListScreen(context);
                }
                else if(state is RegistrationFailed){
                  hideSnackBar(context);
                  showSnackBar(context, state.message ?? "Failed to register. Please try again later.");
                }
                else if(state is UserExists){
                  hideSnackBar(context);
                  showSnackBar(context, "User is already registered with the email id.");
                }
              },
              child: BlocBuilder<RegisterUserBloc, RegisterUserState>(
                builder: (context, state){
                  return Form(
                    key: _formState,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            controller: _nameController,
                            validator: (name){
                              return name == "" ? "Please enter name" : null;
                            },
                            decoration: InputDecoration(
                              labelText: "Name",
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
                            controller: _emailIdController,
                            decoration: InputDecoration(
                              labelText: "Email Id",
                            ),
                            validator: (email){
                              if(email == ""){
                                return "Please enter email id";
                              }
                              if(!emailRegExp.hasMatch(email)){
                                return "Please enter valid email id";
                              }
                              return null;
                            },
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                          child: TextFormField(
                            controller: _passwordController,
                            validator: (password){
                              return password == "" ? "Please enter password" : null;
                            },
                            decoration: InputDecoration(
                              labelText: "Password",
                            ),
                            obscureText: true,
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                          child: RaisedButton(
                            onPressed: (){
                              registerUser();
                            },
                            color: Theme.of(context).primaryColor,
                            child: Text(
                              "REGISTER",
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
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
    );
  }

  void registerUser(){
    if(_formState.currentState.validate()){
      RegisterUserModel registerUserModel = RegisterUserModel();
      registerUserModel.name = _nameController.text;
      registerUserModel.emailId = _emailIdController.text;
      registerUserModel.password = _passwordController.text;
      _registerUserBloc.add(RegisterUser(registerUserModel));
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

  openEventsListScreen(BuildContext context){
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_){
      return EventListScreen();
    }), (route) => false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _registerUserBloc.close();
  }

}

