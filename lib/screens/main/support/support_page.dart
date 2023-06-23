import 'package:test_opensource/base/app_colors.dart';
import 'package:test_opensource/base/app_constants.dart';
import 'package:test_opensource/base/app_text_styles.dart';
import 'package:test_opensource/base/app_widgets.dart';
import 'package:test_opensource/screens/authorization/login/login_page.dart';
import 'package:test_opensource/views/body_view.dart';
import 'package:flutter/material.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
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
                      text: 'SupportPage',
                      textAlign: TextAlign.center,
                    ),
                    AppWidgets().getAppLabelWithPadding(
                      topPadding: 15,
                      textAlign: TextAlign.center,
                      style: AppTextStyles().getAppTextThemeHeadline6(),
                      text:
                      'Размещайте или ищите заказы на оказание разнообразных работ и услуг от ремонта техники до услуг косметолога.',
                    ),
                    AppWidgets().getAppButtonWithPadding(
                      topPadding: 47,
                      title: 'Регистрация',
                    ),
                    AppWidgets().getAppButtonWithPadding(
                      topPadding: 20,
                      color: AppColors.appButtonWhiteColor,
                      colorTitle: AppColors.appMainTextColor,
                      title: 'Вход',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
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
