import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;
import 'package:movies/modules/movie_provider.dart';
import 'package:movies/modules/movies.dart';
import 'package:movies/pages/movie_details.dart';
import 'package:movies/pages/myhome_page.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MovieProvider>(
      create: (_) => MovieProvider(),
      child: MaterialApp(
        title: 'Flutter Movies List',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
        routes: <String, WidgetBuilder>{
          '/home':
              (BuildContext context) =>
                  const MyHomePage(title: 'Flutter Demo Home Page'),
          '/movie': (BuildContext context) => const MovieDetail(),
        },
      ),
    );
  }
}
