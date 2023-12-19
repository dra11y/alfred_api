class Stack<T> {
  final List<T> _stack = [];

  void push(T element) => _stack.add(element);

  T pop() {
    if (_stack.isEmpty) {
      throw StateError("No elements in the Stack");
    } else {
      T lastElement = _stack.last;
      _stack.removeLast();
      return lastElement;
    }
  }

  T get top {
    if (_stack.isEmpty) {
      throw StateError("No elements in the Stack");
    } else {
      return _stack.last;
    }
  }

  int get length => _stack.length;

  bool get isNotEmpty => _stack.isNotEmpty;
  bool get isEmpty => _stack.isEmpty;

  @override
  String toString() => _stack.toString();
}
