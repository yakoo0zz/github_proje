import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final Dio dio;
  HomeCubit(this.dio) : super(HomeInitial());

  Future<void> fatchData(String name) async {
    emit(HomeLoading());
    final response = await dio.get("https://api.github.com/users/$name");
    if (response.statusCode == 200) {
      print(response.data);
      emit(HomeLoaded());
    }
  }
}
