import 'package:injectable/injectable.dart';

import 'app_env.dart';

@lazySingleton
class BuildInfoService {
  const BuildInfoService();

  String describe() =>
      'EventHorizon v2 - nguồn dữ liệu: ${AppEnv.useEmulator ? 'EMULATOR' : 'CLOUD'}';
}
