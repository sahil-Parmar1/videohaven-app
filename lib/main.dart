import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:videohaven/authentication/start.dart';
import 'package:videohaven/screens/signinup.dart';
import 'package:videohaven/serverlogic/youtube_bloc.dart';
import 'videoHaven.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:videohaven/serverlogic/youtube_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';



void main() async
{
  // Initialize Hive
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Register the adapter
  Hive.registerAdapter(VideoAdapter());
  Hive.registerAdapter(ChannelDetailsAdapter());
  Hive.registerAdapter(PlaylistAdapter());
  runApp(
      BlocProvider(
        create: (context) => YoutubeBloc(),
        child: CupertinoApp(
          debugShowCheckedModeBanner: false,
          theme: CupertinoThemeData(
            brightness: Brightness.dark,
            // Enable dark mode
            primaryColor: CupertinoColors.systemIndigo,
            scaffoldBackgroundColor: CupertinoColors.black,
            barBackgroundColor: CupertinoColors.darkBackgroundGray,
            textTheme: CupertinoTextThemeData(
              primaryColor: CupertinoColors.white,
              textStyle: TextStyle(color: CupertinoColors.white),
            ),
          ),
          localizationsDelegates: const [
            DefaultCupertinoLocalizations.delegate,
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
          ],
          //home: SplashScreen(),
          home: check(),
        ),
      )
  );
}

class check extends StatefulWidget {
  const check({super.key});

  @override
  State<check> createState() => _checkState();
}

class _checkState extends State<check> {
  bool login=false;
  bool isOnline=false;
  @override
  void initState()
  {
    super.initState(); // Check internet status on initialization
    checklogin();
  }

  void checklogin()async
  {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    login=prefs.getBool('login')??false;
    setState(() {});
  }
  @override
  void dispose() {
    // Optionally, cancel any async work or cleanup resources here
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
       if(login)
         return SplashScreen();
       else
         return SignUpScreen();
  }
}


