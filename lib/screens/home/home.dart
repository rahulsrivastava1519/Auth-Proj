import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auth_pro/styles/styles.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import '../auth/sign-in.dart';
import 'package:auth_pro/widgets/round-buttons.dart';

class Chat extends StatefulWidget {
  static const String id = "CHAT";
  final FirebaseUser user;
  final userData;

  const Chat({Key key, this.user, this.userData}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final DocumentReference documentReference =
      Firestore.instance.document("data/dummy");
  String myText;

  void signOutGoogle() async {
    await googleSignIn.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => SignIn(),
      ),
    );

    print("User Sign Out");
  }

  void _add() {
    Map<String, String> data = <String, String>{
      "name": "Rahul Srivastava",
      "desc": "Flutter Developer"
    };
    documentReference.setData(data).whenComplete(() {
      _showDialog('Document Added');
    }).catchError((e) => print(e));
  }

  void _delete() {
     documentReference.delete().whenComplete(() {
      print("Deleted Successfully");
      setState(() {});
      _showDialog('Deleted Successfully');
    }).catchError((e) => print(e));
  }

  void _update() {
    Map<String, String> data = <String, String>{
      "name": "Rahul Srivastava Updated",
      "desc": "Flutter Developer Updated"
    };
    documentReference.updateData(data).whenComplete(() {
      print("Document Updated");
      _showDialog('Document Updated');
    }).catchError((e) => print(e));
  }

  void _fetch() {
    documentReference.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        setState(() {
          myText = "";
          myText = datasnapshot.data['desc'];
        });
      }
    });
  }

  static final TwitterLogin twitterLogin = new TwitterLogin(
    consumerKey: '1OR06t702rtEEMGEDhe5Lfxpd',
    consumerSecret: 'vw7jKpy45DlE8Y0wpB5o886olhTgwsfFbLoRTmftWRGQ1qQwnT',
  );

  String _message = 'Logged out.';

  void _twitterLogout() async {
    await twitterLogin.logOut();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => SignIn(),
      ),
    );

    setState(() {
      _message = 'Logged out.';
    });
  }

  static final FacebookLogin facebookSignIn = new FacebookLogin();

  Future<Null> _facebookLogOut() async {
    await facebookSignIn.logOut();
    _showMessage('Logged out.');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => SignIn(),
      ),
    );
  }

  void _showMessage(String message) {
    setState(() {
      message = message;
    });
  }

  void _showDialog(String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Auth Pro"),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => SignIn(),
                  ),
                );
              },
            )
          ],
        ),
        body: Container(
            alignment: AlignmentDirectional.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
//            ClipOval(
//              child: Image.network("${widget.userData['picture']['data']['height']['url']}"),
//            ),
                Text(
                  "Welcome",
                  style: textPrimaryTextSR(),
                ),
                widget.user != null
                    ? Text(
                        "${widget.user.email}",
                        style: textPrimaryTextSR(),
                      )
                    : Text(
                        "${widget.userData}",
                        style: textPrimaryTextSR(),
                      ),
//            Text("welcome ${widget.user.email}", style: textPrimaryTextSR(),),

                RawMaterialButton(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  onPressed: signOutGoogle,
                  child: RoundButton(
                    title: "Sign out google",
                    color1: primaryDark,
                    color2: primaryLight,
                  ),
                ),
                RawMaterialButton(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  onPressed: _facebookLogOut,
                  child: RoundButton(
                    title: "Sign out Facebook",
                    color1: primaryDark,
                    color2: primaryLight,
                  ),
                ),
                RawMaterialButton(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  onPressed: _twitterLogout,
                  child: RoundButton(
                    title: "Sign out Twitter",
                    color1: primaryDark,
                    color2: primaryLight,
                  ),
                ),
                RawMaterialButton(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  onPressed: _add,
                  child: RoundButton(
                    title: "Add",
                    color1: primaryDark,
                    color2: primaryLight,
                  ),
                ),
                RawMaterialButton(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  onPressed: _update,
                  child: RoundButton(
                    title: "Update",
                    color1: primaryDark,
                    color2: primaryLight,
                  ),
                ),
                RawMaterialButton(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  onPressed: _delete,
                  child: RoundButton(
                    title: "Delete",
                    color1: primaryDark,
                    color2: primaryLight,
                  ),
                ),
                RawMaterialButton(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  onPressed: _fetch,
                  child: RoundButton(
                    title: "Fetch",
                    color1: primaryDark,
                    color2: primaryLight,
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.all(10.0),
                ),
                myText == null
                    ? new Container()
                    : new Text(
                        myText,
                        style: new TextStyle(fontSize: 20.0),
                      )
              ],
            )));
  }
}
