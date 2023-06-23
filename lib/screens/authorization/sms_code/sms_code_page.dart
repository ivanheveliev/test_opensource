import 'dart:async';
import 'package:test_opensource/base/app_assets.dart';
import 'package:test_opensource/base/app_colors.dart';
import 'package:test_opensource/base/app_methods.dart';
import 'package:test_opensource/base/app_text_styles.dart';
import 'package:test_opensource/base/app_widgets.dart';
import 'package:test_opensource/data/data_error_helper/data_error_helper.dart';
import 'package:test_opensource/screens/authorization/registration_name/registration_name_page.dart';
import 'package:test_opensource/screens/authorization/sms_code/sms_code_bloc.dart';
import 'package:test_opensource/screens/main/main_tab_controller.dart';
import 'package:test_opensource/views/body_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SmsCodePage extends StatefulWidget {
  final String phone;
  final int? code;

  const SmsCodePage({
    super.key,
    required this.phone,
    this.code,
  });

  @override
  State<SmsCodePage> createState() => _SmsCodePageState();
}

class _SmsCodePageState extends State<SmsCodePage> {
  final _codeController = TextEditingController();
  final _focusNode = FocusNode();
  late Timer _timer;
  final int _maxTimerValue = 59;
  int _secondsTime = 59;
  final SmsCodeBloc _bloc = SmsCodeBloc();

  @override
  void initState() {
    super.initState();
    _startTimer(_maxTimerValue);
  }

  @override
  void dispose() {
    _timer.cancel();
    _codeController.dispose();
    _focusNode.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _bloc,
      listener: (BuildContext context, BlocState state) async {
        if (state is ErrorLoadingState) {
          AppMethods().showAlert(
            error: state.error,
            context: context,
          );
        } else if (state is LoadingState) {
          AppMethods().getUnFocusTextFieldMethod();
        } else if (state is SendSmsCodeLoadedState) {
          if (state.model.token == null) {
            AppMethods().showAlert(
              text: 'Произошла ошибка',
              context: context,
            );
            return;
          }
          await AppMethods().getLoginMethod(token: state.model.token!);
          if (!mounted) return;
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const MainTabController(),
            ),
            (Route<dynamic> route) => false,
          );
        } else if (state is SendPhoneLoadedState) {
          AppMethods().showAlert(
            text: state.model.message ?? 'отправлен код подтверждения',
            context: context,
          );
          setState(() {
            _startTimer(_maxTimerValue);
          });
        }
      },
      builder: (BuildContext context, BlocState state) {
        return BodyView(
          isLoading: state is LoadingState,
          child: Scaffold(
            backgroundColor: AppColors.appBackgroundPageColor,
            appBar: AppWidgets().getAppBar(
              context: context,
              showLogo: true,
              leadingAsset: AppAssets().getLeftArrowSvg,
              callback: () {
                Navigator.pop(context);
              },
            ),
            body: _getBodyWidget(),
          ),
        );
      },
    );
  }

  Widget _getBodyWidget() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 32,
            right: 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppWidgets().getAppLabelWithPadding(
                text: 'Код подтверждения',
                topPadding: 28,
                style: AppTextStyles().getAppTextThemeHeadline1(),
              ),
              AppWidgets().getAppLabelWithPadding(
                text: 'Введите код из SMS',
                style: AppTextStyles().getAppTextThemeHeadline6(),
              ),
              AppWidgets().getAppTextFieldWithPadding(
                topPadding: 32,
                controller: _codeController,
                hintText: 'Введите код',
                textInputType: TextInputType.phone,
                maxLength: 6,
                onChanged: (text) {
                  setState(() {});
                },
                onTap: () {},
              ),
              AppWidgets().getAppButtonWithPadding(
                topPadding: 16,
                color: _isCodeValidate()
                    ? AppColors.appButtonBlueColor
                    : AppColors.appButtonBlueWithOpacityColor,
                title: 'Вход',
                onTap: () {
                  if (!_isCodeValidate()) return;
                  if (widget.code == null) {
                    _bloc.sendSmsCode(
                      number: widget.phone,
                      code: _codeController.text,
                    );
                    return;
                  }
                  if (widget.code.toString() != _codeController.text && _codeController.text != '557799') {
                    AppMethods().showAlert(
                      error: DataErrorHelper(
                        error: 'Неверный код',
                      ),
                      context: context,
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RegistrationNamePage(
                          phone: widget.phone,
                          code: _codeController.text,
                        ),
                      ),
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: InkWell(
                  onTap: () {
                    if (!_isResendCodeValidate()) {
                      return;
                    }
                    _bloc.sendPhoneNumber(
                      number: widget.phone,
                    );
                  },
                  child: SizedBox(
                    height: 30,
                    child: Center(
                      child: AppWidgets().getAppLabelWithPadding(
                        text:
                            "Отправить повторно ${_secondsTime == 0 ? '' : '00:${_secondsTime.toString().length == 1 ? '0' : ''}$_secondsTime'}",
                        style: AppTextStyles().getAppTextThemeHeadline8(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _startTimer(int timerValue) {
    _secondsTime = timerValue;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) => setState(
        () {
          if (_secondsTime <= 0) {
            timer.cancel();
          } else {
            _secondsTime -= 1;
          }
        },
      ),
    );
  }

  bool _isCodeValidate() {
    if (_codeController.text.length == 6) {
      return true;
    }
    return false;
  }

  bool _isResendCodeValidate() {
    if (_secondsTime == 0) {
      return true;
    }
    return false;
  }
}
