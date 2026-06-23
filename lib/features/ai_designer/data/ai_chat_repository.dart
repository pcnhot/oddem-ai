import '../../../shared/models/chat_message.dart';

/// Local mock chat for the AI Designer. Generates ODDEM-style Arabic replies
/// from simple keyword heuristics — no backend, no AI API (Groq/OpenAI not
/// integrated yet). Swap this for a real service later without touching the UI.
abstract class AiChatRepository {
  Future<String> reply(String userMessage, {List<ChatMessage> history});
}

class MockAiChatRepository implements AiChatRepository {
  const MockAiChatRepository();

  @override
  Future<String> reply(
    String userMessage, {
    List<ChatMessage> history = const [],
  }) async {
    // Simulate the designer "thinking/typing".
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return _compose(userMessage);
  }

  String _compose(String text) {
    final t = text.trim();
    final hasBudget = RegExp(r'\d').hasMatch(t);

    bool any(List<String> words) => words.any(t.contains);

    if (any(['مرحبا', 'السلام', 'هلا', 'اهلا', 'أهلا'])) {
      return 'أهلًا بك في مصمم Odem 👋\n'
          'أخبرني عن الغرفة (مثل: مجلس أو غرفة نوم)، والطراز الذي تفضله، وميزانيتك التقريبية، '
          'وسأقترح لك قطعًا متناسقة من موردين سعوديين موثوقين.';
    }

    if (any(['مجلس'])) {
      return 'فكرة رائعة للمجلس 👌\n'
          'أقترح كنبة زاوية بألوان هادئة (رمادي/كحلي) مع طاولة وسطية وإضاءة أرضية دافئة لإحساس فخم ومريح. '
          '${hasBudget ? 'سأراعي ميزانيتك عند اختيار القطع.' : 'ما ميزانيتك التقريبية لأرشّح لك ضمنها؟'}';
    }

    if (any(['نوم', 'سرير'])) {
      return 'لغرفة النوم أنصح بسرير منجّد بظهر مرتفع وطاولتين جانبيتين وإضاءة هادئة، '
          'مع لمسات من الرمادي الفاتح لجو مريح. هل تفضل طرازًا حديثًا أم كلاسيكيًا؟';
    }

    if (any(['طعام', 'سفرة', 'طاولة طعام'])) {
      return 'لغرفة الطعام أقترح طاولة بسطح رخامي وكراسي مريحة بألوان محايدة، '
          'مع وحدة إضاءة معلّقة فوق الطاولة لإبراز المكان. لكم شخصًا تريد الطاولة؟';
    }

    if (any(['مكتب', 'عمل', 'دراسة'])) {
      return 'لمكتب منزلي عملي: كرسي مكتب مريح (إيرغونومي)، طاولة بمساحة كافية، '
          'ووحدة أرفف للتخزين، مع إضاءة جيدة لتقليل إجهاد العين.';
    }

    if (any(['ميزانية', 'سعر', 'كم', 'تكلفة']) || hasBudget) {
      return 'تمام، سأعمل ضمن ميزانيتك. '
          'حدّد لي نوع الغرفة والطراز المفضّل وسأقترح توزيعة قطع متكاملة تناسب المبلغ. '
          'تذكّر أن تقدير التركيب يظهر عند إتمام الطلب حسب مدينتك.';
    }

    if (any(['حديث', 'مودرن', 'كلاسيك', 'مينيمال', 'بسيط', 'صناعي', 'بوهيمي'])) {
      return 'اختيار موفّق للطراز ✨\n'
          'سأبني التصميم على هذا الذوق. أخبرني عن نوع الغرفة وأبعادها التقريبية '
          'لأقترح القطع المناسبة وتوزيعها.';
    }

    if (any(['شكرا', 'شكرًا', 'تسلم', 'ممتاز'])) {
      return 'على الرحب والسعة 🌟 أنا هنا لمساعدتك في تصميم مساحتك المثالية. '
          'هل ترغب أن أقترح قطعًا جاهزة لغرفة معينة الآن؟';
    }

    // Generic, helpful fallback.
    return 'فهمت 👍 لمساعدتك بأفضل شكل، أخبرني بثلاثة أمور:\n'
        '١) نوع الغرفة (مجلس، نوم، طعام، مكتب...)\n'
        '٢) الطراز المفضّل (حديث، كلاسيكي، مينيمال...)\n'
        '٣) ميزانيتك التقريبية\n'
        'وسأقترح لك توزيعة قطع متناسقة من Odem.';
  }
}
