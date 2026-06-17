import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/models.dart';
import '../utils/constants.dart';
import '../data/mock_data.dart';
import '../widgets/post_card.dart';
import '../services/block_service.dart';
import 'post_detail_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final User user;

  const UserProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool isFollowing = false;
  late List<Post> userPosts;
  final BlockService _blockService = BlockService();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    userPosts = mockPosts.where((post) => post.user.id == widget.user.id).toList();
  }

  void _toggleLike(int postId) {
    setState(() {
      final index = userPosts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        final post = userPosts[index];
        userPosts[index] = post.copyWith(
          isLiked: !post.isLiked,
          likes: post.isLiked ? post.likes - 1 : post.likes + 1,
        );
      }
    });
  }

  void _openPostDetail(Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailScreen(post: post),
      ),
    );
  }

  void _openUserProfile(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfileScreen(user: user),
      ),
    );
  }

  void _showMoreMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppRadius.xl),
            topRight: Radius.circular(AppRadius.xl),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.md),
            // 拉黑选项
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                _blockService.blockUser(widget.user.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('已拉黑 ${widget.user.name}'),
                    duration: const Duration(seconds: 2),
                  ),
                );
                // 返回到首页
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(
                    color: AppColors.divider,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE5E5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.block,
                        color: Color(0xFFFF6B6B),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '拉黑',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '不再看到此用户的内容',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textTertiary,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
            // 举报选项
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                _showReportDialog();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(
                    color: AppColors.divider,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF5E5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.flag,
                        color: Color(0xFFFFA500),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '举报',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '举报不当内容',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textTertiary,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
            // 不感兴趣选项
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                // 屏蔽该用户的所有帖子
                for (var post in userPosts) {
                  _blockService.hidePost(post.id);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('已屏蔽此用户的动态'),
                    duration: Duration(seconds: 2),
                  ),
                );
                // 返回到首页
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(
                    color: AppColors.divider,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E8E8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.volume_off,
                        color: Color(0xFF999999),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '不感兴趣',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '减少此类内容推荐',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textTertiary,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  void _showReportDialog() {
    String reportContent = '';
    String? reportImagePath;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(AppSpacing.lg),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppRadius.xl),
                      topRight: Radius.circular(AppRadius.xl),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '举报用户',
                        style: AppTextStyles.heading3.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '举报用户：${widget.user.name}',
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        // 文字输入框
                        Text(
                          '投诉内容',
                          style: AppTextStyles.labelMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.greyLight,
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                            border: Border.all(
                              color: AppColors.divider,
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            onChanged: (value) {
                              reportContent = value;
                            },
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: '请详细描述投诉内容...',
                              hintStyle: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textTertiary,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(AppSpacing.lg),
                            ),
                            style: AppTextStyles.bodySmall,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        // 图片上传
                        Text(
                          '上传图片（可选）',
                          style: AppTextStyles.labelMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        if (reportImagePath != null)
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppRadius.lg),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(AppRadius.lg),
                                  child: Image.file(
                                    File(reportImagePath!),
                                    width: double.infinity,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () {
                                    setDialogState(() {
                                      reportImagePath = null;
                                    });
                                  },
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        else
                          GestureDetector(
                            onTap: () async {
                              try {
                                final XFile? image = await _imagePicker.pickImage(
                                  source: ImageSource.gallery,
                                  maxWidth: 1024,
                                  maxHeight: 1024,
                                  imageQuality: 85,
                                );

                                if (image != null) {
                                  setDialogState(() {
                                    reportImagePath = image.path;
                                  });
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('选择图片失败: $e')),
                                  );
                                }
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 100,
                              decoration: BoxDecoration(
                                color: AppColors.greyLight,
                                borderRadius: BorderRadius.circular(AppRadius.lg),
                                border: Border.all(
                                  color: AppColors.divider,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate_outlined,
                                    color: AppColors.primary,
                                    size: 32,
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    '点击选择图片',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // Footer
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: AppColors.divider,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.greyLight,
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                            ),
                            child: Center(
                              child: Text(
                                '取消',
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (reportContent.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('请输入投诉内容')),
                              );
                              return;
                            }

                            // 屏蔽该用户的所有帖子
                            for (var post in userPosts) {
                              _blockService.hidePost(post.id);
                            }

                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('举报成功，感谢您的反馈'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            // 返回到首页
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                            ),
                            child: Center(
                              child: Text(
                                '确定举报',
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 粉色渐变背景
          Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.8),
                  AppColors.primary,
                ],
              ),
            ),
          ),
          // 主要内容
          CustomScrollView(
            slivers: [
              // 顶部按钮
              SliverToBoxAdapter(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_horiz, color: Colors.white),
                          onPressed: _showMoreMenu,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // 用户信息卡片
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(
                    left: AppSpacing.md,
                    right: AppSpacing.md,
                    top: 60,
                  ),
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    boxShadow: AppShadows.card,
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(AppRadius.full),
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(AppRadius.full),
                              child: widget.user.avatar.startsWith('http')
                                  ? Image.network(
                                      widget.user.avatar,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: AppColors.primary.withOpacity(0.1),
                                          child: Center(
                                            child: Text(
                                              widget.user.name[0],
                                              style: AppTextStyles.heading1.copyWith(
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      widget.user.avatar,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: AppColors.primary.withOpacity(0.1),
                                          child: Center(
                                            child: Text(
                                              widget.user.name[0],
                                              style: AppTextStyles.heading1.copyWith(
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isFollowing = !isFollowing;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.lg,
                                    vertical: AppSpacing.sm,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isFollowing ? AppColors.border : AppColors.primary,
                                    borderRadius: BorderRadius.circular(AppRadius.full),
                                  ),
                                  child: Text(
                                    isFollowing ? '已关注' : '关注',
                                    style: AppTextStyles.body.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Text(
                            widget.user.name,
                            style: AppTextStyles.heading2,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                            ),
                            child: Text(
                              widget.user.tag,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      if (widget.user.bio != null)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.user.bio!,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: [
                          _buildStatItem('24', '关注'),
                          const SizedBox(width: AppSpacing.xl),
                          _buildStatItem('892', '粉丝'),
                          const SizedBox(width: AppSpacing.xl),
                          _buildStatItem('1.5w', '获赞与收藏'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.md,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '动态',
                        style: AppTextStyles.heading3.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '${userPosts.length}',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.primary.withOpacity(0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (userPosts.isEmpty)
                SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Text(
                        '暂无动态',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final post = userPosts[index];
                        return PostCard(
                          post: post,
                          onTap: () => _openPostDetail(post),
                          onLike: () => _toggleLike(post.id),
                          onComment: () => _openPostDetail(post),
                          onUserTap: () => _openUserProfile(post.user),
                        );
                      },
                      childCount: userPosts.length,
                    ),
                  ),
                ),
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xl),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTextStyles.heading2.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
