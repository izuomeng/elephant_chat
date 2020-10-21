import 'dart:math';

class EleUtils {
  static ListMap jsMap<T, P>(List<T> list) {
    return ListMap<T, P>(list);
  }

  static String generateId() =>
      int.parse(Random().nextDouble().toString().substring(2))
          .toRadixString(36);
}

class ListMap<T, P> {
  final List<T> list;

  ListMap(this.list);

  List<P> map(P callback(T item, int index)) {
    return list
        .asMap()
        .map((key, value) => MapEntry(
            key,
            callback(
              value,
              key,
            )))
        .values
        .toList();
  }
}
