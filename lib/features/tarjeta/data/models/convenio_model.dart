import '../../domain/entities/convenio_entity.dart';

class ConvenioModel extends ConvenioEntity {
  const ConvenioModel({
    required super.id,
    required super.nombre,
    required super.etiqueta,
    required super.codigoConvenio,
    required super.tarjetaEnmascarada,
    required super.cupoDisponible,
  });
}
