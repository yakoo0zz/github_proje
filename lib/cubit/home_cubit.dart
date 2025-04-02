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

  void resetDatas() {
    user = null;
    userFollowers = null;
    userRepos = null;
    imageBytes = null;
  }

  Future<void> fetchData(String name) async {
    emit(HomeLoading());

    try {
      final response = await dio.get("https://api.github.com/users/$name");
      print("ERROR ${response.data.toString()}");
      if (response.statusCode == 200) {
        user = UserModel.fromJson(response.data);
        emit(HomeSuccesful(userModel: user!));
      } else {
        resetDatas();
        emit(HomeError(
            error: response.data.toString(), statusCode: response.statusCode));
      }
    } catch (e) {
      resetDatas();
      emit(HomeError(error: e.toString()));
    }
  }

  Future<void> fetchFollowing(String name) async {
    emit(HomeLoading());

    try {
      final response =
          await dio.get("https://api.github.com/users/$name/followers");

      if (response.statusCode == 200) {
        userFollowers = (response.data as List)
            .map((follower) => FollowersModel.fromJson(follower))
            .toList();
        emit(FollwersLoaded(followersModel: userFollowers!));
      } else {
        resetDatas();
        emit(HomeError(
            error: response.data.toString(), statusCode: response.statusCode));
      }
    } catch (e) {
      resetDatas();
      emit(HomeError(error: e.toString()));
    }
  }

  Future<void> fetchRepos(String name) async {
    emit(HomeLoading());

    try {
      final response =
          await dio.get("https://api.github.com/users/$name/repos");
      if (response.statusCode == 200) {
        print("ERROR ${response.data}");
        userRepos = (response.data as List)
            .map((repo) => UserReposModel.fromJson(repo))
            .toList();
        emit(ReposLoaded(reposModel: userRepos!));
      } else {
        resetDatas();
        emit(HomeError(
            error: response.data.toString(),
            statusCode: response.statusCode ?? 0));
      }
    } catch (e) {
      resetDatas();
      emit(HomeError(error: e.toString()));
    }
  }

  Future<void> fetchPhoto(String id) async {
    emit(HomeLoading());
    try {
      final response = await dio.get(
          ("https://avatars.githubusercontent.com/u/$id?v=4"),
          options: Options(responseType: ResponseType.bytes));
      if (response.statusCode == 200) {
        imageBytes = response.data;
        emit(PhotoLoaded(imageBytes: imageBytes!));
      } else {
        resetDatas();
        emit(HomeError(
            error: response.data.toString(),
            statusCode: response.statusCode ?? 0));
      }
    } catch (e) {
      resetDatas();
      emit(HomeError(error: e.toString()));
    }
  }

  Future<void> fetchAllData(String name) async {
    try {
      await Future.wait(
          [fetchData(name), fetchFollowing(name), fetchRepos(name)]);
      if (user?.id != null) await fetchPhoto(user?.id.toString() ?? "");
    } catch (e) {
      resetDatas();
      emit(HomeError(error: e.toString()));
    }
  }
}
