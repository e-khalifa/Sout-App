import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sout_app/bloc/songs_bloc.dart';
import 'package:sout_app/pages/home.dart';
import 'package:sout_app/repository/songs_repository.dart';

void main() async {
  runApp(BlocProvider(
      create: (context) => SongsBloc(SongsRepository()), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sout App',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 202, 38, 27),
        appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 51, 46, 46),
            foregroundColor: Colors.white),
        colorScheme: ColorScheme.fromSwatch(
            backgroundColor: const Color.fromARGB(255, 51, 46, 46)),
      ),
      home: const HomePage(),
    );
  }
}
