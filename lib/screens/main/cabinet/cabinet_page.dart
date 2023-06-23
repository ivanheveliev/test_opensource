import 'package:test_opensource/base/app_assets.dart';
import 'package:test_opensource/base/app_colors.dart';
import 'package:test_opensource/base/app_config.dart';
import 'package:test_opensource/base/app_constants.dart';
import 'package:test_opensource/base/app_methods.dart';
import 'package:test_opensource/base/app_text_styles.dart';
import 'package:test_opensource/base/app_widgets.dart';
import 'package:test_opensource/screens/authorization/login/login_page.dart';
import 'package:test_opensource/screens/authorization/onboardings/onboarding_first.dart';
import 'package:test_opensource/views/body_view.dart';
import 'package:flutter/material.dart';

class CabinetPage extends StatefulWidget {
  CabinetPage({super.key});

  @override
  State<CabinetPage> createState() => _CabinetPageState();
}

class _CabinetPageState extends State<CabinetPage> {
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
        backgroundColor: AppColors.appBackgroundPageColor,
        appBar: AppWidgets().getAppBar(
          context: context,
          leadingWidth: 105,
          leading: Row(
            children: [
              AppWidgets().getAppAssetWithPadding(
                leftPadding: 24,
                topPadding: 17,
                bottomPadding: 17,
                asset: AppAssets().getDiamondImage,
              ),
              AppWidgets().getAppAssetWithPadding(
                leftPadding: 18,
                topPadding: 18,
                bottomPadding: 18,
                asset: AppAssets().getMenuSvg,
                isImage: false,
              ),
            ],
          ),
          actions: [
            AppWidgets().getAppAssetWithPadding(
              rightPadding: 24,
              height: 48,
              width: 48,
              asset: AppAssets().getExampleAvatarImage,
            ),
          ],
        ),
        body: _getBodyWidget(),
      ),
    );
  }

  Widget _getBodyWidget() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppWidgets().getAppLabelWithPadding(
                text:
                    "Привет${AppConfig.userModel.name != null ? ', ${AppConfig.userModel.name}' : ''}",
                topPadding: 20,
                style: AppTextStyles().getAppTextThemeHeadline1(),
              ),
              AppWidgets().getAppLabelWithPadding(
                text: AppConfig.userModel.typeUser == null
                    ? ""
                    : AppConfig.userModel.typeUser == AppConfig.keyMaster
                    ? "Выберите, что Вы готовы сделать"
                    : "Здесь вы можете осуществить свои желания",
                style: AppTextStyles().getAppTextThemeHeadline6(),
              ),
              AppWidgets().getAppButtonWithPadding(
                topPadding: 20,
                title: "Выход",
                onTap: () async {
                  await AppMethods().getLogoutMethod();
                  if (!mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const OnBoardingFirst()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
