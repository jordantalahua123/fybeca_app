import 'package:equatable/equatable.dart';

/// Un convenio empresarial: la tarjeta de crédito/beneficio que un
/// empleado tiene disponible con una empresa afiliada (Fybeca, Sana Sana,
/// tarjeta de empleados, etc.).
class ConvenioEntity extends Equatable {
  final String id;
  final String nombre;
  final String etiqueta;
  final String codigoConvenio;
  final String tarjetaEnmascarada;
  final double cupoDisponible;

  const ConvenioEntity({
    required this.id,
    required this.nombre,
    required this.etiqueta,
    required this.codigoConvenio,
    required this.tarjetaEnmascarada,
    required this.cupoDisponible,
  });

  @override
  List<Object?> get props => [
    id,
    nombre,
    etiqueta,
    codigoConvenio,
    tarjetaEnmascarada,
    cupoDisponible,
  ];
}
