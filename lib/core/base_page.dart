import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kiind_web/core/constants/app_colors.dart';
import 'package:kiind_web/core/providers/base_provider.dart';
import 'package:provider/provider.dart';

class BasePage<T extends ChangeNotifier> extends StatefulWidget {
  final Widget Function(BuildContext context, T value, Widget? child) builder;
  final Function(dynamic)? init;
  final T provider;
  final Widget? child;
  final bool needsUser, hasCustomLoader;

  const BasePage({
    super.key,
    required this.builder,
    required this.provider,
    required this.child,
    this.needsUser = true,
    this.hasCustomLoader = false,
    this.init,
  });

  @override
  _BasePageState<T> createState() => _BasePageState<T>();
}

class _BasePageState<T extends ChangeNotifier> extends State<BasePage<T>> {
  // We want to store the instance of the model in the state
  // that way it stays constant through rebuilds
  late dynamic model;

  @override
  void initState() {
    if (widget.init != null) {
      widget.init!(widget.provider);
    }

    // assign the model once when state is initialised
    model = widget.provider;
    super.initState();
  }

  @override
  void dispose() {
    widget.provider.dispose();
    super.dispose();
  }

  Future<bool> initModel() async {
    if (model is BaseProvider) {
      await model.init(
        context,
        needsUser: widget.needsUser,
      );
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    // var s = widget.child as Scaffold;
    return FutureBuilder<bool>(
      future: initModel(),
      builder: (context, snapshot) {
        bool initialized = snapshot.data ?? false;

        return ChangeNotifierProvider<T>.value(
          value: model,
          child: ValueListenableBuilder<bool>(
            valueListenable: model is BaseProvider
                ? (model as BaseProvider).loadingAsListenable
                : ValueNotifier(false),
            builder: (
              context,
              loading,
              child,
            ) {
              return Stack(
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: model is BaseProvider
                        ? (model as BaseProvider).initialisedAsListenable
                        : ValueNotifier(true),
                    builder: (context, initialised, child) {
                      return initialised
                          ? IgnorePointer(
                              ignoring: !widget.hasCustomLoader && loading,
                              child: GestureDetector(
                                onTap: () => FocusScope.of(context).unfocus(),
                                // child: ValueListenableBuilder<bool>(
                                //   valueListenable: model is BaseProvider
                                //       ? (model as BaseProvider)
                                //           .grayscaleAsListenable
                                //       : ValueNotifier(false),
                                //   builder: (
                                //     context,
                                //     _grayscale,
                                //     child,
                                //   ) {
                                //     return Container(
                                //       foregroundDecoration: _grayscale
                                //           ? const BoxDecoration(
                                //               color: Colors.grey,
                                //               backgroundBlendMode:
                                //                   BlendMode.saturation,
                                //             )
                                //           : null,
                                child: Consumer<T>(
                                  builder: widget.builder,
                                  child: widget.child,
                                ),
                                //       );
                                //     },
                                //   ),
                              ),
                            )
                          : const Offstage();
                    },
                  ),
                  if (!widget.hasCustomLoader && loading)
                    BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 5.0,
                        sigmaY: 5.0,
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: (initialized &&
                                  (model is BaseProvider) &&
                                  model.initialised)
                              ? AppColors.primaryColor
                              : null,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
