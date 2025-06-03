// import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isAgree = false;

  // Future<void> saveToPrefs() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('email', emailController.text);
  //   await prefs.setString('password', passwordController.text);
  //   await prefs.setBool('agreed', isAgree);
  // }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 13, 53, 200),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(50),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "sign up",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,

                        validator: (val) {
                          if (val == "" || val == null || !val.contains("@")) {
                            return "please enter a valid email";
                          }
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Enter password',
                          suffixIcon: const Icon(Icons.visibility_off),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onSaved: (val) {},

                        validator: (val) {
                          if (val == null || val == "" || val.length < 6) {
                            return "Password must be at least 6 characters ";
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Enter confirm password',
                          suffixIcon: const Icon(Icons.visibility_off),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                          
                        validator: (val) {
                          if (val == "" || val != passwordController.text) {
                            return "password not match";
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      Column(
                        children: [
                          CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            value: isAgree,
                            onChanged: (val) {
                              setState(() {
                                isAgree = val ?? false;
                              });
                            },
                            title: const Text.rich(
                              TextSpan(
                                text:
                                    'By creating an account you have to agree with our ',
                                children: [
                                  TextSpan(
                                    text: 'Terms & Condition.',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              if (!isAgree) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please agree to terms and conditions',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                print("onAgree oneeeeeeeeeeeeeee");
                                return;
                              }

                              try {
                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                    );
                                    print("user created");
                                Navigator.pushNamed(context, '/login');
                              } on FirebaseAuthException catch (e) {
                                print("erorrrrrrrrrrrrrrr");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      e.message ?? 'Registration failed',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },

                          // onPressed: () async {
                          // if (formKey.currentState!.validate()) {
                          //   if (!isAgree) {
                          //     ScaffoldMessenger.of(context).showSnackBar(
                          //       const SnackBar(
                          //         backgroundColor: Colors.red,
                          //         content: Text(
                          //           'Please agree to terms and conditions',
                          //         ),
                          //       ),
                          //     );
                          //     return;
                          //   }
                          //   FirebaseAuth.instance
                          //       .createUserWithEmailAndPassword(
                          //     email: emailController.text,
                          //     password: passwordController.text,
                          //   );
                          //   // await saveToPrefs();
                          //   Navigator.pushNamed(context, '/login');
                          // }
                          // },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color(0xFF6B28D1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'SIGN UP',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: const [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text('Or'),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.g_mobiledata),
                        label: const Text('Continue with Google'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.facebook),
                        label: const Text(
                          'Continue with Facebook',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B5998),
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text.rich(
                        TextSpan(
                          text: "Already have account? ",
                          style: TextStyle(color: Colors.black),
                          children: [],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text("login"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
