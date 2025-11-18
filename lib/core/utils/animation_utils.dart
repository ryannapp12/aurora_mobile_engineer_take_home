import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
/// Utility class for common animations used throughout the app
class AnimationUtils {
  static AnimationController createScaleController({
    Duration duration = const Duration(milliseconds: 100),
    required TickerProvider vsync,
  }) {
    return AnimationController(duration: duration, vsync: vsync);
  }
  static Animation<double> createScaleAnimation({
    required AnimationController controller,
    double scaleDownValue = 0.95,
    Curve curve = Curves.easeInOut,
  }) {
    return Tween<double>(
      begin: 1.0,
      end: scaleDownValue,
    ).animate(CurvedAnimation(parent: controller, curve: curve));
  }
  static Future<void> triggerButtonPressAnimation(
    AnimationController controller, {
    VoidCallback? onComplete,
  }) async {
    HapticFeedback.mediumImpact();
    await controller.forward();
    await controller.reverse();
    onComplete?.call();
  }
  static Widget createAnimatedButton({
    required Widget child,
    required AnimationController controller,
    required Animation<double> animation,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () => triggerButtonPressAnimation(controller, onComplete: onTap),
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.scale(scale: animation.value, child: child);
        },
        child: child,
      ),
    );
  }
}
/// Mixin to provide common animation controllers for widgets
mixin ButtonAnimationMixin<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  late AnimationController _buttonController;
  late Animation<double> _buttonScale;
  /// Initialize button animation
  void initButtonAnimation({
    Duration duration = const Duration(milliseconds: 100),
    double scaleDownValue = 0.95,
    Curve curve = Curves.easeInOut,
  }) {
    _buttonController = AnimationController(duration: duration, vsync: this);
    _buttonScale = Tween<double>(
      begin: 1.0,
      end: scaleDownValue,
    ).animate(CurvedAnimation(parent: _buttonController, curve: curve));
  }
  AnimationController get buttonController => _buttonController;
  Animation<double> get buttonScale => _buttonScale;
  Future<void> triggerButtonPress({VoidCallback? onComplete}) {
    HapticFeedback.mediumImpact();
    return AnimationUtils.triggerButtonPressAnimation(
      _buttonController,
      onComplete: onComplete,
    );
  }
  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }
}
/// Mixin for widgets that need multiple button animations
mixin MultiButtonAnimationMixin<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  final Map<String, AnimationController> _controllers = {};
  final Map<String, Animation<double>> _animations = {};
  /// Initialize multiple button animations
  void initButtonAnimations({
    required List<String> buttonIds,
    Duration duration = const Duration(milliseconds: 100),
    double scaleDownValue = 0.95,
    Curve curve = Curves.easeInOut,
  }) {
    for (final buttonId in buttonIds) {
      final controller = AnimationController(duration: duration, vsync: this);
      final animation = Tween<double>(
        begin: 1.0,
        end: scaleDownValue,
      ).animate(CurvedAnimation(parent: controller, curve: curve));
      _controllers[buttonId] = controller;
      _animations[buttonId] = animation;
    }
  }
  AnimationController? getButtonController(String buttonId) {
    return _controllers[buttonId];
  }
  Animation<double>? getButtonAnimation(String buttonId) {
    return _animations[buttonId];
  }
  Future<void> triggerButtonPress(String buttonId, {VoidCallback? onComplete}) {
    HapticFeedback.mediumImpact();
    final controller = _controllers[buttonId];
    if (controller == null) {
      onComplete?.call();
      return Future.value();
    }
    return AnimationUtils.triggerButtonPressAnimation(
      controller,
      onComplete: onComplete,
    );
  }
  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    _animations.clear();
    super.dispose();
  }
}
/// Slide + Fade implicit animation helper widget
class SlideFade extends StatelessWidget {
  const SlideFade({
    super.key,
    required this.visible,
    required this.child,
    this.beginOffset = const Offset(0, 0.2),
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeOutCubic,
  });
  final bool visible;
  final Widget child;
  final Offset beginOffset;
  final Duration duration;
  final Curve curve;
  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: visible ? Offset.zero : beginOffset,
      duration: duration,
      curve: curve,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: duration,
        curve: curve,
        child: child,
      ),
    );
  }
}
/// Pop dismiss animation utilities and mixin
class PopDismissUtils {
  static AnimationController createController({
    required TickerProvider vsync,
    Duration duration = const Duration(milliseconds: 220),
  }) {
    return AnimationController(duration: duration, vsync: vsync);
  }
  /// Scale sequence: 1.0 -> popScale -> endScale (used on dismiss)
  static Animation<double> createScale({
    required AnimationController controller,
    double popScale = 1.06,
    double endScale = 0.85,
  }) {
    return TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: popScale,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: popScale,
          end: endScale,
        ).chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 65,
      ),
    ]).animate(controller);
  }
  /// Opacity: 1 -> 0
  static Animation<double> createOpacity({
    required AnimationController controller,
    Curve curve = Curves.easeOutCubic,
  }) {
    return Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).chain(CurveTween(curve: curve)).animate(controller);
  }
  /// Triggers the pop dismiss animation then calls onComplete.
  static Future<void> trigger(
    AnimationController controller, {
    VoidCallback? onComplete,
  }) async {
    HapticFeedback.mediumImpact();
    await controller.forward();
    onComplete?.call();
  }
}
mixin PopDismissAnimationMixin<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  late AnimationController _popController;
  late Animation<double> _popScale;
  late Animation<double> _popOpacity;
  void initPopDismissAnimation({
    Duration duration = const Duration(milliseconds: 220),
    double popScale = 1.06,
    double endScale = 0.85,
    Curve opacityCurve = Curves.easeOutCubic,
  }) {
    _popController = PopDismissUtils.createController(
      vsync: this,
      duration: duration,
    );
    _popScale = PopDismissUtils.createScale(
      controller: _popController,
      popScale: popScale,
      endScale: endScale,
    );
    _popOpacity = PopDismissUtils.createOpacity(
      controller: _popController,
      curve: opacityCurve,
    );
  }
  AnimationController get popDismissController => _popController;
  Animation<double> get popDismissScale => _popScale;
  Animation<double> get popDismissOpacity => _popOpacity;
  Future<void> triggerPopDismiss({VoidCallback? onComplete}) {
    return PopDismissUtils.trigger(_popController, onComplete: onComplete);
  }
  @override
  void dispose() {
    _popController.dispose();
    super.dispose();
  }
}