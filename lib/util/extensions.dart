extension xInt on int {
  DateTime get toDateTimeFromMilli => DateTime.fromMillisecondsSinceEpoch(this);
}

extension xDouble on double {
  double roundTo2Decimals() {
    return (this * 100).round() / 100;
  }
}

extension xDateTime on DateTime {
  DateTime get plusOneDay => add(const Duration(days: 1));
}

extension xMap on Map {
  Map<K, V> withoutNull<K, V>() => Map<K, V>.from(
        this
          ..removeWhere(
            (key, value) => value == null,
          ),
      );
}

extension xList<T> on List<T> {
  bool containsWhere(bool Function(T) e) {
    return this.indexWhere(e) != -1;
  }
}

extension xListNullable<T> on List<T>? {
  List<T> addOrCreateWith(T value) {
    final list = this;
    if (list == null) {
      return <T>[value];
    } else {
      return list..add(value);
    }
  }
}

