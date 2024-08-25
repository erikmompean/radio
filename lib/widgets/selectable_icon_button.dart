import 'package:flutter/material.dart';
import 'package:radio/widgets/icon_mask.dart';
import 'package:radio/widgets/scale_animation_button.dart';

class SelectableIconButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final Function()? onTap;
  const SelectableIconButton(
    this.icon, {
    super.key,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ScaleAnimationButton(
        onTap: onTap ?? () {},
        child: Container(
          color: Colors.transparent,
          width: 50,
          height: 50,
          child: isSelected
              ? Icon(icon, color: Colors.white)
              : IconMask(
                  child: Icon(icon, size: 26, color: Colors.white)),
        ),
      ),
    );
  }
}
