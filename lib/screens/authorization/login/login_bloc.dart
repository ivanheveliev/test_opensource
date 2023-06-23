import 'package:test_opensource/data/data_error_helper/data_error_helper.dart';
import 'package:test_opensource/data/models/response_sign_in_code_api_model.dart';
import 'package:test_opensource/data/requests/requests.dart';
import 'package:test_opensource/data/requests/requests_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// BLOC
class LoginBloc extends Bloc<BlocEvents, BlocState> {
  LoginBloc() : super(const BlocState());

  final Requests _requests = Requests();

  void sendPhoneNumber({
    required String number,
  }) =>
      add(SendPhoneNumberPostEvent(
        number: number,
      ));

  @override
  Stream<BlocState> mapEventToState(BlocEvents event) async* {
    if (event is SendPhoneNumberPostEvent) {
      yield* _sendPhone(
        number: event.number,
      );
    }
  }

  Stream<BlocState> _sendPhone({
    required String number,
  }) async* {
    yield LoadingState();
    dynamic data = await _requests.sendPhoneNumber(
      number: number,
    );
    if (data is DataErrorHelper) {
      yield ErrorLoadingState(data);
    } else {
      yield SendPhoneLoadedState(data);
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

class SendPhoneLoadedState extends BlocState {
  final ResponseSignInCodeAPIModel model;

  SendPhoneLoadedState(
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

class SendPhoneNumberPostEvent extends BlocEvents {
  final String number;

  SendPhoneNumberPostEvent({
    required this.number,
  }) : super([
          number,
        ]);
}
