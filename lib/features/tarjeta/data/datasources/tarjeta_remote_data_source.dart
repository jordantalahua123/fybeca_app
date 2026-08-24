import 'dart:math';

import '../models/convenio_model.dart';
import '../models/security_code_model.dart';

/// Contrato de la fuente de datos remota. Mock en memoria por ahora; se
/// reemplaza por un cliente Spring Boot implementando esta misma interfaz.
abstract class TarjetaRemoteDataSource {
  Future<List<ConvenioModel>> getConvenios();

  Future<SecurityCodeModel> generateSecurityCode(String convenioId);

  Future<void> simulateUsoEnCaja(String code);
}

class TarjetaMockDataSource implements TarjetaRemoteDataSource {
  static final List<ConvenioModel> _convenios = [
    const ConvenioModel(
      id: 'vcon',
      nombre: 'Tarjeta de Empleados',
      etiqueta: 'VCON',
      codigoConvenio: 'VCOE',
      tarjetaEnmascarada: '4204••••30',
      cupoDisponible: 250.00,
    ),
    const ConvenioModel(
      id: 'fybeca',
      nombre: 'Convenio Empresarial Fybeca',
      etiqueta: 'Fybeca',
      codigoConvenio: 'VCOE',
      tarjetaEnmascarada: '8351••••74',
      cupoDisponible: 480.75,
    ),
    const ConvenioModel(
      id: 'sana-sana',
      nombre: 'Convenio Empresarial Sana Sana',
      etiqueta: 'Sana Sana',
      codigoConvenio: 'VCOE',
      tarjetaEnmascarada: '9064••••11',
      cupoDisponible: 120.50,
    ),
  ];

  final _random = Random();

  @override
  Future<List<ConvenioModel>> getConvenios() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return List.unmodifiable(_convenios);
  }

  @override
  Future<SecurityCodeModel> generateSecurityCode(String convenioId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final code = List.generate(8, (_) => _random.nextInt(10)).join();
    return SecurityCodeModel(
      convenioId: convenioId,
      code: code,
      expiresAt: DateTime.now().add(const Duration(minutes: 5)),
    );
  }

  @override
  Future<void> simulateUsoEnCaja(String code) async {
    await Future.delayed(const Duration(milliseconds: 400));
  }
}
