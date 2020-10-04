import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//Import Sign In Button
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

import 'package:socialmedia_integration/Services/Auth_Services.dart';

class TwitterHome extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<TwitterHome> {
  
  @override
  Widget build(BuildContext context) {
    var authBloc = AuthService();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(80, 80),
                bottomRight: Radius.elliptical(80, 80)),
          ),
          title: Container(
              padding: EdgeInsets.fromLTRB(75, 0, 0, 0),
              child: Text(
                "Welcome",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Parisienne',
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ),
        body: Center(
            child: StreamBuilder<FirebaseUser>(
                stream: authBloc.currentUser,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        snapshot.data.displayName,
                        style: TextStyle(fontSize: 35),
                      ),
                      SizedBox(height: 20),
                      CircleAvatar(
                        radius: 120,
                        backgroundImage: NetworkImage(snapshot.data.photoUrl),
                      ),
                      SizedBox(height: 80),
                      SignInButton(Buttons.Twitter,
                          text: "Sign Out of Twitter",
                          elevation: 29,
                          padding: EdgeInsets.fromLTRB(20, 20, 0, 20),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.elliptical(50, 50))),
                          onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.popUntil(context, (route) => route.isFirst);
                      }),
                    ],
                  );
                })));
  }
}
