// 用户模型
class User {
  final int id;
  final String name;
  final String avatar;
  final String tag;
  final String? bio;
  final int age;
  final double distance;
  final List<String> interests;
  bool isFollowing;

  User({
    required this.id,
    required this.name,
    required this.avatar,
    required this.tag,
    this.bio,
    required this.age,
    required this.distance,
    required this.interests,
    this.isFollowing = false,
  });

  User copyWith({
    int? id,
    String? name,
    String? avatar,
    String? tag,
    String? bio,
    int? age,
    double? distance,
    List<String>? interests,
    bool? isFollowing,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      tag: tag ?? this.tag,
      bio: bio ?? this.bio,
      age: age ?? this.age,
      distance: distance ?? this.distance,
      interests: interests ?? this.interests,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}

// 帖子模型
class Post {
  final int id;
  final User user;
  final String time;
  final String content;
  final String? image;
  int likes;
  int comments;
  bool isLiked;

  Post({
    required this.id,
    required this.user,
    required this.time,
    required this.content,
    this.image,
    required this.likes,
    required this.comments,
    required this.isLiked,
  });

  Post copyWith({
    int? id,
    User? user,
    String? time,
    String? content,
    String? image,
    int? likes,
    int? comments,
    bool? isLiked,
  }) {
    return Post(
      id: id ?? this.id,
      user: user ?? this.user,
      time: time ?? this.time,
      content: content ?? this.content,
      image: image ?? this.image,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}

// 消息模型
class Message {
  final int id;
  final String sender;
  final String text;
  final String time;

  Message({
    required this.id,
    required this.sender,
    required this.text,
    required this.time,
  });
}

// 聊天室模型
class ChatRoom {
  final int id;
  final User user;
  final String lastMessage;
  final String lastTime;
  final int unreadCount;

  ChatRoom({
    required this.id,
    required this.user,
    required this.lastMessage,
    required this.lastTime,
    required this.unreadCount,
  });
}
