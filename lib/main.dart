import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sout_app/bloc/songs_bloc.dart';
import 'package:sout_app/pages/home.dart';
import 'package:sout_app/repository/songs_repository.dart';
import 'package:sout_app/utlis/color_utility.dart';

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
        primaryColor: ColorUtility.main,
        appBarTheme: const AppBarTheme(
            backgroundColor: ColorUtility.background,
            foregroundColor: Colors.white),
        colorScheme:
            ColorScheme.fromSwatch(backgroundColor: ColorUtility.background),
      ),
      home: const HomePage(),
    );
  }
}
