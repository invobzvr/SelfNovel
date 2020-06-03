extension ListEx<E> on List<E> {
  List<E> arrange([bool reverse = false]) {
    return reverse ? this.reversed.toList() : this;
  }
}
