import 'package:test_opensource/base/app_assets.dart';
import 'package:test_opensource/base/app_classes.dart';
import 'package:test_opensource/base/app_colors.dart';
import 'package:test_opensource/base/app_constants.dart';
import 'package:test_opensource/base/app_methods.dart';
import 'package:test_opensource/base/app_text_styles.dart';
import 'package:test_opensource/base/app_widgets.dart';
import 'package:test_opensource/data/models/response_category_list_api_model.dart';
import 'package:test_opensource/screens/authorization/login/login_page.dart';
import 'package:test_opensource/screens/main/create_application/choose_category/choose_category_bloc.dart';
import 'package:test_opensource/views/body_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChooseCategoryPage extends StatefulWidget {
  const ChooseCategoryPage({
    super.key,
  });

  @override
  State<ChooseCategoryPage> createState() => _ChooseCategoryPageState();
}

class _ChooseCategoryPageState extends State<ChooseCategoryPage> {
  final ChooseCategoryBloc _bloc = ChooseCategoryBloc();
  List<Items> _categoryList = [];

  @override
  void initState() {
    super.initState();
    _bloc.getCategoryList();
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
        } else if (state is GetCategoryListLoadedState) {
          _categoryList = state.model.items ?? [];
        }
      },
      builder: (BuildContext context, BlocState state) {
        return BodyView(
          isLoading: state is LoadingState,
          child: Scaffold(
            backgroundColor: AppColors.appBackgroundPageColor,
            appBar: AppWidgets().getAppBar(
              context: context,
              leadingAsset: AppAssets().getLeftArrowSvg,
              centerTitle: false,
              title: 'Выберите категорию',
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _categoryList.length,
                    itemBuilder: (BuildContext ctx, index) {
                      final item = _categoryList[index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(
                              context,
                              CategoryData(
                                name: item.name ?? '',
                                icon: _getIconFromId(id: item.id ?? ''),
                                id: item.id ?? '',
                              ),
                            );
                          },
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                width: 1,
                                color: AppColors.appTransparentColor,
                              ),
                            ),
                            child: Row(
                              children: [
                                AppWidgets().getAppAssetWithPadding(
                                  leftPadding: 12,
                                  rightPadding: 12,
                                  isImage: false,
                                  asset: _getIconFromId(
                                    id: item.id ?? '',
                                  ),
                                ),
                                SizedBox(
                                  width: AppConstants.appWidth - 90,
                                  child: AppWidgets().getAppLabelWithPadding(
                                    text: item.name ?? '',
                                    maxLines: 2,
                                    style: AppTextStyles()
                                        .getAppTextThemeHeadline2(),
                                  ),
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
          ],
        ),
      ),
    );
  }

  String _getIconFromId({
    required String id,
  }) {
    String icon = AppAssets().getOtherCategorySvg;
    switch (id) {
      case '3':
        icon = AppAssets().getConsultingServicesSvg;
        break;
      case '4':
        icon = AppAssets().getEquipmentRepairSvg;
        break;
      case '5':
        icon = AppAssets().getCarRepairSvg;
        break;
      case '6':
        icon = AppAssets().getConstructionRepairSvg;
        break;
      case '7':
        icon = AppAssets().getBeautyHealthSvg;
        break;
    }
    return icon;
  }
}
