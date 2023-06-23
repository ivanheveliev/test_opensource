import 'package:test_opensource/base/app_assets.dart';
import 'package:test_opensource/base/app_colors.dart';
import 'package:test_opensource/base/app_config.dart';
import 'package:test_opensource/base/app_methods.dart';
import 'package:test_opensource/base/app_text_styles.dart';
import 'package:test_opensource/base/app_widgets.dart';
import 'package:test_opensource/screens/authorization/registration_user_type/registration_user_type_page.dart';
import 'package:test_opensource/views/body_view.dart';
import 'package:flutter/material.dart';

class RegistrationNamePage extends StatefulWidget {
  final String phone;
  final String code;

  const RegistrationNamePage({
    super.key,
    required this.phone,
    required this.code,
  });

  @override
  State<RegistrationNamePage> createState() => _RegistrationNamePageState();
}

class _RegistrationNamePageState extends State<RegistrationNamePage> {
  final _nameTextField = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameTextField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BodyView(
      child: Scaffold(
        backgroundColor: AppColors.appBackgroundPageColor,
        appBar: AppWidgets().getAppBar(
          context: context,
          showLogo: true,
          leadingAsset: AppAssets().getLeftArrowSvg,
          callback: () {
            Navigator.pop(context);
          },
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
            left: 32,
            right: 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppWidgets().getAppLabelWithPadding(
                text: 'Как вас зовут?',
                topPadding: 28,
                style: AppTextStyles().getAppTextThemeHeadline1(),
              ),
              AppWidgets().getAppLabelWithPadding(
                text: 'Введите ваше имя',
                style: AppTextStyles().getAppTextThemeHeadline6(),
              ),
              AppWidgets().getAppTextFieldWithPadding(
                topPadding: 32,
                controller: _nameTextField,
                hintText: 'Ваше имя',
                textInputType: TextInputType.text,
                maxLength: 30,
                onChanged: (text) {
                  setState(() {});
                },
                onTap: () {},
              ),
              AppWidgets().getAppButtonWithPadding(
                topPadding: 16,
                color: _isNameValidate()
                    ? AppColors.appButtonBlueColor
                    : AppColors.appButtonBlueWithOpacityColor,
                title: 'Далее',
                onTap: () {
                  if (!_isNameValidate()) return;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => RegistrationUserTypePage(
                        name: _nameTextField.text,
                        phone: widget.phone,
                        code: widget.code,
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

  bool _isNameValidate() {
    if (_nameTextField.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
