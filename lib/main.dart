import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hisnotes/View/login_view.dart';
import 'package:hisnotes/View/register_view.dart';
import 'package:hisnotes/View/verify_view.dart';

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized;
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        '/loginroute/': (context) => const LoginView(),
        '/registerroute/': (context) => const RegisterView(),
      }));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                print('email verified');
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }

            return const Text('Done');
          default:
            return const Text('loading');
        }
      },
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
    );
  }
}
