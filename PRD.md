# Mubadel (مُبدل) — PRD

> تطبيق موبايل لتبديل وبيع المنتجات المستعملة في مصر.
> **Stack:** Flutter (Android + iOS) + Supabase (Auth, Postgres, Storage, Realtime).
> **مصدر التصميم:** فولدر `design/` (صور Figma). أي تفصيلة شكلية غير مذكورة هنا → ارجع للصورة والتزم بيها بالبكسل قدر الإمكان.
> **الهدف:** تطبيق شغال end-to-end (MVP) جاهز للتسليم.

---

## 1. الفكرة باختصار

"مُبدل — مساحتك للتبديل. خلّي اللي مش محتاجه يلاقي صاحب جديد."
المستخدم يعرض منتجاته (للتبديل / للبيع / الاتنين)، ويتصفح منتجات غيره، ويبعت **عرض تبديل** (منتج من عنده + فرق نقدي اختياري) أو **طلب شراء** (دفع عند الاستلام). لما صاحب المنتج يقبل → تتفتح محادثة بينهم للاتفاق على التسليم → أي طرف يأكد إتمام الصفقة → الطرفين يقيّموا بعض.

- نوع مستخدم واحد (كل مستخدم بائع ومشتري).
- العملة: جنيه مصري (ج.م / EGP).
- اللغة: عربي (افتراضي، RTL) + إنجليزي (LTR)، والتبديل من شاشة البداية ومن الإعدادات.
- **لا يوجد:** دفع أونلاين، مكالمات فيديو، Admin Dashboard، Push Notifications (كلها Phase 2).

---

## 2. خريطة صور التصميم

اسم الملفات المقترح داخل `design/`:

| الملف | الشاشة |
|---|---|
| `00_logo.jpg` | اللوجو |
| `01_splash.jpg` | Splash / Welcome |
| `02_design_system.jpg` | الألوان والخطوط |
| `03_login.jpg` | تسجيل الدخول |
| `04_signup.jpg` | إنشاء حساب |
| `05_home.jpg` | الرئيسية |
| `06_product_details.jpg` | تفاصيل المنتج |
| `07_make_offer.jpg` | اعرض تبديل |
| `08_add_product.jpg` | أضف منتجك |
| `09_profile.jpg` | الملف الشخصي |
| `10_chat.jpg` | المحادثة |

**Assets:** انسخ `design/00_logo.jpg` إلى `assets/images/logo.png` (حوّله PNG). بانر الـ Home يُبنى بالكود (انظر 6.4) إلا لو اتوفر `assets/images/home_banner.png`.

---

## 3. Design System

### الألوان
| Token | Hex | الاستخدام |
|---|---|---|
| `forestGreen` (primary) | `#14705A` | الأزرار الأساسية، فقاعات رسائلي، الأسعار، العناوين المميزة |
| `deepPine` | `#0E4F42` | Pressed states، تدرّج الـ Splash |
| `softMint` | `#DBF2E8` | خلفية التاب النشط، badges "متاح"، الكارت المختار، أفاتار |
| `citrus` (accent) | `#C9E866` | زر "اعرض تبديل"، بانر "تم قبول الطلب"، عنوان الـ Splash |
| `canvas` | `#F8FAF9` | خلفية كل الشاشات |
| `ink` | `#132525` | النص الأساسي |
| `warmPeach` | `#FFE9D6` | badge "تم التبديل/تم البيع"، أيقونة قسم ملابس |
| `softBlue` | `#DEEAF9` | أيقونة قسم إلكترونيات |
| `textMuted` | `#6B7A77` | النصوص الثانوية والـ placeholders |
| `border` | `#DDE5E2` | حدود الكروت والحقول البيضاء |
| `inputFill` | `#ECEEED` | حقول شاشات الـ Auth (رمادي ممتلئ) |
| `star` | `#F08C1A` | نجوم التقييم |
| `error` | `#D64545` | الأخطاء والرفض |

### الخط
**Cairo** عبر `google_fonts` (`GoogleFonts.cairoTextTheme`).
| Style | Size / Weight |
|---|---|
| Page title | 24 / Bold, ink |
| Page subtitle | 13 / Regular, textMuted |
| Section title | 18 / Bold |
| Card title | 15 / Bold |
| Body | 14 / Regular |
| Price | 18–22 / Bold, forestGreen |
| Caption / badge | 12 / SemiBold |

### الشكل
- Radius: كروت 18، أزرار 14، حقول 12 (Auth) / 16 (Add product)، chips/badges pill كامل.
- الكروت بيضاء + border `border` بسمك 1، بدون ظلال تقريبًا.
- Padding أفقي للشاشات 20.
- أيقونات outline (Material Symbols Rounded / `Icons.*_outlined`).
- **Header ثابت للشاشات الرئيسية:** عنوان + subtitle على اليمين (RTL)، ولوجو صغير في مربع أبيض radius 14 على اليسار.
- **Bottom Nav (5 تابات):** الرئيسية · المفضلة · أضف · رسائلي · حسابي. التاب النشط: pill بخلفية softMint + أيقونة ونص forestGreen bold. غير النشط: ink بشفافية 70%. Badge رقمي على "رسائلي" لعدد الرسائل غير المقروءة + العروض الواردة pending.

### الأرقام والتواريخ
- عربي: أرقام هندية `١٢,٥٠٠ ج.م` عبر `NumberFormat.decimalPattern('ar_EG')`.
- إنجليزي: `EGP 12,500`.
- وقت الرسائل: `10:32 ص` / `10:32 AM`.

### تصحيحات على التصميم (طبّقها)
1. لينك "نسيت كلمة المرور؟" في الـ Login → لون forestGreen بدل الأزرق.
2. في الـ Signup تحت "عندك حساب؟" الزر يكون **"سجّل دخول"** (مش "سجل دلوقتي").
3. توحيد نوع العرض في كل التطبيق:
   - `both` → **"بيع أو تبديل"**
   - `swap` → **"للتبديل فقط"**
   - `sale` → **"للبيع فقط"**
4. شاشة "اعرض تبديل" لا تعمل highlight لتاب "أضف" (هي شاشة stack فوق الـ tabs بدون bottom nav).
5. حذف أيقونة الفيديو من هيدر الشات.

---

## 4. Tech Stack & Architecture

```
Flutter (stable, latest) — Dart 3
State:        flutter_riverpod
Routing:      go_router (ShellRoute للـ bottom nav)
Backend:      supabase_flutter
i18n:         flutter_localizations + intl + gen-l10n (lib/l10n/app_ar.arb, app_en.arb)
UI:           google_fonts, cached_network_image, image_picker, flutter_image_compress
Utils:        url_launcher (tel:), shared_preferences (اللغة)، timeago (اختياري)
```

### هيكل المشروع
```
lib/
  main.dart
  app.dart                       # MaterialApp.router + theme + locale
  core/
    config/env.dart              # يقرأ SUPABASE_URL و SUPABASE_ANON_KEY من dart-define
    theme/app_colors.dart, app_theme.dart, app_text.dart
    router/app_router.dart
    widgets/                     # AppButton, AppTextField, ProductCard, StatusBadge,
                                 # PageHeader, AppBottomNav, EmptyState, Avatar, RatingStars
    utils/formatters.dart        # السعر، الوقت، الأرقام
  features/
    auth/        (data/, presentation/)
    home/
    products/    (details, add/edit, search)
    offers/      (make offer, buy request, offers list)
    chat/        (conversations list, chat room)
    favorites/
    profile/     (my profile, public profile, edit, settings, reviews)
  l10n/app_ar.arb, app_en.arb
assets/images/logo.png
```

### الإعدادات
`env.json` في جذر المشروع (مضاف إلى `.gitignore`):
```json
{ "SUPABASE_URL": "https://xxxx.supabase.co", "SUPABASE_ANON_KEY": "eyJ..." }
```
التشغيل: `flutter run --dart-define-from-file=env.json`
البناء: `flutter build apk --release --dart-define-from-file=env.json`

### قواعد مهمة للكود
- **ممنوع `select('*')` على جدول `profiles`**، لأن عمودَي `phone` و`address` محجوبين عن القراءة العامة. استخدم الأعمدة المسموحة (قسم 8)، والـ RPCs `get_my_profile` و`get_peer_phone`.
- كل تغييرات حالة العروض (قبول/رفض/إلغاء/إتمام) تتم **فقط** عبر RPC functions، مش update مباشر.
- رفع الصور: ضغط لعرض 1280px وجودة 75، والمسار `{auth.uid}/{uuid}.jpg`.
- كل الواجهات تدعم RTL/LTR تلقائيًا (استخدم `EdgeInsetsDirectional`، `AlignmentDirectional`، و `Directionality` من الـ locale). أيقونات الأسهم تنعكس حسب الاتجاه.
- كل شاشة فيها: loading (skeleton أو spinner)، و empty state، و error state مع زر "حاول تاني"، و pull-to-refresh للقوائم.

---

## 5. Data Model (ملخص)

| Entity | أهم الحقول |
|---|---|
| **profiles** | id (=auth user)، full_name، phone*، address*، city، avatar_url، is_verified، rating_avg، rating_count، swaps_count، created_at |
| **categories** | id، slug، name_ar، name_en، icon (emoji)، color، sort |
| **products** | id، owner_id، title، description، category_id، condition (`new/like_new/used`)، listing_type (`sale/swap/both`)، price (إجباري إلا لو swap)، city، images[]، status (`available/reserved/swapped/sold`)، created_at |
| **favorites** | user_id + product_id |
| **offers** | id، type (`swap/buy`)، product_id (المطلوب)، offered_product_id (في التبديل)، sender_id، receiver_id، cash_amount (في التبديل: فرق يدفعه المرسل، وفي الشراء: سعر المنتج)، note، status (`pending/accepted/rejected/cancelled/completed`) |
| **conversations** | id، product_id، offer_id، user1_id (البادئ)، user2_id (صاحب المنتج)، last_message، last_message_at |
| **messages** | id، conversation_id، sender_id، body، read_at، created_at |
| **reviews** | id، offer_id، reviewer_id، reviewee_id، rating 1–5، comment |

\* محجوب عن الآخرين.

### دورة حياة العرض
```
pending ──(receiver: accept_offer)──► accepted ──(any party: complete_offer)──► completed ─► reviews
   │                                     │
   ├─(receiver: reject_offer)─► rejected └─(any party: cancel_offer)─► cancelled  (المنتجات ترجع available)
   └─(sender: cancel_offer)──► cancelled
```
- عند القبول: المنتجات المعنية تصبح `reserved` (تختفي من الـ Home)، وكل العروض الـ pending الأخرى عليها تترفض تلقائيًا، وتتفتح/تترَبط محادثة.
- عند الإتمام: swap → المنتجين `swapped` و `swaps_count+1` للطرفين، buy → المنتج `sold`.

---

## 6. الشاشات والمتطلبات

### 6.1 Splash / Welcome — `01_splash.jpg`
- Toggle اللغة (ع / en) أعلى اليسار، والاختيار يتحفظ في shared_preferences ويطبق فورًا (RTL/LTR).
- اللوجو، والجزء السفلي أخضر متدرّج (`forestGreen` → `#4CBF6B` تقريبًا) بحافة علوية منحنية، وعليه "مُبدل" بلون citrus، و"مساحتك للتبديل"، والـ tagline، وزر "ابدأ" (أبيض/رمادي فاتح).
- لو فيه session محفوظة → يروح الـ Home مباشرة (بدون الضغط على ابدأ). غير كده "ابدأ" → Login.

### 6.2 Login — `03_login.jpg`
- الحقول: البريد (أيقونة ظرف)، كلمة المرور (قفل + عين لإظهار/إخفاء).
- "تذكرني" checkbox: لو مش متعلّم يتم `signOut` عند فتح التطبيق المرة الجاية.
- "نسيت كلمة المرور؟" → 6.3.
- Validation: إيميل صحيح، باسورد ≥ 6. والأخطاء تظهر تحت الحقل بالعربي (مثلاً "البريد أو كلمة المرور غير صحيحة").
- "سجل دلوقتي" → Signup.

### 6.3 Forgot Password (غير مصممة، بنفس ستايل الـ Auth)
1. شاشة إدخال الإيميل → `resetPasswordForEmail(email)`.
2. شاشة إدخال الكود (6 أرقام) + كلمة مرور جديدة + تأكيدها → `verifyOTP(type: OtpType.recovery, email, token)` ثم `updateUser(UserAttributes(password))` → الـ Home.

### 6.4 Signup — `04_signup.jpg`
- الحقول: الاسم بالكامل، البريد، كلمة المرور، رقم التليفون (مصري: `^01[0125][0-9]{8}$`)، **المحافظة** (dropdown، حقل مضاف بنفس الستايل قبل العنوان، وقيمه محافظات مصر)، العنوان.
- `signUp(email, password, data: {full_name, phone, city, address})`، والـ trigger ينشئ الـ profile → Home.
- "سجّل دخول" → Login.

### 6.5 Home — `05_home.jpg`
- Header: "**مُبدل** مساحتك للتبديل" + tagline + اللوجو.
- Search bar: "بتدور على إيه النهارده؟"، والضغط يفتح Search (6.6).
- Banner: كارت softMint radius 20، فيه اللوجو، و"اللي مش محتاجه .. ممكن يكون كنز لحد تاني"، وزر citrus "ابدأ التبديل ←" → Add Product. (لو فيه `home_banner.png` يُستخدم كصورة).
- "تصفّح الأقسام": صف أفقي scrollable من الأقسام (دائرة ملوّنة + emoji + اسم)، والضغط → Search مفلتر بالقسم.
- "لقطات ممكن تعجبك" + "عرض الكل ←": Grid عمودين، فيه منتجات `available` ليست ملكي، الأحدث أولًا، و pagination (20 عنصر).
- **ProductCard:** صورة (aspect ~1:1، radius 16)، وقلب مفضلة أعلى اليسار (toggle فوري optimistic)، والاسم، والسعر (أو "للتبديل" لو swap)، والحالة ("جديد / شبه جديد / مستعمل")، و📍 المدينة، و badge نوع العرض (softMint).

### 6.6 Search & Category (غير مصممة)
- Search field في الأعلى (debounce 400ms، `title ilike %q%`).
- Filter chips: القسم، ونوع العرض (الكل/بيع/تبديل)، والحالة.
- Grid نفس ProductCard، و empty state "مفيش نتائج".

### 6.7 Product Details — `06_product_details.jpg`
- Header "تفاصيل المنتج / راجع التفاصيل قبل ما تبعت عرض".
- Gallery: PageView للصور، وعداد "١ / ٤"، وقلب مفضلة، والضغط على الصورة → full screen viewer.
- الاسم، والسعر، و badge نوع العرض، و"تفاصيل المنتج" (الوصف + القسم + الحالة).
- "صاحب المنتج": أفاتار (أول حرف) + الاسم + "المدينة · عضو من {سنة}" + ★ التقييم (عدد التقييمات)، والضغط → Public Profile.
- أزرار سفلية ثابتة (حسب listing_type):
  - **اعرض تبديل** (citrus) — يظهر لو `swap` أو `both` → 6.8
  - **اشتري** (forestGreen) — يظهر لو `sale` أو `both` → 6.9
  - **راسل البائع** (outline أبيض) — دائمًا → `start_conversation` → Chat
- لو أنا صاحب المنتج: بدل الأزرار يظهر **تعديل** و **حذف** (مع تأكيد).
- لو المنتج مش `available`: الأزرار disabled وبانر "المنتج غير متاح حاليًا".
- لو فيه عرض pending مني على المنتج: زر "اعرض تبديل/اشتري" يتحول لـ "تم إرسال عرضك" disabled.

### 6.8 Make Swap Offer — `07_make_offer.jpg`
- كارت "المنتج المطلوب": الصورة، والاسم، والسعر، و"بواسطة {الاسم} · {المدينة}".
- "اختار منتجك اللي هتعرضه": قائمة منتجاتي `available` (single select). الكارت المختار: border forestGreen + خلفية softMint + ✓ دائرة خضراء.
- لو مفيش منتجات: empty state + زر "أضف منتج".
- "فرق نقدي (اختياري)": رقم، و placeholder "مثال: هدفع ٢,٥٠٠ ج.م زيادة"، و hint "الفرق النهائي بيتحدد بالاتفاق بين الطرفين."
- "إرسال عرض التبديل" → insert offer (type swap) → snackbar نجاح → رجوع.

### 6.9 Buy Request (Bottom Sheet، غير مصمم)
- ملخص المنتج والسعر، و"الدفع عند الاستلام"، وحقل ملاحظة اختياري، وزر "إرسال طلب الشراء" → insert offer (type buy, cash_amount = price).

### 6.10 Add / Edit Product — `08_add_product.jpg`
- "صور المنتج": زر "أضف صور" (حتى 6 صور، من الكاميرا أو المعرض)، وكارت tip softMint "صوّر المنتج في إضاءة كويسة". الصور المختارة تظهر كـ thumbnails أفقية مع زر حذف، وأول صورة هي الغلاف.
- "بيانات المنتج": اسم المنتج، والقسم (dropdown من categories)، والحالة (chips: جديد/شبه جديد/مستعمل)، والوصف (multiline، **حقل مضاف** تحت الاسم).
- "عايز تعرضه إزاي؟": 3 كروت (بيع أو تبديل ↔، للتبديل ⇄، للبيع ج.م)، والمختار له border forestGreen + softMint.
- "السعر المطلوب (جنيه)": إجباري إلا لو "للتبديل".
- Validation: صورة واحدة على الأقل، واسم ≥ 3 حروف، وقسم، وحالة.
- "انشر المنتج": رفع الصور → insert → Product Details. وفي وضع التعديل يكون الزر "حفظ التعديلات".
- city تُنسخ من profile المستخدم.

### 6.11 My Profile (تاب حسابي) — `09_profile.jpg`
- بدون زر رجوع، و أيقونة إعدادات (⚙) في الهيدر → 6.13.
- أفاتار دائري softMint (صورة أو أول حرف)، والاسم، و⌖ المدينة، و نجوم + التقييم، و"عضو موثق في مجتمع مُبدل" (لو is_verified).
- كارت إحصائيات forestGreen: التقييم | تبديل (swaps_count) | عنصر (عدد منتجاتي).
- "عناصري" + "عرض الكل ←"، وتابين: **منتجاتي** | **تقييماتي**.
  - منتجاتي: Grid كروت (صورة/emoji، الاسم، status badge: متاح=softMint، محجوز=softBlue، تم التبديل/تم البيع=warmPeach، والسطر الفرعي "للتبديل/للبيع/تم بنجاح").
  - تقييماتي: قائمة (اسم المقيّم، نجوم، تعليق، تاريخ).

### 6.12 Public Profile
نفس 6.11 مع: زر رجوع، بدون إعدادات، وعرض المنتجات `available` فقط، وعناوين التابات "المنتجات | التقييمات".

### 6.13 Settings & Edit Profile (غير مصممة)
- تعديل الملف: الصورة (رفع لـ avatars)، والاسم، والتليفون، والمحافظة، والعنوان.
- اللغة: عربي / English.
- تسجيل الخروج (مع تأكيد).

### 6.14 Favorites (تاب المفضلة)
Header "المفضلة"، وGrid ProductCard للمنتجات المحفوظة، و empty state "لسه مفيش حاجة في المفضلة".

### 6.15 Messages (تاب رسائلي)
- Segmented control أعلى الشاشة: **المحادثات** | **العروض**.
- **المحادثات:** قائمة مرتبة بـ last_message_at. العنصر: أفاتار، واسم الطرف الآخر، وآخر رسالة، والوقت، و badge غير مقروء، وthumbnail المنتج. Realtime update.
- **العروض:** sub-tabs **واردة** | **صادرة**. كارت العرض: صورة المنتج المطلوب ⇄ صورة المنتج المعروض (أو "شراء" + السعر)، والفرق النقدي، والطرف الآخر، و status chip، والتاريخ.
  - واردة pending: أزرار **قبول** (forestGreen) و **رفض** (outline error). القبول → `accept_offer` → يفتح الشات.
  - صادرة pending: زر **إلغاء العرض**.
  - accepted / completed: زر **فتح المحادثة**.

### 6.16 Chat — `10_chat.jpg`
- Header: رجوع، وأفاتار، والاسم، و"● متصل الآن" (**MVP: اعرض بدلها المدينة** بنفس الستايل)، وأيقونة اتصال 📞 (→ `get_peer_phone` → `tel:`، تظهر فقط لو المحادثة مرتبطة بعرض accepted/completed)، وأيقونة قائمة ≡.
- بانر الحالة (لو فيه offer):
  - accepted: citrus "✓ تم قبول طلب التبادل" / "✓ تم قبول طلب الشراء"
  - completed: softMint "تمت الصفقة بنجاح 🎉"
  - cancelled: warmPeach "تم إلغاء الاتفاق"
- كارت "تفاصيل التبادل": المنتجين مع ⇄ (أو المنتج + "شراء" + السعر)، والضغط على منتج يفتح تفاصيله.
- فاصل اليوم ("اليوم" / "أمس" / التاريخ).
- الفقاعات: رسائلي forestGreen بنص أبيض + الوقت + ✓✓ (أبيض لو مقروءة، وشفاف لو لا)، ورسائل الطرف الآخر `#EEF1F0` بنص ink. والفقاعات radius 22.
- Input: حقل "اكتب رسالة..."، وزر إرسال دائري forestGreen. زر "+" (**MVP: مخفي**، Phase 2 للصور).
- Realtime: subscribe على messages بـ conversation_id. عند الفتح → `mark_conversation_read`.
- قائمة ≡: "عرض المنتج"، و"تأكيد إتمام الصفقة" (accepted فقط، مع تأكيد → `complete_offer`)، و"إلغاء الاتفاق" (accepted فقط → `cancel_offer`).
- بعد الإتمام: كارت داخل الشات "قيّم تجربتك مع {الاسم}" → Bottom sheet (نجوم 1–5 + تعليق) → insert review. يختفي بعد التقييم.

---

## 7. Navigation

```
/splash → /login ↔ /signup, /forgot-password
ShellRoute (bottom nav):
  /home   /favorites   /add   /messages   /profile
Stack routes (بدون bottom nav):
  /product/:id   /product/:id/edit   /product/:id/offer
  /search?category=&q=   /user/:id   /chat/:conversationId   /settings   /settings/edit-profile
```
- Auth guard: أي route غير auth بدون session → /login.

---

## 8. Supabase — المطلوب بالظبط

### 8.1 خطوات على حساب Supabase (اللي هيعمل المشروع)
1. **New Project**: Region = `Central EU (Frankfurt)` (الأقرب لمصر)، واحفظ الـ DB password.
2. **SQL Editor** → New query → الصق السكريبت كامل في 8.3 → Run (لازم يخلص بدون errors).
3. **Authentication → Providers → Email**: Enabled. وقفّل **Confirm email** (عشان التسجيل يدخل فورًا). Minimum password length = 6.
4. **Authentication → Email Templates → Reset Password**: استبدل المحتوى بـ:
   ```html
   <h2>إعادة تعيين كلمة المرور - مُبدل</h2>
   <p>كود إعادة التعيين الخاص بك:</p>
   <h1>{{ .Token }}</h1>
   ```
5. **Project Settings → API**: ابعت لنا **Project URL** و **anon public key** فقط.
   ⚠️ **ممنوع** إرسال `service_role` key.

### 8.2 اللي هنحطه في التطبيق
`env.json` ← `SUPABASE_URL` و `SUPABASE_ANON_KEY`. بس كده.

### 8.3 SQL Script (تشغيل مرة واحدة)

```sql
-- =========================================================
-- Mubadel — Supabase schema
-- =========================================================

-- ---------- ENUMS ----------
create type product_condition as enum ('new','like_new','used');
create type listing_type      as enum ('sale','swap','both');
create type product_status    as enum ('available','reserved','swapped','sold');
create type offer_type        as enum ('swap','buy');
create type offer_status      as enum ('pending','accepted','rejected','cancelled','completed');

-- ---------- TABLES ----------
create table public.profiles (
  id            uuid primary key references auth.users(id) on delete cascade,
  full_name     text not null default '',
  phone         text,
  address       text,
  city          text,
  avatar_url    text,
  is_verified   boolean not null default false,
  rating_avg    numeric(2,1) not null default 0,
  rating_count  int not null default 0,
  swaps_count   int not null default 0,
  created_at    timestamptz not null default now()
);

create table public.categories (
  id       serial primary key,
  slug     text unique not null,
  name_ar  text not null,
  name_en  text not null,
  icon     text not null,
  color    text not null,
  sort     int not null default 0
);

create table public.products (
  id            uuid primary key default gen_random_uuid(),
  owner_id      uuid not null references public.profiles(id) on delete cascade,
  title         text not null,
  description   text not null default '',
  category_id   int not null references public.categories(id),
  condition     product_condition not null,
  listing_type  listing_type not null,
  price         numeric(12,2),
  city          text,
  images        text[] not null default '{}',
  status        product_status not null default 'available',
  created_at    timestamptz not null default now(),
  constraint price_required check (listing_type = 'swap' or price is not null)
);
create index products_owner_idx    on public.products(owner_id);
create index products_category_idx on public.products(category_id);
create index products_feed_idx     on public.products(status, created_at desc);

create table public.favorites (
  user_id     uuid not null references public.profiles(id) on delete cascade,
  product_id  uuid not null references public.products(id) on delete cascade,
  created_at  timestamptz not null default now(),
  primary key (user_id, product_id)
);

create table public.offers (
  id                  uuid primary key default gen_random_uuid(),
  type                offer_type not null,
  product_id          uuid not null references public.products(id) on delete cascade,
  offered_product_id  uuid references public.products(id) on delete set null,
  sender_id           uuid not null references public.profiles(id) on delete cascade,
  receiver_id         uuid not null references public.profiles(id) on delete cascade,
  cash_amount         numeric(12,2) not null default 0,
  note                text,
  status              offer_status not null default 'pending',
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now(),
  constraint swap_needs_product check (type = 'buy' or offered_product_id is not null),
  constraint not_self check (sender_id <> receiver_id)
);
create index offers_sender_idx   on public.offers(sender_id, created_at desc);
create index offers_receiver_idx on public.offers(receiver_id, created_at desc);

create table public.conversations (
  id               uuid primary key default gen_random_uuid(),
  product_id       uuid references public.products(id) on delete set null,
  offer_id         uuid references public.offers(id) on delete set null,
  user1_id         uuid not null references public.profiles(id) on delete cascade,
  user2_id         uuid not null references public.profiles(id) on delete cascade,
  last_message     text,
  last_message_at  timestamptz not null default now(),
  created_at       timestamptz not null default now(),
  unique (product_id, user1_id, user2_id)
);

create table public.messages (
  id               uuid primary key default gen_random_uuid(),
  conversation_id  uuid not null references public.conversations(id) on delete cascade,
  sender_id        uuid not null references public.profiles(id) on delete cascade,
  body             text not null check (length(trim(body)) > 0),
  read_at          timestamptz,
  created_at       timestamptz not null default now()
);
create index messages_conv_idx on public.messages(conversation_id, created_at);

create table public.reviews (
  id           uuid primary key default gen_random_uuid(),
  offer_id     uuid not null references public.offers(id) on delete cascade,
  reviewer_id  uuid not null references public.profiles(id) on delete cascade,
  reviewee_id  uuid not null references public.profiles(id) on delete cascade,
  rating       int not null check (rating between 1 and 5),
  comment      text,
  created_at   timestamptz not null default now(),
  unique (offer_id, reviewer_id)
);

-- ---------- SEED: CATEGORIES ----------
insert into public.categories (slug, name_ar, name_en, icon, color, sort) values
  ('home',        'منزل',        'Home',        '🛋️', '#EAE6FA', 1),
  ('tools',       'أدوات',       'Tools',       '🔧', '#FFF4D6', 2),
  ('clothes',     'ملابس',       'Clothes',     '👕', '#FFE9D6', 3),
  ('electronics', 'إلكترونيات',  'Electronics', '🎧', '#DEEAF9', 4),
  ('mobiles',     'موبايلات',    'Mobiles',     '📱', '#DBF2E8', 5),
  ('books',       'كتب',         'Books',       '📚', '#DBF2E8', 6),
  ('other',       'أخرى',        'Other',       '📦', '#ECEEED', 7);

-- ---------- TRIGGERS ----------
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, full_name, phone, address, city)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', ''),
    new.raw_user_meta_data->>'phone',
    new.raw_user_meta_data->>'address',
    new.raw_user_meta_data->>'city'
  );
  return new;
end $$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

create or replace function public.on_message_insert()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  update public.conversations
     set last_message = new.body, last_message_at = new.created_at
   where id = new.conversation_id;
  return new;
end $$;

create trigger messages_after_insert
  after insert on public.messages
  for each row execute function public.on_message_insert();

create or replace function public.on_review_insert()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  update public.profiles p
     set rating_count = s.cnt, rating_avg = s.avg
    from (select count(*)::int cnt, round(avg(rating)::numeric, 1) avg
            from public.reviews where reviewee_id = new.reviewee_id) s
   where p.id = new.reviewee_id;
  return new;
end $$;

create trigger reviews_after_insert
  after insert on public.reviews
  for each row execute function public.on_review_insert();

-- ---------- RPC FUNCTIONS ----------
-- full profile of the current user (includes phone/address)
create or replace function public.get_my_profile()
returns public.profiles language sql security definer set search_path = public as $$
  select * from public.profiles where id = auth.uid();
$$;

-- other participant's phone (only after an accepted/completed offer in that conversation)
create or replace function public.get_peer_phone(p_conversation_id uuid)
returns text language plpgsql security definer set search_path = public as $$
declare c public.conversations; peer uuid; ok boolean;
begin
  select * into c from public.conversations where id = p_conversation_id;
  if c.id is null or auth.uid() not in (c.user1_id, c.user2_id) then
    raise exception 'not allowed';
  end if;
  select exists(select 1 from public.offers o
                 where o.id = c.offer_id and o.status in ('accepted','completed')) into ok;
  if not ok then raise exception 'no accepted deal'; end if;
  peer := case when c.user1_id = auth.uid() then c.user2_id else c.user1_id end;
  return (select phone from public.profiles where id = peer);
end $$;

-- "راسل البائع"
create or replace function public.start_conversation(p_product_id uuid)
returns uuid language plpgsql security definer set search_path = public as $$
declare v_owner uuid; v_conv uuid;
begin
  select owner_id into v_owner from public.products where id = p_product_id;
  if v_owner is null then raise exception 'product not found'; end if;
  if v_owner = auth.uid() then raise exception 'cannot message yourself'; end if;
  insert into public.conversations (product_id, user1_id, user2_id)
  values (p_product_id, auth.uid(), v_owner)
  on conflict (product_id, user1_id, user2_id) do update set product_id = excluded.product_id
  returning id into v_conv;
  return v_conv;
end $$;

-- receiver accepts → reserve products, reject competing offers, open/link conversation
create or replace function public.accept_offer(p_offer_id uuid)
returns uuid language plpgsql security definer set search_path = public as $$
declare o public.offers; v_conv uuid;
begin
  select * into o from public.offers where id = p_offer_id for update;
  if o.id is null or o.receiver_id <> auth.uid() then raise exception 'not allowed'; end if;
  if o.status <> 'pending' then raise exception 'offer is not pending'; end if;

  update public.offers set status = 'accepted', updated_at = now() where id = o.id;

  update public.products set status = 'reserved'
   where id = o.product_id or id = o.offered_product_id;

  update public.offers set status = 'rejected', updated_at = now()
   where id <> o.id and status = 'pending'
     and (product_id in (o.product_id, o.offered_product_id)
          or offered_product_id in (o.product_id, o.offered_product_id));

  insert into public.conversations (product_id, offer_id, user1_id, user2_id)
  values (o.product_id, o.id, o.sender_id, o.receiver_id)
  on conflict (product_id, user1_id, user2_id)
  do update set offer_id = excluded.offer_id, last_message_at = now()
  returning id into v_conv;

  return v_conv;
end $$;

create or replace function public.reject_offer(p_offer_id uuid)
returns void language plpgsql security definer set search_path = public as $$
declare o public.offers;
begin
  select * into o from public.offers where id = p_offer_id for update;
  if o.id is null or o.receiver_id <> auth.uid() then raise exception 'not allowed'; end if;
  if o.status <> 'pending' then raise exception 'offer is not pending'; end if;
  update public.offers set status = 'rejected', updated_at = now() where id = o.id;
end $$;

-- sender cancels pending, or either party cancels accepted (products return to available)
create or replace function public.cancel_offer(p_offer_id uuid)
returns void language plpgsql security definer set search_path = public as $$
declare o public.offers;
begin
  select * into o from public.offers where id = p_offer_id for update;
  if o.id is null or auth.uid() not in (o.sender_id, o.receiver_id) then raise exception 'not allowed'; end if;
  if o.status = 'pending' and o.sender_id = auth.uid() then
    update public.offers set status = 'cancelled', updated_at = now() where id = o.id;
  elsif o.status = 'accepted' then
    update public.offers set status = 'cancelled', updated_at = now() where id = o.id;
    update public.products set status = 'available'
     where (id = o.product_id or id = o.offered_product_id) and status = 'reserved';
  else
    raise exception 'cannot cancel this offer';
  end if;
end $$;

create or replace function public.complete_offer(p_offer_id uuid)
returns void language plpgsql security definer set search_path = public as $$
declare o public.offers;
begin
  select * into o from public.offers where id = p_offer_id for update;
  if o.id is null or auth.uid() not in (o.sender_id, o.receiver_id) then raise exception 'not allowed'; end if;
  if o.status <> 'accepted' then raise exception 'offer is not accepted'; end if;

  update public.offers set status = 'completed', updated_at = now() where id = o.id;

  if o.type = 'swap' then
    update public.products set status = 'swapped'
     where id = o.product_id or id = o.offered_product_id;
    update public.profiles set swaps_count = swaps_count + 1
     where id in (o.sender_id, o.receiver_id);
  else
    update public.products set status = 'sold' where id = o.product_id;
  end if;
end $$;

create or replace function public.mark_conversation_read(p_conversation_id uuid)
returns void language plpgsql security definer set search_path = public as $$
begin
  if not exists (select 1 from public.conversations
                  where id = p_conversation_id and auth.uid() in (user1_id, user2_id)) then
    raise exception 'not allowed';
  end if;
  update public.messages set read_at = now()
   where conversation_id = p_conversation_id and sender_id <> auth.uid() and read_at is null;
end $$;

-- ---------- ROW LEVEL SECURITY ----------
alter table public.profiles      enable row level security;
alter table public.categories    enable row level security;
alter table public.products      enable row level security;
alter table public.favorites     enable row level security;
alter table public.offers        enable row level security;
alter table public.conversations enable row level security;
alter table public.messages      enable row level security;
alter table public.reviews       enable row level security;

-- profiles: public read of non-sensitive columns only; owner updates editable columns only
create policy profiles_select on public.profiles for select using (true);
create policy profiles_update on public.profiles for update
  using (auth.uid() = id) with check (auth.uid() = id);
revoke select, update on public.profiles from anon, authenticated;
grant select (id, full_name, city, avatar_url, is_verified, rating_avg, rating_count, swaps_count, created_at)
  on public.profiles to anon, authenticated;
grant update (full_name, phone, address, city, avatar_url) on public.profiles to authenticated;

-- categories
create policy categories_select on public.categories for select using (true);

-- products
create policy products_select on public.products for select using (true);
create policy products_insert on public.products for insert with check (owner_id = auth.uid());
create policy products_update on public.products for update using (owner_id = auth.uid()) with check (owner_id = auth.uid());
create policy products_delete on public.products for delete using (owner_id = auth.uid());

-- favorites
create policy favorites_all on public.favorites for all
  using (user_id = auth.uid()) with check (user_id = auth.uid());

-- offers: participants read; sender inserts valid pending offers; state changes via RPC only
create policy offers_select on public.offers for select
  using (auth.uid() in (sender_id, receiver_id));
create policy offers_insert on public.offers for insert with check (
  sender_id = auth.uid()
  and status = 'pending'
  and receiver_id = (select owner_id from public.products where id = product_id)
  and exists (select 1 from public.products where id = product_id and status = 'available')
  and (
    offered_product_id is null
    or exists (select 1 from public.products
                where id = offered_product_id and owner_id = auth.uid() and status = 'available')
  )
);

-- conversations (created via RPC only)
create policy conversations_select on public.conversations for select
  using (auth.uid() in (user1_id, user2_id));

-- messages
create policy messages_select on public.messages for select using (
  exists (select 1 from public.conversations c
           where c.id = conversation_id and auth.uid() in (c.user1_id, c.user2_id))
);
create policy messages_insert on public.messages for insert with check (
  sender_id = auth.uid()
  and exists (select 1 from public.conversations c
               where c.id = conversation_id and auth.uid() in (c.user1_id, c.user2_id))
);

-- reviews: public read; only participants of a completed offer, one per offer
create policy reviews_select on public.reviews for select using (true);
create policy reviews_insert on public.reviews for insert with check (
  reviewer_id = auth.uid()
  and reviewee_id <> auth.uid()
  and exists (select 1 from public.offers o
               where o.id = offer_id and o.status = 'completed'
                 and auth.uid() in (o.sender_id, o.receiver_id)
                 and reviewee_id in (o.sender_id, o.receiver_id))
);

-- ---------- REALTIME ----------
alter publication supabase_realtime add table public.messages, public.conversations, public.offers;

-- ---------- STORAGE ----------
insert into storage.buckets (id, name, public) values
  ('product-images', 'product-images', true),
  ('avatars', 'avatars', true)
on conflict (id) do nothing;

create policy storage_insert_own on storage.objects for insert to authenticated
  with check (bucket_id in ('product-images','avatars')
              and (storage.foldername(name))[1] = auth.uid()::text);
create policy storage_update_own on storage.objects for update to authenticated
  using (bucket_id in ('product-images','avatars')
         and (storage.foldername(name))[1] = auth.uid()::text);
create policy storage_delete_own on storage.objects for delete to authenticated
  using (bucket_id in ('product-images','avatars')
         and (storage.foldername(name))[1] = auth.uid()::text);
```

### 8.4 أمثلة Queries للتطبيق
```dart
// Feed
supabase.from('products')
  .select('*, category:categories(*), owner:profiles(id, full_name, city, avatar_url, rating_avg, rating_count, created_at)')
  .eq('status', 'available').neq('owner_id', uid)
  .order('created_at', ascending: false).range(from, to);

// Conversations list
supabase.from('conversations')
  .select('*, product:products(id, title, images), offer:offers(*), '
          'u1:profiles!conversations_user1_id_fkey(id, full_name, avatar_url, city), '
          'u2:profiles!conversations_user2_id_fkey(id, full_name, avatar_url, city)')
  .order('last_message_at', ascending: false);

// RPC
await supabase.rpc('accept_offer', params: {'p_offer_id': id}); // returns conversation id
```

---

## 9. Out of Scope (Phase 2)
دفع أونلاين، والصور في الشات، و Push notifications، وحالة online الحقيقية، والمكالمات داخل التطبيق، وتوثيق الهوية (حاليًا `is_verified` يُعدّل يدويًا من Supabase)، والبلاغات والحظر، و Admin Dashboard، و Counter-offers.

---

## 10. خطة التنفيذ (بالترتيب)
1. إعداد المشروع: packages، و theme + colors + Cairo، و l10n (ar/en) + RTL، و router + shell + bottom nav، و Supabase init.
2. Auth: Splash، و Login، و Signup، و Forgot password، و guard.
3. Products: Home، و ProductCard، و Search/Category، و Details، و Add/Edit (رفع صور)، و Favorites.
4. Offers: Make swap offer، و Buy sheet، و قائمة العروض (واردة/صادرة) + RPCs.
5. Chat: قائمة المحادثات + الشات realtime + البانرات + إتمام/إلغاء + التقييم.
6. Profile: My/Public profile، و تقييماتي، و Settings، و Edit profile، و اللغة، و Logout.
7. مراجعة كل شاشة مقابل صورتها في `design/`، بالـ RTL والـ LTR.
8. `flutter analyze` بدون errors، وبناء APK release.

---

## 11. Acceptance Checklist
- [ ] مستخدم جديد يسجل ويدخل الـ Home مباشرة، والـ profile اتعمل بالاسم والتليفون والمحافظة.
- [ ] Login/Logout/تذكرني/نسيت كلمة المرور (OTP) شغالين.
- [ ] تبديل اللغة يقلب الاتجاه والنصوص في كل الشاشات فورًا ويتحفظ.
- [ ] إضافة منتج بصور (حتى 6) تظهر في Home لمستخدم آخر، وتعديله وحذفه يشتغلوا.
- [ ] البحث والفلترة بالقسم والنوع والحالة شغالين.
- [ ] المفضلة تتحفظ وتظهر في تاب المفضلة.
- [ ] أزرار تفاصيل المنتج تتغير حسب listing_type والملكية والحالة.
- [ ] عرض تبديل (بفرق نقدي) وطلب شراء يوصلوا للطرف التاني في "العروض الواردة" realtime.
- [ ] القبول يحجز المنتجات، ويرفض العروض المنافسة، ويفتح شات فيه بانر citrus وكارت التفاصيل.
- [ ] الرسائل realtime، و ✓✓ تتلون عند القراءة، و badge غير المقروء على تاب رسائلي.
- [ ] زر الاتصال يفتح رقم الطرف الآخر بعد القبول فقط.
- [ ] الإتمام يغيّر الحالات (تم التبديل/تم البيع) ويزوّد عداد التبديلات، والتقييم يحدّث متوسط البروفايل.
- [ ] الإلغاء بعد القبول يرجّع المنتجات "متاح".
- [ ] كل القوائم فيها loading و empty و error states، ومفيش overflow في RTL أو LTR على شاشة 360px.
- [ ] كل الشاشات المصممة مطابقة لصورها في `design/`.
