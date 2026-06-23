import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class _Faq {
  const _Faq(this.q, this.a);
  final String q;
  final String a;
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const _faqs = <_Faq>[
    _Faq('كيف يعمل المصمم بالذكاء الاصطناعي؟',
        'اختر نوع الغرفة والطراز والميزانية (وأبعاد الغرفة إن رغبت)، وسيقترح لك ${AppConstants.appName} قطعًا متناسقة ضمن ميزانيتك.'),
    _Faq('هل أقدر أغيّر قطعة واحدة فقط؟',
        'نعم، اختر «تغيير قطعة واحدة فقط» وسنحافظ على بقية الغرفة كما هي.'),
    _Faq('متى يتم تركيب الأثاث؟',
        'يظهر وقت التوصيل والتركيب المتوقع قبل تأكيد الطلب حسب المدينة وتوفر الفريق.'),
    _Faq('هل المنتجات أصلية؟',
        'نعم، جميع المنتجات من موردين سعوديين، وتتضمن تفاصيل المقاسات والخامات والألوان والتوفر.'),
    _Faq('كيف أشاهد المنتج داخل غرفتي؟',
        'افتح المعاينة من صفحة المنتج لتراه بالحجم الحقيقي داخل غرفتك وتتأكد من الحجم واللون قبل الشراء.'),
  ];

  static const _policies = <_Faq>[
    _Faq('سياسة الاسترجاع',
        'يمكن استرجاع المنتجات غير المستخدمة خلال المدة الموضحة في صفحة المنتج وفق شروط المورّد.'),
    _Faq('سياسة الخصوصية',
        'نحافظ على بياناتك ونستخدمها فقط لتحسين تجربتك داخل التطبيق ومعالجة طلباتك.'),
    _Faq('الشحن والتوصيل',
        'نوصّل لجميع مدن المملكة المشمولة بالخدمة، وتُحتسب رسوم الشحن عند إتمام الطلب.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(title: const Text('المساعدة والسياسات')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section('الأسئلة الشائعة', _faqs),
          const SizedBox(height: 16),
          _section('السياسات', _policies),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.support_agent, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('تواصل معنا: support@odemfurniture.com',
                      style: AppTextStyles.body),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, List<_Faq> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(title, style: AppTextStyles.title),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                ExpansionTile(
                  shape: const Border(),
                  title: Text(items[i].q, style: AppTextStyles.subtitle),
                  childrenPadding:
                      const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  expandedAlignment: Alignment.centerRight,
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(items[i].a, style: AppTextStyles.bodyMuted),
                  ],
                ),
                if (i < items.length - 1)
                  const Divider(height: 1, indent: 16, endIndent: 16),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
