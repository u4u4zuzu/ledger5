import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// 应用本地设置（加密开关 + 盐值 + 支付通知自动记账开关），存为 JSON 文件
class AppSettings {
  final bool encEnabled;
  final String? salt;
  final bool autoCapture;

  const AppSettings({this.encEnabled = false, this.salt, this.autoCapture = true});

  factory AppSettings.fromJson(Map<String, dynamic> j) => AppSettings(
        encEnabled: j['encEnabled'] ?? false,
        salt: j['salt'],
        autoCapture: j['autoCapture'] ?? true,
      );

  Map<String, dynamic> toJson() =>
      {'encEnabled': encEnabled, 'salt': salt, 'autoCapture': autoCapture};
}

class SettingsStore {
  static const _fileName = 'ledger_settings.json';
  static AppSettings _cache = const AppSettings();

  static AppSettings get current => _cache;

  static Future<AppSettings> load() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final f = File('${dir.path}/$_fileName');
      if (await f.exists()) {
        final j = jsonDecode(await f.readAsString()) as Map<String, dynamic>;
        _cache = AppSettings.fromJson(j);
      }
    } catch (_) {
      // 忽略损坏的设置文件
    }
    return _cache;
  }

  static Future<void> save(AppSettings s) async {
    _cache = s;
    final dir = await getApplicationDocumentsDirectory();
    final f = File('${dir.path}/$_fileName');
    await f.writeAsString(jsonEncode(s.toJson()));
  }
}
