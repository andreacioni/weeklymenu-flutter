const List<UnitOfMeasure> unitsOfMeasure = [
  UnitOfMeasure("1", "pcs"),
  UnitOfMeasure("2", "gr"),
  UnitOfMeasure("3", "cl"),
];

class UnitOfMeasure {
  final String id;
  final String name;

  const UnitOfMeasure(this.id, this.name);

  @override
  String toString() {
    return name;
  }
}