import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/screens/login_signup/otp_verfication_screen.dart';
import 'package:jaansay_public_user/widgets/loading.dart';
import 'package:jaansay_public_user/widgets/login_signup/custom_auth_button.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "login";

  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoad = false;

  Future<void> loginPhone() async {
    ///String phoneNumber = "+919481516278";

    if (controller.text.length == 10) {
      isLoad = true;
      setState(() {});
      String phoneNumber = "+91" + controller.text;

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 15),
        verificationCompleted: (AuthCredential authCredential) {
          print("Your account is successfully verified");
        },
        verificationFailed: (FirebaseAuthException authException) {
          isLoad = false;
          setState(() {});
          _scaffoldKey.currentState.showSnackBar(
              new SnackBar(content: new Text("Oops! Something went wrong")));
          print("${authException.message}");
        },
        codeSent: (String verId, [int forceCodeResent]) {
          isLoad = false;
          setState(() {});
          Navigator.of(context).pushNamed(OtpVerificationScreen.routeName,
              arguments: [verId, phoneNumber]);
        },
        codeAutoRetrievalTimeout: (String verId) {
          print("TIMEOUT");
        },
      );
    } else {
      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(content: new Text("Please enter valid phone number")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      body: isLoad
          ? Loading()
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Hero(
                      tag: "mainlogo",
                      child: Image.asset(
                        "assets/images/logo.png",
                        height: _mediaQuery.width * 0.3,
                        width: _mediaQuery.width * 0.3,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Welcome to JaanSAY!",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    "Lets get started!",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: controller,
                      onSubmitted: (val) {
                        loginPhone();
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "Phone Number",
                        hintText: "Enter your phone number",
                      ),
                    ),
                  ),
                  CustomAuthButton(
                    onTap: loginPhone,
                    title: "Login",
                  ),
                ],
              ),
            ),
    );
  }
}
