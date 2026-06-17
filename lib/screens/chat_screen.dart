import 'package:flutter/material.dart';
import '../models/models.dart';
import '../utils/constants.dart';
import '../utils/image_helper.dart';
import '../services/chat_service.dart';
import '../services/user_service.dart';
import 'user_profile_screen.dart';

class ChatScreen extends StatefulWidget {
  final User user;

  const ChatScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late List<Message> messages;
  final TextEditingController _messageController = TextEditingController();
  late ScrollController _scrollController;
  final ChatService _chatService = ChatService();

  @override
  void initState() {
    super.initState();
    // 从 ChatService 加载该用户的消息历史（创建副本避免重复）
    messages = List.from(_chatService.getChatHistory(widget.user.id));
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (messages.isNotEmpty) {
        _scrollToBottom();
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _openUserProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfileScreen(user: widget.user),
      ),
    );
  }

  void _showMoreOptions() {
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
                // 删除对话选项
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _showDeleteConfirmDialog();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.lg,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 24,
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        Text(
                          '删除对话',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.red,
                          ),
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
      },
    );
  }

  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('删除对话'),
          content: Text('确定要删除与 ${widget.user.name} 的对话吗？'),
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
                _deleteConversation();
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

  void _deleteConversation() {
    _chatService.deleteConversation(widget.user.id);
    Navigator.pop(context, {'deleted': true});
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      final newMessage = Message(
        id: messages.length + 1,
        sender: 'me',
        text: _messageController.text,
        time: '刚刚',
      );
      
      setState(() {
        messages.add(newMessage);
      });
      
      // 保存到 ChatService
      _chatService.addMessage(widget.user.id, newMessage);
      
      _messageController.clear();
      // 延迟滚动，确保列表已更新
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.textPrimary,
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.user.name,
              style: AppTextStyles.headline3,
            ),
            const SizedBox(height: 2),
            Text(
              '刚刚活跃',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            color: AppColors.textPrimary,
            onPressed: _showMoreOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          '暂无消息',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          '发送第一条消息开始聊天吧',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMine = message.sender == 'me';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: Row(
                          mainAxisAlignment: isMine
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            if (!isMine)
                              GestureDetector(
                                onTap: _openUserProfile,
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundImage: getImageProvider(widget.user.avatar),
                                  backgroundColor: AppColors.primaryLight,
                                ),
                              ),
                            if (!isMine) const SizedBox(width: AppSpacing.md),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.lg,
                                  vertical: AppSpacing.md,
                                ),
                                decoration: BoxDecoration(
                                  color: isMine ? AppColors.primary : AppColors.white,
                                  borderRadius: BorderRadius.circular(AppRadius.lg),
                                  boxShadow: [AppShadows.sm],
                                ),
                                child: Text(
                                  message.text,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: isMine ? AppColors.white : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                            if (isMine) const SizedBox(width: AppSpacing.md),
                            if (isMine)
                              CircleAvatar(
                                radius: 16,
                                backgroundImage: getImageProvider(UserService().userAvatar),
                                backgroundColor: AppColors.primaryLight,
                              ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          // 输入框
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
            child: Row(
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
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: '说点什么...',
                        hintStyle: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                        border: InputBorder.none,
                      ),
                      style: AppTextStyles.bodySmall,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Icon(
                    Icons.send,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
