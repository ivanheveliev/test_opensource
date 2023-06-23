import 'package:test_opensource/base/app_assets.dart';
import 'package:test_opensource/base/app_colors.dart';
import 'package:test_opensource/base/app_config.dart';
import 'package:test_opensource/base/app_constants.dart';
import 'package:test_opensource/base/app_methods.dart';
import 'package:test_opensource/base/app_text_styles.dart';
import 'package:test_opensource/base/app_widgets.dart';
import 'package:test_opensource/screens/main/applications/applications_page.dart';
import 'package:test_opensource/screens/main/cabinet/cabinet_page.dart';
import 'package:test_opensource/screens/main/create_application/create_application_page.dart';
import 'package:test_opensource/screens/main/feedback/feedback_page.dart';
import 'package:test_opensource/screens/main/main_tab_bloc.dart';
import 'package:test_opensource/screens/main/support/support_page.dart';
import 'package:test_opensource/views/body_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainTabController extends StatefulWidget {
  final int selectedIndex;

  const MainTabController({
    Key? key,
    this.selectedIndex = 0,
  }) : super(key: key);

  @override
  State<MainTabController> createState() => _MainTabControllerState();
}

class _MainTabControllerState extends State<MainTabController>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  final MainTabBloc _bloc = MainTabBloc();

  @override
  void initState() {
    super.initState();
    _bloc.getApplicationList();
    _selectedIndex = widget.selectedIndex;
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
            context: context,
            error: state.error,
          );
        } else if (state is LoadingState) {
          AppMethods().getUnFocusTextFieldMethod();
        } else if (state is GetMainInfoLoadedState) {
          AppConfig.applicationList = state.applicationListAPIModel.items!;
          AppConfig.userModel = state.userInfoAPIModel;
        }
      },
      builder: (BuildContext context, BlocState state) {
        return BodyView(
          isLoading: state is LoadingState,
          child: Scaffold(
            backgroundColor: AppColors.appBackgroundPageColor,
            key: _scaffoldKey,
            extendBody: true,
            body: IndexedStack(
              index: _selectedIndex,
              children: _getPages(),
            ),
            bottomNavigationBar: _selectedIndex != 2
                ? SizedBox(
                    height: AppConfig.appBottomNavigationBarHeight,
                    child: BottomNavigationBar(
                      elevation: 1,
                      onTap: (index) {
                        if (index == 1) return;
                        if (AppConfig.userModel.typeUser !=
                            AppConfig.keyClient) {
                          if (index == 2) return;
                          setState(
                                () {
                              _selectedIndex = index;
                            },
                          );
                        } else {
                          if (index == 3) return;
                          setState(
                                () {
                              _selectedIndex = index;
                            },
                          );
                        }
                      },
                      type: BottomNavigationBarType.fixed,
                      currentIndex: _selectedIndex,
                      showSelectedLabels: false,
                      showUnselectedLabels: false,
                      selectedFontSize: 0,
                      unselectedFontSize: 0,
                      items: _getItems(),
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }

  _getPages() {
    List<Widget> pages = [
      ApplicationsPage(
        callback: () {
          setState(() {
            _selectedIndex = 2;
          });
        },
        refreshApplications: () {
          _bloc.getApplicationList();
        },
      ),
      const FeedbackPage(),
      const SupportPage(),
      CabinetPage(),
    ];

    if (AppConfig.userModel.typeUser == AppConfig.keyClient) {
      pages.insert(
        2,
        CreateApplicationPage(
          callback: () {
            setState(() {
              _selectedIndex = 0;
            });
          },
        ),
      );
    }
    return pages;
  }

  _getItems() {
    List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
        icon: _getBottomNavigationBarIcon(
          label: 'Заявки',
          index: 0,
          icon: AppAssets().getApplicationsSvg,
        ),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: _getBottomNavigationBarIcon(
          label: 'Отклики',
          index: 1,
          icon: AppAssets().getFeedbackSvg,
        ),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: _getBottomNavigationBarIcon(
          label: 'Поддержка',
          index: AppConfig.userModel.typeUser == AppConfig.keyMaster ? 2 : 3,
          icon: AppAssets().getSupportSvg,
        ),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: _getBottomNavigationBarIcon(
          label: 'Кабинет',
          index:  AppConfig.userModel.typeUser == AppConfig.keyMaster ? 3 : 4,
          icon: AppAssets().getCabinetSvg,
        ),
        label: '',
      ),
    ];

    if (AppConfig.userModel.typeUser == AppConfig.keyClient) {
      items.insert(
        2,
        BottomNavigationBarItem(
          icon: _getBottomNavigationBarIcon(
            label: '',
            index: 2,
            icon: AppAssets().getPlusSvg,
          ),
          label: '',
        ),
      );
    }
    return items;
  }

  Widget _getBottomNavigationBarIcon({
    required int index,
    required String icon,
    String label = "",
  }) {
    return SizedBox(
      height: AppConfig.appBottomNavigationBarHeight - 1,
      width: AppConstants.appWidth / 5,
      child: Column(
        children: [
          Visibility(
            visible: index != 2 || AppConfig.userModel.typeUser == AppConfig.keyMaster,
            child: AppWidgets().getAppAssetWithPadding(
              topPadding: 8,
              bottomPadding: 3,
              asset: icon,
              isImage: false,
              color:
                  _selectedIndex == index ? AppColors.appButtonBlueColor : null,
            ),
          ),
          Visibility(
            visible: index != 2 || AppConfig.userModel.typeUser == AppConfig.keyMaster,
            child: Text(
              label,
              style: AppTextStyles().getAppTextThemeHeadline10(
                color: _selectedIndex == index
                    ? AppColors.appButtonBlueColor
                    : null,
              ),
            ),
          ),
          Visibility(
            visible: index == 2 && AppConfig.userModel.typeUser != AppConfig.keyMaster,
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Container(
                constraints: const BoxConstraints(
                  maxHeight: 38,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.appGreenColor,
                ),
                child: Center(
                  child: AppWidgets().getAppAssetWithPadding(
                    asset: icon,
                    isImage: false,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
