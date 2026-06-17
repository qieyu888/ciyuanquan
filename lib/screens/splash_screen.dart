import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../services/tracking_service.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );

    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _textController.forward();
    });

    // iOS ATT 授权请求（界面可见后）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TrackingService().requestTrackingIfNeeded();
    });

    // Splash 结束后根据是否首次启动决定跳转目标
    Future.delayed(const Duration(seconds: 3), () async {
      if (!mounted) return;
      final prefs = await SharedPreferences.getInstance();
      final onboardingDone = prefs.getBool('onboarding_done') ?? false;
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => onboardingDone
              ? const LoginScreen()
              : const OnboardingScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _logoScale,
              child: FadeTransition(
                opacity: _logoOpacity,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            FadeTransition(
              opacity: _textOpacity,
              child: Column(
                children: [
                  Text(
                    '次元圈',
                    style: AppTextStyles.headline1.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '分享热爱，遇见同好',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
            FadeTransition(
              opacity: _textOpacity,
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primary.withValues(alpha: 0.6),
                  ),
                  strokeWidth: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
