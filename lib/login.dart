import 'package:firebase/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool SignIn = false;
  bool isLogin = false;

  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  signIn() async {
    try {
      setState(() {
        isLogin = true;
      });
      var auth = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: nameController.text, password: passwordController.text);
      print(auth.user!);
      Fluttertoast.showToast(msg: 'LogIn Sucssesfully.');
      setState(() {
        isLogin = false;
      });
    } on Exception catch (e) {
      print(e);
      if (e.toString().contains('firebase_auth/invalid-credential')) {
        Fluttertoast.showToast(msg: 'Invalid Details');
        setState(() {
          isLogin = false;
        });
      } else if (e.toString().contains('firebase_auth/weak-password')) {
        Fluttertoast.showToast(msg: 'Week password');
        setState(() {
          isLogin = false;
        });
      }
    }
  }

  bool isGoogleLogin = false;
  signInWithGoogle() async {
    try {
      setState(() {
        isGoogleLogin = true;
      });
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      print(googleUser?.email);

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() {
        isGoogleLogin = false;
      });
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomePage(
                name: googleUser!.displayName!,
                email: googleUser!.email,
                type: 'GoogleLogIn',
                image: googleUser.photoUrl!,
              )));
    } catch (e) {
      setState(() {
        isGoogleLogin = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(height: 60.0),
                    Text(
                      "LogIn",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Create your account",
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Email';
                        }
                      },
                      controller: nameController,
                      decoration: InputDecoration(
                          hintText: "Email",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: Colors.purple.withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.email)),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Password';
                        }
                      },
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: "Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none),
                        fillColor: Colors.purple.withOpacity(0.1),
                        filled: true,
                        prefixIcon: Icon(Icons.password),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                  ],
                ),
                (isLogin == true)
                    ? ElevatedButton(
                        onPressed: null, child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            signIn();
                          }
                        },
                        child: Text(
                          "LogIn",
                          style: TextStyle(fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.purple,
                        ),
                      ),
                SizedBox(
                  height: 5,
                ),
                (isGoogleLogin == true)
                    ? ElevatedButton(
                        onPressed: null, child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () {
                          signInWithGoogle();
                        },
                        child: Text(
                          "Google LogIn",
                          style: TextStyle(fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.purple,
                        ),
                      ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
