// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'كاشف التلوث الضوئي';

  @override
  String get sura => 'سُرى';

  @override
  String get welcomeBack => 'مرحبًا بعودتك';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ ';

  @override
  String get signUpLink => 'سجّل الآن';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ ';

  @override
  String get loginLink => 'تسجيل الدخول';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get joinCommunity => 'انضم لمجتمع مراقبة النجوم';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get enterEmail => 'أدخل بريدك الإلكتروني';

  @override
  String get enterValidEmail => 'أدخل بريدًا إلكترونيًا صحيحًا';

  @override
  String get enterPassword => 'أدخل كلمة المرور';

  @override
  String get enterAPassword => 'أدخل كلمة المرور';

  @override
  String get enterName => 'أدخل اسمك';

  @override
  String get chooseUsername => 'اختر اسم مستخدم';

  @override
  String get usernameTooShort => 'يجب أن يكون اسم المستخدم ٣ أحرف على الأقل';

  @override
  String get passwordTooShort => 'يجب أن تكون كلمة المرور ٦ أحرف على الأقل';

  @override
  String get errorNoAccount => 'لم يتم العثور على حساب بهذا البريد الإلكتروني.';

  @override
  String get errorWrongPassword =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get errorInvalidEmail => 'يرجى إدخال بريد إلكتروني صحيح.';

  @override
  String get errorTooManyRequests => 'محاولات كثيرة. حاول مرة أخرى لاحقًا.';

  @override
  String get errorLoginFailed => 'فشل تسجيل الدخول. حاول مرة أخرى.';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get resetPasswordDesc =>
      'أدخل بريدك الإلكتروني وسنرسل لك رابطًا لإعادة تعيين كلمة المرور.';

  @override
  String get sendResetLink => 'إرسال رابط الإعادة';

  @override
  String get checkYourEmail => 'تحقق من بريدك';

  @override
  String get resetEmailSentTo => 'أرسلنا رابط إعادة تعيين كلمة المرور إلى';

  @override
  String get resetEmailInstructions =>
      'افتح البريد واضغط على الرابط لتعيين كلمة مرور جديدة. ثم عد وسجّل الدخول.';

  @override
  String get backToLogin => 'العودة لتسجيل الدخول';

  @override
  String get didntGetEmail => 'لم يصلك البريد؟ ';

  @override
  String get resend => 'إعادة الإرسال';

  @override
  String get resetPasswordFailed =>
      'فشل إرسال رابط الإعادة. تحقق من بريدك الإلكتروني.';

  @override
  String get errorEmailInUse => 'هذا البريد الإلكتروني مسجّل بالفعل.';

  @override
  String get errorWeakPassword => 'يجب أن تكون كلمة المرور ٦ أحرف على الأقل.';

  @override
  String get errorSignUpFailed => 'فشل إنشاء الحساب. حاول مرة أخرى.';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navSearch => 'بحث';

  @override
  String get navCamera => 'الكاميرا';

  @override
  String get navMap => 'الخريطة';

  @override
  String get navReserve => 'الحجز';

  @override
  String get navChat => 'المحادثة';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get premium => 'بريميوم';

  @override
  String get bookmarks => 'المحفوظات';

  @override
  String get lists => 'القوائم';

  @override
  String get communities => 'المجتمعات';

  @override
  String get myReservations => 'رحلاتي';

  @override
  String get settingsPrivacy => 'الإعدادات والخصوصية';

  @override
  String get helpCenter => 'مركز المساعدة';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get language => 'اللغة';

  @override
  String get failedToLoadPosts => 'فشل تحميل المنشورات.';

  @override
  String get noPostsYet => 'لا توجد منشورات بعد. كن أول من يشارك!';

  @override
  String get cancel => 'إلغاء';

  @override
  String get post => 'نشر';

  @override
  String get whatsHappening => 'ماذا يحدث؟';

  @override
  String get everyoneCanReply => 'الجميع يمكنه الرد';

  @override
  String get deletePost => 'حذف المنشور';

  @override
  String failedToPost(String error) {
    return 'فشل النشر: $error';
  }

  @override
  String get comments => 'التعليقات';

  @override
  String get noCommentsYet => 'لا توجد تعليقات بعد';

  @override
  String get addComment => 'أضف تعليقًا...';

  @override
  String get posts => 'المنشورات';

  @override
  String get repliesTab => 'الردود';

  @override
  String get photos => 'الصور';

  @override
  String get likesTab => 'الإعجابات';

  @override
  String get noPostsYetSimple => 'لا توجد منشورات بعد';

  @override
  String get noRepliesYet => 'لا توجد ردود بعد';

  @override
  String get noPhotosYet => 'لا توجد صور بعد';

  @override
  String get noLikesYet => 'لا توجد إعجابات بعد';

  @override
  String get loadingText => 'جارٍ التحميل...';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get save => 'حفظ';

  @override
  String get nameLabel => 'الاسم';

  @override
  String get bioLabel => 'النبذة';

  @override
  String get locationLabel => 'الموقع';

  @override
  String get websiteLabel => 'الموقع الإلكتروني';

  @override
  String get addWebsite => 'أضف موقعك الإلكتروني';

  @override
  String get birthDate => 'تاريخ الميلاد';

  @override
  String get addBirthDate => 'أضف تاريخ ميلادك';

  @override
  String get switchToProfessional => 'التحويل إلى حساب احترافي';

  @override
  String get takeAPhoto => 'التقط صورة';

  @override
  String get chooseFromGallery => 'اختر من المعرض';

  @override
  String failedToSave(String error) {
    return 'فشل الحفظ: $error';
  }

  @override
  String get pollutionDetection => 'كشف التلوث الضوئي';

  @override
  String get takeOrUploadPhoto =>
      'التقط أو ارفع صورة للسماء الليلية\nلكشف مستوى التلوث الضوئي';

  @override
  String get photoButton => 'صورة';

  @override
  String get analyzing => 'جارٍ التحليل...';

  @override
  String get analysisFailed => 'فشل التحليل';

  @override
  String get unknownError => 'خطأ غير معروف';

  @override
  String get reExamine => 'إعادة الفحص';

  @override
  String get skyQualityLabel => 'جودة السماء:';

  @override
  String get details => 'التفاصيل';

  @override
  String bortleValue(int value) {
    return 'بورتل $value';
  }

  @override
  String get aiModelScore => 'نتيجة نموذج الذكاء الاصطناعي';

  @override
  String get pixelAnalysisScore => 'نتيجة تحليل البكسل';

  @override
  String get meanBrightness => 'متوسط السطوع';

  @override
  String get brightPixels => 'البكسل المضيء';

  @override
  String get darkPixels => 'البكسل المظلم';

  @override
  String get blueRatio => 'نسبة الأزرق';

  @override
  String get orangeRatio => 'نسبة البرتقالي';

  @override
  String get brightnessDistribution => 'توزيع السطوع';

  @override
  String get dark => 'مظلم';

  @override
  String get bright => 'مضيء';

  @override
  String get explore => 'استكشاف';

  @override
  String get toggleLegend => 'إظهار/إخفاء الدليل';

  @override
  String get lightPollutionOverlay => 'طبقة التلوث الضوئي';

  @override
  String get opacity => 'الشفافية';

  @override
  String get yearLabel => 'السنة: ';

  @override
  String get bortleScale => 'مقياس بورتل';

  @override
  String get searchLocation => 'ابحث عن موقع...';

  @override
  String get tapLocation => 'اضغط على موقع في الخريطة';

  @override
  String get orSearchCity => 'أو ابحث عن مدينة أعلاه';

  @override
  String get someDataFailed =>
      'تعذر تحميل بعض البيانات. عرض المعلومات المتاحة.';

  @override
  String get stargazingScore => 'تقييم رصد النجوم';

  @override
  String get outOf100 => 'من ١٠٠';

  @override
  String get excellent => 'ممتاز';

  @override
  String get good => 'جيد';

  @override
  String get fair => 'مقبول';

  @override
  String get poor => 'ضعيف';

  @override
  String get veryPoor => 'ضعيف جدًا';

  @override
  String get clouds => 'السحب';

  @override
  String get moon => 'القمر';

  @override
  String get bortle => 'بورتل';

  @override
  String get skyPhotoAnalyzer => 'محلل صور السماء';

  @override
  String get uploadSkyPhoto => 'ارفع صورة للسماء';

  @override
  String get tapToSelect => 'اضغط للاختيار من المعرض';

  @override
  String get skyQuality => 'جودة السماء';

  @override
  String get avgBrightness => 'متوسط السطوع';

  @override
  String get warmGlow => 'التوهج الدافئ';

  @override
  String get skyColor => 'لون السماء: ';

  @override
  String get analyzeAnotherPhoto => 'تحليل صورة أخرى';

  @override
  String get lightPollutionBortle => 'التلوث الضوئي (مقياس بورتل)';

  @override
  String classLabel(int value, String name) {
    return 'الفئة $value — $name';
  }

  @override
  String get currentWeather => 'الطقس الحالي';

  @override
  String get cloudCover => 'الغطاء السحابي';

  @override
  String get humidity => 'الرطوبة';

  @override
  String get wind => 'الرياح';

  @override
  String get cloudCover24h => 'الغطاء السحابي (٢٤ ساعة)';

  @override
  String get sunTwilight => 'الشمس والشفق';

  @override
  String dayDuration(String duration) {
    return 'النهار: $duration';
  }

  @override
  String nightDuration(String duration) {
    return 'الليل: $duration';
  }

  @override
  String get sunrise => 'شروق الشمس';

  @override
  String get solarNoon => 'منتصف النهار';

  @override
  String get sunset => 'غروب الشمس';

  @override
  String get civilTwilightEnd => 'نهاية الشفق المدني';

  @override
  String get nauticalTwilightEnd => 'نهاية الشفق البحري';

  @override
  String get astroTwilightEnd => 'نهاية الشفق الفلكي';

  @override
  String get moonPhase => 'طور القمر';

  @override
  String illuminated(int percent) {
    return 'مضاء $percent%';
  }

  @override
  String get impact => 'التأثير';

  @override
  String get ageLabel => 'العمر';

  @override
  String daysValue(String value) {
    return '$value يوم';
  }

  @override
  String get visiblePlanets => 'الكواكب المرئية';

  @override
  String get visible => 'مرئي';

  @override
  String get hidden => 'مخفي';

  @override
  String get mapLegendRadiance => 'دليل الخريطة — الإشعاع';

  @override
  String get low => 'منخفض';

  @override
  String get high => 'مرتفع';

  @override
  String get comingSoon => 'قريبًا';

  @override
  String underDevelopment(String title) {
    return '$title قيد التطوير';
  }

  @override
  String get bortleClass1Name => 'سماء مظلمة ممتازة';

  @override
  String get bortleClass1Desc =>
      'درب التبانة يلقي بظلاله. الضوء البروجي والوهج المعاكس مرئيان.';

  @override
  String get bortleClass2Name => 'سماء مظلمة نموذجية';

  @override
  String get bortleClass2Desc =>
      'درب التبانة منظّم بشكل كبير. الضوء البروجي ساطع.';

  @override
  String get bortleClass3Name => 'سماء ريفية';

  @override
  String get bortleClass3Desc =>
      'درب التبانة لا يزال يبدو معقدًا. بعض التلوث الضوئي في الأفق.';

  @override
  String get bortleClass4Name => 'انتقالي ريفي/ضواحي';

  @override
  String get bortleClass4Desc =>
      'درب التبانة مرئي لكن يفتقر للتفاصيل. قباب الضوء مرئية.';

  @override
  String get bortleClass5Name => 'سماء الضواحي';

  @override
  String get bortleClass5Desc =>
      'درب التبانة ضعيف أو غير مرئي بالقرب من الأفق. قباب الضوء بارزة.';

  @override
  String get bortleClass6Name => 'سماء ضواحي مضيئة';

  @override
  String get bortleClass6Desc =>
      'درب التبانة مرئي فقط بالقرب من السمت. توهج السماء على كامل الأفق.';

  @override
  String get bortleClass7Name => 'انتقالي ضواحي/حضري';

  @override
  String get bortleClass7Desc =>
      'درب التبانة غير مرئي. السماء لها لون رمادي أبيض باهت.';

  @override
  String get bortleClass8Name => 'سماء المدينة';

  @override
  String get bortleClass8Desc =>
      'السماء تتوهج بالأبيض أو البرتقالي. فقط الأبراج الساطعة مرئية.';

  @override
  String get bortleClass9Name => 'سماء وسط المدينة';

  @override
  String get bortleClass9Desc =>
      'فقط القمر والكواكب وبعض النجوم الساطعة مرئية.';

  @override
  String get pristineDarkSky => 'سماء مظلمة نقية';

  @override
  String get darkSky => 'سماء مظلمة';

  @override
  String get ruralSky => 'سماء ريفية';

  @override
  String get suburbanSky => 'سماء ضواحي';

  @override
  String get brightSuburban => 'ضواحي مضيئة';

  @override
  String get urbanSky => 'سماء حضرية';

  @override
  String get innerCitySky => 'سماء وسط المدينة';

  @override
  String get cloudyOvercast => 'غائم / ملبد بالغيوم';

  @override
  String get impactMinimal => 'طفيف';

  @override
  String get impactLow => 'منخفض';

  @override
  String get impactModerate => 'متوسط';

  @override
  String get impactHigh => 'مرتفع';

  @override
  String get impactSevere => 'شديد';

  @override
  String get impactDescExcellent => 'ممتاز لرصد النجوم';

  @override
  String get impactDescGood => 'ظروف جيدة';

  @override
  String get impactDescSome => 'بعض سطوع السماء';

  @override
  String get impactDescFaint => 'الأجرام الخافتة غير مرئية';

  @override
  String get impactDescBright => 'ضوء القمر الساطع يحد من الرؤية';

  @override
  String get veryBright => 'ساطع جدًا';

  @override
  String get brightLabel => 'ساطع';

  @override
  String get moderate => 'متوسط';

  @override
  String get dim => 'خافت';

  @override
  String get faint => 'باهت';

  @override
  String get reserveTitle => 'احجز رحلة';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterUpcoming => 'القادمة';

  @override
  String get filterPopular => 'الأكثر شعبية';

  @override
  String get guidedBy => 'بإرشاد';

  @override
  String get rating => 'التقييم';

  @override
  String get bortleClassLabel => 'فئة بورتل';

  @override
  String get groupSize => 'حجم المجموعة';

  @override
  String get spotsLeftLabel => 'أماكن متبقية';

  @override
  String durationHours(int count) {
    return '$count ساعات';
  }

  @override
  String get bookNow => 'احجز الآن';

  @override
  String get aboutTrip => 'عن هذه الرحلة';

  @override
  String get whatsIncluded => 'ماذا يشمل';

  @override
  String get perPerson => 'للشخص';

  @override
  String get noTripsAvailable => 'لا توجد رحلات متاحة';

  @override
  String get tripBooked => 'تم الحجز';

  @override
  String get tripBookedMsg => 'تم حجز الرحلة بنجاح!';

  @override
  String get createTrip => 'إنشاء رحلة';

  @override
  String get tripTitle => 'عنوان الرحلة';

  @override
  String get tripTitleHint => 'مثال: ليلة تصوير درب التبانة';

  @override
  String get tripLocationHint => 'مثال: العلا، السعودية';

  @override
  String get tripDate => 'التاريخ';

  @override
  String get selectDate => 'اختر تاريخًا';

  @override
  String get duration => 'المدة';

  @override
  String get hours => 'ساعات';

  @override
  String get price => 'السعر';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get addItemHint => 'أضف عنصرًا...';

  @override
  String get tripCreated => 'تم نشر الرحلة بنجاح!';

  @override
  String get darkSkySite => 'موقع سماء مظلمة';

  @override
  String get reserveTrip => 'احجز';

  @override
  String get certifiedDarkSky => 'سماء مظلمة معتمدة';

  @override
  String bortleClassInfo(int value, String certification) {
    return 'بورتل $value — $certification';
  }

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get premiumTitle => 'سُرى بريميوم';

  @override
  String get premiumSubtitle => 'لعشّاق الفلك والتصوير الفلكي المتميّزين';

  @override
  String get premiumFeatureTrips => 'إنشاء ونشر الرحلات';

  @override
  String get premiumFeatureTripsDesc =>
      'أنشئ رحلات رصد نجوم وشاركها مع المجتمع';

  @override
  String get premiumFeatureBadge => 'شارة بريميوم';

  @override
  String get premiumFeatureBadgeDesc =>
      'تميّز بشارة نجمة بريميوم على ملفك الشخصي';

  @override
  String get premiumFeaturePriority => 'أولوية الحجز';

  @override
  String get premiumFeaturePriorityDesc => 'احصل على وصول مبكر للرحلات الشائعة';

  @override
  String get premiumFeatureAnalysis => 'تحليل متقدم';

  @override
  String get premiumFeatureAnalysisDesc =>
      'افتح تقارير جودة السماء المفصلة بالذكاء الاصطناعي';

  @override
  String get premiumCriteriaTitle => 'كيف تصبح بريميوم';

  @override
  String get premiumCriteria1 => 'اهتمام نشط بالفلك والتصوير الفلكي';

  @override
  String get premiumCriteria2 => 'نشر منتظم لصور السماء ومواقع رصد النجوم';

  @override
  String get premiumCriteria3 => 'حضور مجتمعي قوي مع متابعين متفاعلين';

  @override
  String get applyForPremium => 'تقدّم لبريميوم';

  @override
  String get premiumApplied => 'تم إرسال الطلب! سنراجع ملفك الشخصي.';

  @override
  String get premiumAlreadyActive => 'أنت عضو بريميوم!';

  @override
  String get premiumApplicationFailed => 'فشل الطلب. حاول مرة أخرى.';

  @override
  String get premiumMemberSince => 'عضو بريميوم';

  @override
  String get premiumYourBenefits => 'مزاياك';

  @override
  String get myTripsTitle => 'رحلاتي';

  @override
  String get noBookedTrips => 'لا توجد رحلات محجوزة بعد';

  @override
  String get noBookedTripsDesc => 'الرحلات التي تحجزها ستظهر هنا';

  @override
  String get pickFromMap => 'اختر من الخريطة';

  @override
  String get confirmLocation => 'تأكيد الموقع';

  @override
  String get changeCoverImage => 'تغيير صورة الغلاف';

  @override
  String get uploadingImage => 'جارٍ رفع الصورة...';

  @override
  String get verdictExcellent =>
      'ممتاز لرصد النجوم! درب التبانة يجب أن يكون مرئيًا.';

  @override
  String get verdictGood => 'جيد لرصد النجوم. العديد من النجوم والأبراج مرئية.';

  @override
  String get verdictDecent =>
      'مقبول لرصد النجوم. النجوم الساطعة والكواكب مرئية.';

  @override
  String get verdictPoor => 'ضعيف لرصد النجوم. فقط ألمع النجوم مرئية.';

  @override
  String get verdictVeryPoor =>
      'ضعيف جدًا لرصد النجوم. فقط عدد قليل من النجوم مرئية.';

  @override
  String get verdictNotSuitable => 'غير مناسب لرصد النجوم. تلوث ضوئي شديد.';

  @override
  String get verdictCloudy =>
      'غير مناسب لرصد النجوم. السماء غائمة أو ملبدة بالغيوم.';

  @override
  String get searchHint => 'ابحث عن مستخدمين، منشورات، مواقع...';

  @override
  String get people => 'الأشخاص';

  @override
  String get noUsersFound => 'لم يتم العثور على مستخدمين';

  @override
  String get noPostsFound => 'لم يتم العثور على منشورات';

  @override
  String get trendingNow => 'الأكثر رواجاً';

  @override
  String get astronomyNews => 'أخبار الفلك';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get trendingTopics => 'المواضيع الرائجة';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get account => 'الحساب';

  @override
  String get accountInfo => 'معلومات الحساب';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get pushNotifications => 'إشعارات الدفع';

  @override
  String get emailNotifications => 'إشعارات البريد الإلكتروني';

  @override
  String get privacy => 'الخصوصية';

  @override
  String get privateAccount => 'حساب خاص';

  @override
  String get privateAccountDesc =>
      'فقط المتابعون المعتمدون يمكنهم رؤية منشوراتك';

  @override
  String get showOnlineStatus => 'إظهار حالة الاتصال';

  @override
  String get allowMessages => 'السماح بالرسائل من الجميع';

  @override
  String get display => 'العرض';

  @override
  String get appearance => 'المظهر';

  @override
  String get appearanceDesc => 'فاتح، داكن، أو حسب النظام';

  @override
  String get appVersion => 'إصدار التطبيق';

  @override
  String get about => 'حول';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get openSourceLicenses => 'تراخيص المصادر المفتوحة';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get deleteAccountWarning =>
      'سيتم حذف حسابك وجميع بياناتك نهائياً. لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get dangerZone => 'منطقة الخطر';

  @override
  String get bookmarksTitle => 'المحفوظات';

  @override
  String get noBookmarks => 'لا توجد محفوظات بعد';

  @override
  String get noBookmarksDesc => 'المنشورات التي تحفظها ستظهر هنا';

  @override
  String get removeBookmark => 'تم إزالة الحفظ';

  @override
  String get sharePost => 'مشاركة المنشور';

  @override
  String get repost => 'إعادة نشر';

  @override
  String get bookingFailed => 'فشل الحجز. حاول مرة أخرى.';

  @override
  String get tripFull => 'هذه الرحلة محجوزة بالكامل.';

  @override
  String get alreadyBooked => 'لقد حجزت هذه الرحلة بالفعل.';

  @override
  String get chatSettingsComingSoon => 'إعدادات المحادثة قريباً';

  @override
  String get startNewMessage => 'ابدأ رسالة جديدة';

  @override
  String get messagesTitle => 'الرسائل';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeSystem => 'حسب النظام';

  @override
  String get chooseTheme => 'اختر المظهر';

  @override
  String get privateAccountTitle => 'هذا الحساب خاص';

  @override
  String get privateAccountMessage =>
      'فقط المتابعون المعتمدون يمكنهم رؤية منشورات وتفاصيل هذا الحساب.';
}
