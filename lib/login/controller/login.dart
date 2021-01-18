import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vauchar_test/event_list/controller/event_list_screen.dart';
import 'package:vauchar_test/global/helper/shared_preference_helper.dart';
import 'package:vauchar_test/login/bloc/login_user_bloc.dart';
import 'package:vauchar_test/register/controller/register.dart';
import 'package:vauchar_test/services/service_locator.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController _emailIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  SharedPreferenceHelper _sharedPreferenceHelper = locator<SharedPreferenceHelper>();

  RegExp emailRegExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  GlobalKey<FormState> _formState = GlobalKey();

  LoginUserBloc _loginUserBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loginUserBloc = LoginUserBloc();
  }

  @override
  Widget build(BuildContext context) {
    openEventsOrLogin(context);
    return Scaffold(
      body: Center(
        child: Container(
          child: BlocProvider(
            create: (_) => _loginUserBloc,
            child: BlocListener<LoginUserBloc, LoginUserState>(
              listener: (context, state){
                if(state is LoginUserLoading){
                  showSnackBarLoading(context, "Login in process, please wait...");
                }
                else if(state is LoginSuccessful){
                  hideSnackBar(context);
                  _sharedPreferenceHelper.saveBool("is_active", true);
                  openEventsListScreen(context);
                }
                else if(state is LoginFailed){
                  hideSnackBar(context);
                  showSnackBar(context, state.message ?? "Failed to login. Please try again.");
                }
                else if(state is NoUserFound){
                  hideSnackBar(context);
                  showSnackBar(context, "No user found.");
                }
              },
              child: BlocBuilder<LoginUserBloc, LoginUserState>(
                builder: (_, state){
                  return Form(
                    key: _formState,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
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
                              loginUser();
                            },
                            color: Theme.of(context).primaryColor,
                            child: Text(
                              "LOGIN",
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: RichText(
                            text: TextSpan(
                                text: "New User? ",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                                recognizer: TapGestureRecognizer()..onTap = () => {
                                  openRegistrationScreen(context)
                                },
                                children: <InlineSpan>[
                                  TextSpan(
                                      text: "Register",
                                      recognizer: TapGestureRecognizer()..onTap = () => {
                                        openRegistrationScreen(context)
                                      },
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                      )
                                  )
                                ]
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
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

  openEventsOrLogin(context) async{
    if(await _sharedPreferenceHelper.getBool("is_active")){
      openEventsListScreen(context);
    }
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

  void loginUser(){
    if(_formState.currentState.validate()){
      _loginUserBloc.add(LoginUser(_emailIdController.text, _passwordController.text));
    }
  }

  openRegistrationScreen(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder: (_){
      return RegisterScreen();
    }));
  }

}
