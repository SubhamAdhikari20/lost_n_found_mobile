import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // Base URL - change this for production
  // static const String baseUrl = 'http://10.0.2.2:3000/api/v1';
  //static const String baseUrl = 'http://localhost:3000/api/v1';
  // For Android Emulator use: 'http://10.0.2.2:3000/api/v1'
  // For iOS Simulator use: 'http://localhost:5000/api/v1'
  // For Physical Device use your computer's IP: 'http://192.168.x.x:5000/api/v1'

  static const bool isPhysicalDevice = false;
  static const String _ipAddress = "192.168.1.1";
  static const int _port = 3000;

  // static String get baseUrl {
  //   if (isPhysicalDevice) {
  //     return "http://$_ipAddress:3000/api/v1";
  //   }
  //   if (kIsWeb) {
  //     return "http://localhost:3000/api/v1";
  //   } else if (Platform.isAndroid) {
  //     return "http://10.0.2.2:3000/api/v1";
  //   } else if (Platform.isIOS) {
  //     return "http://localhost:5000/api/v1";
  //   } else {
  //     return "http://localhost:3000/api/v1";
  //   }
  // }

  // Base URLs
  static String get _host {
    if (isPhysicalDevice) {
      return _ipAddress;
    }
    if (kIsWeb || Platform.isIOS) {
      return "localhost";
    }
    if (Platform.isAndroid) {
      return "10.0.2.2";
    }
    return "localhost";
  }

  static String get serverUrl => "http://$_host:$_port";
  // static String get baseUrl => "$serverUrl/api/v1";
  static const String baseUrl = 'http://10.0.2.2:3000/api/v1';
  static String get mediaServerUrl => serverUrl;

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ============ Batch Endpoints ============
  static const String batches = "/batches";
  static String batchById(String id) => "/batches/$id";

  // ============ Category Endpoints ============
  static const String categories = "/categories";
  static String categoryById(String id) => "/categories/$id";

  // ============ Student Endpoints ============
  static const String students = "/students";
  static const String studentLogin = "/students/login";
  static const String studentLogout = "/students/logout";
  static const String studentRegister = "/students/register";
  static String studentById(String id) => "/students/$id";
  static String studentPhoto(String id) => "/students/$id/photo";
  static String studentByEmail(String email) => "/students/$email";

  // ============ Item Endpoints ============
  static const String items = "/items";
  static String itemById(String id) => "/items/$id";
  static String itemClaim(String id) => "/items/$id/claim";
  static const String itemUploadPhoto = "/items/upload-photo";
  static const String itemUploadVideo = "/items/upload-video";
  // for images and videos :
  // http://localhost:3000/profile_pictures/pro-pic-1762685563167.jpg
  static String itemPicture(String filename) =>
      "$mediaServerUrl/item_photos/$filename";
  static String itemVideo(String filename) =>
      "$mediaServerUrl/item_videos/$filename";

  // ============ Comment Endpoints ============
  static const String comments = "/comments";
  static String commentById(String id) => "/comments/$id";
  static String commentsByItem(String itemId) => "/comments/item/$itemId";
  static String commentLike(String id) => "/comments/$id/like";
}
