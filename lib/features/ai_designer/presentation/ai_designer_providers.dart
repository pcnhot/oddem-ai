import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../shared/models/ai_design_request.dart';
import '../../../shared/models/ai_design_result.dart';
import '../data/ai_designer_repository.dart';

final aiDesignerRepositoryProvider = Provider<AiDesignerRepository>(
  (ref) => const MockAiDesignerRepository(),
);

/// The request currently being composed across the AI designer screens
/// (form, photo upload, dimensions).
final aiRequestProvider =
    StateProvider<AiDesignRequest>((ref) => AiDesignRequest(
          roomType: AppConstants.roomTypes.first,
          style: AppConstants.designStyles.first,
          budget: 15000,
        ));

/// Holds the generated result (null until the user runs the designer).
class AiDesignController extends StateNotifier<AsyncValue<AiDesignResult?>> {
  AiDesignController(this._repo) : super(const AsyncValue.data(null));

  final AiDesignerRepository _repo;

  Future<void> generate(AiDesignRequest request) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.generate(request));
  }

  void reset() => state = const AsyncValue.data(null);
}

final aiDesignControllerProvider =
    StateNotifierProvider<AiDesignController, AsyncValue<AiDesignResult?>>(
  (ref) => AiDesignController(ref.watch(aiDesignerRepositoryProvider)),
);
