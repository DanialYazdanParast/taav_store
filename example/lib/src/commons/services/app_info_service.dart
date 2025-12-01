import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppInfoService extends GetxService {
  String _version = '';
  String _buildNumber = '';

  Future<AppInfoService> init() async {
    try {
      final pubspecContent = await rootBundle.loadString('pubspec.yaml');

      final regex = RegExp(r'^version:\s*(.+)$', multiLine: true);
      final match = regex.firstMatch(pubspecContent);

      if (match != null) {
        final fullVersionString = match.group(1)?.trim() ?? '';

        if (fullVersionString.contains('+')) {
          final parts = fullVersionString.split('+');
          _version = parts[0];
          if (parts.length > 1) {
            _buildNumber = parts[1];
          }
        } else {
          _version = fullVersionString;
        }
      }
    } catch (e) {
      debugPrint('Error loading app version from pubspec: $e');
      _version = '1.0.0';
    }

    return this;
  }

  String get version => _version.isEmpty ? '1.0.0' : _version;

  String get buildNumber => _buildNumber;

  String get fullVersion =>
      _buildNumber.isEmpty ? version : "$version+$buildNumber";
}
