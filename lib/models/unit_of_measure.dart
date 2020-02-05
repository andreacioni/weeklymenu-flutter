class UnitOfMeasure {
  final String id;
  final String name;

  const UnitOfMeasure(this.id, this.name);

  @override
  String toString() {
    return name;
  }
}