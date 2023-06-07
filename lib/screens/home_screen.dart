import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_todo/blocs/todos/todos_bloc.dart';
import 'package:flutter_bloc_todo/blocs/todos_filter/todos_filter_bloc.dart';
import 'package:flutter_bloc_todo/models/todos_fliter_model.dart';
import 'package:flutter_bloc_todo/models/todos_model.dart';
import 'package:flutter_bloc_todo/screens/add_todo_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Bloc Pattern: ToDos"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddTodoScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ],
          bottom: TabBar(
            onTap: (tabIndex) {
              switch (tabIndex) {
                case 0:
                  BlocProvider.of<TodosFilterBloc>(context).add(
                    const UpdateTodos(
                      todosFilter: TodosFilter.pending,
                    ),
                  );
                  break;
                case 1:
                  BlocProvider.of<TodosFilterBloc>(context).add(
                    const UpdateTodos(
                      todosFilter: TodosFilter.completed,
                    ),
                  );
                  break;
              }
            },
            tabs: const [
              Tab(
                icon: Icon(Icons.pending),
              ),
              Tab(
                icon: Icon(Icons.add_task),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _todos("Pending Todos"),
            _todos("Completed Todos"),
          ],
        ),
      ),
    );
  }

  BlocConsumer<TodosFilterBloc, TodosFilterState> _todos(String title) {
    return BlocConsumer<TodosFilterBloc, TodosFilterState>(
      listener: (context, state) {
        if (state is TodosFilterLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "There are ${state.filteredTodos.length} To Dos in your ${state.todosFilter.toString().split(".").last}",
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is TodosFilterLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is TodosFilterLoaded) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.filteredTodos.length,
                  itemBuilder: (BuildContext context, int index) {
                    return TodoCard(
                      todo: state.filteredTodos[index],
                    );
                  },
                )
              ],
            ),
          );
        } else {
          return Text("An error ocurred!");
        }
      },
    );
  }

  // BlocBuilder<TodosFilterBloc, TodosFilterState> _todos(String title) {
  //   return BlocBuilder<TodosFilterBloc, TodosFilterState>(
  //     builder: (context, state) {
  //       if (state is TodosFilterLoading) {
  //         return const Center(child: CircularProgressIndicator());
  //       }
  //       if (state is TodosFilterLoaded) {
  //         return Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Container(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Text(
  //                   title,
  //                   style: const TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //               ListView.builder(
  //                 shrinkWrap: true,
  //                 itemCount: state.filteredTodos.length,
  //                 itemBuilder: (BuildContext context, int index) {
  //                   return TodoCard(
  //                     todo: state.filteredTodos[index],
  //                   );
  //                 },
  //               )
  //             ],
  //           ),
  //         );
  //       } else {
  //         return Text("An error ocurred!");
  //       }
  //     },
  //   );
  // }
}

class TodoCard extends StatelessWidget {
  final Todo todo;
  const TodoCard({
    super.key,
    required this.todo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${todo.id} : ${todo.task}",
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    context.read<TodosBloc>().add(
                          UpdateTodo(
                            todo: todo.copyWith(isCompleted: true),
                          ),
                        );
                  },
                  icon: const Icon(
                    Icons.add_task,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.read<TodosBloc>().add(DeleteTodo(todo: todo));
                  },
                  icon: const Icon(
                    Icons.cancel,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
