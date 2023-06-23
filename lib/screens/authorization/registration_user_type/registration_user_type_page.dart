import 'package:test_opensource/base/app_assets.dart';
import 'package:test_opensource/base/app_colors.dart';
import 'package:test_opensource/base/app_constants.dart';
import 'package:test_opensource/base/app_methods.dart';
import 'package:test_opensource/base/app_text_styles.dart';
import 'package:test_opensource/base/app_widgets.dart';
import 'package:test_opensource/data/data_error_helper/data_error_helper.dart';
import 'package:test_opensource/screens/authorization/onboardings/onboarding_second.dart';
import 'package:test_opensource/screens/authorization/registration_user_type/registration_user_type_bloc.dart';
import 'package:test_opensource/screens/main/main_tab_controller.dart';
import 'package:test_opensource/views/body_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationUserTypePage extends StatefulWidget {
  final String phone;
  final String name;
  final String code;

  const RegistrationUserTypePage({
    super.key,
    required this.phone,
    required this.name,
    required this.code,
  });

  @override
  State<RegistrationUserTypePage> createState() =>
      _RegistrationUserTypePageState();
}

class _RegistrationUserTypePageState extends State<RegistrationUserTypePage> {
  final _bloc = RegistrationUserTypeBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
        } else if (state is RegisterUserLoadedState) {
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
              builder: (context) => const OnBoardingSecond(),
            ),
            (Route<dynamic> route) => false,
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
                text: 'Регистрация',
                topPadding: 28,
                style: AppTextStyles().getAppTextThemeHeadline1(),
              ),
              AppWidgets().getAppLabelWithPadding(
                text: 'Как вы хотите использовать приложение?',
                style: AppTextStyles().getAppTextThemeHeadline6(),
              ),
              _getTypeWidget(
                topPadding: 32,
                icon: AppWidgets().getAppAssetWithPadding(
                  asset: AppAssets().getClientImage,
                  width: 116,
                  height: 118,
                  fit: BoxFit.cover,
                ),
                topTitle: 'Мне нужна помощь',
                bottomTitle: 'Например, ремонт или стрижка',
                callback: () {
                  _bloc.registerUser(
                    number: widget.phone,
                    name: widget.name,
                    type: 'client',
                    code: widget.code,
                  );
                },
              ),
              _getTypeWidget(
                topPadding: 24,
                icon: AppWidgets().getAppAssetWithPadding(
                  asset: AppAssets().getMasterImage,
                  width: 112,
                  height: 118,
                  fit: BoxFit.contain,
                ),
                topTitle: 'Я мастер',
                bottomTitle: 'Хочу принимать и выполнять заказы',
                callback: () {
                  _bloc.registerUser(
                    number: widget.phone,
                    name: widget.name,
                    type: 'master',
                    code: widget.code,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getTypeWidget({
    required Widget icon,
    required double topPadding,
    required String topTitle,
    required String bottomTitle,
    required VoidCallback callback,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: GestureDetector(
        onTap: callback,
        child: Container(
          height: 150,
          width: AppConstants.appWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              width: 2,
              color: AppColors.appBorderColor,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 24,
              top: 16,
              right: 16,
              bottom: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: AppConstants.appWidth - 238,
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: AppWidgets().getAppLabelWithPadding(
                            text: topTitle,
                            style: AppTextStyles().getAppTextThemeHeadline11(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: AppWidgets().getAppLabelWithPadding(
                          topPadding: 10,
                          text: bottomTitle,
                          style: AppTextStyles().getAppTextThemeHeadline6(),
                        ),
                      ),
                    ],
                  ),
                ),
                icon,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
