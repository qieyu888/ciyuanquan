import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/models.dart';
import '../data/mock_data.dart';
import '../utils/constants.dart';
import '../widgets/post_card.dart';
import '../services/block_service.dart';
import '../services/user_service.dart';
import 'post_detail_screen.dart';
import 'user_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Post> posts;
  late ScrollController _scrollController;
  final BlockService _blockService = BlockService();
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _contentController = TextEditingController();
  String? _selectedImagePath;
  String _selectedTag = '绘画';

  @override
  void initState() {
    super.initState();
    posts = List.from(mockPosts);
    _scrollController = ScrollController();
    // 监听拉黑和屏蔽状态变化
    _blockService.addListener(_onBlockServiceChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _contentController.dispose();
    _blockService.removeListener(_onBlockServiceChanged);
    super.dispose();
  }

  void _onBlockServiceChanged() {
    // 当拉黑或屏蔽状态改变时，刷新列表
    setState(() {});
  }

  /// 获取过滤后的帖子列表（排除被拉黑用户和被屏蔽的帖子）
  List<Post> get _filteredPosts {
    return posts.where((post) {
      // 过滤被拉黑的用户
      if (_blockService.isUserBlocked(post.user.id)) {
        return false;
      }
      // 过滤被屏蔽的帖子
      if (_blockService.isPostHidden(post.id)) {
        return false;
      }
      return true;
    }).toList();
  }

  void _toggleLike(int postId) {
    setState(() {
      final index = posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        final post = posts[index];
        posts[index] = post.copyWith(
          isLiked: !post.isLiked,
          likes: post.isLiked ? post.likes - 1 : post.likes + 1,
        );
      }
    });
  }

  void _toggleFollow(int userId) {
    setState(() {
      final index = posts.indexWhere((p) => p.user.id == userId);
      if (index != -1) {
        final post = posts[index];
        final updatedUser = post.user.copyWith(
          isFollowing: !post.user.isFollowing,
        );
        posts[index] = post.copyWith(user: updatedUser);
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

  void _showPublishDialog() {
    String dialogSelectedTag = _selectedTag;
    String? dialogSelectedImagePath = _selectedImagePath;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(AppSpacing.lg),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppRadius.xl),
                      topRight: Radius.circular(AppRadius.xl),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '发布动态',
                        style: AppTextStyles.headline3.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          _contentController.clear();
                          _selectedImagePath = null;
                          _selectedTag = '绘画';
                        },
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
                        // 内容输入框
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
                            controller: _contentController,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: '分享你的想法、创意或日常碎片...',
                              hintStyle: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textTertiary,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(AppSpacing.lg),
                            ),
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 15,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        // 标签选择
                        Text(
                          '选择标签',
                          style: AppTextStyles.labelMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.greyLight,
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                          child: Wrap(
                            spacing: AppSpacing.md,
                            runSpacing: AppSpacing.md,
                            children: [
                              '绘画',
                              '游戏',
                              '摄影',
                              '动画',
                              '音乐',
                              '文艺',
                              '美食',
                              '其他',
                            ]
                                .map((tag) => GestureDetector(
                                      onTap: () {
                                        setDialogState(() {
                                          dialogSelectedTag = tag;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: AppSpacing.md,
                                          vertical: AppSpacing.sm,
                                        ),
                                        decoration: BoxDecoration(
                                          color: dialogSelectedTag == tag
                                              ? AppColors.primary
                                              : AppColors.white,
                                          borderRadius:
                                              BorderRadius.circular(AppRadius.circle),
                                          border: Border.all(
                                            color: dialogSelectedTag == tag
                                                ? AppColors.primary
                                                : AppColors.divider,
                                            width: 1.5,
                                          ),
                                          boxShadow: dialogSelectedTag == tag
                                              ? [
                                                  BoxShadow(
                                                    color: AppColors.primary
                                                        .withOpacity(0.3),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ]
                                              : [],
                                        ),
                                        child: Text(
                                          tag,
                                          style: AppTextStyles.bodySmall.copyWith(
                                            color: dialogSelectedTag == tag
                                                ? AppColors.white
                                                : AppColors.textPrimary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        // 图片选择
                        Text(
                          '上传图片（可选）',
                          style: AppTextStyles.labelMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        if (dialogSelectedImagePath != null)
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
                                    File(dialogSelectedImagePath!),
                                    width: double.infinity,
                                    height: 180,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 12,
                                right: 12,
                                child: GestureDetector(
                                  onTap: () {
                                    setDialogState(() {
                                      dialogSelectedImagePath = null;
                                    });
                                  },
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.red.withOpacity(0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 20,
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
                                    dialogSelectedImagePath = image.path;
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
                              height: 120,
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
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.add_photo_alternate_outlined,
                                      color: AppColors.primary,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  Text(
                                    '点击选择图片',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w500,
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
                // Footer with buttons
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
                          onTap: () {
                            Navigator.pop(context);
                            _contentController.clear();
                            _selectedImagePath = null;
                            _selectedTag = '绘画';
                          },
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
                            if (_contentController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('请输入动态内容')),
                              );
                              return;
                            }

                            // 创建新帖子
                            final userService = UserService();
                            final newPost = Post(
                              id: posts.length + 2000,
                              user: User(
                                id: 999,
                                name: userService.userName,
                                avatar: userService.userAvatar,
                                tag: dialogSelectedTag,
                                bio: userService.userBio,
                                age: 22,
                                distance: 0,
                                interests: ['动画', '游戏', '绘画'],
                              ),
                              time: '刚刚',
                              content: _contentController.text,
                              image: dialogSelectedImagePath,
                              likes: 0,
                              comments: 0,
                              isLiked: false,
                            );

                            setState(() {
                              posts.insert(0, newPost);
                            });

                            Navigator.pop(context);
                            _contentController.clear();
                            _selectedImagePath = null;
                            _selectedTag = '绘画';

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('发布成功'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.primary.withOpacity(0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '发布',
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: AppColors.white,
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
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        toolbarHeight: 70,
        title: Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 100,
            height: 45,
            child: Image.asset(
              'assets/images/img.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showPublishDialog,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: _filteredPosts.length,
        itemBuilder: (context, index) {
          final post = _filteredPosts[index];
          return PostCard(
            post: post,
            onTap: () => _openPostDetail(post),
            onLike: () => _toggleLike(post.id),
            onComment: () => _openPostDetail(post),
            onUserTap: () => _openUserProfile(post.user),
            showFollowButton: true, // 首页显示关注按钮
            onFollow: () => _toggleFollow(post.user.id), // 关注功能
          );
        },
      ),
    );
  }
}
