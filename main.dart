import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

const String deviceId = "";
const String appId = "ca-app-pub-5695244063993443~1349551010";
const String unitId = "ca-app-pub-5695244063993443/7170398492";

const String interUnitId = "ca-app-pub-5695244063993443/2500471844";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Phone Auth',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
          primaryColor: Colors.blue[600],
          accentColor: Colors.deepOrange[200],
          primaryTextTheme: TextTheme(title: TextStyle(color:Colors.white,fontFamily: 'Sofia',fontSize: 25))),
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  static final MobileAdTargetingInfo mobileAdTargetingInfo =
      new MobileAdTargetingInfo(
    testDevices: <String>[],
    keywords: <String>['kidsgame', 'atoz', '1to10'],
    childDirected: true,
  );

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  Future<FirebaseUser> _signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;

    FirebaseUser user = await _auth.signInWithGoogle(
        idToken: gSA.idToken, accessToken: gSA.accessToken);

    print("User Name : ${user.displayName}");
    return user;
  }

  void _signOut() {
    googleSignIn.signOut();
    print("User Signed out");
  }
  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  BannerAd createBannerAd() {
    return new BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        targetingInfo: mobileAdTargetingInfo,
        listener: (MobileAdEvent event) {
          print("Banner Event : $event");
        });
  }

  InterstitialAd createInterstitialAd() {
    return new InterstitialAd(
        adUnitId: InterstitialAd.testAdUnitId,
        targetingInfo: mobileAdTargetingInfo,
        listener: (MobileAdEvent event) {
          print("Interstitial Event : $event");
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    _bannerAd = createBannerAd()
      ..load()
      ..show();
    _interstitialAd = createInterstitialAd()
      ..load()
      ..show();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Sample"),
      ),
      backgroundColor: Colors.white,
      body: new Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new RaisedButton(
              onPressed: () => _signIn()
                  .then((FirebaseUser user) => print(user))
                  .catchError((e) => print(e)),
              child: new Text("Sign In"),
              color: Colors.green,
            ),
            new Padding(
              padding: const EdgeInsets.all(10.0),
            ),
            new RaisedButton(
              onPressed: _signOut,
              child: new Text("Sign out"),
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
