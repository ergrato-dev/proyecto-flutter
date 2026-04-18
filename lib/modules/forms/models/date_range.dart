/// Rango de fechas para la búsqueda de asteroides en la API NeoWs.
///
/// @what  Encapsula las fechas de inicio y fin de la búsqueda con la restricción
///        de máximo 7 días que impone la API NeoWs de la NASA.
/// @why   Evitar que la lógica de validación del rango esté dispersa entre el
///        formulario y el repositorio.
/// @impact Usado en [nasaNeoWsProvider] y en [AsteroidSearchFormScreen].
class DateRange {
  const DateRange({required this.startDate, required this.endDate});

  final DateTime startDate;
  final DateTime endDate;

  /// Valida que el rango no supere 7 días (límite de la API NeoWs).
  bool get isValid =>
      !endDate.isBefore(startDate) &&
      endDate.difference(startDate).inDays <= 7;

  @override
  bool operator ==(Object other) =>
      other is DateRange &&
      startDate == other.startDate &&
      endDate == other.endDate;

  @override
  int get hashCode => Object.hash(startDate, endDate);

  @override
  String toString() =>
      'DateRange(${startDate.toIso8601String().substring(0, 10)} → ${endDate.toIso8601String().substring(0, 10)})';
}
