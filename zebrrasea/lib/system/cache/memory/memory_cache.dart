import 'package:zebrrasea/system/cache/memory/memory_store.dart';
import 'package:zebrrasea/modules.dart';
import 'package:zebrrasea/vendor.dart';

class ZebrraMemoryCache<T> {
  late String _key;
  late Future<Cache<T>> _cache;

  ZebrraMemoryCache({
    required ZebrraModule module,
    required String id,
    EvictionPolicy evictionPolicy = const LruEvictionPolicy(),
    ExpiryPolicy expiryPolicy = const EternalExpiryPolicy(),
    int maxEntries = 25,
    KeySampler sampler = const FullSampler(),
    EventListenerMode eventListenerMode = EventListenerMode.disabled,
  }) {
    _key = '${module.key}:$id';
    _cache = _getCache(
      evictionPolicy: evictionPolicy,
      expiryPolicy: expiryPolicy,
      maxEntries: maxEntries,
      sampler: sampler,
      eventListenerMode: eventListenerMode,
    );
  }

  /// Returns the the cache with the given ID from the module.
  ///
  /// If the cache has not been instantiated, it will create a new one.
  Future<Cache<T>> _getCache({
    EvictionPolicy evictionPolicy = const LruEvictionPolicy(),
    ExpiryPolicy expiryPolicy = const EternalExpiryPolicy(),
    int maxEntries = 25,
    KeySampler sampler = const FullSampler(),
    EventListenerMode eventListenerMode = EventListenerMode.disabled,
  }) async {
    return ZebrraMemoryStore().get(
      id: _key,
      fresh: true,
      evictionPolicy: evictionPolicy,
      expiryPolicy: expiryPolicy,
      maxEntries: maxEntries,
      sampler: sampler,
      eventListenerMode: eventListenerMode,
    );
  }

  Future<bool> contains(String key) async {
    final cache = await _cache;
    return cache.containsKey(key);
  }

  Future<T?> get(String key) async {
    final cache = await _cache;
    return cache.get(key);
  }

  Future<int> size() async {
    final cache = await _cache;
    return cache.size;
  }

  Future<void> put(String key, T value) async {
    final cache = await _cache;
    return cache.put(key, value);
  }

  Future<void> remove(String key) async {
    final cache = await _cache;
    return cache.remove(key);
  }

  Future<void> clear() async {
    final cache = await _cache;
    return cache.clear();
  }
}
