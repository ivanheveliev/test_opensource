import 'dart:io';

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
class CreateApplicationBloc extends Bloc<BlocEvents, BlocState> {
  CreateApplicationBloc() : super(const BlocState());

  final Requests _requests = Requests();

  void sendApplication({
    required List<File> files,
    required String categoryId,
    required String descriptionProblem,
  }) =>
      add(
        SendApplicationPostEvent(
          files: files,
          categoryId: categoryId,
          descriptionProblem: descriptionProblem,
        ),
      );

  @override
  Stream<BlocState> mapEventToState(BlocEvents event) async* {
    if (event is SendApplicationPostEvent) {
      yield* _sendApplication(
        files: event.files,
        categoryId: event.categoryId,
        descriptionProblem: event.descriptionProblem,
      );
    }
  }

  Stream<BlocState> _sendApplication({
    required List<File> files,
    required String categoryId,
    required String descriptionProblem,
  }) async* {
    yield LoadingState();
    dynamic data = await _requests.sendApplication(
      files: files,
      categoryId: categoryId,
      descriptionProblem: descriptionProblem,
    );
    if (data is DataErrorHelper) {
      yield ErrorLoadingState(data);
    } else {
      yield SendApplicationLoadedState(data);
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

class SendApplicationLoadedState extends BlocState {
  final ResponseCategoryListAPIModel model;

  SendApplicationLoadedState(
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

class SendApplicationPostEvent extends BlocEvents {
  final List<File> files;
  final String categoryId;
  final String descriptionProblem;

  SendApplicationPostEvent({
    required this.files,
    required this.categoryId,
    required this.descriptionProblem,
  }) : super([
          files,
          categoryId,
          descriptionProblem,
        ]);
}
