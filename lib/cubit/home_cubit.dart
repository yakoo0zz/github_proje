import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:github_proje/model/followers_model.dart';
import 'package:github_proje/model/user_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final Dio dio;
  HomeCubit(this.dio) : super(HomeInitial());
  UserModel? user;
  List<FollowersModel>? userFollowers;

  Future<void> fatchData(String name) async {
    emit(HomeLoading());
    final response = await dio.get("https://api.github.com/users/$name");
    if (response.statusCode == 200) {
      print(response.data);
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
}
