import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/mock_data.dart';
import '../utils/constants.dart';
import '../utils/image_helper.dart';
import '../services/chat_service.dart';
import 'chat_screen.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  late List<ChatRoom> chatRooms;
  final ChatService _chatService = ChatService();

  @override
  void initState() {
    super.initState();
    // 只显示有聊天记录的用户
    _filterChatRooms();
    // 监听聊天服务的变化
    _chatService.addListener(_onChatServiceChanged);
  }

  void _filterChatRooms() {
    // 过滤出有聊天记录的聊天室
    final chatWithUsers = _chatService.getAllChatUserIds();
    
    // 从 mockChatRooms 中获取已有的聊天室
    final existingRooms = mockChatRooms
        .where((room) => chatWithUsers.contains(room.user.id))
        .toList();
    
    // 对于有聊天记录但不在 mockChatRooms 中的用户，需要从其他地方获取用户信息
    // 这里我们可以从 mockPosts 中获取用户信息
    final newChatRooms = <ChatRoom>[];
    
    for (final userId in chatWithUsers) {
      // 检查是否已经在 existingRooms 中
      if (!existingRooms.any((room) => room.user.id == userId)) {
        // 从 mockPosts 中查找用户信息
        Post? post;
        try {
          post = mockPosts.firstWhere(
            (p) => p.user.id == userId,
          );
        } catch (e) {
          post = null;
        }
        
        if (post != null) {
          final lastMessage = _chatService.getLastMessage(userId) ?? '';
          final lastTime = _chatService.getLastTime(userId) ?? '';
          
          newChatRooms.add(ChatRoom(
            id: userId,
            user: post.user,
            lastMessage: lastMessage,
            lastTime: lastTime,
            unreadCount: 0,
          ));
        }
      }
    }
    
    chatRooms = [...existingRooms, ...newChatRooms];
    
    // 按时间排序，最新的在最上面
    chatRooms.sort((a, b) {
      // 尝试解析时间字符串进行比较
      // 支持格式: "2分钟前", "1小时前", "3小时前", "昨天", "2024-01-01"
      final timeA = _parseTime(a.lastTime);
      final timeB = _parseTime(b.lastTime);
      return timeB.compareTo(timeA); // 降序排列，最新的在前
    });
  }

  // 解析时间字符串为 DateTime 用于排序
  DateTime _parseTime(String timeStr) {
    final now = DateTime.now();
    
    if (timeStr.contains('分钟前')) {
      final minutes = int.tryParse(timeStr.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
      return now.subtract(Duration(minutes: minutes));
    } else if (timeStr.contains('小时前')) {
      final hours = int.tryParse(timeStr.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
      return now.subtract(Duration(hours: hours));
    } else if (timeStr.contains('昨天')) {
      return now.subtract(const Duration(days: 1));
    } else if (timeStr.contains('天前')) {
      final days = int.tryParse(timeStr.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
      return now.subtract(Duration(days: days));
    } else {
      // 尝试解析为日期格式
      try {
        return DateTime.parse(timeStr);
      } catch (e) {
        return DateTime(1970); // 默认返回最早的时间
      }
    }
  }

  @override
  void dispose() {
    _chatService.removeListener(_onChatServiceChanged);
    super.dispose();
  }

  void _onChatServiceChanged() {
    // 当有新消息时，更新聊天室列表
    setState(() {
      _filterChatRooms();
      _updateChatRooms();
    });
  }

  void _updateChatRooms() {
    // 更新每个聊天室的最后消息
    for (int i = 0; i < chatRooms.length; i++) {
      final userId = chatRooms[i].user.id;
      final lastMessage = _chatService.getLastMessage(userId);
      final lastTime = _chatService.getLastTime(userId);
      
      if (lastMessage != null && lastTime != null) {
        chatRooms[i] = ChatRoom(
          id: chatRooms[i].id,
          user: chatRooms[i].user,
          lastMessage: lastMessage,
          lastTime: lastTime,
          unreadCount: 0, // 可以根据需要实现未读计数
        );
      }
    }
    
    // 重新排序，保持最新的在最上面
    chatRooms.sort((a, b) {
      final timeA = _parseTime(a.lastTime);
      final timeB = _parseTime(b.lastTime);
      return timeB.compareTo(timeA); // 降序排列，最新的在前
    });
  }

  void _openChat(ChatRoom chatRoom) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(user: chatRoom.user),
      ),
    ).then((result) {
      // 从聊天页面返回时，更新聊天室列表
      if (result != null && result['deleted'] == true) {
        // 对话已被删除，刷新列表
        setState(() {
          _filterChatRooms();
        });
      } else {
        // 只是返回，更新最后消息
        setState(() {
          _updateChatRooms();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          '消息',
          style: AppTextStyles.headline2,
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: chatRooms.length,
        itemBuilder: (context, index) {
          final chatRoom = chatRooms[index];
          return GestureDetector(
            onTap: () => _openChat(chatRoom),
            child: Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: [AppShadows.sm],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: getImageProvider(chatRoom.user.avatar),
                    backgroundColor: AppColors.primaryLight,
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              chatRoom.user.name,
                              style: AppTextStyles.labelLarge,
                            ),
                            Text(
                              chatRoom.lastTime,
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          chatRoom.lastMessage,
                          style: AppTextStyles.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (chatRoom.unreadCount > 0)
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          chatRoom.unreadCount.toString(),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
