import 'dart:ui' as ui show ImageFilter;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:radio/enum/radio_status.dart';
import 'package:radio/utils/app_colors.dart';
import 'package:radio/widgets/loading_indicator.dart';
import 'package:radio/widgets/scale_animation_button.dart';
import 'package:radio/widgets/selectable_icon_button.dart';

class BottomBar extends StatelessWidget {
  final RadioStatus radioStatus;
  final List<Widget> children;
  final Function() onMediaTap;

  const BottomBar({
    super.key,
    required this.radioStatus,
    required this.children,
    required this.onMediaTap,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 14.0, sigmaY: 14.0),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.background.withOpacity(0.2),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return const LinearGradient(
                        colors: [Color(0xFF8C7F8D), Color(0xFF402D46)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(rect);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                        border: Border.all(
                          width: 2,
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child:
                          VerticalDivider(color: Colors.white.withOpacity(0.2)),
                    ),
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: radioStatus.isInitialized
                          ? SelectableIconButton(
                              iconDisplayed(),
                              onTap: () => onMediaTap(),
                            )
                          : const ScaleAnimationButton(
                              child: LoadingIndicator()),
                    ),
                  ]..insertAll(0, children),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData iconDisplayed() {
    switch (radioStatus) {
      case RadioStatus.playing:
        return CupertinoIcons.pause;
      case RadioStatus.paused:
        return CupertinoIcons.play_arrow;
      default:
        return CupertinoIcons.play_arrow;
    }
  }
}
