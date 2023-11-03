import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gestao_livros_2023/config/custom_colors.dart';
import 'package:gestao_livros_2023/pages/home_page.dart';
import 'package:gestao_livros_2023/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

FirebaseFirestore firestore = FirebaseFirestore.instance;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: CustomColors.blue,
        scaffoldBackgroundColor: CustomColors.blue,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: CustomColors.red,
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: CustomColors.blue,
        ),
        appBarTheme: const AppBarTheme(
          toolbarHeight: 72,
          centerTitle: true,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(32),
            ),
          ),
        ),
      ),
      home: const ScreenRouter(),
    );
  }
}

class ScreenRouter extends StatelessWidget {
  const ScreenRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return HomePage(
            user: snapshot.data!,
          );
        } else {
          return const LoginPage();
        }
      }),
    );
  }
}
