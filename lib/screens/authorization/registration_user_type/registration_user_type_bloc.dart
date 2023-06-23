import 'package:test_opensource/data/data_error_helper/data_error_helper.dart';
import 'package:test_opensource/data/models/response_registration_api_model.dart';
import 'package:test_opensource/data/requests/requests.dart';
import 'package:test_opensource/data/requests/requests_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// BLOC
class RegistrationUserTypeBloc extends Bloc<BlocEvents, BlocState> {
  RegistrationUserTypeBloc() : super(const BlocState());

  final Requests _requests = Requests();

  void registerUser({
    required String number,
    required String name,
    required String type,
    required String code,
  }) =>
      add(RegisterUserPostEvent(
        number: number,
        name: name,
        type: type,
        code: code,
      ));

  @override
  Stream<BlocState> mapEventToState(BlocEvents event) async* {
    if (event is RegisterUserPostEvent) {
      yield* _registerUser(
        number: event.number,
        name: event.name,
        type: event.type,
        code: event.code,
      );
    }
  }

  Stream<BlocState> _registerUser({
    required String number,
    required String name,
    required String type,
    required String code,
  }) async* {
    yield LoadingState();
    dynamic data = await _requests.registerUser(
      number: number,
      name: name,
      type: type,
      code: code,
    );
    if (data is DataErrorHelper) {
      yield ErrorLoadingState(data);
    } else {
      yield RegisterUserLoadedState(data);
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

class RegisterUserLoadedState extends BlocState {
  final ResponseRegistrationAPIModel model;

  RegisterUserLoadedState(
    this.model,
  ) : super(
          [
            model,
          ],
        );
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

class RegisterUserPostEvent extends BlocEvents {
  final String number;
  final String name;
  final String type;
  final String code;

  RegisterUserPostEvent({
    required this.number,
    required this.name,
    required this.type,
    required this.code,
  }) : super([
          number,
          name,
          type,
    code,
        ]);
}
