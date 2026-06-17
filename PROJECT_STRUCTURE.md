# 次元圈 - Flutter 应用项目结构

## 项目概述
次元圈是一个专为年轻人打造的高颜值兴趣社交平台，采用粉色系设计，提供动态分享、用户发现、实时聊天和个人主页等功能。

## 项目结构

```
lib/
├── main.dart                 # 应用入口，底部导航栏管理
├── models/
│   └── models.dart          # 数据模型（User, Post, Message, ChatRoom）
├── data/
│   └── mock_data.dart       # 模拟数据
├── utils/
│   └── constants.dart       # 常量定义（颜色、文本样式、间距等）
├── widgets/
│   ├── pink_button.dart     # 粉色按钮组件
│   ├── post_card.dart       # 帖子卡片组件
│   └── user_card.dart       # 用户卡片组件（心动卡片）
└── screens/
    ├── home_screen.dart           # 首页 - 动态流
    ├── discover_screen.dart       # 发现页 - 用户发现（心动卡片）
    ├── message_screen.dart        # 消息页 - 聊天列表
    ├── profile_screen.dart        # 我的页 - 个人主页
    ├── post_detail_screen.dart    # 帖子详情页
    ├── chat_screen.dart           # 聊天页面
    ├── user_profile_screen.dart   # 用户个人主页
    └── edit_profile_screen.dart   # 编辑资料页
```

## 核心功能

### 1. 首页 (HomeScreen)
- 展示动态流
- 支持点赞、评论
- 点击用户头像查看用户主页
- 点击帖子查看详情

### 2. 发现页 (DiscoverScreen)
- 心动卡片玩法
- 向右滑动（点击心形按钮）表示喜欢
- 向左滑动（点击关闭按钮）表示不感兴趣
- 显示用户信息、距离、兴趣标签

### 3. 消息页 (MessageScreen)
- 聊天列表
- 显示最后一条消息和时间
- 未读消息计数
- 点击进入聊天页面

### 4. 我的页 (ProfileScreen)
- 个人信息展示
- 编辑资料功能
- 获赞和收藏统计
- 我的发布网格展示

### 5. 帖子详情页 (PostDetailScreen)
- 完整帖子内容
- 评论列表
- 点赞和评论功能
- 底部评论输入框

### 6. 聊天页面 (ChatScreen)
- 实时消息显示
- 消息气泡样式
- 消息输入和发送
- 自动滚动到最新消息

### 7. 用户主页 (UserProfileScreen)
- 用户详细信息
- 关注/取消关注
- 发消息按钮
- 用户发布内容展示

### 8. 编辑资料页 (EditProfileScreen)
- 修改用户名
- 修改个人简介
- 头像编辑入口

## 设计系统

### 颜色方案
- **主色**: #EC7BA8 (粉色)
- **浅粉色**: #FFC0D9
- **深粉色**: #E85A8F
- **背景色**: #FAF9F8
- **文字主色**: #333333
- **文字次色**: #666666
- **文字三级**: #999999

### 间距系统
- xs: 4px
- sm: 8px
- md: 12px
- lg: 16px
- xl: 20px
- xxl: 24px
- xxxl: 32px

### 圆角系统
- xs: 4px
- sm: 8px
- md: 12px
- lg: 16px
- xl: 20px
- circle: 999px

## 状态管理
使用 `setState` 进行状态管理，简单高效。

## 数据存储
- 模拟数据存储在 `mock_data.dart`
- 可集成 `shared_preferences` 进行本地持久化
- 支持扩展为网络API调用

## 依赖包
- `flutter`: Flutter SDK
- `cupertino_icons`: iOS风格图标
- `shared_preferences`: 本地数据存储（可选）

## 运行项目

```bash
# 获取依赖
flutter pub get

# 运行应用
flutter run

# 构建发布版本
flutter build apk      # Android
flutter build ios      # iOS
```

## 代码规范
- 使用 `const` 构造函数
- 使用 `super.key` 简化参数
- 遵循 Flutter 命名规范
- 使用 `AppColors` 和 `AppTextStyles` 保持设计一致性

## 扩展建议
1. 集成真实API替换模拟数据
2. 添加图片上传功能
3. 实现实时消息推送
4. 添加用户认证系统
5. 集成支付功能
6. 添加分享功能
7. 实现搜索功能
8. 添加通知系统

## 注意事项
- 所有网络图片使用 `NetworkImage`
- 本地图片资源在 `assets/images/` 目录
- 使用 Material Design 3
- 支持深色模式扩展
