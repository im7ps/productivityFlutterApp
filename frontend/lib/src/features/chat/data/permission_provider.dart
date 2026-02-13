import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'permission_provider.g.dart';

class PermissionService {
  Future<bool> requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      status = await Permission.microphone.request();
    }
    return status.isGranted;
  }
}

@riverpod
PermissionService permissionService(Ref ref) {
  return PermissionService();
}
