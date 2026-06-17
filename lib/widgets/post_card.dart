import 'package:flutter/material.dart';
import '../models/models.dart';
import '../utils/constants.dart';
import '../utils/image_helper.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onUserTap;
  final VoidCallback? onDelete; // 可选的删除回调
  final VoidCallback? onFollow; // 可选的关注回调
  final bool showFollowButton; // 是否显示关注按钮

  const PostCard({
    Key? key,
    required this.post,
    required this.onTap,
    required this.onLike,
    required this.onComment,
    required this.onUserTap,
    this.onDelete, // 可选参数
    this.onFollow, // 可选参数
    this.showFollowButton = false, // 默认不显示
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [AppShadows.sm],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 用户信息
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onUserTap,
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primaryLight,
                      backgroundImage: getImageProvider(post.user.avatar),
                      onBackgroundImageError: (exception, stackTrace) {
                        // Fallback to text if image fails to load
                      },
                      child: post.user.avatar.isEmpty
                          ? Text(
                              post.user.name.substring(0, 1),
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.user.name,
                          style: AppTextStyles.labelLarge,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          post.time,
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  // 关注按钮（美化版）
                  if (showFollowButton && onFollow != null)
                    GestureDetector(
                      onTap: onFollow,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: post.user.isFollowing
                              ? null
                              : LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.primary.withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                          color: post.user.isFollowing ? AppColors.greyLight : null,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: post.user.isFollowing
                              ? null
                              : [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              post.user.isFollowing ? Icons.check : Icons.add,
                              color: post.user.isFollowing
                                  ? AppColors.textSecondary
                                  : Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              post.user.isFollowing ? '已关注' : '关注',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: post.user.isFollowing
                                    ? AppColors.textSecondary
                                    : Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // 删除按钮（仅在提供 onDelete 回调时显示）
                  if (onDelete != null)
                    GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.xs),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // 内容
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text(
                post.content,
                style: AppTextStyles.bodyMedium,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // 标签
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.greyLight,
                  borderRadius: BorderRadius.circular(AppRadius.circle),
                ),
                child: Text(
                  '#${post.user.tag}',
                  style: AppTextStyles.labelSmall,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // 图片
            if (post.image != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  child: buildImage(
                    post.image!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            if (post.image != null) const SizedBox(height: AppSpacing.md),
            // 互动按钮
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onLike,
                    child: Row(
                      children: [
                        Icon(
                          post.isLiked ? Icons.favorite : Icons.favorite_border,
                          color: post.isLiked ? AppColors.primary : AppColors.textTertiary,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          post.likes.toString(),
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xl),
                  GestureDetector(
                    onTap: onComment,
                    child: Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          color: AppColors.textTertiary,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          post.comments.toString(),
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
