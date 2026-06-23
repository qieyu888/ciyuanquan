import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/image_helper.dart';
import '../widgets/pink_button.dart';
import '../widgets/post_card.dart';
import '../models/models.dart';
import '../services/user_service.dart';
import '../services/credit_service.dart';
import 'edit_profile_screen.dart';
import 'post_detail_screen.dart';
import 'settings_screen.dart';
import 'credit_store_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserService _userService;
  final CreditService _creditService = CreditService();
  int likes = 128;
  int collections = 45;

  // 当前用户对象
  late User currentUser;
  // 我的动态列表
  late List<Post> myPosts;

  @override
  void initState() {
    super.initState();
    _userService = UserService();
    _creditService.addListener(_onCreditChanged);
    
    // 初始化当前用户
    currentUser = User(
      id: 999,
      name: _userService.userName,
      avatar: _userService.userAvatar,
      tag: '二次元爱好者',
      bio: _userService.userBio,
      age: 22,
      distance: 0,
      interests: ['动画', '游戏', '绘画'],
    );

    // 初始化两条默认动态
    myPosts = [
      Post(
        id: 2001,
        user: currentUser,
        time: '2小时前',
        content: '今天天气真好，出去拍了一些风景照片，感觉心情都变好了！分享给大家～',
        image: 'assets/images/img_j.jpg',
        likes: 42,
        comments: 3,
        isLiked: false,
      ),
      Post(
        id: 2002,
        user: currentUser,
        time: '昨天',
        content: '最近在追新番，剧情真的太精彩了！有没有小伙伴一起讨论的？',
        image: null,
        likes: 28,
        comments: 2,
        isLiked: false,
      ),
    ];
  }

  @override
  void dispose() {
    _creditService.removeListener(_onCreditChanged);
    super.dispose();
  }

  void _onCreditChanged() {
    if (mounted) setState(() {});
  }

  void _openCreditStore() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreditStoreScreen(),
      ),
    );
  }

  void _toggleLike(int postId) {
    setState(() {
      final index = myPosts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        final post = myPosts[index];
        myPosts[index] = post.copyWith(
          isLiked: !post.isLiked,
          likes: post.isLiked ? post.likes - 1 : post.likes + 1,
        );
      }
    });
  }

  void _deletePost(int postId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('删除动态'),
          content: const Text('确定要删除这条动态吗？'),
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
                setState(() {
                  myPosts.removeWhere((post) => post.id == postId);
                });
                Navigator.pop(context);
              },
              child: Text(
                '删除',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _openPostDetail(Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailScreen(post: post),
      ),
    );
  }

  void _openEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditProfileScreen(),
      ),
    );
    if (result != null) {
      setState(() {
        _userService.updateUserProfile(
          name: result['name'],
          bio: result['bio'],
          avatar: result['avatar'],
        );
        
        // 更新当前用户信息
        currentUser = currentUser.copyWith(
          name: result['name'] ?? currentUser.name,
          bio: result['bio'] ?? currentUser.bio,
          avatar: result['avatar'] ?? currentUser.avatar,
        );
        
        // 更新所有动态中的用户信息
        myPosts = myPosts.map((post) {
          return post.copyWith(
            user: post.user.copyWith(
              name: result['name'] ?? post.user.name,
              bio: result['bio'] ?? post.user.bio,
              avatar: result['avatar'] ?? post.user.avatar,
            ),
          );
        }).toList();
      });
    }
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
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
        title: Text(
          '我的',
          style: AppTextStyles.headline2,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            color: AppColors.textPrimary,
            onPressed: _openSettings,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 个人信息卡片
            Container(
              margin: const EdgeInsets.all(AppSpacing.lg),
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: [AppShadows.md],
              ),
              child: Column(
                children: [
                  // 头像
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: getImageProvider(_userService.userAvatar),
                    backgroundColor: AppColors.primaryLight,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // 用户名
                  Text(
                    _userService.userName,
                    style: AppTextStyles.headline3,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  // 个人简介
                  Text(
                    _userService.userBio,
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  // 编辑按钮
                  PinkButton(
                    text: '编辑资料',
                    onPressed: _openEditProfile,
                    isFullWidth: true,
                  ),
                ],
              ),
            ),
            // 积分充值
            GestureDetector(
              onTap: _openCreditStore,
              child: Container(
                margin: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withValues(alpha: 0.85),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.monetization_on,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '我的积分',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_creditService.credits}',
                            style: AppTextStyles.headline2.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.circle),
                      ),
                      child: Text(
                        '充值',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 统计信息
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        boxShadow: [AppShadows.sm],
                      ),
                      child: Column(
                        children: [
                          Text(
                            likes.toString(),
                            style: AppTextStyles.headline2.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            '获赞',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        boxShadow: [AppShadows.sm],
                      ),
                      child: Column(
                        children: [
                          Text(
                            collections.toString(),
                            style: AppTextStyles.headline2.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            '收藏',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            // 我的发布标题
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
                    '${myPosts.length}',
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
            const SizedBox(height: AppSpacing.md),
            // 动态列表
            ...myPosts.map((post) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: PostCard(
                post: post,
                onTap: () => _openPostDetail(post),
                onLike: () => _toggleLike(post.id),
                onComment: () => _openPostDetail(post),
                onUserTap: () {}, // 当前用户，不需要跳转
                onDelete: () => _deletePost(post.id), // 添加删除功能
              ),
            )).toList(),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
