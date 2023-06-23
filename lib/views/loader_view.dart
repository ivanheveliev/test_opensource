import "package:test_opensource/base/app_colors.dart";
import "package:flutter/material.dart";

class LoaderView extends StatefulWidget {
  const LoaderView({Key? key}) : super(key: key);

  @override
  State<LoaderView> createState() => _LoaderViewState();
}

class _LoaderViewState extends State<LoaderView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.appBackgroundPageLoaderColor,
      child: Center(
        child: SizedBox(
          width: 78,
          height: 78,
          child: CircularProgressIndicator(
            strokeWidth: 10,
            color: AppColors.appLoaderColor,
            backgroundColor: AppColors.appSeparatorColor,
          ),
        ),
      ),
    );
  }
}
