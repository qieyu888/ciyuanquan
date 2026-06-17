import 'package:flutter/material.dart';
import '../models/models.dart';
import '../utils/constants.dart';
import '../utils/image_helper.dart';

class UserCard extends StatefulWidget {
  final User user;
  final VoidCallback onLike;
  final VoidCallback onDislike;
  final VoidCallback onTap;

  const UserCard({
    Key? key,
    required this.user,
    required this.onLike,
    required this.onDislike,
    required this.onTap,
  }) : super(key: key);

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;
  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleSwipe(DragEndDetails details) {
    const double swipeThreshold = 100;
    final double velocity = details.velocity.pixelsPerSecond.dx;

    if (velocity.abs() > 500 || _dragOffset.dx.abs() > swipeThreshold) {
      // 右滑 - 喜欢
      if (_dragOffset.dx > 0 || velocity > 500) {
        _animateSwipe(true);
      }
      // 左滑 - 不喜欢
      else if (_dragOffset.dx < 0 || velocity < -500) {
        _animateSwipe(false);
      }
    } else {
      // 重置位置
      _resetPosition();
    }
  }

  void _animateSwipe(bool isLike) {
    final targetOffset = isLike ? 500.0 : -500.0;
    
    _slideAnimation = Tween<Offset>(
      begin: Offset(_dragOffset.dx / 100, 0),
      end: Offset(targetOffset / 100, 0),
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _animationController.forward().then((_) {
      if (mounted) {
        isLike ? widget.onLike() : widget.onDislike();
        _resetPosition();
      }
    });
  }

  void _resetPosition() {
    _dragOffset = Offset.zero;
    _isDragging = false;
    _animationController.reset();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dragOffset = Offset(_dragOffset.dx + details.delta.dx, 0);
          _isDragging = true;
        });
      },
      onHorizontalDragEnd: _handleSwipe,
      child: Transform.translate(
        offset: _isDragging ? _dragOffset : Offset.zero,
        child: Opacity(
          opacity: _isDragging ? (1 - (_dragOffset.dx.abs() / 500)).clamp(0.0, 1.0) : 1.0,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              boxShadow: [AppShadows.lg],
            ),
            child: Stack(
              children: [
                // 背景图片
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  child: buildImage(
                    widget.user.avatar,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // 如果图片加载失败，显示渐变背景
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primary.withValues(alpha: 0.3),
                              AppColors.primaryLight.withValues(alpha: 0.3),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.person,
                            size: 80,
                            color: AppColors.primary.withValues(alpha: 0.5),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // 渐变遮罩
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
                // 左滑提示 (不喜欢)
                if (_isDragging && _dragOffset.dx < -20)
                  Positioned(
                    top: AppSpacing.lg,
                    left: AppSpacing.lg,
                    child: Opacity(
                      opacity: (_dragOffset.dx.abs() / 200).clamp(0.0, 1.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        child: Text(
                          '不喜欢',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                // 右滑提示 (喜欢)
                if (_isDragging && _dragOffset.dx > 20)
                  Positioned(
                    top: AppSpacing.lg,
                    right: AppSpacing.lg,
                    child: Opacity(
                      opacity: (_dragOffset.dx / 200).clamp(0.0, 1.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        child: Text(
                          '喜欢',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                // 用户信息
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${widget.user.name}, ${widget.user.age}',
                              style: AppTextStyles.headline3.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(AppRadius.circle),
                              ),
                              child: Text(
                                '${widget.user.distance.toStringAsFixed(1)}km',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          widget.user.bio ?? '',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Wrap(
                          spacing: AppSpacing.sm,
                          children: widget.user.interests
                              .map(
                                (interest) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md,
                                    vertical: AppSpacing.xs,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(AppRadius.circle),
                                  ),
                                  child: Text(
                                    interest,
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                // 操作按钮
                Positioned(
                  bottom: AppSpacing.lg,
                  right: AppSpacing.lg,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _animateSwipe(false);
                        },
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                            boxShadow: [AppShadows.lg],
                          ),
                          child: Icon(
                            Icons.close,
                            color: AppColors.textTertiary,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      GestureDetector(
                        onTap: () {
                          _animateSwipe(true);
                        },
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [AppShadows.lg],
                          ),
                          child: Icon(
                            Icons.favorite,
                            color: AppColors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
