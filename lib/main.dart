import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_model/project_view_model.dart';
import 'views/home_view.dart';

void main()  {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProjectViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gestor de Proyectos',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomeView(),
      ),
    );
  }
}

//
