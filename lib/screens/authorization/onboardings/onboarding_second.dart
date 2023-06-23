import 'package:test_opensource/base/app_colors.dart';
import 'package:test_opensource/base/app_constants.dart';
import 'package:test_opensource/base/app_text_styles.dart';
import 'package:test_opensource/base/app_widgets.dart';
import 'package:test_opensource/screens/authorization/login/login_page.dart';
import 'package:test_opensource/screens/authorization/registration/registration_page.dart';
import 'package:test_opensource/screens/main/main_tab_controller.dart';
import 'package:test_opensource/views/body_view.dart';
import 'package:flutter/material.dart';

class OnBoardingSecond extends StatefulWidget {
  const OnBoardingSecond({super.key});

  @override
  State<OnBoardingSecond> createState() => _OnBoardingSecondState();
}

class _OnBoardingSecondState extends State<OnBoardingSecond> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BodyView(
      child: Scaffold(
        backgroundColor: AppColors.appBackgroundPageBlueColor,
        body: _getBodyWidget(),
      ),
    );
  }

  Widget _getBodyWidget() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: AppConstants.appSafeAreaWithAppBarHeight,
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: AppColors.appBackgroundPageColor,
              width: AppConstants.appWidth,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 40,
                  bottom: 30,
                  left: 32,
                  right: 32,
                ),
                child: Column(
                  children: [
                    AppWidgets().getAppLabelWithPadding(
                      text: 'Готово!',
                      textAlign: TextAlign.center,
                    ),
                    AppWidgets().getAppLabelWithPadding(
                      topPadding: 15,
                      textAlign: TextAlign.center,
                      style: AppTextStyles().getAppTextThemeHeadline6(),
                      text:
                          'Вы успешно зарегистрированы. Подробную информацию о себе вы сможете заполнить в личном кабинете.',
                    ),
                    AppWidgets().getAppButtonWithPadding(
                      topPadding: 47,
                      title: 'ОК',
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const MainTabController(),
                          ),
                              (Route<dynamic> route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
