import 'package:flutter/foundation.dart';

/// 拉黑和屏蔽服务
/// 用于管理被拉黑的用户和被屏蔽的帖子
class BlockService extends ChangeNotifier {
  // 单例模式
  static final BlockService _instance = BlockService._internal();
  factory BlockService() => _instance;
  BlockService._internal();

  // 被拉黑的用户ID列表
  final Set<int> _blockedUserIds = {};
  
  // 被屏蔽的帖子ID列表
  final Set<int> _hiddenPostIds = {};

  /// 获取被拉黑的用户ID列表
  Set<int> get blockedUserIds => Set.unmodifiable(_blockedUserIds);

  /// 获取被屏蔽的帖子ID列表
  Set<int> get hiddenPostIds => Set.unmodifiable(_hiddenPostIds);

  /// 拉黑用户
  void blockUser(int userId) {
    _blockedUserIds.add(userId);
    notifyListeners();
  }

  /// 取消拉黑用户
  void unblockUser(int userId) {
    _blockedUserIds.remove(userId);
    notifyListeners();
  }

  /// 检查用户是否被拉黑
  bool isUserBlocked(int userId) {
    return _blockedUserIds.contains(userId);
  }

  /// 屏蔽帖子（不感兴趣）
  void hidePost(int postId) {
    _hiddenPostIds.add(postId);
    notifyListeners();
  }

  /// 取消屏蔽帖子
  void unhidePost(int postId) {
    _hiddenPostIds.remove(postId);
    notifyListeners();
  }

  /// 检查帖子是否被屏蔽
  bool isPostHidden(int postId) {
    return _hiddenPostIds.contains(postId);
  }

  /// 清空所有拉黑和屏蔽记录
  void clearAll() {
    _blockedUserIds.clear();
    _hiddenPostIds.clear();
    notifyListeners();
  }
}
