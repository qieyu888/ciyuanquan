import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import 'login_screen.dart';

// 引导页数据
class _OnboardingPage {
  final String emoji;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;

  const _OnboardingPage({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
  });
}

const _pages = [
  _OnboardingPage(
    emoji: '🌸',
    title: '发现同好',
    subtitle: '在次元圈找到和你\n热爱同一个世界的人',
    gradientColors: [Color(0xFFFFC0D9), Color(0xFFEC7BA8)],
  ),
  _OnboardingPage(
    emoji: '🪆',
    title: '手办分享',
    subtitle: '晒出你的珍藏宝贝\n和懂你的人一起欣赏',
    gradientColors: [Color(0xFFCE93D8), Color(0xFF9C27B0)],
  ),
  _OnboardingPage(
    emoji: '✨',
    title: '加入次元圈',
    subtitle: '分享热爱，遇见同好\n你的二次元之旅从这里开始',
    gradientColors: [Color(0xFF80DEEA), Color(0xFF00BCD4)],
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // 每页的动画控制器
  late List<AnimationController> _emojiControllers;
  late List<AnimationController> _textControllers;
  late List<Animation<double>> _emojiScales;
  late List<Animation<Offset>> _textSlides;
  late List<Animation<double>> _textOpacities;

  @override
  void initState() {
    super.initState();

    _emojiControllers = List.generate(
      _pages.length,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      ),
    );
    _textControllers = List.generate(
      _pages.length,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ),
    );

    _emojiScales = _emojiControllers
        .map(
          (c) => Tween<double>(begin: 0.6, end: 1.0).animate(
            CurvedAnimation(parent: c, curve: Curves.elasticOut),
          ),
        )
        .toList();

    _textSlides = _textControllers
        .map(
          (c) => Tween<Offset>(
            begin: const Offset(0, 0.3),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: c, curve: Curves.easeOut)),
        )
        .toList();

    _textOpacities = _textControllers
        .map(
          (c) => Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: c, curve: Curves.easeIn),
          ),
        )
        .toList();

    // 启动第一页动画
    _playPageAnimation(0);
  }

  void _playPageAnimation(int index) {
    _emojiControllers[index].forward(from: 0);
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _textControllers[index].forward(from: 0);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (final c in _emojiControllers) c.dispose();
    for (final c in _textControllers) c.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── PageView ──
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (i) {
              setState(() => _currentPage = i);
              _playPageAnimation(i);
            },
            itemBuilder: (_, i) => _PageContent(
              page: _pages[i],
              emojiScale: _emojiScales[i],
              textSlide: _textSlides[i],
              textOpacity: _textOpacities[i],
            ),
          ),

          // ── 底部控制区 ──
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xxl, 0, AppSpacing.xxl, AppSpacing.xxl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 指示点
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == i ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == i
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // 主按钮
                    GestureDetector(
                      onTap: _nextPage,
                      child: Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(AppRadius.full),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withValues(alpha: 0.12),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _currentPage < _pages.length - 1
                                ? '下一步'
                                : '立即体验',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: _pages[_currentPage]
                                  .gradientColors
                                  .last,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 跳过按钮（最后一页隐藏）
                    if (_currentPage < _pages.length - 1)
                      TextButton(
                        onPressed: _finish,
                        child: Text(
                          '跳过',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      )
                    else
                      const SizedBox(height: 36),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 单页内容 ─────────────────────────────────
class _PageContent extends StatelessWidget {
  final _OnboardingPage page;
  final Animation<double> emojiScale;
  final Animation<Offset> textSlide;
  final Animation<double> textOpacity;

  const _PageContent({
    required this.page,
    required this.emojiScale,
    required this.textSlide,
    required this.textOpacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: page.gradientColors,
        ),
      ),
      child: Column(
        children: [
          // 顶部装饰圆
          Expanded(
            flex: 3,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 背景大圆
                Positioned(
                  top: -60,
                  right: -60,
                  child: Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: -40,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                ),
                // Emoji 主图
                ScaleTransition(
                  scale: emojiScale,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 30,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        page.emoji,
                        style: const TextStyle(fontSize: 80),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 文字区
          Expanded(
            flex: 2,
            child: SlideTransition(
              position: textSlide,
              child: FadeTransition(
                opacity: textOpacity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xxl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        page.title,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        page.subtitle,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.85),
                          height: 1.8,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 给底部控制区留空间
          const SizedBox(height: 160),
        ],
      ),
    );
  }
}
