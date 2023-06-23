import 'package:test_opensource/views/distributor_view.dart';
// import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_opensource/base/app_colors.dart';
import 'package:test_opensource/base/app_config.dart';
import 'package:test_opensource/base/app_methods.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await EasyLocalization.ensureInitialized();
  await AppMethods().getPackageInfo();
  await AppMethods().getPreferences();
  runApp(
    const MyApp(),
    // EasyLocalization(
    //   supportedLocales: const [
    //     Locale('ru', 'RU'),
    //   ],
    //   path: 'lib/assets/translations',
    //   fallbackLocale: const Locale('ru', 'RU'),
    //   child: const MyApp(),
    // ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      // localizationsDelegates: context.localizationDelegates,
      // supportedLocales: context.supportedLocales,
      // locale: context.locale,
      debugShowCheckedModeBanner: false,
      title: AppConfig.projectTitle,
      theme: ThemeData(
        highlightColor: AppColors.appTransparentColor,
        splashColor: AppColors.appTransparentColor,
        appBarTheme: AppBarTheme(
          systemOverlayStyle: const SystemUiOverlayStyle(
            // statusBarColor: AppColors.appTransparentColor,
            // systemNavigationBarColor:
            //     AppColors.bottomNavigationBarBackgroundColor,
            // statusBarIconBrightness: Brightness.light,
            // statusBarBrightness: Brightness.light,
          ),
          color: AppColors.appBarColor,
          elevation: 0,
          centerTitle: true,
          toolbarHeight: AppConfig.appBarHeight,
        ),
      ),
      home: const DistributionView(),
    );
  }
}