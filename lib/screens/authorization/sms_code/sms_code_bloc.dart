import 'package:test_opensource/data/data_error_helper/data_error_helper.dart';
import 'package:test_opensource/data/models/response_registration_api_model.dart';
import 'package:test_opensource/data/models/response_sign_in_api_model.dart';
import 'package:test_opensource/data/models/response_sign_in_code_api_model.dart';
import 'package:test_opensource/data/requests/requests.dart';
import 'package:test_opensource/data/requests/requests_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// BLOC
class SmsCodeBloc extends Bloc<BlocEvents, BlocState> {
  SmsCodeBloc() : super(const BlocState());

  final Requests _requests = Requests();

  void sendSmsCode({
    required String number,
    required String code,
  }) =>
      add(
        SendSmsCodePostEvent(
          number: number,
          code: code,
        ),
      );

  void sendPhoneNumber({
    required String number,
  }) =>
      add(SendPhoneNumberPostEvent(
        number: number,
      ));

  @override
  Stream<BlocState> mapEventToState(BlocEvents event) async* {
    if (event is SendSmsCodePostEvent) {
      yield* _sendSmsCode(
        number: event.number,
        code: event.code,
      );
    } else if (event is SendPhoneNumberPostEvent) {
      yield* _sendPhone(
        number: event.number,
      );
    }
  }

  Stream<BlocState> _sendSmsCode({
    required String number,
    required String code,
  }) async* {
    yield LoadingState();
    dynamic data = await _requests.sendSmsCode(
      number: number,
      code: code,
    );
    if (data is DataErrorHelper) {
      yield ErrorLoadingState(data);
    } else {
      yield SendSmsCodeLoadedState(data);
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

class SendSmsCodeLoadedState extends BlocState {
  final ResponseRegistrationAPIModel model;

  SendSmsCodeLoadedState(
      this.model,
      ) : super([
    model,
  ]);
}

class SendPhoneLoadedState extends BlocState {
  final ResponseSignInAPIModel model;

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

class SendSmsCodePostEvent extends BlocEvents {
  final String number;
  final String code;

  SendSmsCodePostEvent({
    required this.number,
    required this.code,
  }) : super([
          number,
          code,
        ]);
}

class SendPhoneNumberPostEvent extends BlocEvents {
  final String number;

  SendPhoneNumberPostEvent({
    required this.number,
  }) : super([
          number,
        ]);
}
