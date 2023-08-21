extension StringExt on String {
  nullIfEmpty() => isEmpty ? null : this;
}

extension ListExt on List {
  nullIfEmpty() => isEmpty ? null : this;
}


