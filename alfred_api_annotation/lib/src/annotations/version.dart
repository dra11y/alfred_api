class Version {
  const Version(this.start, [this.end])
      : assert(start > 0, 'Version numbering starts with 1.'),
        assert(end == null || end >= start,
            'Version end must be null or >= start.');

  final int start;
  final int? end;

  @override
  String toString() => 'Version($start${end != null ? ', $end' : ''})';

  @override
  int get hashCode => Object.hash(start, end);

  @override
  bool operator ==(Object other) =>
      other is Version && other.start == start && other.end == end;
}
