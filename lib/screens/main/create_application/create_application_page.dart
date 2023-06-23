import 'dart:io';

import 'package:test_opensource/base/app_assets.dart';
import 'package:test_opensource/base/app_classes.dart';
import 'package:test_opensource/base/app_colors.dart';
import 'package:test_opensource/base/app_constants.dart';
import 'package:test_opensource/base/app_methods.dart';
import 'package:test_opensource/base/app_text_styles.dart';
import 'package:test_opensource/base/app_widgets.dart';
import 'package:test_opensource/screens/authorization/login/login_page.dart';
import 'package:test_opensource/screens/main/create_application/choose_category/choose_category_page.dart';
import 'package:test_opensource/screens/main/create_application/create_application_bloc.dart';
import 'package:test_opensource/views/body_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateApplicationPage extends StatefulWidget {
  final VoidCallback callback;

  const CreateApplicationPage({
    super.key,
    required this.callback,
  });

  @override
  State<CreateApplicationPage> createState() => _CreateApplicationPageState();
}

class _CreateApplicationPageState extends State<CreateApplicationPage> {
  final _descriptionTextController = TextEditingController();
  final List<File> _filesList = [];
  CategoryData? _categoryData;
  final _bloc = CreateApplicationBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    _descriptionTextController.dispose();
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
        } else if (state is SendApplicationLoadedState) {
          AppMethods().showAlert(
            context: context,
            text: 'Заявка успешно отправлена',
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
              leadingAsset: AppAssets().getCloseSvg,
              callback: () {
                widget.callback();
              },
              centerTitle: false,
              title: 'Новая заявка',
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
        child: Container(
          constraints: BoxConstraints(
            minHeight: AppConstants.appSafeAreaWithoutAppBarBottomNavigationBar,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppWidgets().getAppLabelWithPadding(
                          text: "Категория",
                          topPadding: 16,
                          bottomPadding: 8,
                          style: AppTextStyles().getAppTextThemeHeadline13(),
                        ),
                        GestureDetector(
                          onTap: () async {
                            dynamic result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ChooseCategoryPage(),
                              ),
                            );
                            if (result is CategoryData) {
                              setState(
                                () {
                                  _categoryData = result;
                                },
                              );
                            }
                          },
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                width: 1,
                                color: AppColors.appBorderColor,
                              ),
                            ),
                            child: Row(
                              children: [
                                AppWidgets().getAppAssetWithPadding(
                                  leftPadding: 12,
                                  rightPadding: 12,
                                  isImage: false,
                                  asset: _categoryData?.icon ??
                                      AppAssets().getOtherCategorySvg,
                                  color: _categoryData == null
                                      ? AppColors.appGreyTextColor
                                      : null,
                                ),
                                SizedBox(
                                  width: AppConstants.appWidth - 90,
                                  child: AppWidgets().getAppLabelWithPadding(
                                    text: _categoryData?.name ??
                                        'Выберите категорию',
                                    maxLines: 2,
                                    style: AppTextStyles()
                                        .getAppTextThemeHeadline2(
                                      color: _categoryData == null
                                          ? AppColors.appGreyTextColor
                                          : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        AppWidgets().getAppLabelWithPadding(
                          text: "Описание проблемы",
                          topPadding: 20,
                          style: AppTextStyles().getAppTextThemeHeadline13(),
                        ),
                        AppWidgets().getAppTextFieldWithPadding(
                          topPadding: 8,
                          hintText: 'Укажите проблему',
                          maxLines: 8,
                          controller: _descriptionTextController,
                        ),
                        AppWidgets().getAppLabelWithPadding(
                          text: "Фото",
                          topPadding: 20,
                          bottomPadding: 8,
                          style: AppTextStyles().getAppTextThemeHeadline13(),
                        ),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: _filesList.length + 1,
                            itemBuilder: (BuildContext ctx, index) {
                              if (index >= _filesList.length) {
                                return GestureDetector(
                                  onTap: () async {
                                    dynamic result =
                                        await AppMethods().getFileFromSource();
                                    if (result != null) {
                                      setState(() {
                                        _filesList.add(result);
                                      });
                                    }
                                  },
                                  child: Container(
                                    height: 120,
                                    width: (AppConstants.appWidth - 80) / 2,
                                    decoration: BoxDecoration(
                                      color: AppColors.appBorderColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AppWidgets().getAppAssetWithPadding(
                                          asset: AppAssets().getCameraSvg,
                                          isImage: false,
                                        ),
                                        AppWidgets().getAppLabelWithPadding(
                                          topPadding: 5,
                                          text: 'Добавить',
                                          style: AppTextStyles()
                                              .getAppTextThemeHeadline2(),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Container(
                                    height: 120,
                                    width: (AppConstants.appWidth - 80) / 2,
                                    decoration: BoxDecoration(
                                      color: AppColors.appBorderColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.file(
                                              _filesList[index],
                                              height: 120,
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              right: 10,
                                              bottom: 10,
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _filesList.removeAt(index);
                                                });
                                              },
                                              child: Container(
                                                height: 32,
                                                width: 32,
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColors.appWhiteColor,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: AppWidgets()
                                                      .getAppAssetWithPadding(
                                                    asset:
                                                        AppAssets().getBinSvg,
                                                    isImage: false,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              AppWidgets().getAppButtonWithPadding(
                leftPadding: 16,
                rightPadding: 16,
                bottomPadding: 16,
                topPadding: 16,
                color: _isApplicationValidate()
                    ? AppColors.appButtonBlueColor
                    : AppColors.appButtonBlueWithOpacityColor,
                title: 'Добавить заявку',
                onTap: () {
                  if (!_isApplicationValidateWithAlert()) return;
                  _bloc.sendApplication(
                    files: _filesList,
                    categoryId: _categoryData!.id,
                    descriptionProblem: _descriptionTextController.text,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isApplicationValidate() {
    bool validate = false;
    if (_categoryData != null &&
        _descriptionTextController.text.isNotEmpty
        // &&
        // _filesList.isNotEmpty
        ) {
      validate = true;
    }
    return validate;
  }

  bool _isApplicationValidateWithAlert() {
    if (_categoryData == null) {
      AppMethods().showAlert(
        context: context,
        text: 'Выберите категорию',
      );
      return false;
    }
    if (_descriptionTextController.text.isEmpty) {
      AppMethods().showAlert(
        context: context,
        text: 'Укажите проблему',
      );
      return false;
    }
    // if (_filesList.isEmpty) {
    //   AppMethods().showAlert(
    //     context: context,
    //     text: 'Добавьте фото',
    //   );
    //   return false;
    // }
    return true;
  }
}
