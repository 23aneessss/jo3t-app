import 'package:hive_flutter/hive_flutter.dart';

class HiveCacheService {
  static const _savedPlacesBox = 'saved_places';
  static const _feedCacheBox = 'feed_cache';
  static const _placeDetailBox = 'place_detail';

  static const Duration _feedTtl = Duration(hours: 2);
  static const Duration _detailTtl = Duration(hours: 6);

  static Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox<String>(_savedPlacesBox),
      Hive.openBox<Map>(_feedCacheBox),
      Hive.openBox<Map>(_placeDetailBox),
    ]);
  }

  // ---- Saved places (ids only) ----

  Box<String> get _saved => Hive.box<String>(_savedPlacesBox);

  List<String> getSavedPlaceIds() => _saved.values.toList();

  Future<void> savePlaceId(String id) => _saved.put(id, id);

  Future<void> removePlaceId(String id) => _saved.delete(id);

  bool isPlaceSaved(String id) => _saved.containsKey(id);

  // ---- Feed cache (JSON map keyed by wilaya+category) ----

  Box<Map> get _feed => Hive.box<Map>(_feedCacheBox);

  String _feedKey(String wilayaId, String? category) =>
      'feed_${wilayaId}_${category ?? "all"}';

  Future<void> cacheFeed(
    String wilayaId,
    String? category,
    List<Map<String, dynamic>> places,
  ) async {
    final key = _feedKey(wilayaId, category);
    await _feed.put(key, {
      'places': places,
      'cachedAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  List<Map<String, dynamic>>? getCachedFeed(String wilayaId, String? category) {
    final key = _feedKey(wilayaId, category);
    final entry = _feed.get(key);
    if (entry == null) return null;
    final cachedAt =
        DateTime.fromMillisecondsSinceEpoch(entry['cachedAt'] as int);
    if (DateTime.now().difference(cachedAt) > _feedTtl) {
      _feed.delete(key);
      return null;
    }
    return (entry['places'] as List).cast<Map<String, dynamic>>();
  }

  // ---- Place detail cache ----

  Box<Map> get _detail => Hive.box<Map>(_placeDetailBox);

  Future<void> cachePlaceDetail(String id, Map<String, dynamic> place) async {
    await _detail.put(id, {
      'place': place,
      'cachedAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Map<String, dynamic>? getCachedPlaceDetail(String id) {
    final entry = _detail.get(id);
    if (entry == null) return null;
    final cachedAt =
        DateTime.fromMillisecondsSinceEpoch(entry['cachedAt'] as int);
    if (DateTime.now().difference(cachedAt) > _detailTtl) {
      _detail.delete(id);
      return null;
    }
    return Map<String, dynamic>.from(entry['place'] as Map);
  }

  Future<void> clearAll() => Future.wait([
        _saved.clear(),
        _feed.clear(),
        _detail.clear(),
      ]);
}
