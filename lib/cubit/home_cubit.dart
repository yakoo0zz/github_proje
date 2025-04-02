import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:github_proje/model/followers_model.dart';
import 'package:github_proje/model/user_model.dart';
import 'package:github_proje/model/user_repos_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final Dio dio;
  HomeCubit(this.dio) : super(HomeInitial());
  UserModel? user;
  List<FollowersModel>? userFollowers;
  List<UserReposModel>? userRepos;
  Uint8List? imageBytes;

  Future<void> fetchData(String name) async {
    emit(HomeLoading());
    final response = await dio.get("https://api.github.com/users/$name");
    if (response.statusCode == 200) {
      user = UserModel.fromJson(response.data);
      emit(HomeSuccesful(userModel: user!));
    }
  }

  Future<void> fetchFollowing(String name) async {
    emit(HomeLoading());
    final response =
        await dio.get("https://api.github.com/users/$name/followers");
    if (response.statusCode == 200) {
      userFollowers = (response.data as List)
          .map((follower) => FollowersModel.fromJson(follower))
          .toList();
      emit(FollwersLoaded(followersModel: userFollowers!));
    }
  }

  Future<void> fetchRepos(String name) async {
    emit(HomeLoading());
    final response = await dio.get("https://api.github.com/users/$name/repos");
    if (response.statusCode == 200) {
      userRepos = (response.data as List)
          .map((repo) => UserReposModel.fromJson(repo))
          .toList();
      emit(ReposLoaded(reposModel: userRepos!));
    }
  }

  Future<void> fetchPhoto(String id) async {
    emit(HomeLoading());
    final response = await dio.get(
        ("https://avatars.githubusercontent.com/u/$id?v=4"),
        options: Options(responseType: ResponseType.bytes));
    if (response.statusCode == 200) {
      imageBytes = response.data;
      emit(PhotoLoaded(imageBytes: imageBytes!)); // Yeni state ile güncelle
    }
  }

  Future<void> fetchAllData(String name) async {
    await Future.wait(
        [fetchData(name), fetchFollowing(name), fetchRepos(name)]);
    await fetchPhoto(user?.id.toString() ?? "");
  }
}
