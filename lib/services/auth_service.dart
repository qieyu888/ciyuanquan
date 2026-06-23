import 'user_service.dart';
import 'chat_service.dart';
import 'block_service.dart';
import 'credit_service.dart';

/// 账号认证与会话管理
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  /// 清除本地会话数据
  void clearSession() {
    UserService().reset();
    ChatService().clearAll();
    BlockService().clearAll();
  }

  /// 注销账号（假注销，仅清除本地数据）
  void deleteAccount() {
    clearSession();
    CreditService().reset();
  }

  /// 退出登录
  void logout() {
    clearSession();
  }
}
