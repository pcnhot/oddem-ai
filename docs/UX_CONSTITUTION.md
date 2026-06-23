# ODDEM UX Constitution

> Permanent reference for all UI, product, and content decisions.
> When any future change conflicts with this document, this document wins.

ODDEM is **not** a normal furniture store.
ODDEM is an **intelligent designer** that guides the user to choose and buy
suitable furniture with the **least thinking possible**.

## Reference model
- **IKEA Kreativ** — ease of use
- **Wayfair** — product display and purchase flow
- **Houzz** — inspiration
- A **very simplified** AI Designer

Bar to clear: easier than IKEA Kreativ at the start, clearer than Wayfair on
product pages, less cluttered than Houzz, and much simpler than Planner 5D.

## Forbidden in user-facing UI
- No technical terms: **GLB, USDZ, 3D Model, ARCore, ARKit, JSON, Mock, Demo
  URL**, backend terms, or any developer-facing label.
- Do **not** start the experience with a 2D Planner.
- Do **not** show too many options at the beginning.
- Do **not** promise a fixed installation time (never "تركيب خلال 72 ساعة").
- Do **not** make ODDEM feel like an engineering tool.
- Do **not** make ODDEM feel like only a furniture catalog.

## Core rule — one question per screen
Every screen must answer **only one** of these user questions:
1. وش أحط في غرفتي؟ (What should I put in my room?)
2. كم بيكلف؟ (How much will it cost?)
3. هل يناسب المكان؟ (Will it fit my space?)
4. كيف أشتريه؟ (How do I buy it?)

## The 5-second test (every screen must pass)
1. I understand where I am.
2. I understand what to do next.
3. I see one clear primary action.
4. I do not need to read long text.
5. I do not need to understand technology.

## Final rule for every future screen
1. One image or one decision at the top.
2. Very short title.
3. One-line description.
4. One clear primary action.
5. Secondary options hidden or lower on the screen.
6. No technical terms.
7. No more than one main task per screen.

---

## Screen direction

### Home — lead with design, not catalog
- Title: **صمّم غرفتك واشترِ القطع المناسبة**
- Description: **ارفع صورة غرفتك أو اختر المنتجات وشاهدها قبل الشراء.**
- Primary actions, in order:
  1. **صمّم غرفتي**
  2. **تصفح المنتجات**
  3. **شاهد منتج في غرفتي**
- Inspiration section: **غرف جاهزة للإلهام**
- Product section: **مختارات لغرفة المعيشة**

### AI Designer ("المصمم") — the heart of ODDEM
The most important screen, and it must be the **easiest**, not the one with the
most options. Use **progressive disclosure**.
- Title: **لنصمّم غرفتك**
- Step 1: Upload room photo.
- Step 2: Ask what the user wants:
  - تصميم كامل للغرفة
  - تغيير الكنبة فقط
  - تغيير السجادة فقط
  - اقتراح منتجات فقط
- Step 3 (optional, revealed only when needed): Budget, Style, Dimensions.
- "StrictMode" is never shown. Use **"تغيير قطعة واحدة فقط"** with helper text
  **"سنحافظ على بقية الغرفة كما هي."**

### Products — closer to Wayfair, purchase-oriented
Card shows only: image, short name, price, basic size, availability,
**شاهد في غرفتي**, **أضف للسلة**. Nothing more — details live on the detail page.
- Filters (simple horizontal bar + "كل التصفية"): الغرفة، الفئة، السعر، اللون،
  المقاس، متوفر الآن.

### Product Detail — the most important commercial screen
Order: images → name → price → availability → dimensions → colors/materials →
**شاهد في غرفتي** → **أضف للسلة** → delivery/installation info → product details
→ similar products.
Most important furniture content: الأبعاد، الخامة، اللون، الوزن إن وُجد، هل يحتاج
تركيب، وقت التوصيل/التركيب المتوقع، سياسة الإرجاع.
Fixed bottom actions: **شاهد في غرفتي** + **أضف للسلة**, with **96–120px** bottom
padding so they never cover content.

### "شاهد في غرفتي" (AR) — customer language only
Never write GLB/USDZ/3D/ARCore/ARKit. Use:
- **شاهد المنتج داخل غرفتك** / **تأكد من الحجم واللون قبل الشراء**
Screen: product image, name, large button **افتح المعاينة**, short steps
(حرّك الجوال على الأرض حتى تظهر النقطة / اضغط لوضع المنتج / اسحب للتدوير),
actions (تغيير اللون، تدوير، التقاط صورة، أضف للسلة).

### Cart — a decision screen, not browsing
Items (small image, name, color/size, price, quantity), total, delivery fees if
any, installation note, checkout button.

### Checkout — very short
Order: المدينة/الحي → العنوان → طريقة التوصيل/التركيب → الدفع → مراجعة الطلب →
تأكيد. Never promise a fixed time. Use exactly:
**"يظهر وقت التوصيل والتركيب المتوقع قبل تأكيد الطلب حسب المدينة وتوفر الفريق."**

### Order Success — explain what happens next
تم تأكيد طلبك، رقم الطلب، ملخص المنتجات، الإجمالي، حالة الطلب، الخطوة التالية،
زر **متابعة الطلب**، زر **العودة للرئيسية**.

### 2D Planner — deferred
Not a main tab. Keep under advanced options or defer to a later stage.

---

## Navigation (bottom)
الرئيسية · المنتجات · المصمم · السلة · حسابي — with **المصمم** treated as the heart.

## Visual style
Clean, calm, premium-but-restrained, easy, mobile-first.
Colors: **Navy, Charcoal, White, Light Grey**.

### Spacing
- Inside cards: **12–16px**
- Between sections: **20–24px**
- Page side padding: **16px**
- Bottom padding with fixed buttons: **96–120px**

## Primary actions
Only a few, clear: **صمّم غرفتي · شاهد في غرفتي · أضف للسلة · إتمام الطلب**.
Never more than one primary action in the same area unless one is clearly
secondary.

## Copywriting — direct and customer-friendly
- Use **"صمّم غرفتك الآن"**, not "ابدأ تجربة التصميم الداخلي المدعومة بالذكاء الاصطناعي".
- Use **"شاهد المنتج داخل غرفتك"**, not "معاينة ثلاثية الأبعاد بتقنية الواقع المعزز".

### User-facing replacements
| Never show | Show instead |
|---|---|
| GLB / USDZ / 3D Model / ARCore / ARKit | شاهد المنتج داخل غرفتك |
| StrictMode | تغيير قطعة واحدة فقط (+ "سنحافظ على بقية الغرفة كما هي.") |
| JSON / Mock / Demo URL / backend terms | (hidden entirely) |

## Most dangerous UX mistake
ODDEM must never feel like "furniture store + technical buttons".
It must feel like "an intelligent designer guiding the user to buy suitable
furniture."

## Product ingestion rule (future)
When pulling products from retailer sites, do not dump them in. Flow:
1. Pull products.
2. Clean names, prices, dimensions, images.
3. Show in simple product cards.
4. Connect them to the AI Designer.
5. Then add "شاهد في غرفتي".
