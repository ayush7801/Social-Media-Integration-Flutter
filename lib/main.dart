import 'package:flutter/material.dart';
//Import Firebase Auth
import 'package:firebase_auth/firebase_auth.dart';
//import Facebook login package
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
//import Twitter login package
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
//import Google login package
import 'package:google_sign_in/google_sign_in.dart';
//import Sign in buttons
import 'package:flutter_signin_button/flutter_signin_button.dart';
//import  different Social Media Homepage
import 'package:socialmedia_integration/Facebook/fbhome.dart';
import 'package:socialmedia_integration/Twitter/twitterHome.dart';
import 'Google/GoogleHome.dart';
//import Auth services
import 'Services/Auth_Services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Social Media Integration App",
        debugShowCheckedModeBanner: false,
        home: SignInMethods());
  }
}

class SignInMethods extends StatefulWidget {
  @override
  _SignInMethodsState createState() => _SignInMethodsState();
}

class _SignInMethodsState extends State<SignInMethods> {
  final authService = AuthService();
  final FacebookLogin fb = FacebookLogin();

  Stream<FirebaseUser> get currentUser => authService.currentUser;

  loginFacebook() async {
    print("Starting facebook login");
    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email
    ]);

    switch (res.status) {
      case FacebookLoginStatus.Success:
        print("It Worked");

        //Get Token
        final FacebookAccessToken fbToken = res.accessToken;
        print("It Worked");
        //convert to auth credential
        final AuthCredential credential =
            FacebookAuthProvider.getCredential(accessToken: fbToken.token);
        //User credential to sign in with firebase
        final result = await authService.signInWithCredential(credential);
        print("${result.user.displayName} is now logged in");

        break;
      case FacebookLoginStatus.Cancel:
        print("The user canceled the login");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyApp()));
        break;
      case FacebookLoginStatus.Error:
        print("There was an error");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyApp()));
        break;
    }
  }

  //Stream<FirebaseUser> get currentUser => authService.currentUser;
  final twitterauthService = AuthService();
  loginTwitter() async {
    final twitter = TwitterLogin(
        consumerKey: '2IXTwWTBlH4F29GGbXekJPMm2',
        consumerSecret: '7ocKDQ8RjsStDgnN0ib88XR8m6heYSzxzCMBJIOwBk5oe6GAnf');

    print("Starting Twitter login");

    final TwitterLoginResult res = await twitter.authorize();
    print("yes");
    switch (res.status) {
      case TwitterLoginStatus.loggedIn:
        print("It Worked");
        var session = res.session;
        print("It Worked");

        //convert to auth credential
        final AuthCredential credential = TwitterAuthProvider.getCredential(
            authToken: session.token, authTokenSecret: session.secret);

        //User credential to sign in with firebase
        final result =
            await twitterauthService.signInWithCredential(credential);
        print("${result.user.displayName} is now logged in");
        break;
      case TwitterLoginStatus.cancelledByUser:
        debugPrint("Canceled by user " + res.status.toString());
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyApp()));
        break;
      case TwitterLoginStatus.error:
        debugPrint("There is an error " + res.errorMessage);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyApp()));
        break;
    }
  }

  //Google Sign in

  Widget build(BuildContext context) {
    final GoogleSignIn _googleAuth = GoogleSignIn();

    loginGoogle() async {
      print("Signing in to google");
      //final GoogleSignInAccount googleSignIn = await
      _googleAuth.signIn().then((googleSignIn) async {
        print("Logged in");
        final GoogleSignInAuthentication result =
            await googleSignIn.authentication;
        AuthCredential credential = GoogleAuthProvider.getCredential(
            idToken: result.idToken, accessToken: result.accessToken);
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then(
                (r) => {print("${googleSignIn.displayName} is now logged in")})
            .catchError((e) {
          print("Unable to log in " + e);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyApp()));
        });
        print("${googleSignIn.displayName} is now logged in");
        return;
      }).catchError((e) {
        print("Unable to log in " + e);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyApp()));
        return;
      });
      return;
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(80, 80),
                bottomRight: Radius.elliptical(80, 80)),
          ),
          actions: [
            Container(
              width: 46,
              margin: EdgeInsets.fromLTRB(0, 0, 80, 0),
              constraints: BoxConstraints(
                  minWidth: 0, maxWidth: 50, minHeight: 0, maxHeight: 1),
              child: SignInButton(
                Buttons.Twitter,
                onPressed: () {
                  print("presed Came here");
                  loginTwitter();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TwitterHome()));
                },
                text: "",
                shape: CircleBorder(
                    side: BorderSide(width: 0, style: BorderStyle.none)),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                elevation: 0,
              ),
            ),
            Container(
              width: 46,
              margin: EdgeInsets.fromLTRB(0, 0, 76, 0),
              constraints: BoxConstraints(
                  minWidth: 0, maxWidth: 50, minHeight: 0, maxHeight: 1),
              child: SignInButton(
                Buttons.Google,
                onPressed: () {
                  print("presed Came here");
                  loginGoogle();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => GHome()));
                },
                text: "",
                shape: CircleBorder(
                    side: BorderSide(width: 0, style: BorderStyle.none)),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                elevation: 0,
              ),
            ),
            Container(
              width: 46,
              margin: EdgeInsets.fromLTRB(0, 0, 60, 0),
              constraints: BoxConstraints(
                  minWidth: 0, maxWidth: 47, minHeight: 0, maxHeight: 0),
              child: SignInButton(
                Buttons.Facebook,
                onPressed: () {
                  print("presed Came here");
                  loginFacebook();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FBHome()));
                },
                text: "",
                shape: CircleBorder(
                    side: BorderSide(width: 0, style: BorderStyle.none)),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                elevation: 0,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blueGrey,
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            child: Text(
                " WELCOME\n to Social Media \n     Intigrator \n        App",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Parisienne',
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                )),
          ),
          SizedBox(height: 100),
          Container(
              //padding: EdgeInsets.fromLTRB(80, 18, 80, 50),
              child: SignInButton(Buttons.Google,
                  elevation: 10,
                  padding: EdgeInsets.fromLTRB(50, 12, 30, 10),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.elliptical(50, 50))),
                  onPressed: () {
            print("presed Came here");
            loginGoogle();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => GHome()));
          })),
          SizedBox(height: 30),
          Container(
              //padding: EdgeInsets.fromLTRB(80, 18, 80, 50),
              child: SignInButton(Buttons.Twitter,
                  elevation: 20,
                  padding: EdgeInsets.fromLTRB(50, 18, 30, 18),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.elliptical(50, 50))),
                  onPressed: () {
            print("presed Came here");
            loginTwitter();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TwitterHome()));
          })),
          SizedBox(height: 30),
          Container(
              //padding: EdgeInsets.fromLTRB(80, 18, 80, 50),
              child: SignInButton(Buttons.Facebook,
                  elevation: 30,
                  padding: EdgeInsets.fromLTRB(50, 18, 30, 18),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.elliptical(50, 50))),
                  onPressed: () {
            print("presed Came here");
            loginFacebook();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => FBHome()));
          })),
           SizedBox(height:70),        
          Row(mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              Icon(Icons.copyright,color: Colors.white,),
              SizedBox(width:5),
              Expanded(child:Container(
                width: double.infinity,
                
                child: Text("Ayush Tiwari",style: TextStyle(color:Colors.white),))),
              
            ]
          )
                ])));
  }
}
