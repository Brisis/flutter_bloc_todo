import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/blocs/todos/todos_bloc.dart';
import 'package:flutter_bloc_todo/blocs/todos_filter/todos_filter_bloc.dart';
import 'package:flutter_bloc_todo/models/todos_model.dart';
import 'package:flutter_bloc_todo/screens/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TodosBloc()
            ..add(
              LoadTodos(
                todos: [
                  Todo(
                    id: "1",
                    task: "Sample Todo 1",
                    description: "This is a test demo",
                  ),
                  Todo(
                    id: "2",
                    task: "Sample Todo 2",
                    description: "This is a test demo",
                  ),
                ],
              ),
            ),
        ),
        BlocProvider(
          create: (context) => TodosFilterBloc(
            todosBloc: BlocProvider.of<TodosBloc>(context),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Bloc",
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xFF000A1F),
          appBarTheme: const AppBarTheme(
            color: Color(0xFF000A1F),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
