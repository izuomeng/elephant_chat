class EleUtils {
  static ListMap jsMap<T, P>(List<T> list) {
    return ListMap<T, P>(list);
  }
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
