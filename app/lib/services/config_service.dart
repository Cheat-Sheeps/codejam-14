import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';
import 'dart:io';

class ConfigService {
  late Map<String, dynamic> _config;

  ConfigService._();

  static Future<ConfigService> create(String path) async {
    ConfigService s = ConfigService._();
    await s._loadConfig(path);
    return s;
  }

  dynamic operator[](String key) {
    return _config[key];
  }

  Future<void> _loadConfig(String path) async {
    try {
      final content = await rootBundle.loadString(path);
      final yamlMap = loadYaml(content) as YamlMap;

      _config = Map<String, dynamic>.from(yamlMap);
    } catch (e) {
      throw Exception('Error loading configuration file: $e');
    }
  }
}