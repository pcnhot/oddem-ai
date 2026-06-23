import '../../../shared/data/product_loader.dart';
import '../../../shared/models/ai_design_request.dart';
import '../../../shared/models/ai_design_result.dart';
import '../../../shared/models/product.dart';

/// AI designer abstraction. Recommends products by room type, budget, style
/// and dimensions. A real implementation will call the Odem AI service.
abstract class AiDesignerRepository {
  Future<AiDesignResult> generate(AiDesignRequest request);
}

class MockAiDesignerRepository implements AiDesignerRepository {
  const MockAiDesignerRepository();

  @override
  Future<AiDesignResult> generate(AiDesignRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));

    final products = await ProductLoader.instance.load();

    // Rank candidates by how well they match style, room type and budget.
    final scored = <_Scored>[];
    for (final p in products) {
      double score = 0;
      if (p.style == request.style) score += 3;
      if (p.roomType == request.roomType) score += 3;
      if (p.effectivePrice <= request.budget) score += 2;
      score += p.rating; // tie-breaker by quality
      scored.add(_Scored(p, score));
    }
    scored.sort((a, b) => b.score.compareTo(a.score));

    // StrictMode: change only one item, keep everything else unchanged.
    if (request.strictMode) {
      final replacement = scored.isNotEmpty ? scored.first.product : null;
      return AiDesignResult(
        title: 'تعديل عنصر واحد فقط',
        summary: request.strictReplaceItem == null
            ? 'تم اقتراح بديل واحد مع الإبقاء على بقية عناصر الغرفة كما هي.'
            : 'تم اقتراح بديل لـ«${request.strictReplaceItem}» مع الإبقاء على بقية عناصر الغرفة كما هي تمامًا.',
        recommendedProducts:
            replacement == null ? const [] : [replacement],
        estimatedTotal: replacement?.effectivePrice ?? 0,
        style: request.style,
        roomType: request.roomType,
        strictMode: true,
        strictReplaceItem: request.strictReplaceItem,
      );
    }

    // Full design: fit a curated set within the budget.
    final picked = <Product>[];
    double total = 0;
    for (final s in scored) {
      if (total + s.product.effectivePrice <= request.budget) {
        picked.add(s.product);
        total += s.product.effectivePrice;
      }
      if (picked.length >= 5) break;
    }
    if (picked.isEmpty && scored.isNotEmpty) {
      picked.add(scored.first.product);
      total = scored.first.product.effectivePrice;
    }

    final area = request.dimensions?.floorAreaM2;
    final areaNote = area == null
        ? ''
        : ' لمساحة ${area.toStringAsFixed(0)} م².';

    return AiDesignResult(
      title: 'تصميم ${request.roomType} بطابع ${request.style}',
      summary:
          'اخترنا لك ${picked.length} قطع متناسقة بأسلوب ${request.style} ضمن ميزانية ${request.budget.toStringAsFixed(0)} ر.س$areaNote',
      recommendedProducts: picked,
      estimatedTotal: total,
      style: request.style,
      roomType: request.roomType,
    );
  }
}

class _Scored {
  _Scored(this.product, this.score);
  final Product product;
  final double score;
}
