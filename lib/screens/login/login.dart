import 'package:campus_clubs/providers/feedback.dart';
import 'package:campus_clubs/providers/firestore.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _form = GlobalKey<FormState>();

  bool _isLogin = true;
  String _enteredEmail = '';
  String _enteredPassword = '';

  void _submit() async {
    bool isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }

    if (!_validateEmail()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(FeedbackSystem.getInvalidEmailFeedback());
      return;
    }

    _form.currentState!.save();

    // this sends a HTTP request to firebase behind the scenes
    if (_isLogin) {
      await Firestore.loginUser(_enteredEmail, _enteredPassword);
    } else {
      setRolesForUser();
      await Firestore.createUser(_enteredEmail, _enteredPassword);
    }
  }

  bool _validateEmail() {
    return _enteredEmail.endsWith('@calbaptist.edu') &&
        _enteredEmail.length < 16;
  }

  Future<bool> _sendOTP() async {
    EmailAuth emailAuth = EmailAuth(sessionName: 'Verify Login');
    return await emailAuth.sendOtp(recipientMail: _enteredEmail, otpLength: 5);
  }

  // call when user signs up for the first time
  void setRolesForUser() {
    // if output.json has the entered email on file, retrieve club name.
    // get the club data on FS and add this person's email to admin email list
    // Make sure that if admin list is already size two,
    // remove the former president/advisor and add this user.
    // We do this by calling upload_json_to_db.dart file.
    // Make sure that the json file is up to date.
    // this may need to be done in a different file if
    // the user is already registered into the system
  }

  void setIsLogin(bool isLogin) {
    setState(() {
      _isLogin = isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _form,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 56),
              const Text('Clubs'),
              const Text('Communities that come to you'),
              const SizedBox(height: 14),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
                onSaved: (value) {
                  _enteredEmail = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Password",
                ),
                obscureText: true,
                onSaved: (value) {
                  _enteredPassword = value!;
                },
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () async {
                  bool isLoginAllowed = false;
                  if (!_isLogin) {
                    if (await _sendOTP()) {
                      isLoginAllowed = true;
                    }
                  }

                  if (isLoginAllowed) {
                    _submit();
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(FeedbackSystem.getInvalidEmailFeedback());
                  }
                },
                child: Text(_isLogin ? 'Login' : 'Signup'),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (!_isLogin) {
                        setIsLogin(true);
                      }
                    },
                    child: const Text('Login'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_isLogin) {
                        setIsLogin(false);
                      }
                    },
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
