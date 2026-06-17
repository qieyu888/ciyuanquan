import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/mock_data.dart';
import '../utils/constants.dart';
import '../widgets/user_card.dart';
import 'user_profile_screen.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late List<User> users;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    users = List.from(mockUsers);
  }

  void _handleLike() {
    if (currentIndex < users.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('没有更多用户了')),
      );
    }
  }

  void _handleDislike() {
    if (currentIndex < users.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('没有更多用户了')),
      );
    }
  }

  void _openUserProfile(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfileScreen(user: user),
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
          '发现',
          style: AppTextStyles.headline2,
        ),
        centerTitle: true,
      ),
      body: currentIndex < users.length
          ? Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: UserCard(
                user: users[currentIndex],
                onLike: _handleLike,
                onDislike: _handleDislike,
                onTap: () => _openUserProfile(users[currentIndex]),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sentiment_satisfied_alt,
                    size: 64,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    '没有更多用户了',
                    style: AppTextStyles.headline3,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '稍后再来看看吧',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
    );
  }
}
