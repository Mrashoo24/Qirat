import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

/// Centralized configuration powered by Firebase Remote Config
/// with safe fallbacks to compile-time values when remote is unavailable.
class ConfigService {
  final FirebaseRemoteConfig _rc;

  // Compile-time fallback (override at build-time with --dart-define)
  static const String _defaultHeroCategoryId = String.fromEnvironment(
    'HERO_CATEGORY_ID',
    defaultValue: 'yQWQKhpX7FHFk9PGApGr',
  );
  static const String _defaultPremiumCategoryId = String.fromEnvironment(
    'PREMIUM_CATEGORY_ID',
    defaultValue: '3iBzqJwmpnaIVNnkIUhA',
  );
  static const String _default_featured_collection_id = String.fromEnvironment(
    'FEATURED_COLLECTION_ID',
    defaultValue: 'Ke69nY39reTuYGt5upKI',
  );

  static const String _logoUrl = String.fromEnvironment(
    'LOGO_URL',
    defaultValue:
        'https://firebasestorage.googleapis.com/v0/b/qiratperfumes.appspot.com/o/qiratgoldicon.png?alt=media&token=724b9ddc-aa3c-4ad3-b016-f761fad8049b',
  );

  ConfigService(this._rc);

  Future<void> init() async {
    // Reasonable defaults + faster dev fetch intervals
    await _rc.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval:
          kReleaseMode ? const Duration(hours: 1) : const Duration(seconds: 0),
    ));

    await _rc.setDefaults(<String, dynamic>{
      'hero_category_id': _defaultHeroCategoryId,
      'premium_category_id': _defaultPremiumCategoryId,
      'featured_collection_id': 'default_featured_collection_id',
      'logo_url': _logoUrl,
      // JSON array of objects: [{"imageUrl":"https://...","route":"/product-details?id=..."}, ...]
      'promo_banners': '[]',
    });

    try {
      final activated = await _rc.fetchAndActivate();
      debugPrint('[RemoteConfig] fetchAndActivate activated=$activated');
      debugPrint('[RemoteConfig] hero_category_id=' + heroCategoryId);
      debugPrint('[RemoteConfig] premium_category_id=' + premiumCategoryId);
      debugPrint('[RemoteConfig] logourl=' + logoUrl);
    } catch (e) {
      debugPrint('[RemoteConfig] fetch error: $e');
      // Swallow errors; fallbacks remain active
    }
  }

  String get heroCategoryId {
    final id = _rc.getString('hero_category_id');
    if (id.isEmpty) return _defaultHeroCategoryId;
    return id;
  }

  String get premiumCategoryId {
    final id = _rc.getString('premium_category_id');
    if (id.isEmpty) return _defaultPremiumCategoryId;
    return id;
  }

  String get featured_collection_id {
    final id = _rc.getString('featured_collection_id');
    if (id.isEmpty) return _default_featured_collection_id;
    return id;
  }

  String get logoUrl {
    final url = _rc.getString('logo_url');
    if (url.isEmpty) return _logoUrl;
    return url;
  }

  /// Force-refresh Remote Config (use during testing to bypass cache intervals)
  Future<void> refreshNow() async {
    try {
      await _rc.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 0),
      ));
      final activated = await _rc.fetchAndActivate();
      debugPrint('[RemoteConfig] refreshNow activated=$activated');
      debugPrint('[RemoteConfig] hero_category_id=' + heroCategoryId);
      debugPrint('[RemoteConfig] premium_category_id=' + premiumCategoryId);
      debugPrint('[RemoteConfig] logourl=' + logoUrl);
    } catch (e) {
      debugPrint('[RemoteConfig] refreshNow error: $e');
    }
  }

  /// Promotional banners from Remote Config.
  /// Expects key 'promo_banners' to be a JSON array of objects like:
  /// [{"imageUrl":"https://...","route":"/products?categoryId=..."}]
  List<Map<String, dynamic>> get promoBanners {
    try {
      final raw = _rc.getString('promo_banners');
      if (raw.isEmpty) return const [];
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .whereType<Map>()
            .map((e) => e.map((k, v) => MapEntry(k.toString(), v)))
            .toList();
      }
    } catch (_) {}
    return const [];
  }
}
