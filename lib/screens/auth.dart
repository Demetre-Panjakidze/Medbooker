import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medbooker/enums/user_roles.dart';
import 'package:medbooker/widgets/user_image_picker.dart';

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
  File? _selectedImage;
  UserRole _chosenRole = UserRole.member;
  bool _isLogin = true;

  void _submit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }

    if (isValid) {
      _form.currentState!.save();
    }

    if (!_isLogin && _selectedImage == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please upload an image"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (!_isLogin && _enteredPassword != _enteredConfirmedPassword) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match."),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      await Future.delayed(
        const Duration(
          milliseconds: 300,
        ),
      );
      if (_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');

        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set(
          {
            'fullName': _enteredFullName,
            'displayName': _enteredUsername,
            'email': _enteredEmail,
            'photoURL': imageUrl,
            'creationTime': DateTime.now(),
            'role': getRole(_chosenRole),
            'entityNo':
                _chosenRole == UserRole.member ? 1000000001 : 1100000111,
          },
        );
      }
    } on FirebaseAuthException catch (err) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err.message ?? "Authentification failed"),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.sizeOf(context).height * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
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
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          key: _form,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                        value.trim().length < 3) {
                                      return 'Please enter at least 3 character full name.';
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
                                        value.trim().length < 3) {
                                      return 'Please enter at least 3 character username.';
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
                              if (!_isLogin)
                                const Padding(
                                  padding: EdgeInsets.only(top: 16.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Select role',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              if (!_isLogin)
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Radio<UserRole>(
                                              value: UserRole.member,
                                              groupValue: _chosenRole,
                                              onChanged: (UserRole? value) {
                                                setState(() {
                                                  _chosenRole = UserRole.member;
                                                });
                                              },
                                            ),
                                            Text(
                                              getRole(UserRole.member),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _chosenRole = UserRole.member;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Radio<UserRole>(
                                              value: UserRole.practitioner,
                                              groupValue: _chosenRole,
                                              onChanged: (UserRole? value) {
                                                setState(() {
                                                  _chosenRole =
                                                      UserRole.practitioner;
                                                });
                                              },
                                            ),
                                            Text(
                                              getRole(UserRole.practitioner),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _chosenRole = UserRole.practitioner;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              if (!_isLogin)
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: UserImagePicker(
                                      onPickedImage: (pickedImage) {
                                        _selectedImage = pickedImage;
                                      },
                                    ),
                                  ),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
