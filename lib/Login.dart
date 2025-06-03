// import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isAgree = false;
  
  bool isLoading = false;

  Future<void> loginUser() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pushNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Login failed') ,backgroundColor: Colors.red,),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


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
                  "Login",
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
                     
                      const SizedBox(height: 16),
                      Column(
                        children: [
                          CheckboxListTile(
                        
                            controlAffinity: ListTileControlAffinity.leading,
                            value: isAgree,
                            onChanged: (val) {
                              setState(() {
                                isAgree = val??false;
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
                              if(!isAgree){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text('Please agree to terms and conditions'),
                                  ),
                                );
                                return;
                              }
                              // await saveToPrefs();
                              await loginUser();
                              // Navigator.pushNamed(context, '/doctor');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color(0xFF6B28D1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text('SIGN UP' ,style: TextStyle(color: Colors.white),),
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
                      const Text.rich(
                        TextSpan(
                          text: "don't have account? ",
                          
                        ),
                      ),
                      ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/');
                              },
                              child: Text("Sign Up"),
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


// // ==========================================================================================================
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class Login extends StatefulWidget {
//   @override
//   State<Login> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<Login> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   bool isLoading = false;

//   Future<void> loginUser() async {
//     if (!formKey.currentState!.validate()) return;

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: emailController.text.trim(),
//         password: passwordController.text.trim(),
//       );
//       Navigator.pushNamed(context, '/home');
//     } on FirebaseAuthException catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.message ?? 'Login failed')),
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Form(
//         key: formKey,
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text("Login", style: TextStyle(fontSize: 24)),
//               SizedBox(height: 16),
//               TextFormField(
//                 controller: emailController,
//                 decoration: InputDecoration(labelText: "Email"),
//                 validator: (val) =>
//                     val == null || !val.contains('@') ? "Enter valid email" : null,
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 controller: passwordController,
//                 obscureText: true,
//                 decoration: InputDecoration(labelText: "Password"),
//                 validator: (val) => val != null && val.length < 6
//                     ? "Password too short"
//                     : null,
//               ),
//               SizedBox(height: 24),
//               isLoading
//                   ? CircularProgressIndicator()
//                   : ElevatedButton(
//                       onPressed: loginUser,
//                       child: Text("Login"),
//                     ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/register');
//                 },
//                 child: Text("Don't have an account? Sign up"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


