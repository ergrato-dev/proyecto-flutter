import 'package:reactive_forms/reactive_forms.dart';

/// Clave de error que indica que la fecha de fin es anterior a la de inicio.
const String kDateOrderError = 'dateOrder';

/// Clave de error que indica que el rango supera los 7 días permitidos por NeoWs.
const String kDateRangeError = 'dateRange';

/// Validador que garantiza que la fecha de fin no sea anterior a la de inicio.
///
/// @what  Compara `startDate` y `endDate` dentro del mismo [AbstractControl] de grupo.
/// @why   La API NeoWs requiere que endDate >= startDate para devolver resultados.
/// @impact Retorna `{kDateOrderError: true}` si la validación falla; `null` si pasa.
class DateOrderValidator extends Validator<dynamic> {
  const DateOrderValidator();

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    final group = control as FormGroup;
    final start = group.control('startDate').value as DateTime?;
    final end = group.control('endDate').value as DateTime?;

    if (start == null || end == null) return null;

    if (end.isBefore(start)) {
      return {kDateOrderError: true};
    }
    return null;
  }
}

/// Validador que garantiza que el rango no supere los 7 días permitidos por NeoWs.
///
/// @what  Calcula la diferencia en días entre `startDate` y `endDate`.
/// @why   La API NeoWs de la NASA solo acepta consultas de hasta 7 días.
/// @impact Retorna `{kDateRangeError: true}` si supera 7 días; `null` si pasa.
class DateRangeValidator extends Validator<dynamic> {
  const DateRangeValidator();

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    final group = control as FormGroup;
    final start = group.control('startDate').value as DateTime?;
    final end = group.control('endDate').value as DateTime?;

    if (start == null || end == null) return null;
    if (end.isBefore(start)) return null; // DateOrderValidator ya lo cubre

    if (end.difference(start).inDays > 7) {
      return {kDateRangeError: true};
    }
    return null;
  }
}

/// Construye el [FormGroup] del formulario de búsqueda de asteroides.
///
/// @what  Define los controles `startDate`, `endDate` con validadores síncronos.
/// @why   Centraliza la construcción del formulario para facilitar los tests
///        y evitar duplicación de validadores.
/// @impact Cambiar los validadores aquí afecta directamente a [AsteroidSearchFormScreen].
FormGroup buildAsteroidSearchForm() {
  final now = DateTime.now();
  final weekAgo = now.subtract(const Duration(days: 6));

  return FormGroup(
    {
      'startDate': FormControl<DateTime>(
        value: weekAgo,
        validators: [Validators.required],
      ),
      'endDate': FormControl<DateTime>(
        value: now,
        validators: [Validators.required],
      ),
    },
    validators: [const DateOrderValidator(), const DateRangeValidator()],
  );
}
