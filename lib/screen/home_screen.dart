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
                textAlign: TextAlign.start,
              ),
              TextButton.icon(
                onPressed: () {
                  context.read<HomeCubit>().fetchFollowing(txtController.text);
                },
                icon: Icon(Icons.search_outlined),
                label: Text("Arama"),
              ),
              Text(state is HomeSuccesful ? (state.userModel.name ?? "") : ""),
              if (state is HomeLoading) CircularProgressIndicator(),
              if (state is HomeSuccesful)
                Text(state.userModel.followersUrl ?? "boş"),
              if (state is FollwersLoaded)
                Expanded(
                  child: ListView.builder(
                    itemCount: state.followersModel.length,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    itemBuilder: (context, index) =>
                        Text(state.followersModel[index].login ?? ""),
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}
