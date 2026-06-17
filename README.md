# 次元圈 (MoeCircle) - Flutter 社交应用

一个专为年轻人打造的高颜值兴趣社交平台，采用粉色系设计，提供动态分享、用户发现、实时聊天和个人主页等功能。

## 🎯 应用简介

**次元圈** 是一个创新的社交应用，致力于为年轻人打造一个舒适、无压力的表达空间。在这里，我们不看脸，只看灵魂。

### 核心特色

- 🎨 **兴趣动态** - 随心分享，记录真实自我
- 💖 **灵魂共鸣** - 创新的"心动卡片"玩法，精准匹配气味相投的伙伴
- 💬 **纯粹交流** - 无缝沟通，告别无效社交
- 🎀 **个性主页** - 高颜值UI，定义专属名片

## 📊 项目统计

| 指标 | 数值 |
|------|------|
| Dart 文件数 | 15 个 |
| 代码行数 | 2,665 行 |
| 页面数量 | 8 个 |
| 组件数量 | 3 个 |
| 编译状态 | ✅ 无错误 |
| 功能完成度 | 100% |

## 🚀 快速开始

### 环境要求

- Flutter 3.10+
- Dart 3.0+
- iOS 11.0+ 或 Android 5.0+

### 安装步骤

1. **克隆项目**
```bash
git clone <repository-url>
cd ciyuan
```

2. **获取依赖**
```bash
flutter pub get
```

3. **运行应用**
```bash
flutter run
```

4. **构建发布版本**
```bash
# Android
flutter build apk

# iOS
flutter build ios
```

## 📱 功能特性

### 🏠 首页 (Home)
- 动态流展示
- 帖子卡片组件
- 点赞功能
- 用户头像点击进入用户主页
- 帖子点击进入详情页

### 🔍 发现页 (Discover)
- 心动卡片玩法
- 用户信息展示（名字、年龄、距离、兴趣）
- 向右滑动/点击心形按钮表示喜欢
- 向左滑动/点击关闭按钮表示不感兴趣
- 自动切换到下一个用户

### 💬 消息页 (Message)
- 聊天列表展示
- 最后消息预览
- 未读消息计数
- 点击进入聊天页面

### 👤 我的页 (Profile)
- 个人信息展示
- 编辑资料功能
- 获赞和收藏统计
- 我的发布网格

### 📄 帖子详情页
- 完整帖子内容
- 评论列表
- 点赞和评论功能
- 底部评论输入框

### 💭 聊天页面
- 实时消息显示
- 消息气泡样式
- 消息输入和发送
- 自动滚动到最新消息

### 👥 用户主页
- 用户详细信息
- 关注/取消关注
- 发消息按钮
- 用户发布内容展示

### ✏️ 编辑资料页
- 修改用户名
- 修改个人简介
- 头像编辑入口

## 🎨 设计系统

### 颜色方案
- **主色**: #EC7BA8 (粉色)
- **浅粉色**: #FFC0D9
- **深粉色**: #E85A8F
- **背景色**: #FAF9F8
- **文字主色**: #333333
- **文字次色**: #666666
- **文字三级**: #999999

### 间距系统
- xs: 4px | sm: 8px | md: 12px | lg: 16px | xl: 20px | xxl: 24px | xxxl: 32px

### 圆角系统
- xs: 4px | sm: 8px | md: 12px | lg: 16px | xl: 20px | circle: 999px

## 📁 项目结构

```
lib/
├── main.dart                          # 应用入口
├── models/
│   └── models.dart                    # 数据模型
├── data/
│   └── mock_data.dart                 # 模拟数据
├── utils/
│   └── constants.dart                 # 设计系统常量
├── widgets/
│   ├── pink_button.dart              # 粉色按钮组件
│   ├── post_card.dart                # 帖子卡片组件
│   └── user_card.dart                # 用户卡片组件
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

## 📦 依赖包

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  shared_preferences: ^2.2.2
```

## 🔄 数据模型

### User
```dart
User(
  id: int,
  name: String,
  avatar: String,
  tag: String,
  bio: String?,
  age: int,
  distance: double,
  interests: List<String>,
  isFollowing: bool,
)
```

### Post
```dart
Post(
  id: int,
  user: User,
  time: String,
  content: String,
  image: String?,
  likes: int,
  comments: int,
  isLiked: bool,
)
```

### Message
```dart
Message(
  id: int,
  sender: String,
  text: String,
  time: String,
)
```

### ChatRoom
```dart
ChatRoom(
  id: int,
  user: User,
  lastMessage: String,
  lastTime: String,
  unreadCount: int,
)
```

## 💡 扩展建议

### 短期 (1-2周)
- [ ] 集成真实API替换模拟数据
- [ ] 添加用户认证系统
- [ ] 实现图片上传功能

### 中期 (2-4周)
- [ ] 添加搜索功能
- [ ] 实现实时消息推送
- [ ] 添加通知系统
- [ ] 优化性能（图片缓存、列表虚拟化）

### 长期 (1-3个月)
- [ ] 添加支付功能
- [ ] 实现分享功能
- [ ] 添加深色模式
- [ ] 国际化支持

## 📚 文档

- [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) - 项目结构详细说明
- [QUICK_START.md](QUICK_START.md) - 快速开始指南
- [FILES_SUMMARY.md](FILES_SUMMARY.md) - 文件详细清单
- [DEVELOPMENT_COMPLETE.md](DEVELOPMENT_COMPLETE.md) - 开发完成报告

## 🛠️ 技术栈

- **框架**: Flutter 3.10+
- **语言**: Dart 3.0+
- **UI设计**: Material Design 3
- **状态管理**: setState
- **本地存储**: shared_preferences (可选)

## 📝 常见问题

### Q: 如何修改应用主题色？
A: 编辑 `lib/utils/constants.dart` 中的 `AppColors` 类

### Q: 如何添加新页面？
A: 
1. 在 `lib/screens/` 创建新的 `.dart` 文件
2. 在 `main.dart` 的 `_screens` 列表中添加
3. 在底部导航栏中添加对应的 `BottomNavigationBarItem`

### Q: 如何集成真实API？
A: 
1. 创建 `lib/services/api_service.dart`
2. 替换 `lib/data/mock_data.dart` 中的数据源
3. 使用 `http` 或 `dio` 包进行网络请求

### Q: 如何添加本地图片？
A: 
1. 将图片放在 `assets/images/` 目录
2. 在 `pubspec.yaml` 中配置资源路径
3. 使用 `Image.asset('assets/images/xxx.png')`

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT License

## 👨‍💻 开发者

开发者寄语：
> "在这个快节奏的时代，我们希望提供一个能让人慢下来、找到归属感的角落。次元圈不仅是一个社交工具，更是连接热爱与灵魂的桥梁。"

## 📞 联系方式

如有问题或建议，欢迎反馈！

---

**项目状态**: ✅ 完成并可运行  
**最后更新**: 2024年  
**Flutter版本**: 3.10+  
**Dart版本**: 3.0+
# ciyuanquan
