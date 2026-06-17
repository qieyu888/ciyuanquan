import 'package:flutter/material.dart';
import '../utils/constants.dart';

class PinkButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonVariant variant;
  final double? width;
  final double? height;
  final bool isLoading;
  final Widget? icon;
  final bool isFullWidth;

  const PinkButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.solid,
    this.width,
    this.height = 48,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonWidth = isFullWidth ? double.infinity : width;

    return SizedBox(
      width: buttonWidth,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(AppRadius.circle),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.circle),
              color: _getBackgroundColor(),
              border: variant == ButtonVariant.outline
                  ? Border.all(color: AppColors.primary, width: 2)
                  : null,
              boxShadow: variant == ButtonVariant.solid
                  ? [AppShadows.md]
                  : null,
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getTextColor(),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          icon!,
                          const SizedBox(width: AppSpacing.sm),
                        ],
                        Text(
                          text,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _getTextColor(),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (variant) {
      case ButtonVariant.solid:
        return AppColors.primary;
      case ButtonVariant.outline:
        return Colors.transparent;
      case ButtonVariant.ghost:
        return Colors.transparent;
    }
  }

  Color _getTextColor() {
    switch (variant) {
      case ButtonVariant.solid:
        return AppColors.white;
      case ButtonVariant.outline:
        return AppColors.primary;
      case ButtonVariant.ghost:
        return AppColors.primary;
    }
  }
}

enum ButtonVariant { solid, outline, ghost }
