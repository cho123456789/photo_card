import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/ml_photocard_scanner.dart';
import '../../domain/repositories/photocard_scanner.dart';

/// UI가 구체적인 ML 플러그인이 아닌 스캐너 계약에만 의존하도록 구현체를 주입합니다.
final photocardScannerProvider = Provider<PhotocardScanner>(
  (ref) => MlPhotocardScanner(),
);
