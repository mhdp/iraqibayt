import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iraqibayt/widgets/abouts.dart';
import 'package:iraqibayt/widgets/advanced_search.dart';
import 'package:iraqibayt/widgets/favorites.dart';
import 'package:iraqibayt/widgets/fullAbout.dart';
import 'package:iraqibayt/widgets/fullTip.dart';
import 'package:iraqibayt/widgets/fullSystem.dart';
import 'package:iraqibayt/widgets/home/home.dart';
import 'package:iraqibayt/widgets/login.dart';
import 'package:iraqibayt/widgets/main_board.dart';
import 'package:iraqibayt/widgets/posts/my_post.dart';
import 'package:iraqibayt/widgets/posts/post_details.dart';
import 'package:iraqibayt/widgets/posts/posts_home.dart';
import 'package:iraqibayt/widgets/posts/update_post.dart';
import 'package:iraqibayt/widgets/profile.dart';
import 'package:iraqibayt/widgets/quizMain.dart';
import 'package:iraqibayt/widgets/quizs.dart';
import 'package:iraqibayt/widgets/register.dart';
import 'package:iraqibayt/widgets/splash.dart';
import 'package:iraqibayt/widgets/statistics.dart';
import 'package:iraqibayt/widgets/systems.dart';
import 'package:iraqibayt/widgets/tips.dart';
import 'package:iraqibayt/widgets/welcome.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iraqibayt/widgets/notes.dart';
import 'package:iraqibayt/widgets/currencies.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp().whenComplete((){
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((value) => runApp(MyApp()));
  });

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        Locale('ar', 'AE'), // OR Locale('ar', 'AE') OR Other RTL locales
      ],

      title: 'البيت العراقي',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'ArabicKufi',
      ),
      // home: MyHomePage(title: 'البيت العراقي'),
      routes: {
        '/': (context) => Splash(),
        '/Welcome': (context) => Welcome(),
        '/register': (context) => Register(),
        '/login': (context) => Login(),
        '/main_board': (context) => MainBoard(),
        '/home': (context) => Home(),
        '/posts': (context) => Posts_Home(),
        '/my_posts': (context) => MyPosts(),
        '/Posts_detalis': (context) => Posts_detalis(),
        '/update_post': (context) => UpdatePost(),
        '/notes': (context) => Notes(),
        '/currencies': (context) => Currencies(),
        '/tips': (context) => Tips(),
        '/full_tip': (context) => FullTip(),
        '/systems': (context) => Systems(),
        '/full_system': (context) => FullSystem(),
        '/abouts': (context) => Abouts(),
        '/full_about': (context) => FullAbout(),
        '/statistics': (context) => Statistics(),
        '/profile': (context) => Profile(),
        '/quizs': (context) => Quizs(),
        '/quiz_main': (context) => QuizMain(),
        '/adv_search': (context) => AdvancedSearch(),
        '/favorites': (context) => Favorites(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isAuth = false;
  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      setState(() {
        isAuth = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
