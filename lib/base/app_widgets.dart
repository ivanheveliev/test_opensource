import 'package:test_opensource/base/app_assets.dart';
import 'package:test_opensource/base/app_colors.dart';
import 'package:test_opensource/base/app_config.dart';
import 'package:test_opensource/base/app_constants.dart';
import 'package:test_opensource/base/app_text_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppWidgets {
  Widget getAppLabelWithPadding({
    String text = AppConfig.projectTitle,
    double topPadding = 0,
    double leftPadding = 0,
    double rightPadding = 0,
    double bottomPadding = 0,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        top: topPadding,
        left: leftPadding,
        right: rightPadding,
        bottom: bottomPadding,
      ),
      child: InkWell(
        onTap: onTap,
        child: AutoSizeText(
          text,
          textAlign: textAlign,
          maxLines: maxLines,
          style: style ?? AppTextStyles().getAppTextThemeHeadline1(),
        ),
      ),
    );
  }

  Widget getAppAssetWithPadding({
    String asset = 'lib/assets/photos/logo.png',
    bool isImage = true,
    double topPadding = 0,
    double leftPadding = 0,
    double rightPadding = 0,
    double bottomPadding = 0,
    BoxFit? fit,
    double? height,
    double? width,
    Color? color,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        top: topPadding,
        left: leftPadding,
        right: rightPadding,
        bottom: bottomPadding,
      ),
      child: isImage
          ? Image.asset(
              asset,
              fit: fit,
              width: width,
              height: height,
            )
          : SvgPicture.asset(
              asset,
              fit: fit ?? BoxFit.contain,
              width: width,
              height: height,
              color: color,
            ),
    );
  }

  PreferredSizeWidget getAppBar({
    required BuildContext context,
    bool showLogo = false,
    String title = '',
    double? toolBarHeight,
    Color? color,
    String? leadingAsset,
    VoidCallback? callback,
    Widget? leading,
    double? leadingWidth,
    List<Widget>? actions,
    bool? centerTitle,
  }) {
    return AppBar(
      centerTitle: centerTitle,
      title: showLogo
          ? getAppAssetWithPadding(
              asset: AppAssets().getDiamondImage,
              width: 35,
              height: 30,
            )
          : getAppLabelWithPadding(
              text: title,
              style: AppTextStyles().getAppTextThemeHeadline12(),
            ),
      leadingWidth: leadingWidth ?? 68,
      toolbarHeight: toolBarHeight,
      automaticallyImplyLeading: false,
      backgroundColor: color ?? AppColors.appBarColor,
      actions: actions,
      leading: leading ??
          (leadingAsset != null
              ? GestureDetector(
                  onTap: callback,
                  child: getAppAssetWithPadding(
                    leftPadding: 16,
                    topPadding: 12,
                    bottomPadding: 12,
                    rightPadding: 12,
                    isImage: false,
                    asset: leadingAsset,
                  ),
                )
              : null),
      elevation: 0.5,
      shadowColor: AppColors.appSeparatorColor,
    );
  }

  Widget getAppButtonWithPadding({
    double topPadding = 0,
    double leftPadding = 0,
    double rightPadding = 0,
    double bottomPadding = 0,
    String? title,
    Color? color,
    double? height,
    double? width,
    double? borderRadius,
    VoidCallback? onTap,
    TextStyle? textStyle,
    Color? colorTitle,
    String icon = "",
  }) {
    return Padding(
      padding: EdgeInsets.only(
        top: topPadding,
        left: leftPadding,
        right: rightPadding,
        bottom: bottomPadding,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: height ?? 56,
          width: width ?? AppConstants.appWidth,
          decoration: BoxDecoration(
            color: color ?? AppColors.appButtonBlueColor,
            borderRadius: BorderRadius.circular(
              borderRadius ?? 12,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: icon.isNotEmpty,
                child: getAppAssetWithPadding(
                  asset: icon,
                  height: 24,
                  width: 24,
                  rightPadding: 8,
                  isImage: false,
                ),
              ),
              AutoSizeText(
                title ?? AppConfig.projectTitle,
                style: textStyle ??
                    AppTextStyles().getAppTextThemeHeadline7(
                      color: colorTitle,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getAppTextFieldWithPadding({
    double topPadding = 0,
    double leftPadding = 0,
    double rightPadding = 0,
    double bottomPadding = 0,
    TextEditingController? controller,
    String? hintText,
    int? maxLength,
    int? maxLines,
    bool scrollPaddingToBottom = false,
    TextInputType? textInputType,
    Function(String)? onChanged,
    Function()? onTap,
    String? errorText,
    String? prefixIcon,
    Color? fillColor,
    double borderRadius = 12,
    TextStyle? hintTextStyle,
    TextStyle? style,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        top: topPadding,
        left: leftPadding,
        right: rightPadding,
        bottom: bottomPadding,
      ),
      child: TextFormField(
        controller: controller,
        cursorColor: AppColors.appCursorColor,
        keyboardType: textInputType,
        style: AppTextStyles().getAppTextThemeHeadline3(),
        onChanged: onChanged,
        onTap: onTap,
        maxLines: maxLines,
        maxLength: maxLength,
        decoration: InputDecoration(
          filled: fillColor != null ? true : false,
          fillColor: fillColor,
          prefixIcon: prefixIcon != null
              ? getAppAssetWithPadding(
                  topPadding: 14,
                  leftPadding: 16,
                  rightPadding: 12,
                  bottomPadding: 14,
                  asset: prefixIcon,
                  isImage: false,
                )
              : null,
          errorText: errorText,
          errorStyle: TextStyle(
            height: 0,
            color: AppColors.appTransparentColor,
          ),
          isDense: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              width: 2,
              color: AppColors.appBorderTextFieldColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              width: 1,
              color: AppColors.appBorderTextFieldColor,
            ),
          ),
          // errorBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(borderRadius),
          //   borderSide: BorderSide(
          //     width: 1,
          //     color: AppColors.appErrorColor,
          //   ),
          // ),
          // focusedErrorBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(12),
          //   borderSide: BorderSide(
          //     width: 1,
          //     color: AppColors.appErrorColor,
          //   ),
          // ),
          counterText: "",
          hintText: hintText,
          hintStyle:
              hintTextStyle ?? AppTextStyles().getAppTextThemeHeadline8(),
          labelStyle: style ?? AppTextStyles().getAppTextThemeHeadline3(),
        ),
        scrollPadding: scrollPaddingToBottom
            ? EdgeInsets.only(
                bottom: AppConstants.deviceBottomTrash,
              )
            : const EdgeInsets.all(20.0),
      ),
    );
  }
}
