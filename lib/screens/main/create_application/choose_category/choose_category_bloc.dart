import 'package:test_opensource/data/data_error_helper/data_error_helper.dart';
import 'package:test_opensource/data/models/response_category_list_api_model.dart';
import 'package:test_opensource/data/models/response_registration_api_model.dart';
import 'package:test_opensource/data/models/response_sign_in_api_model.dart';
import 'package:test_opensource/data/models/response_sign_in_code_api_model.dart';
import 'package:test_opensource/data/requests/requests.dart';
import 'package:test_opensource/data/requests/requests_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// BLOC
class ChooseCategoryBloc extends Bloc<BlocEvents, BlocState> {
  ChooseCategoryBloc() : super(const BlocState());

  final Requests _requests = Requests();

  void getCategoryList() =>
      add(
        GetCategoryListGetEvent(),
      );

  @override
  Stream<BlocState> mapEventToState(BlocEvents event) async* {
    if (event is GetCategoryListGetEvent) {
      yield* _getCategoryList(

      );
    }
  }

  Stream<BlocState> _getCategoryList() async* {
    yield LoadingState();
    dynamic data = await _requests.getCategoryList();
    if (data is DataErrorHelper) {
      yield ErrorLoadingState(data);
    } else {
      yield GetCategoryListLoadedState(data);
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

class GetCategoryListLoadedState extends BlocState {
  final ResponseCategoryListAPIModel model;

  GetCategoryListLoadedState(
      this.model,
      ) : super([
    model,
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

class GetCategoryListGetEvent extends BlocEvents {}
