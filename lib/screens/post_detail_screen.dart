import 'package:flutter/material.dart';
import '../models/models.dart';
import '../utils/constants.dart';
import '../utils/image_helper.dart';
import '../services/block_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PostDetailScreen extends StatefulWidget {
  final Post post;

  const PostDetailScreen({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late Post post;
  final TextEditingController _commentController = TextEditingController();
  final BlockService _blockService = BlockService();

  @override
  void initState() {
    super.initState();
    post = widget.post;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      post = post.copyWith(
        isLiked: !post.isLiked,
        likes: post.isLiked ? post.likes - 1 : post.likes + 1,
      );
    });
  }

  void _toggleFollow() {
    setState(() {
      final updatedUser = post.user.copyWith(
        isFollowing: !post.user.isFollowing,
      );
      post = post.copyWith(user: updatedUser);
    });
  }

  void _showMoreOptions() {
    // Check if this is the user's own post (user id 999 is the current user)
    bool isOwnPost = post.user.id == 999;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppRadius.xl),
              topRight: Radius.circular(AppRadius.xl),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: AppSpacing.md),
                // 顶部指示条
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                // 如果是自己的帖子，显示删除选项
                if (isOwnPost)
                  _buildMenuOption(
                    icon: Icons.delete_outline,
                    title: '删除',
                    subtitle: '删除此帖子',
                    color: Colors.red,
                    onTap: () {
                      Navigator.pop(context);
                      _showDeleteConfirmDialog();
                    },
                  )
                else ...[
                  // 拉黑选项
                  _buildMenuOption(
                    icon: Icons.block,
                    title: '拉黑',
                    subtitle: '不再看到此用户的内容',
                    color: AppColors.error,
                    onTap: () {
                      Navigator.pop(context);
                      _showConfirmDialog(
                        title: '拉黑用户',
                        content: '确定要拉黑 ${post.user.name} 吗？拉黑后将不再看到该用户的任何内容。',
                        onConfirm: () {
                          // 拉黑用户
                          _blockService.blockUser(post.user.id);
                          
                          // 显示提示
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('已拉黑 ${post.user.name}'),
                              backgroundColor: AppColors.error,
                            ),
                          );
                          
                          // 关闭确认对话框
                          Navigator.pop(context);
                          
                          // 跳转到首页
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                      );
                    },
                  ),
                  Divider(color: AppColors.divider, height: 1),
                  // 举报选项
                  _buildMenuOption(
                    icon: Icons.flag_outlined,
                    title: '举报',
                    subtitle: '举报不当内容',
                    color: AppColors.warning,
                    onTap: () {
                      Navigator.pop(context);
                      _showReportDialog();
                    },
                  ),
                  Divider(color: AppColors.divider, height: 1),
                  // 不感兴趣选项
                  _buildMenuOption(
                    icon: Icons.visibility_off_outlined,
                    title: '不感兴趣',
                    subtitle: '减少此类内容推荐',
                    color: AppColors.textSecondary,
                    onTap: () {
                      Navigator.pop(context);
                      
                      // 屏蔽帖子
                      _blockService.hidePost(post.id);
                      
                      // 显示提示
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('已标记为不感兴趣'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      
                      // 跳转到首页
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('删除帖子'),
          content: const Text('确定要删除这条帖子吗？'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                '取消',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // 返回上一页
                Navigator.pop(context);
              },
              child: const Text(
                '删除',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textTertiary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmDialog({
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          title: Text(
            title,
            style: AppTextStyles.headline3,
          ),
          content: Text(
            content,
            style: AppTextStyles.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                '取消',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: onConfirm,
              child: Text(
                '确定',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => _ReportDialog(
        post: post,
        onReportSubmitted: () {
          // 屏蔽该帖子
          _blockService.hidePost(post.id);
          
          // 显示成功提示
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('举报已提交，感谢您的反馈'),
              backgroundColor: AppColors.success,
            ),
          );
          
          // 跳转到首页
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 改为纯白色背景
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.textPrimary,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '帖子详情',
          style: AppTextStyles.headline3,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            color: AppColors.textPrimary,
            onPressed: _showMoreOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 用户信息
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: getImageProvider(post.user.avatar),
                        backgroundColor: AppColors.primaryLight,
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
                      // 美化的关注按钮（仅在不是自己的帖子时显示）
                      if (post.user.id != 999)
                        GestureDetector(
                          onTap: _toggleFollow,
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
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // 内容
                  Text(
                    post.content,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // 标签
                  Container(
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
                  const SizedBox(height: AppSpacing.lg),
                  // 图片
                  if (post.image != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      child: buildImage(
                        post.image!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  if (post.image != null) const SizedBox(height: AppSpacing.xl),
                  // 互动数据
                  Row(
                    children: [
                      Text(
                        '${post.likes} 赞',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Text(
                        '${post.comments} 评论',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Divider(
                    color: AppColors.divider,
                    height: 1,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  // 评论标题
                  Text(
                    '全部评论 (${post.comments})',
                    style: AppTextStyles.headline3,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // 评论列表
                  ...List.generate(
                    post.comments,
                    (index) {
                      final commentNames = [
                        '小明', '小红', '小刚', '小丽', '小华', '小芳',
                        '小强', '小美', '小杰', '小雪', '小龙', '小凤'
                      ];
                      final commentTexts = [
                        '这个帖子真的很棒！我也很喜欢这个话题。',
                        '说得太好了，完全同意你的观点！',
                        '很有意思的分享，学到了很多。',
                        '感谢分享，期待更多精彩内容。',
                        '这个角度很独特，给了我新的启发。',
                        '写得真好，已经收藏了！',
                        '非常赞同，我也有类似的经历。',
                        '太棒了，继续加油！',
                        '很有深度的内容，值得细细品味。',
                        '说到心坎里了，感同身受。',
                        '精彩的分享，受益匪浅。',
                        '很棒的内容，期待下一篇！'
                      ];
                      final avatarUrls = [
                        'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop',
                        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop',
                        'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=100&h=100&fit=crop',
                        'https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=100&h=100&fit=crop',
                        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop',
                        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop',
                        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop',
                        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&h=100&fit=crop',
                        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop',
                        'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&h=100&fit=crop',
                        'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100&h=100&fit=crop',
                        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&h=100&fit=crop',
                      ];
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: getImageProvider(avatarUrls[index]),
                              backgroundColor: AppColors.greyLight,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    commentNames[index],
                                    style: AppTextStyles.labelMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    commentTexts[index],
                                    style: AppTextStyles.bodySmall,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '2小时前',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // 底部互动栏
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border(
                top: BorderSide(
                  color: AppColors.divider,
                  width: 1,
                ),
              ),
            ),
            padding: EdgeInsets.only(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              top: AppSpacing.md,
              bottom: AppSpacing.md + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.greyLight,
                          borderRadius: BorderRadius.circular(AppRadius.circle),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: '说点什么...',
                            hintStyle: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textTertiary,
                            ),
                            border: InputBorder.none,
                          ),
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    GestureDetector(
                      onTap: _toggleLike,
                      child: Icon(
                        post.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: post.isLiked ? AppColors.primary : AppColors.textTertiary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    GestureDetector(
                      onTap: () {
                        if (_commentController.text.isNotEmpty) {
                          setState(() {
                            post = post.copyWith(
                              comments: post.comments + 1,
                            );
                          });
                          _commentController.clear();
                        }
                      },
                      child: Icon(
                        Icons.send,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 举报对话框组件
class _ReportDialog extends StatefulWidget {
  final Post post;
  final VoidCallback onReportSubmitted;

  const _ReportDialog({
    required this.post,
    required this.onReportSubmitted,
  });

  @override
  State<_ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<_ReportDialog> {
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  String? _selectedReason;

  final List<String> _reportReasons = [
    '垃圾广告',
    '色情低俗',
    '违法违规',
    '侵权内容',
    '人身攻击',
    '其他原因',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('选择图片失败，请重试'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _submitReport() {
    if (_selectedReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请选择举报原因'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请输入举报描述'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    // 关闭对话框
    Navigator.pop(context);
    
    // 调用回调
    widget.onReportSubmitted();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题栏
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.divider,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '举报内容',
                      style: AppTextStyles.headline3,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // 内容区域
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 被举报用户信息
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.greyLight,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: getImageProvider(widget.post.user.avatar),
                            backgroundColor: AppColors.primaryLight,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.post.user.name,
                                  style: AppTextStyles.labelLarge,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '举报该用户的内容',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // 举报原因
                    Text(
                      '举报原因',
                      style: AppTextStyles.labelLarge,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: _reportReasons.map((reason) {
                        final isSelected = _selectedReason == reason;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedReason = reason;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.sm,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.greyLight,
                              borderRadius: BorderRadius.circular(AppRadius.full),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.divider,
                              ),
                            ),
                            child: Text(
                              reason,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textPrimary,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // 详细描述
                    Text(
                      '详细描述',
                      style: AppTextStyles.labelLarge,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.greyLight,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: 4,
                        maxLength: 200,
                        decoration: InputDecoration(
                          hintText: '请详细描述举报原因（必填）',
                          hintStyle: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          border: InputBorder.none,
                          counterStyle: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // 上传图片
                    Text(
                      '上传证据（选填）',
                      style: AppTextStyles.labelLarge,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.greyLight,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(
                            color: AppColors.divider,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: _selectedImage != null
                            ? Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(AppRadius.md),
                                    child: Image.file(
                                      File(_selectedImage!.path),
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedImage = null;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
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
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 40,
                                    color: AppColors.textTertiary,
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    '点击上传图片证据',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '最多1张',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textTertiary,
                                      fontSize: 10,
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
            // 底部按钮
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
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                        backgroundColor: AppColors.greyLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      child: Text(
                        '取消',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextButton(
                      onPressed: _submitReport,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                        backgroundColor: AppColors.error,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      child: Text(
                        '提交举报',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: Colors.white,
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
    );
  }
}
