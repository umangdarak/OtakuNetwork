import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:otaku_connect/providers/user_provider.dart';
import 'package:otaku_connect/reponsive/mobile_screen.dart';
import 'package:otaku_connect/reponsive/responsive_layout.dart';
import 'package:otaku_connect/reponsive/web_screen.dart';
import 'package:otaku_connect/screens/login_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        // ignore: prefer_const_constructors
        options: FirebaseOptions(
            apiKey: 'AIzaSyAT8JAxkJ896HRlLfcIJ6ARy5aogL4Xgik',
            appId: '1:236946858654:web:338962ca0cbebdb69a118f',
            messagingSenderId: '236946858654',
            projectId: 'otakuconnect',
            storageBucket: 'otakuconnect.appspot.com'));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'OtakuConnect',
          theme: ThemeData.dark(),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              Provider.of<UserProvider>(context, listen: false)
                  .fetchUserDetails();
              if (snapshot.connectionState == ConnectionState.active) {
                // Checking if the snapshot has any data or not
                if (snapshot.hasData) {
                  // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                  return ResponsiveLayout(
                    MobileLayout: MobileScreen(),
                    WebLayout: WebScreen(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }

              // means connection to future hasnt been made yet
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return LoginScreen();
            },
          )),
    );
  }
}
