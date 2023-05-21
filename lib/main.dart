import 'package:app/DatabaseHandler/DataManager.dart';
import 'package:app/screens/HomeForm.dart';
import 'package:flutter/material.dart';
import 'package:screen_loader/screen_loader.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
Future<void> main() async {
  configScreenLoader(
    loader: AlertDialog(
      title: Text('Loading..'),
    ),
    bgBlur: 80.0,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login with Signup',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<Splash> with ScreenLoader {
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _afterLayout());
  }

  _afterLayout() async {
    await DataManager().init();
    setState(() {
      _isReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isReady ? HomeForm() : Container();
  }
}
