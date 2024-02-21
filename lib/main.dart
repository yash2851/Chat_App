import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: 'Firebase',
      options: FirebaseOptions(
          apiKey: 'AIzaSyBqWqzzu_qMJ-eSrsTaOU7QaMSv7h1-Fd0',
          appId: '1:137443114098:android:250c75b06fab743b7bd6eb',
          messagingSenderId: '137443114098',
          projectId: 'fir-f9f17'));
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin = false;

  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  signIn() async {
    try {
      setState(() {
        isLogin = true;
      });
      var auth = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: nameController.text, password: passwordController.text);
      print(auth.user!);

      await FirebaseFirestore.instance.collection("Users").doc().set({
        'Email':nameController.text,
        'Password':passwordController.text,
        'uid': auth.user!.uid
      });

      Fluttertoast.showToast(msg: 'Sign Up Sucssesfully.');
      setState(() {
        isLogin = false;
      });
    } on Exception catch (e) {
      print(e);
      if (e.toString().contains('firebase_auth/email-already-in-use')) {
        Fluttertoast.showToast(msg: 'Alredy exist');
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
                      "Sign Up",
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
                          "Sign Up",
                          style: TextStyle(fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.purple,
                        ),
                      ),
                Row(
                  children: [
                    Text(
                      'You Have Already Account',
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return LoginScreen();
                          }));
                        },
                        child: Text('LogIn'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
