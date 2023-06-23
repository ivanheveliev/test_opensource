import 'package:test_opensource/data/data_error_helper/data_error_helper.dart';
import 'package:test_opensource/data/models/response_application_list_api_model.dart';
import 'package:test_opensource/data/models/response_user_info_api_model.dart';
import 'package:test_opensource/data/requests/requests.dart';
import 'package:test_opensource/data/requests/requests_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// BLOC
class MainTabBloc extends Bloc<BlocEvents, BlocState> {
  MainTabBloc() : super(const BlocState());

  final Requests _requests = Requests();

  void getApplicationList() => add(
    GetMainInfoEvent(),
      );

  @override
  Stream<BlocState> mapEventToState(BlocEvents event) async* {
    if (event is GetMainInfoEvent) {
      yield* _getMainInfo();
    }
  }

  Stream<BlocState> _getMainInfo() async* {
    yield LoadingState();
    List<dynamic> responses = await Future.wait(
      [
        _requests.getApplicationList(),
        _requests.getUserInfo(),
      ],
    );
    var error = responses.whereType<DataErrorHelper>();
    if (error.isNotEmpty) {
      yield ErrorLoadingState(error.first);
    } else {
      yield GetMainInfoLoadedState(
        applicationListAPIModel: responses[0],
        userInfoAPIModel: responses[1],
      );
    }
  }
}

// STATES
@immutable
class BlocState {
  final List propsList;

  const BlocState([this.propsList = const []]);

  List<dynamic> get props => propsList;
}

class LoadingState extends BlocState {}

class GetMainInfoLoadedState extends BlocState {
  final ResponseApplicationListAPIModel applicationListAPIModel;
  final ResponseUserInfoAPIModel userInfoAPIModel;

  GetMainInfoLoadedState({
    required this.applicationListAPIModel,
    required this.userInfoAPIModel,
  }) : super([
          applicationListAPIModel,
          userInfoAPIModel,
        ]);
}

class ErrorLoadingState extends BlocState {
  final DataErrorHelper error;

  ErrorLoadingState(
    this.error,
  ) : super([
          error,
        ]);
}

// EVENTS
@immutable
abstract class BlocEvents {
  final List propsList;

  const BlocEvents([this.propsList = const []]);

  List<dynamic> get props => propsList;
}

class GetMainInfoEvent extends BlocEvents {}
