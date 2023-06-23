import 'package:test_opensource/base/app_assets.dart';
import 'package:test_opensource/base/app_colors.dart';
import 'package:test_opensource/base/app_config.dart';
import 'package:test_opensource/base/app_methods.dart';
import 'package:test_opensource/base/app_text_styles.dart';
import 'package:test_opensource/base/app_widgets.dart';
import 'package:test_opensource/screens/authorization/login/login_bloc.dart';
import 'package:test_opensource/screens/authorization/registration/registration_page.dart';
import 'package:test_opensource/screens/authorization/sms_code/sms_code_page.dart';
import 'package:test_opensource/views/body_view.dart';
import 'package:test_opensource/views/loader_view.dart';
import 'package:extended_masked_text/extended_masked_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rich_text_controller/rich_text_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final _phoneTextController = RichTextController(
  //   patternMatchMap: AppConfig.numberPatternMap,
  //   onMatch: (List<String> match) {},
  // );
  final _phoneTextController = MaskedTextController(mask: '+0-000-000-00-00');
  final _bloc = LoginBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    _phoneTextController.dispose();
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
        } else if (state is SendPhoneLoadedState) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SmsCodePage(
                phone: _phoneTextController.text.replaceAll(
                  '-',
                  '',
                ),
                code: state.model.codeOut,
              ),
            ),
          );
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
                text: 'Вход',
                topPadding: 28,
                style: AppTextStyles().getAppTextThemeHeadline1(),
              ),
              AppWidgets().getAppLabelWithPadding(
                text: 'Введите ваш номер телефона',
                style: AppTextStyles().getAppTextThemeHeadline6(),
              ),
              AppWidgets().getAppTextFieldWithPadding(
                prefixIcon: AppAssets().getPhoneSvg,
                topPadding: 32,
                controller: _phoneTextController,
                hintText: 'Номер телефона',
                textInputType: TextInputType.phone,
                maxLength: 16,
                onChanged: (text) {
                  if (!text.startsWith('+7')) {
                    _phoneTextController.text = '+7';
                    _phoneTextController.selection = TextSelection.fromPosition(
                      const TextPosition(offset: 2),
                    );
                    // _phoneTextController.text += text;
                  }
                  setState(() {});
                },
                onTap: () {
                  if (_phoneTextController.text.length == 2) {
                    _phoneTextController.selection = TextSelection.fromPosition(
                      const TextPosition(offset: 2),
                    );
                  } else {
                    if (_phoneTextController.text.isEmpty) {
                      _phoneTextController.text = '+7';
                    }
                  }
                },
              ),
              AppWidgets().getAppButtonWithPadding(
                topPadding: 16,
                color: _isPhoneValidate()
                    ? AppColors.appButtonBlueColor
                    : AppColors.appButtonBlueWithOpacityColor,
                title: 'Далее',
                // colorTitle: AppColors.appBackgroundPageColor,
                onTap: () {
                  if (!_isPhoneValidate()) return;
                  _bloc.sendPhoneNumber(
                    number: _phoneTextController.text.replaceAll(
                      '-',
                      '',
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const RegistrationPage(),
                      ),
                    );
                  },
                  child: SizedBox(
                    height: 30,
                    child: Center(
                      child: AppWidgets().getAppLabelWithPadding(
                        text: 'Нет аккаунта? Зарегистрируйтесь',
                        style: AppTextStyles().getAppTextThemeHeadline6(),
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

  bool _isPhoneValidate() {
    if (_phoneTextController.text.length == 16) {
      return true;
    } else {
      return false;
    }
  }
}
