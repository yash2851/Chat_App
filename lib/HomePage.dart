import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Model.dart';
import 'package:firebase/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  final String name;
  final String email;
  final String type;
  final String image;
  const HomePage(
      {Key? key,
      required this.email,
      required this.type,
      required this.image,
      required this.name})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSignOut = false;
  signout() async {
    try {
      setState(() {
        isSignOut = true;
      });
      final GoogleSignInAccount? User = await GoogleSignIn().signOut();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginScreen()));
      setState(() {
        isSignOut = false;
      });
    } catch (e) {
      setState(() {
        isSignOut = false;
      });
    }
  }

  void initState() {
    getUserDataFromFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Home Page'),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: UserAccountsDrawerHeader(
                accountName: Text(
                  "${widget.name}",
                  style: TextStyle(fontSize: 18),
                ),
                accountEmail: Text("${widget.email}"),
                currentAccountPictureSize: Size.square(50),
                currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Image.network(widget.image)),
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                'SignOut',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                signout();
              },
            ),
          ],
        ),
      ),
      body: (userList.isEmpty)
          ? CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      return Text(userList[index].email!);
                    }),
              ],
            ),
    );
  }

  getUserDataFromFirebase() async {
    FirebaseFirestore.instance.collection('Users').get().then((value) {
      print(value.docs.length);
      var data = value.docs;
      data.forEach((element) {
        setState(() {
          userList.add(UserModel.fromJson(element.data()));
        });
      });
    });
  }
}
