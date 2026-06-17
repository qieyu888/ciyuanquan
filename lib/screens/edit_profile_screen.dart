import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/constants.dart';
import '../utils/image_helper.dart';
import '../widgets/pink_button.dart';
import '../services/user_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  String? _selectedImagePath;
  late String _currentAvatarPath;
  final ImagePicker _imagePicker = ImagePicker();
  late UserService _userService;

  @override
  void initState() {
    super.initState();
    _userService = UserService();
    _nameController = TextEditingController(text: _userService.userName);
    _bioController = TextEditingController(text: _userService.userBio);
    _currentAvatarPath = _userService.userAvatar;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null && mounted) {
        setState(() {
          _selectedImagePath = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('选择图片失败: $e')),
        );
      }
    }
  }

  void _saveProfile() {
    Navigator.pop(context, {
      'name': _nameController.text,
      'bio': _bioController.text,
      'avatar': _selectedImagePath,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            '取消',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        title: Text(
          '编辑资料',
          style: AppTextStyles.headline3,
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: Text(
              '保存',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            // 头像编辑
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: getImageProvider(
                      _selectedImagePath ?? _currentAvatarPath,
                    ),
                    backgroundColor: AppColors.primaryLight,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.white,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: AppColors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            // 用户名输入框
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: [AppShadows.sm],
              ),
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '用户名',
                    style: AppTextStyles.labelMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: '输入用户名',
                      hintStyle: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: const BorderSide(
                          color: AppColors.divider,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: const BorderSide(
                          color: AppColors.divider,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                    ),
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // 个人简介输入框
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: [AppShadows.sm],
              ),
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '个人简介',
                    style: AppTextStyles.labelMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _bioController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: '介绍一下自己吧...',
                      hintStyle: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: const BorderSide(
                          color: AppColors.divider,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: const BorderSide(
                          color: AppColors.divider,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                    ),
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            // 保存按钮
            PinkButton(
              text: '保存修改',
              onPressed: _saveProfile,
              isFullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}
