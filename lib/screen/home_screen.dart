import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_proje/cubit/home_cubit.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final TextEditingController txtController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Column(
            children: [
              TextFormField(
                controller: txtController,
              ),
              TextButton.icon(
                onPressed: () {
                  context.read<HomeCubit>().fatchData(txtController.text);
                },
                icon: Icon(Icons.search_outlined),
                label: Text("Arama"),
              ),
            ],
          );
        },
      ),
    );
  }
}
