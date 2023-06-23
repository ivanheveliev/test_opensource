import 'package:test_opensource/base/app_assets.dart';
import 'package:test_opensource/base/app_colors.dart';
import 'package:test_opensource/base/app_config.dart';
import 'package:test_opensource/base/app_methods.dart';
import 'package:test_opensource/base/app_text_styles.dart';
import 'package:test_opensource/base/app_widgets.dart';
import 'package:test_opensource/screens/main/create_application/create_application_page.dart';
import 'package:test_opensource/views/body_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ApplicationsPage extends StatefulWidget {
  final VoidCallback callback;
  final VoidCallback refreshApplications;

  const ApplicationsPage({
    super.key,
    required this.callback,
    required this.refreshApplications,
  });

  @override
  State<ApplicationsPage> createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {
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
              Visibility(
                visible: AppConfig.userModel.typeUser == AppConfig.keyClient,
                child: AppWidgets().getAppButtonWithPadding(
                  topPadding: 20,
                  color: AppColors.appGreenColor,
                  title: "Добавить заявку",
                  icon: AppAssets().getAddCircleSvg,
                  onTap: () {
                    // widget.callback();
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            CreateApplicationPage(
                          callback: () {
                            Navigator.pop(context);
                          },
                        ),
                        transitionDuration: Duration.zero,
                      ),
                    );
                  },
                ),
              ),
              Visibility(
                visible: AppConfig.userModel.typeUser == AppConfig.keyMaster,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Container(
                        height: 1,
                        color: AppColors.appSeparatorColor,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppWidgets().getAppLabelWithPadding(
                          text: "Заявки",
                          style: AppTextStyles().getAppTextThemeHeadline13(),
                        ),
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: InkWell(
                            onTap: () {
                              widget.refreshApplications();
                            },
                            child: const Icon(
                              Icons.refresh,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        height: 1,
                        color: AppColors.appSeparatorColor,
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: AppConfig.applicationList.length,
                itemBuilder: (BuildContext ctx, index) {
                  final item = AppConfig.applicationList[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        // color: AppColors.appBackgroundPageLoaderColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          width: 1,
                          color: AppColors.appBlackTextColor,
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 8, left: 8, right: 8),
                        child: Column(
                          children: [
                            _getTopBottomTitles(
                              topTitle: "Имя клиента",
                              bottomTitle: item.author?.name ?? '',
                            ),
                            _getTopBottomTitles(
                              topTitle: "Номер заявки",
                              bottomTitle: item.id ?? '',
                            ),
                            _getTopBottomTitles(
                              topTitle: "Дата заявки",
                              bottomTitle: DateFormat('yMd').format(
                                DateTime.parse(item.created ?? ''),
                              ),
                            ),
                            _getTopBottomTitles(
                              topTitle: "Статус",
                              bottomTitle: item.status ?? '',
                            ),
                            _getTopBottomTitles(
                              topTitle: "Описание проблемы",
                              bottomTitle: item.content ?? '',
                            ),
                            _getTopBottomTitles(
                              topTitle: "Телефон клиента",
                              bottomTitle:
                                  _refactoringPhone(phone: item.author?.phone),
                              onTap: () {
                                AppMethods().openPhone(
                                  context: context,
                                  phone: item.author?.phone ?? '',
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getTopBottomTitles({
    required String topTitle,
    required String bottomTitle,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.appBackgroundPageLoaderColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              width: 2,
              color: AppColors.appBorderColor,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppWidgets().getAppLabelWithPadding(
                  text: topTitle,
                  style: AppTextStyles().getAppTextThemeHeadline14(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 2),
                  child: Container(
                    height: 1,
                    color: AppColors.appSeparatorColor,
                  ),
                ),
                AppWidgets().getAppLabelWithPadding(
                  text: bottomTitle,
                  style: AppTextStyles().getAppTextThemeHeadline5(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _refactoringPhone({required String? phone}) {
    var i = 0;
    final dashes = {2, 5, 8, 10};

    final replaced = phone?.splitMapJoin(RegExp('.'),
        onNonMatch: (s) => dashes.contains(i++) ? '-' : '');
    return replaced ?? '';
  }
}
