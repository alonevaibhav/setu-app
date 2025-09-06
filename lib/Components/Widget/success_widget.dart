import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A reusable success animation widget using Lottie
class SuccessAnimation extends StatefulWidget {
  final double size;
  final Duration? duration;
  final VoidCallback? onAnimationComplete;
  final bool autoPlay;
  final bool repeat;
  final Color? color;

  const SuccessAnimation({
    Key? key,
    this.size = 60,
    this.duration,
    this.onAnimationComplete,
    this.autoPlay = true,
    this.repeat = false,
    this.color,
  }) : super(key: key);

  @override
  State<SuccessAnimation> createState() => _SuccessAnimationState();
}

class _SuccessAnimationState extends State<SuccessAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 1500),
      vsync: this,
    );

    if (widget.autoPlay) {
      _controller.forward().then((_) {
        if (widget.onAnimationComplete != null) {
          widget.onAnimationComplete!();
        }
        if (widget.repeat) {
          _controller.repeat();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void playAnimation() {
    _controller.reset();
    _controller.forward().then((_) {
      if (widget.onAnimationComplete != null) {
        widget.onAnimationComplete!();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Lottie.network(
        'https://assets2.lottiefiles.com/packages/lf20_jbrw3hcz.json', // Success checkmark animation
        controller: _controller,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.contain,
        repeat: widget.repeat,
        animate: widget.autoPlay,
        onLoaded: (composition) {
          _controller.duration = composition.duration;
        },
      ),
    );
  }
}

/// Alternative success animations - you can switch between these URLs
class SuccessAnimationVariants {
  // Checkmark with circle
  static const String checkmarkCircle = 'https://assets2.lottiefiles.com/packages/lf20_jbrw3hcz.json';

  // Simple checkmark
  static const String simpleCheck = 'https://assets9.lottiefiles.com/packages/lf20_xlkxtmul.json';

  // Success with confetti
  static const String successConfetti = 'https://assets4.lottiefiles.com/packages/lf20_s2lryxtd.json';

  // Thumbs up
  static const String thumbsUp = 'https://assets6.lottiefiles.com/packages/lf20_touohxv0.json';

  // Check with bounce
  static const String checkBounce = 'https://assets5.lottiefiles.com/packages/lf20_atippmpe.json';
}

/// Button state management for loading and success states
enum ButtonState { idle, loading, success, error }

/// Enhanced button with loading and success states
class AnimatedSubmitButton extends StatefulWidget {
  final String idleText;
  final String loadingText;
  final String successText;
  final VoidCallback onPressed;
  final ButtonState state;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final TextStyle? textStyle;
  final Duration animationDuration;

  const AnimatedSubmitButton({
    Key? key,
    required this.idleText,
    required this.onPressed,
    this.loadingText = 'Submitting...',
    this.successText = 'Success!',
    this.state = ButtonState.idle,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 50,
    this.textStyle,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  State<AnimatedSubmitButton> createState() => _AnimatedSubmitButtonState();
}

class _AnimatedSubmitButtonState extends State<AnimatedSubmitButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedSubmitButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state == ButtonState.success && oldWidget.state != ButtonState.success) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }
  }

  Widget _buildButtonContent() {
    switch (widget.state) {
      case ButtonState.loading:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.textColor ?? Colors.white,
                ),
              ),
            ),
            if (widget.loadingText.isNotEmpty) ...[
              const SizedBox(width: 10),
              Text(
                widget.loadingText,
                style: widget.textStyle?.copyWith(
                  color: widget.textColor ?? Colors.white,
                ) ?? TextStyle(
                  color: widget.textColor ?? Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        );

      case ButtonState.success:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SuccessAnimation(
              size: 24,
              duration: const Duration(milliseconds: 1000),
            ),
            if (widget.successText.isNotEmpty) ...[
              const SizedBox(width: 10),
              Text(
                widget.successText,
                style: widget.textStyle?.copyWith(
                  color: widget.textColor ?? Colors.white,
                ) ?? TextStyle(
                  color: widget.textColor ?? Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        );

      case ButtonState.error:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: widget.textColor ?? Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Try Again',
              style: widget.textStyle?.copyWith(
                color: widget.textColor ?? Colors.white,
              ) ?? TextStyle(
                color: widget.textColor ?? Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );

      default:
        return Text(
          widget.idleText,
          style: widget.textStyle?.copyWith(
            color: widget.textColor ?? Colors.white,
          ) ?? TextStyle(
            color: widget.textColor ?? Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: ElevatedButton(
              onPressed: widget.state == ButtonState.loading ? null : widget.onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.backgroundColor ?? Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: widget.state == ButtonState.success ? 8 : 2,
              ),
              child: AnimatedSwitcher(
                duration: widget.animationDuration,
                child: _buildButtonContent(),
              ),
            ),
          ),
        );
      },
    );
  }
}
