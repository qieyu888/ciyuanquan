import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

/// iOS App Tracking Transparency 授权请求
class TrackingService {
  static final TrackingService _instance = TrackingService._internal();
  factory TrackingService() => _instance;
  TrackingService._internal();

  /// 在应用界面可见后请求 ATT 授权（仅 iOS）
  Future<void> requestTrackingIfNeeded() async {
    if (!Platform.isIOS) return;

    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await Future.delayed(const Duration(milliseconds: 500));
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }
}
