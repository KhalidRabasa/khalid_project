import 'package:convertplus/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false,home: MyApp()));

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SplashScreen(
          seconds: 5,
          navigateAfterSeconds: new AfterSplash(),
          // title: new Text('Welcome In SplashScreen',
          // style: new TextStyle(
          //   fontWeight: FontWeight.bold,
          //   fontSize: 20.0
          // ),),
          loaderColor: Colors.transparent,
          backgroundColor: Colors.white,

          // styleTextUnderTheLoader: new TextStyle(),
          // loaderColor: Colors.red
        ),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            // height: 200,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/splash_screen.jpg'),
                    fit: BoxFit.cover)),
          ),
        )
      ],
    );
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}
