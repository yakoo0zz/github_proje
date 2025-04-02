import 'dart:typed_data';

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
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          print(state);
        },
        builder: (context, state) {
          HomeCubit homeCubit = context.read<HomeCubit>();

          return SingleChildScrollView(
            child: Column(
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

                TextButton.icon(
                  onPressed: () {
                    homeCubit.fetchAllData(txtController.text);
                  },
                  label: Text("Veriler"),
                  icon: Icon(Icons.format_italic_outlined),
                ),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     TextButton.icon(
                //       onPressed: () {
                //         context.read<HomeCubit>().fetchRepos(txtController.text);
                //       },
                //       icon: Icon(Icons.search_outlined),
                //       label: Text("Arama"),
                //     ),
                //     TextButton.icon(
                //       onPressed: () async {
                //         final username = txtController.text;
                //         await context.read<HomeCubit>().fetchData(username);
                //         if (!context.mounted) return;
                //         final userId =
                //             context.read<HomeCubit>().user?.id.toString() ?? "";
                //         if (userId.isNotEmpty) {
                //           await context.read<HomeCubit>().fetchPhoto(userId);
                //         }
                //       },
                //       icon: Icon(Icons.photo),
                //       label: Text("Resim"),
                //     ),
                //   ],
                // ),
                if (state is HomeLoading)
                  CircularProgressIndicator()
                else if (state is HomeError)
                  Text(state.error)
                else
                  Column(children: [
                    Text(homeCubit.user?.name ?? ""),
                    Image.memory(homeCubit.imageBytes ?? Uint8List(10)),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: homeCubit.userRepos?.length ?? 0,
                      padding: EdgeInsets.all(5),
                      itemBuilder: (context, index) =>
                          Text(homeCubit.userRepos?[index].name ?? ""),
                    )
                  ]),

                // ! state kontrolleri
                // if (state is HomeSuccesful) Text(state.userModel.name ?? ""),
                // if (state is HomeLoading) CircularProgressIndicator(),
                // if (state is FollwersLoaded)
                //   Expanded(
                //     child: ListView.builder(
                //       itemCount: state.followersModel.length,
                //       padding: EdgeInsets.symmetric(horizontal: 15),
                //       itemBuilder: (context, index) =>
                //           Text(state.followersModel[index].login ?? ""),
                //     ),
                //   )
                // else if (state is ReposLoaded)
                //   Expanded(
                //     child: ListView.builder(
                //       itemCount: state.reposModel.length,
                //       padding: EdgeInsets.symmetric(horizontal: 15),
                //       itemBuilder: (context, index) =>
                //           Text(state.reposModel[index].name ?? ""),
                //     ),
                //   ),
                // if (state is PhotoLoaded)
                //   Image.memory(state.imageBytes, width: 200, height: 200),
              ],
            ),
          );
        },
      ),
    );
  }
}
