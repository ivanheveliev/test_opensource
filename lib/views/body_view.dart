import "package:test_opensource/base/app_colors.dart";
import "package:test_opensource/base/app_methods.dart";
import "package:test_opensource/views/loader_view.dart";
import "package:flutter/material.dart";

class BodyView extends StatefulWidget {
  final Widget child;
  final bool isLoading;

  const BodyView({
    Key? key,
    required this.child,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<BodyView> createState() => _BodyViewState();
}

class _BodyViewState extends State<BodyView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppMethods().getUnFocusTextFieldMethod();
      },
      child: Stack(
        children: [
          widget.child,
          Visibility(
            visible: widget.isLoading,
            child: const LoaderView(),
          ),
        ],
      ),
    );
  }
}
