import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constants/colors.dart';
import 'package:flutter_todo_app/screens/home.dart';
import 'package:flutter_todo_app/screens/signup_page.dart';
import 'package:flutter_todo_app/widgets/NoScafford.dart';

import '../repositories/auth_repository.dart';

final AuthRepository _auth = AuthRepository();

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignInPageState();
  }
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late bool _success = false;
  late String _userEmail;
  late bool _loading = false;
  late bool _passwordVisible = true;

  String _errorMessage = 'ooops, Something went wrong';

  @override
  initState() {
    super.initState();
    if (_auth.currentUser != null) {
      Navigator.of(context).pushNamed('/');
    }
  }

  Future<void> _login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message!;
      });
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldNoAppBar(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text(
              'Login',
              style: TextStyle(
                  color: tdGrey,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.none,
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                ),
                labelText: 'Email',
                prefixIcon: Icon(Icons.mail),
                hintText: '',
              ),
              validator: (value) {
                if (value is String) {
                  if (value.isEmpty) {
                    return 'Type your email';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              obscureText: _passwordVisible,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.key),
                  suffixIcon: IconButton(
                    icon: _passwordVisible
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  )),
              validator: (value) {
                if (value is String) {
                  if (value.isEmpty) {
                    return 'Type a password';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                child: const Text('Login'),
                onPressed: () {
                  // It returns true if the form is valid, otherwise returns false
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a Snackbar.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.grey.shade400,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        content: const Text(
                          'Loadinggg.......',
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                    _login().then((value) {
                      setState(() {
                        _success = true;
                      });
                      if (_auth.currentUser != null) {
                        // Navigator.of(context).pushNamed('/home');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Home(title: '',)));
                      }
                    }).catchError((e) {
                      print(e.toString());
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Color.fromARGB(255, 201, 19, 15),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          content: Text(
                            _errorMessage,
                            style: const TextStyle(
                                fontSize: 24,
                                color: Color.fromARGB(255, 212, 17, 17)),
                          ),
                        ),
                      );
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                    onPressed: () {
                      // Navigator.of(context).popAndPushNamed('/splash');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage()));
                    },
                    child: const Text('Register'))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
