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
              SizedBox(height: 10),
              TextFormField(
                controller: txtController,
                decoration: InputDecoration(
                    labelText: "Kullanıcı adını giriniz",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: context.read<HomeCubit>().user?.name),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      context.read<HomeCubit>().fetchData(txtController.text);
                    },
                    icon: Icon(Icons.search_outlined),
                    label: Text("Arama"),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      final username = txtController.text;
                      await context.read<HomeCubit>().fetchData(username);
                      if (!context.mounted) return;
                      final userId =
                          context.read<HomeCubit>().user?.id.toString() ?? "";
                      if (userId.isNotEmpty) {
                        await context.read<HomeCubit>().fetchPhoto(userId);
                      }
                    },
                    icon: Icon(Icons.search_outlined),
                    label: Text("Resim"),
                  ),
                ],
              ),
              if (state is HomeSuccesful) Text(state.userModel.name ?? ""),
              if (state is HomeLoading) CircularProgressIndicator(),
              if (state is FollwersLoaded)
                Expanded(
                  child: ListView.builder(
                    itemCount: state.followersModel.length,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    itemBuilder: (context, index) =>
                        Text(state.followersModel[index].login ?? ""),
                  ),
                )
              else if (state is ReposLoaded)
                Expanded(
                  child: ListView.builder(
                    itemCount: state.reposModel.length,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    itemBuilder: (context, index) =>
                        Text(state.reposModel[index].name ?? ""),
                  ),
                ),
              if (state is PhotoLoaded)
                Image.memory(state.imageBytes, width: 200, height: 200),
            ],
          );
        },
      ),
    );
  }
}
