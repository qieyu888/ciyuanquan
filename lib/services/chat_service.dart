import 'package:flutter/foundation.dart';
import '../models/models.dart';

/// 聊天服务
/// 用于管理所有对话的消息历史和最新消息
class ChatService extends ChangeNotifier {
  // 单例模式
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  // 存储每个用户的消息历史 userId -> List<Message>
  final Map<int, List<Message>> _chatHistories = {};

  // 存储每个用户的最后一条消息 userId -> lastMessage
  final Map<int, String> _lastMessages = {};

  // 存储每个用户的最后消息时间 userId -> lastTime
  final Map<int, String> _lastTimes = {};

  /// 获取指定用户的消息历史
  List<Message> getChatHistory(int userId) {
    return _chatHistories[userId] ?? [];
  }

  /// 获取指定用户的最后一条消息
  String? getLastMessage(int userId) {
    return _lastMessages[userId];
  }

  /// 获取指定用户的最后消息时间
  String? getLastTime(int userId) {
    return _lastTimes[userId];
  }

  /// 添加消息到指定用户的聊天历史
  void addMessage(int userId, Message message) {
    if (!_chatHistories.containsKey(userId)) {
      _chatHistories[userId] = [];
    }
    _chatHistories[userId]!.add(message);
    
    // 更新最后一条消息
    _lastMessages[userId] = message.text;
    _lastTimes[userId] = message.time;
    
    notifyListeners();
  }

  /// 检查是否有与指定用户的对话
  bool hasChatWith(int userId) {
    return _chatHistories.containsKey(userId) && 
           _chatHistories[userId]!.isNotEmpty;
  }

  /// 获取所有有对话的用户ID列表
  List<int> getAllChatUserIds() {
    return _chatHistories.keys
        .where((userId) => _chatHistories[userId]!.isNotEmpty)
        .toList();
  }

  /// 清空所有聊天记录
  void clearAll() {
    _chatHistories.clear();
    _lastMessages.clear();
    _lastTimes.clear();
    notifyListeners();
  }

  /// 删除与指定用户的对话
  void deleteConversation(int userId) {
    _chatHistories.remove(userId);
    _lastMessages.remove(userId);
    _lastTimes.remove(userId);
    notifyListeners();
  }
}