# 次元圈 - 快速开始指南

## 项目已完成的功能

✅ **完整的Flutter应用框架**
- 底部导航栏（4个主要页面）
- 所有页面间的导航
- 完整的UI设计系统

✅ **首页 (Home)**
- 动态流展示
- 帖子卡片组件
- 点赞功能
- 用户头像点击进入用户主页
- 帖子点击进入详情页

✅ **发现页 (Discover)**
- 心动卡片玩法
- 用户信息展示（名字、年龄、距离、兴趣）
- 向右滑动/点击心形按钮表示喜欢
- 向左滑动/点击关闭按钮表示不感兴趣

✅ **消息页 (Message)**
- 聊天列表
- 最后消息预览
- 未读消息计数
- 点击进入聊天页面

✅ **我的页 (Profile)**
- 个人信息展示
- 编辑资料功能
- 获赞和收藏统计
- 我的发布网格

✅ **帖子详情页**
- 完整帖子内容
- 评论列表
- 点赞和评论功能
- 底部评论输入框

✅ **聊天页面**
- 实时消息显示
- 消息气泡样式
- 消息输入和发送
- 自动滚动到最新消息

✅ **用户主页**
- 用户详细信息
- 关注/取消关注
- 发消息按钮
- 用户发布内容展示

✅ **编辑资料页**
- 修改用户名
- 修改个人简介
- 头像编辑入口

✅ **设计系统**
- 完整的颜色系统
- 文本样式定义
- 间距系统
- 圆角系统
- 阴影系统

## 文件清单

### 核心文件
```
lib/
├── main.dart                          # 应用入口
├── models/models.dart                 # 数据模型
├── data/mock_data.dart                # 模拟数据
├── utils/constants.dart               # 常量定义
├── widgets/
│   ├── pink_button.dart              # 粉色按钮
│   ├── post_card.dart                # 帖子卡片
│   └── user_card.dart                # 用户卡片
└── screens/
    ├── home_screen.dart              # 首页
    ├── discover_screen.dart          # 发现页
    ├── message_screen.dart           # 消息页
    ├── profile_screen.dart           # 我的页
    ├── post_detail_screen.dart       # 帖子详情
    ├── chat_screen.dart              # 聊天页
    ├── user_profile_screen.dart      # 用户主页
    └── edit_profile_screen.dart      # 编辑资料
```

## 运行应用

### 1. 获取依赖
```bash
flutter pub get
```

### 2. 运行应用
```bash
flutter run
```

### 3. 构建发布版本
```bash
# Android
flutter build apk

# iOS
flutter build ios
```

## 应用导航流程

```
底部导航栏
├── 首页 (Home)
│   ├── 点击帖子 → 帖子详情页
│   └── 点击用户头像 → 用户主页
│       ├── 点击"发消息" → 聊天页
│       └── 点击"关注" → 关注/取消关注
│
├── 发现页 (Discover)
│   ├── 点击心形按钮 → 下一个用户
│   ├── 点击关闭按钮 → 下一个用户
│   └── 点击卡片 → 用户主页
│       ├── 点击"发消息" → 聊天页
│       └── 点击"关注" → 关注/取消关注
│
├── 消息页 (Message)
│   └── 点击聊天室 → 聊天页
│       └── 发送消息
│
└── 我的页 (Profile)
    └── 点击"编辑资料" → 编辑资料页
        └── 修改信息并保存
```

## 主要功能说明

### 1. 动态流 (Home)
- 展示所有用户发布的内容
- 支持点赞（点赞数会实时更新）
- 支持查看评论
- 点击用户头像可查看用户详细信息

### 2. 心动卡片 (Discover)
- 展示单个用户卡片
- 显示用户基本信息（名字、年龄、距离、兴趣）
- 向右滑动或点击心形按钮表示喜欢
- 向左滑动或点击关闭按钮表示不感兴趣
- 卡片会自动切换到下一个用户

### 3. 聊天系统 (Message & Chat)
- 消息列表显示所有聊天
- 点击进入聊天页面
- 支持发送和接收消息
- 消息自动滚动到最新

### 4. 个人主页 (Profile)
- 显示个人信息和统计数据
- 支持编辑资料
- 展示我的发布内容
- 显示获赞和收藏数

## 数据模型

### User
```dart
User(
  id: 1,
  name: '用户名',
  avatar: '头像URL',
  tag: '标签',
  bio: '个人简介',
  age: 22,
  distance: 2.5,
  interests: ['兴趣1', '兴趣2'],
  isFollowing: false,
)
```

### Post
```dart
Post(
  id: 1001,
  user: User(...),
  time: '3天前',
  content: '帖子内容',
  image: '图片URL',
  likes: 42,
  comments: 12,
  isLiked: false,
)
```

### Message
```dart
Message(
  id: 1,
  sender: 'me' | 'other',
  text: '消息内容',
  time: '现在',
)
```

### ChatRoom
```dart
ChatRoom(
  id: 1,
  user: User(...),
  lastMessage: '最后一条消息',
  lastTime: '2分钟前',
  unreadCount: 2,
)
```

## 颜色系统

| 用途 | 颜色值 | 说明 |
|------|--------|------|
| 主色 | #EC7BA8 | 粉色，用于按钮、链接等 |
| 浅粉色 | #FFC0D9 | 背景色、标签背景 |
| 深粉色 | #E85A8F | 悬停、按下状态 |
| 背景 | #FAF9F8 | 页面背景色 |
| 白色 | #FFFFFF | 卡片、输入框背景 |
| 文字主 | #333333 | 主要文字 |
| 文字次 | #666666 | 次要文字 |
| 文字三 | #999999 | 辅助文字 |

## 常见问题

### Q: 如何修改用户数据？
A: 编辑 `lib/data/mock_data.dart` 中的 `mockUsers` 和 `mockPosts`

### Q: 如何添加新的页面？
A: 
1. 在 `lib/screens/` 创建新的 `.dart` 文件
2. 在 `main.dart` 的 `_screens` 列表中添加
3. 在底部导航栏中添加对应的 `BottomNavigationBarItem`

### Q: 如何修改颜色主题？
A: 编辑 `lib/utils/constants.dart` 中的 `AppColors` 类

### Q: 如何添加本地图片？
A: 
1. 将图片放在 `assets/images/` 目录
2. 在 `pubspec.yaml` 中配置资源路径
3. 使用 `Image.asset('assets/images/xxx.png')`

### Q: 如何集成真实API？
A: 
1. 在 `lib/data/` 创建 API 服务类
2. 替换 `mock_data.dart` 中的数据源
3. 使用 `http` 或 `dio` 包进行网络请求

## 下一步建议

1. **集成真实API** - 替换模拟数据
2. **添加用户认证** - 登录/注册功能
3. **实现图片上传** - 用户可以上传头像和帖子图片
4. **添加搜索功能** - 搜索用户和帖子
5. **实现实时通知** - 消息推送
6. **添加分享功能** - 分享帖子到其他平台
7. **优化性能** - 图片缓存、列表虚拟化
8. **深色模式支持** - 适配系统深色模式

## 技术栈

- **框架**: Flutter 3.10+
- **语言**: Dart
- **状态管理**: setState
- **UI设计**: Material Design 3
- **数据存储**: 模拟数据（可扩展为 shared_preferences 或 API）

## 许可证

MIT License

## 联系方式

如有问题或建议，欢迎反馈！
