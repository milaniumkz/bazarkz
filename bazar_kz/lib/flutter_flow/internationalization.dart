import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ['ru', 'kk', 'en'];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? '${locale.toString()}_short'
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? ruText = '',
    String? kkText = '',
    String? enText = '',
  }) =>
      [ruText, kkText, enText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
  };
}

/// Used if the locale is not supported by GlobalMaterialLocalizations.
class FallbackMaterialLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<MaterialLocalizations> load(Locale locale) async =>
      SynchronousFuture<MaterialLocalizations>(
        const DefaultMaterialLocalizations(),
      );

  @override
  bool shouldReload(FallbackMaterialLocalizationDelegate old) => false;
}

/// Used if the locale is not supported by GlobalCupertinoLocalizations.
class FallbackCupertinoLocalizationDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture<CupertinoLocalizations>(
        const DefaultCupertinoLocalizations(),
      );

  @override
  bool shouldReload(FallbackCupertinoLocalizationDelegate old) => false;
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

bool _isSupportedLocale(Locale locale) {
  final language = locale.toString();
  return FFLocalizations.languages().contains(
    language.endsWith('_')
        ? language.substring(0, language.length - 1)
        : language,
  );
}

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // login
  {
    '8knxa9jp': {
      'ru': 'Войти',
      'en': 'Login',
      'kk': 'Жүйеге кіру',
    },
    '4tll898q': {
      'ru': 'Ваш номер телефона',
      'en': 'Your phone number',
      'kk': 'Сіздің телефон нөміріңіз',
    },
    'y8keketp': {
      'ru': 'Войти',
      'en': 'Login',
      'kk': 'Жүйеге кіру',
    },
    'n4qimib6': {
      'ru': 'Использую приложение вы соглашаетесь с  ',
      'en': 'By using the application you agree to',
      'kk': 'Қолданбаны пайдалану арқылы сіз келісесіз',
    },
    'avz24mom': {
      'ru': 'Правилами сервиса',
      'en': 'Service rules',
      'kk': 'Қызмет көрсету ережелері',
    },
    '3s8c1qc2': {
      'ru': 'Home',
      'en': 'Home',
      'kk': 'Үй',
    },
  },
  // home
  {
    '9z5txsuv': {
      'ru': 'Поиск',
      'en': 'Search',
      'kk': 'Іздеу',
    },
    '5m0lann0': {
      'ru': 'Главная',
      'en': 'Home',
      'kk': 'Үй',
    },
  },
  // selectLang
  {
    'mz9mkbc5': {
      'ru': 'Казахский язык',
      'en': 'Kazakh language',
      'kk': 'Қазақ тілі',
    },
    '46oq6owk': {
      'ru': 'Русский язык',
      'en': 'Russian language',
      'kk': 'орыс тілі',
    },
    '38be4dnl': {
      'ru': 'Английский язык',
      'en': 'English language',
      'kk': 'Ағылшын тілі',
    },
    '5f9ryjwq': {
      'ru': 'Home',
      'en': 'Home',
      'kk': 'Үй',
    },
  },
  // cart
  {
    'usivfaij': {
      'ru': 'Удалить',
      'en': '',
      'kk': '',
    },
    's6tdic80': {
      'ru': 'ИТОГО:',
      'en': '',
      'kk': '',
    },
    'm887wc6b': {
      'ru': 'Оформить заказ',
      'en': '',
      'kk': '',
    },
    'fq7iva6t': {
      'ru': 'Корзина',
      'en': '',
      'kk': '',
    },
    'm5q5yn6l': {
      'ru': 'QR',
      'en': 'QR',
      'kk': 'QR',
    },
  },
  // profile
  {
    '205whkl0': {
      'ru': 'Личный кабинет',
      'en': 'Personal account',
      'kk': 'Жеке кабинет',
    },
    'ec7ik0le': {
      'ru': 'Настройка уведомлений',
      'en': 'Setting up notifications',
      'kk': 'Хабарландыруларды орнату',
    },
    'pa51imj2': {
      'ru': 'Редактировать профиль',
      'en': 'Edit profile',
      'kk': 'Профильді өңдеу',
    },
    '02w5x49j': {
      'ru': 'Язык',
      'en': 'Language',
      'kk': 'Тіл',
    },
    'c8nhw6vn': {
      'ru': 'Выход',
      'en': 'Exit',
      'kk': 'Шығу',
    },
    'exy4kndl': {
      'ru': 'Удалить аккаунт',
      'en': 'Delete account',
      'kk': 'Есептік жазбаны жою',
    },
    '4vg24hrd': {
      'ru': 'Поддержка',
      'en': 'Support',
      'kk': 'Қолдау',
    },
    '2nsy3b2h': {
      'ru': 'Whats\'app',
      'en': 'Whats\'app',
      'kk': 'Whats\'app',
    },
    '43ig2wu1': {
      'ru': 'Telegram',
      'en': 'Telegram',
      'kk': 'Telegram',
    },
    'jxuy2o6a': {
      'ru': 'Instagram ',
      'en': 'Instagram',
      'kk': 'Instagram',
    },
    'hkzilgff': {
      'ru': 'Профиль',
      'en': 'Profile',
      'kk': 'Профиль',
    },
  },
  // smsVerification
  {
    'xskgiw1g': {
      'ru': 'Пароль',
      'en': 'Password',
      'kk': 'Құпия сөз',
    },
    'ehz3wxh2': {
      'ru': 'Укажите свой пароль от аккаунта',
      'en': 'Please enter your account password',
      'kk': 'Тіркелгіңіздің құпия сөзін енгізіңіз',
    },
    'qd02iuwp': {
      'ru': 'Пароль',
      'en': 'Password',
      'kk': 'Құпия сөз',
    },
    'ws4ovo21': {
      'ru': 'Войти',
      'en': 'Login',
      'kk': 'Жүйеге кіру',
    },
    'z7pvmr6t': {
      'ru': 'Home',
      'en': 'Home',
      'kk': 'Үй',
    },
  },
  // CreateProfile
  {
    'vfexvh5n': {
      'ru': 'Ваше ФИО',
      'en': 'Your full name',
      'kk': 'Толық аты-жөніңіз',
    },
    'twhjmz53': {
      'ru': 'Пароль',
      'en': 'Password',
      'kk': 'Құпия сөз',
    },
    '6mtn21sb': {
      'ru': 'Повторите Пароль',
      'en': 'Repeat password',
      'kk': 'Құпия сөзді қайталаңыз',
    },
    'pbcyx0jd': {
      'ru': 'Город',
      'en': 'City',
      'kk': 'Қала',
    },
    's3blkpw1': {
      'ru': 'Выберите город',
      'en': 'Select city',
      'kk': 'Қаланы таңдаңыз',
    },
    'c70g9pw2': {
      'ru': 'Сохранить',
      'en': 'Save',
      'kk': 'Сақтау',
    },
    '0gzglqyx': {
      'ru': 'Создайте профиль',
      'en': 'Create a profile',
      'kk': 'Профиль жасау',
    },
  },
  // favorites
  {
    '3uyr5c1d': {
      'ru': 'Избранные',
      'en': 'The Chosen Ones',
      'kk': 'Таңдалғандар',
    },
    '22yqo165': {
      'ru': 'Избранное',
      'en': 'Featured',
      'kk': 'Таңдаулы',
    },
  },
  // history
  {
    'z9n57mz9': {
      'ru': 'История',
      'en': 'Story',
      'kk': 'Әңгіме',
    },
    't2ib61wz': {
      'ru': 'История',
      'en': 'Story',
      'kk': 'Әңгіме',
    },
  },
  // podSale
  {
    'hwbr9feu': {
      'ru': 'Инфо',
      'en': 'Info',
      'kk': 'Ақпарат',
    },
    'ldszn3u5': {
      'ru': 'Товары',
      'en': 'Goods',
      'kk': 'Тауарлар',
    },
    'pk611ovs': {
      'ru': 'Добавить в корзину',
      'en': '',
      'kk': '',
    },
    'c5ybuqcw': {
      'ru': 'Home',
      'en': 'Home',
      'kk': 'Үй',
    },
  },
  // Sale
  {
    'dtxnxn9n': {
      'ru': 'Главная',
      'en': 'Home',
      'kk': 'Үй',
    },
  },
  // katPage
  {
    'r7nougbu': {
      'ru': 'Главная',
      'en': 'Home',
      'kk': 'Үй',
    },
    'hbbobp7h': {
      'ru': 'Выберите город',
      'en': 'Select city',
      'kk': 'Қаланы таңдаңыз',
    },
  },
  // order
  {
    '9d7stdem': {
      'ru': 'Оформление заказа',
      'en': '',
      'kk': '',
    },
    'hu8jbatb': {
      'ru': 'Ваш адрес',
      'en': '',
      'kk': '',
    },
    'knwj7afn': {
      'ru': 'Ваш адрес',
      'en': '',
      'kk': '',
    },
    'vtn0rwbw': {
      'ru': 'ИТОГО: ',
      'en': '',
      'kk': '',
    },
    '754cirls': {
      'ru': 'Оформить заказ',
      'en': '',
      'kk': '',
    },
    'qswhhsh5': {
      'ru': 'Home',
      'en': '',
      'kk': '',
    },
  },
  // payments
  {
    '4wo69zw1': {
      'ru': 'Перенаправление в магазин......',
      'en': '',
      'kk': '',
    },
    'fqf340jh': {
      'ru': 'Home',
      'en': '',
      'kk': '',
    },
  },
  // SelectCity
  {
    'eeay1ft9': {
      'ru': 'Выберите город',
      'en': 'Select city',
      'kk': 'Қаланы таңдаңыз',
    },
    'botejy4z': {
      'ru': 'Search for an item...',
      'en': 'Search for an item...',
      'kk': 'Элементті іздеу...',
    },
    '4iku2usl': {
      'ru': 'Option 1',
      'en': 'Option 1',
      'kk': '1-нұсқа',
    },
  },
  // uslovia
  {
    'xbac9ioe': {
      'ru': 'Правила сервиса',
      'en': 'Service rules',
      'kk': 'Қызмет көрсету ережелері',
    },
  },
  // navbar
  {
    'ak3jxbr2': {
      'ru': 'Главная',
      'en': 'Home',
      'kk': 'Үй',
    },
    't40xa0ey': {
      'ru': 'Главная',
      'en': 'Home',
      'kk': 'Үй',
    },
    'jtu2sygx': {
      'ru': 'Избранное',
      'en': 'Featured',
      'kk': 'Таңдаулы',
    },
    'fclo3f34': {
      'ru': 'Избранное',
      'en': 'Featured',
      'kk': 'Таңдаулы',
    },
    's3e408mi': {
      'ru': 'История',
      'en': 'Story',
      'kk': 'Әңгіме',
    },
    '4xiy52b9': {
      'ru': 'История',
      'en': 'Story',
      'kk': 'Әңгіме',
    },
    'cn3w22bi': {
      'ru': 'Профиль',
      'en': 'Profile',
      'kk': 'Профиль',
    },
    'cvl02lrb': {
      'ru': 'Профиль',
      'en': 'Profile',
      'kk': 'Профиль',
    },
  },
  // lang
  {
    'fzr9bbgt': {
      'ru': 'Казахский язык',
      'en': 'Kazakh language',
      'kk': 'Қазақ тілі',
    },
    '4r60s6t7': {
      'ru': 'Русский язык',
      'en': 'Russian language',
      'kk': 'орыс тілі',
    },
    'rjjbhr1o': {
      'ru': 'Английский язык',
      'en': 'English language',
      'kk': 'Ағылшын тілі',
    },
  },
  // SelectSrok
  {
    'w0n7asse': {
      'ru': 'Выберите срок',
      'en': 'Select a term',
      'kk': 'Терминді таңдаңыз',
    },
    '5bx2zoaw': {
      'ru': 'Search for an item...',
      'en': 'Search for an item...',
      'kk': 'Элементті іздеу...',
    },
    '5ci46023': {
      'ru': '1 месяц',
      'en': '1 month',
      'kk': '1 ай',
    },
    'r3n8k7xs': {
      'ru': '3 месяца',
      'en': '3 months',
      'kk': '3 ай',
    },
    'jjfii7mm': {
      'ru': '6 месяцев',
      'en': '6 months',
      'kk': '6 ай',
    },
    'cv7xbivc': {
      'ru': '1 год',
      'en': '1 year',
      'kk': '1 жыл',
    },
  },
  // Miscellaneous
  {
    'cqih1kyi': {
      'ru': 'Загрузка фото',
      'en': 'Uploading photo',
      'kk': 'Фото жүктеп салынуда',
    },
    '5ev2rvvc': {
      'ru': 'Загрузка фото',
      'en': 'Uploading photo',
      'kk': 'Фото жүктеп салынуда',
    },
    'msvreiry': {
      'ru': 'Защита ваших данных',
      'en': 'Protecting your data',
      'kk': 'Деректеріңізді қорғау',
    },
    'nb2vm73s': {
      'ru': '',
      'en': '',
      'kk': '',
    },
    'swn60l3u': {
      'ru': '',
      'en': '',
      'kk': '',
    },
    'nz4k0vcw': {
      'ru': 'Для сканирования qr кодов',
      'en': 'For scanning qr codes',
      'kk': 'Qr кодтарын сканерлеуге арналған',
    },
    'vg795dyd': {
      'ru': 'Получайте увеломление о новых акциях',
      'en': 'Receive notifications about new promotions',
      'kk': 'Жаңа акциялар туралы хабарландырулар алыңыз',
    },
    '9fjja8o4': {
      'ru': '',
      'en': '',
      'kk': '',
    },
    'eif2gcg2': {
      'ru': '',
      'en': '',
      'kk': '',
    },
    'vbio2i1l': {
      'ru': '',
      'en': '',
      'kk': '',
    },
    'fja76ms4': {
      'ru': '',
      'en': '',
      'kk': '',
    },
    'boecwlb8': {
      'ru': '',
      'en': '',
      'kk': '',
    },
    'vmocywzu': {
      'ru': '',
      'en': '',
      'kk': '',
    },
    'pu3gm2p1': {
      'ru': '',
      'en': '',
      'kk': '',
    },
    'jrlvzu8r': {
      'ru': '',
      'en': '',
      'kk': '',
    },
    'dd6g6sq3': {
      'ru': '',
      'en': '',
      'kk': '',
    },
    'kiffj6yy': {
      'ru': '',
      'en': '',
      'kk': '',
    },
    'rhqhx9o1': {
      'ru': '',
      'en': '',
      'kk': '',
    },
    'brhi97uz': {
      'ru': 'Неверный формат',
      'en': 'Invalid format',
      'kk': 'Жарамсыз пішім',
    },
    'qc55on0n': {
      'ru': 'Загрузка файла',
      'en': 'Uploading file',
      'kk': 'Файл жүктелуде',
    },
    'pcdru2wu': {
      'ru': 'Успешно',
      'en': 'Successfully',
      'kk': 'Сәтті',
    },
    '054c502n': {
      'ru': 'Ошибка загрузки файла',
      'en': 'File upload error',
      'kk': 'Файлды жүктеп салу қатесі',
    },
    'i1kmov0p': {
      'ru': '',
      'en': '',
      'kk': '',
    },
    'tna6c9nu': {
      'ru': 'Выберите источник',
      'en': 'Select source',
      'kk': 'Дереккөзді таңдаңыз',
    },
    'zbyxhyl7': {
      'ru': 'Галерея',
      'en': 'Gallery',
      'kk': 'Галерея',
    },
    '55i4d5iv': {
      'ru': '',
      'en': '',
      'kk': '',
    },
    'l521b6cr': {
      'ru': '',
      'en': '',
      'kk': '',
    },
    'b0nyrs8c': {
      'ru': 'Камера',
      'en': 'Camera',
      'kk': 'Камера',
    },
    'kpgjarp2': {
      'ru': '',
      'en': '',
      'kk': '',
    },
    'sljtk486': {
      'ru': '',
      'en': '',
      'kk': '',
    },
    'fd4myymn': {
      'ru': '',
      'en': '',
      'kk': '',
    },
    'eav5fxos': {
      'ru': '',
      'en': '',
      'kk': '',
    },
  },
].reduce((a, b) => a..addAll(b));
