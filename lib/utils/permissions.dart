import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

class Permissions {
  static PermissionHandlerPlatform get _handler => PermissionHandlerPlatform.instance;

  static Future<bool> storageAndAudioGranted() async {
    PermissionStatus storagePermissionStatus = await _getStoragePermission();
    PermissionStatus checkMicroPhonePermission = await _getSpeechAudioPermission();

    if (storagePermissionStatus == PermissionStatus.granted && checkMicroPhonePermission == PermissionStatus.granted) {
      return true;
    } else {
      _handleInvalidPermissions(storagePermissionStatus, checkMicroPhonePermission);
      return false;
    }
  }

  static Future<bool> storageGranted() async {
    PermissionStatus storagePermissionStatus = await _getStoragePermission();

    if (storagePermissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      throw new PlatformException(code: "PERMISSION_DENIED", message: "Access to Storage denied", details: null);
    }
  }

  static Future<bool> speechGranted() async {
    PermissionStatus storagePermissionStatus = await _getSpeechAudioPermission();

    if (storagePermissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      return false;
      throw new PlatformException(code: "PERMISSION_DENIED", message: "Access to Audio denied", details: null);
    }
  }

  static Future<PermissionStatus> _getStoragePermission() async {
    PermissionStatus permission = await _handler.checkPermissionStatus(Permission.storage);

    if (permission != PermissionStatus.granted) {
      Map<Permission, PermissionStatus> permissionStatus = await _handler.requestPermissions([Permission.storage]);
      return permissionStatus[Permission.storage] ?? PermissionStatus.denied;
    } else {
      return permission;
    }
  }

  static Future<PermissionStatus> _getSpeechAudioPermission() async {
    PermissionStatus permission = await _handler.checkPermissionStatus(Permission.speech);
    if (permission != PermissionStatus.granted) {
      Map<Permission, PermissionStatus> permissionStatus = await _handler.requestPermissions([Permission.speech]);
      return permissionStatus[Permission.speech] ?? PermissionStatus.denied;
    } else {
      return permission;
    }
  }

  static void _handleInvalidPermissions(
    PermissionStatus cameraPermissionStatus,
    PermissionStatus microphonePermissionStatus,
  ) {
    if (cameraPermissionStatus == PermissionStatus.denied && microphonePermissionStatus == PermissionStatus.denied) {
      throw new PlatformException(code: "PERMISSION_DENIED", message: "Access to Storage denied", details: null);
    } else if (cameraPermissionStatus == PermissionStatus.restricted && microphonePermissionStatus == PermissionStatus.restricted) {
      throw new PlatformException(code: "PERMISSION_DISABLED", message: "Access to Audio denied", details: null);
    }
  }
}
