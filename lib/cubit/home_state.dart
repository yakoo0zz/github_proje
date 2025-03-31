part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeSuccesful extends HomeState {
  final UserModel userModel;

  const HomeSuccesful({required this.userModel});
}

final class FollwersLoaded extends HomeState {
  final List<FollowersModel> followersModel;

  FollwersLoaded({required this.followersModel});
}

final class ReposLoaded extends HomeState {
  final List<UserReposModel> reposModel;

  ReposLoaded({required this.reposModel});
}

final class PhotoLoaded extends HomeState {
  final Uint8List imageBytes;
  const PhotoLoaded({required this.imageBytes});
}
