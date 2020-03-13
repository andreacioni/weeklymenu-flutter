enum UnitOfMeasure {
  PIECES,

  LITERS,
  CENTILITERS,
  MILLILITERS,

  GRAMS
}

const Map<UnitOfMeasure, String> UnitOfMeasures = const {
  UnitOfMeasure.PIECES: 'pcs',

  UnitOfMeasure.LITERS: 'l',
  UnitOfMeasure.CENTILITERS: 'cl',
  UnitOfMeasure.MILLILITERS: 'ml',

  UnitOfMeasure.GRAMS: 'gr'
};