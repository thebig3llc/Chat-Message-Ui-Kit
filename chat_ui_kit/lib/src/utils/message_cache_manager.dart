import 'dart:collection';
import 'package:flutter/widgets.dart';
import '../models/message.dart';

/// Manages widget caching and memory usage for chat messages
class MessageCacheManager {
  /// LRU cache for message widgets
  final LinkedHashMap<String, Widget> _widgetCache = LinkedHashMap();

  /// Maximum number of widgets to cache
  final int maxCacheSize;

  /// Set of message IDs currently being animated
  final Set<String> _animatingIds = <String>{};

  MessageCacheManager({this.maxCacheSize = 50});

  /// Get cached widget for message ID
  Widget? getCachedWidget(String messageId) {
    final widget = _widgetCache.remove(messageId);
    if (widget != null) {
      // Move to end (most recently used)
      _widgetCache[messageId] = widget;
    }
    return widget;
  }

  /// Cache a widget for the given message ID
  void cacheWidget(String messageId, Widget widget) {
    // Remove if already exists to update position
    _widgetCache.remove(messageId);

    // Add to end
    _widgetCache[messageId] = widget;

    // Remove oldest entries if over limit
    while (_widgetCache.length > maxCacheSize) {
      _widgetCache.remove(_widgetCache.keys.first);
    }
  }

  /// Check if message is currently animating
  bool isAnimating(String messageId) {
    return _animatingIds.contains(messageId);
  }

  /// Mark message as animating
  void setAnimating(String messageId, bool isAnimating) {
    if (isAnimating) {
      _animatingIds.add(messageId);
    } else {
      _animatingIds.remove(messageId);
    }
  }

  /// Clear animation state for multiple messages
  void clearAnimationState(Iterable<String> messageIds) {
    _animatingIds.removeAll(messageIds);
  }

  /// Get current cache size
  int get cacheSize => _widgetCache.length;

  /// Clear all cached widgets
  void clearCache() {
    _widgetCache.clear();
  }

  /// Remove specific message from cache
  void removeCachedWidget(String messageId) {
    _widgetCache.remove(messageId);
  }

  /// Get cache statistics for debugging
  Map<String, dynamic> getCacheStats() {
    return {
      'cacheSize': _widgetCache.length,
      'maxSize': maxCacheSize,
      'animatingCount': _animatingIds.length,
      'memoryUsage': '${(_widgetCache.length * 1024).toStringAsFixed(1)} bytes (estimated)',
    };
  }
}

/// Utility class for message ID extraction and comparison
class MessageUtils {
  /// Extract message IDs from items list using whereType for type safety
  static Set<String> extractMessageIds(List<Object> items) {
    return items
        .whereType<Map<String, Object>>()
        .map((item) {
          final message = item['message'] as MessageModel;
          return message.id;
        })
        .toSet();
  }

  /// Compare two message lists efficiently (shallow comparison)
  static bool listsEqual(List<Object> list1, List<Object> list2) {
    if (list1.length != list2.length) return false;

    for (int i = 0; i < list1.length; i++) {
      final item1 = list1[i];
      final item2 = list2[i];

      if (item1 is Map<String, Object> && item2 is Map<String, Object>) {
        final message1 = item1['message'] as MessageModel;
        final message2 = item2['message'] as MessageModel;

        if (message1.id != message2.id) return false;
      } else if (item1 != item2) {
        return false;
      }
    }

    return true;
  }

  /// Extract message from item safely
  static MessageModel? extractMessage(Object item) {
    if (item is Map<String, Object> && item.containsKey('message')) {
      return item['message'] as MessageModel;
    }
    return null;
  }
}