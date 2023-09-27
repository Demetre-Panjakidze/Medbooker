import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredConfirmedPassword = '';
  var _enteredUsername = '';
  var _enteredFullName = '';
  bool _isLogin = true;

  void _submit() {
    final isValid = _form.currentState!.validate();

    if (isValid) {
      _form.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const Icon(
                        Icons.health_and_safety_outlined,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.only(top: 20),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Form(
                            key: _form,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!_isLogin)
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.person),
                                      labelText: 'Full name',
                                    ),
                                    initialValue: _enteredFullName,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().length < 10) {
                                        return 'Please enter at least 10 character full name.';
                                      } else if (value.trim().length > 45) {
                                        return 'Please enter maximum of 45 character full name.';
                                      }

                                      return null;
                                    },
                                    onSaved: (newValue) {
                                      _enteredFullName = newValue!;
                                    },
                                  ),
                                if (!_isLogin)
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.person),
                                      labelText: 'Username',
                                    ),
                                    initialValue: _enteredUsername,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().length < 5) {
                                        return 'Please enter at least 5 character username.';
                                      } else if (value.trim().length > 25) {
                                        return 'Please enter maximum of 25 character username.';
                                      }

                                      return null;
                                    },
                                    onSaved: (newValue) {
                                      _enteredUsername = newValue!;
                                    },
                                  ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.alternate_email),
                                    labelText: 'Email Address',
                                  ),
                                  initialValue: _enteredEmail,
                                  keyboardType: TextInputType.emailAddress,
                                  autocorrect: false,
                                  textCapitalization: TextCapitalization.none,
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty ||
                                        !value.contains('@')) {
                                      return 'Please enter a valid email address.';
                                    }

                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    _enteredEmail = newValue!;
                                  },
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.password),
                                    labelText: 'Password',
                                  ),
                                  initialValue: _enteredPassword,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().length < 6) {
                                      return 'Please enter at least 6 character password.';
                                    } else if (value.trim().length > 30) {
                                      return 'Please enter maximum of 30 character password.';
                                    }

                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    _enteredPassword = newValue!;
                                  },
                                ),
                                if (!_isLogin)
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.password),
                                      labelText: 'Confirm Password',
                                    ),
                                    initialValue: _enteredConfirmedPassword,
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().length < 6) {
                                        return 'Please enter at least 6 character password.';
                                      } else if (value.trim().length > 30) {
                                        return 'Please enter maximum of 30 character password.';
                                      }

                                      return null;
                                    },
                                    onSaved: (newValue) {
                                      _enteredConfirmedPassword = newValue!;
                                    },
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Row(
                                    children: [
                                      TextButton(
                                        child: Text(
                                          _isLogin
                                              ? "Don't have an account ?"
                                              : "Already have an account ?",
                                        ),
                                        onPressed: () async {
                                          await Future.delayed(
                                            const Duration(
                                              milliseconds: 300,
                                            ),
                                          );
                                          setState(() {
                                            print(
                                                ',<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<');
                                            _form.currentState?.reset();
                                            _isLogin = !_isLogin;
                                          });
                                        },
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: _submit,
                                          child: _isLogin
                                              ? const Text('Sign in')
                                              : const Text('Sign up'),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
