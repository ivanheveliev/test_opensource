import 'package:test_opensource/base/app_assets.dart';
import 'package:test_opensource/base/app_colors.dart';
import 'package:test_opensource/base/app_config.dart';
import 'package:test_opensource/base/app_constants.dart';
import 'package:test_opensource/base/app_text_styles.dart';
import 'package:test_opensource/base/app_widgets.dart';
import 'package:test_opensource/screens/authorization/login/login_page.dart';
import 'package:test_opensource/screens/authorization/onboardings/onboarding_first.dart';
import 'package:test_opensource/screens/main/main_tab_controller.dart';
import 'package:flutter/material.dart';

class DistributionView extends StatefulWidget {
  const DistributionView({Key? key}) : super(key: key);

  @override
  State<DistributionView> createState() => _DistributionViewState();
}

class _DistributionViewState extends State<DistributionView> {
  @override
  void initState() {
    super.initState();
    _debugPrint();
    _redirectToTheCorrectScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundPageBlueColor,
      body: _getBodyWidget(),
    );
  }

  Widget _getBodyWidget() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: AppConstants.appSafeAreaWithAppBarHeight,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppWidgets().getAppAssetWithPadding(
                asset: AppAssets().getSplashBackgroundImage,
              ),
              AppWidgets().getAppLabelWithPadding(
                leftPadding: 22,
                rightPadding: 22,
                textAlign: TextAlign.center,
                style: AppTextStyles().getAppTextThemeHeadline5(),
                text:
                    'Мобильное приложение предназначено для сбора, обработки информации и предоставления консультативной информации для удовлетворения потребностей пользователей, размещения и поиска заказов на оказание работ и услуг, контроль выполнения работ и услуг для заинтересованных пользователей.',
              ),
              AppWidgets().getAppAssetWithPadding(
                asset: AppAssets().getLogoImage,
                height: 40,
                bottomPadding: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _debugPrint() {
    debugPrint(AppConfig.debugPrint);
  }

  Future<void> _redirectToTheCorrectScreen() async {
    bool userIsLogin =
        AppConfig.sharedPreferences.containsKey(AppConfig.keyUserToken);

    await Future.delayed(
      const Duration(
        seconds: 5,
         // seconds: 1,
      ),
    ).then(
      (value) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) =>
                userIsLogin ? const MainTabController() : const OnBoardingFirst(),
          ),
          (Route<dynamic> route) => false,
        );
      },
    );
  }
}
