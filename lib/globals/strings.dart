class TrimmedString {
  final String _string;
  TrimmedString(String s) : this._string = s.trim();

  @override
  bool operator ==(o) => o is TrimmedString && o._string == this._string;

  @override
  int get hashCode => _string.hashCode;

  @override
  String toString() => _string;
}
