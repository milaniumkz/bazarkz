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

  String getText(String key) {
    final translations = kTranslationsMap[key] ?? {};
    final translated = translations[locale.languageCode];
    return translated != null && translated.isNotEmpty
        ? translated
        : translations['ru'] ?? '';
  }

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
    'ux6kjc5r': {
      'ru': 'Войдите в аккаунт',
      'en': 'Login to your account',
      'kk': 'Тіркелгіңізге кіріңіз',
    },
    '57l71rxf': {
      'ru': 'E-mail',
      'en': '',
      'kk': '',
    },
    'o6o51ny4': {
      'ru': 'Пароль',
      'en': '',
      'kk': '',
    },
    'wwb0p1mf': {
      'ru': 'Войти',
      'en': '',
      'kk': '',
    },
    'lo7aoubd': {
      'ru': 'Подать заявку',
      'en': '',
      'kk': '',
    },
    '79f11stz': {
      'ru': 'Забыли пароль?',
      'en': '',
      'kk': '',
    },
    '3s8c1qc2': {
      'ru': 'Home',
      'en': 'Home',
      'kk': 'Үй',
    },
  },
  // chat_2_Details
  {
    'dh8ec1yg': {
      'ru': 'Group Chat',
      'en': 'Group Chat',
      'kk': 'Топтық чат',
    },
    '1vusdce8': {
      'ru': 'Home',
      'en': 'Home',
      'kk': 'Үй',
    },
  },
  // chat_2_main
  {
    'rhgp63l3': {
      'ru': 'Group Chat',
      'en': 'Group Chat',
      'kk': 'Топтық чат',
    },
    '1a7tzmn3': {
      'ru': 'Мои Чаты',
      'en': 'My Chats',
      'kk': 'Менің чаттарым',
    },
    'ucz1ybwm': {
      'ru': 'Чат',
      'en': 'Chat',
      'kk': 'Чат',
    },
  },
  // chat_2_InviteUsers
  {
    '8rua5rdy': {
      'ru': 'Друзей',
      'en': 'Friends',
      'kk': 'Достар',
    },
    '72mf4k6b': {
      'ru': 'Выбрано',
      'en': 'Selected',
      'kk': 'Таңдалған',
    },
    'na5yq1jz': {
      'ru': 'Пригласить друзей',
      'en': 'Invite friends',
      'kk': 'Достарды шақыр',
    },
    'olp1amll': {
      'ru': 'Home',
      'en': 'Home',
      'kk': 'Үй',
    },
  },
  // image_Details
  {
    'olgvfe6o': {
      'ru': 'Home',
      'en': 'Home',
      'kk': 'Үй',
    },
  },
  // home
  {
    'dzwjtmyi': {
      'ru': 'Вывести',
      'en': '',
      'kk': '',
    },
    '565fan1l': {
      'ru': 'Товары',
      'en': '',
      'kk': '',
    },
    'sxuwz4yf': {
      'ru': 'Заказы',
      'en': '',
      'kk': '',
    },
    'e9b7ltdb': {
      'ru': 'Ваши магазины',
      'en': '',
      'kk': '',
    },
    'h6xhokua': {
      'ru': 'Home',
      'en': '',
      'kk': '',
    },
  },
  // QrCode
  {
    'm0zet4zo': {
      'ru': 'Заказы',
      'en': '',
      'kk': '',
    },
    '0oj39psm': {
      'ru': 'Home',
      'en': '',
      'kk': '',
    },
  },
  // sale
  {
    'uqsnhi69': {
      'ru': 'Выберите город',
      'en': '',
      'kk': '',
    },
    '75exxoyu': {
      'ru': 'Search for an item...',
      'en': '',
      'kk': '',
    },
    'wl941ejw': {
      'ru': 'Option 1',
      'en': '',
      'kk': '',
    },
    'qhgv9ew3': {
      'ru': 'Поиск',
      'en': '',
      'kk': '',
    },
    '5f7p0dyk': {
      'ru': 'Редактировать',
      'en': '',
      'kk': '',
    },
    '4li5xtbk': {
      'ru': 'Удалить',
      'en': '',
      'kk': '',
    },
    '7kctoct1': {
      'ru': 'Магазины',
      'en': '',
      'kk': '',
    },
    'oqnez4ax': {
      'ru': 'Home',
      'en': '',
      'kk': '',
    },
  },
  // addSale
  {
    'rzu8936i': {
      'ru': 'Загрузить логотип',
      'en': '',
      'kk': '',
    },
    '1kq9dkyy': {
      'ru': 'Фото',
      'en': '',
      'kk': '',
    },
    'kx6fde7r': {
      'ru': 'Наименование',
      'en': '',
      'kk': '',
    },
    'dxgz8x5m': {
      'ru': 'Адрес',
      'en': '',
      'kk': '',
    },
    'abt72ia1': {
      'ru': 'Телефон',
      'en': '',
      'kk': '',
    },
    'lrduytww': {
      'ru': 'Ссылка на Instagram',
      'en': '',
      'kk': '',
    },
    '6f8bdd8k': {
      'ru': 'Описание',
      'en': '',
      'kk': '',
    },
    'gweypdln': {
      'ru': 'Выберите город',
      'en': '',
      'kk': '',
    },
    '2ol3adt4': {
      'ru': 'Выберите город',
      'en': '',
      'kk': '',
    },
    'twbis7lt': {
      'ru': 'Поиск',
      'en': '',
      'kk': '',
    },
    'ff95wqex': {
      'ru': 'Option 1',
      'en': '',
      'kk': '',
    },
    'ee1gspw7': {
      'ru': 'Выберите категорию',
      'en': '',
      'kk': '',
    },
    'oesebfkk': {
      'ru': 'Выберите категорию',
      'en': '',
      'kk': '',
    },
    'zcjoy79j': {
      'ru': 'Поиск',
      'en': '',
      'kk': '',
    },
    'dst6p6e8': {
      'ru': 'Option 1',
      'en': '',
      'kk': '',
    },
    'gnphut4i': {
      'ru': 'Понедельник',
      'en': '',
      'kk': '',
    },
    '1vl5xozv': {
      'ru': 'С',
      'en': '',
      'kk': '',
    },
    '24jpc7ik': {
      'ru': 'Время работы',
      'en': '',
      'kk': '',
    },
    'i1ucrnpw': {
      'ru': 'ДО',
      'en': '',
      'kk': '',
    },
    'onyn9pfu': {
      'ru': 'Время работы',
      'en': '',
      'kk': '',
    },
    '9aptvxx2': {
      'ru': 'Вторник',
      'en': '',
      'kk': '',
    },
    'z5pjhzjq': {
      'ru': 'С',
      'en': '',
      'kk': '',
    },
    'hiivj16h': {
      'ru': 'Время работы',
      'en': '',
      'kk': '',
    },
    'b03lozie': {
      'ru': 'ДО',
      'en': '',
      'kk': '',
    },
    'k3bkj4cs': {
      'ru': 'Время работы',
      'en': '',
      'kk': '',
    },
    'w2gmcpzh': {
      'ru': 'Среда',
      'en': '',
      'kk': '',
    },
    'xicu2vtc': {
      'ru': 'С',
      'en': '',
      'kk': '',
    },
    'tmbnb7zp': {
      'ru': 'Время работы',
      'en': '',
      'kk': '',
    },
    'io0t9nms': {
      'ru': 'ДО',
      'en': '',
      'kk': '',
    },
    'ka5an5ok': {
      'ru': 'Время работы',
      'en': '',
      'kk': '',
    },
    'nrr6qho5': {
      'ru': 'Четверг',
      'en': '',
      'kk': '',
    },
    'x6rekt9z': {
      'ru': 'С',
      'en': '',
      'kk': '',
    },
    'hy5g5f8c': {
      'ru': 'Время работы',
      'en': '',
      'kk': '',
    },
    'x8k5yfso': {
      'ru': 'ДО',
      'en': '',
      'kk': '',
    },
    '1q900skv': {
      'ru': 'Время работы',
      'en': '',
      'kk': '',
    },
    'd12rkr8y': {
      'ru': 'Пятница',
      'en': '',
      'kk': '',
    },
    'v0xtb7oj': {
      'ru': 'С',
      'en': '',
      'kk': '',
    },
    'xyfeyqa2': {
      'ru': 'Время работы',
      'en': '',
      'kk': '',
    },
    'jjr6snmx': {
      'ru': 'ДО',
      'en': '',
      'kk': '',
    },
    'zdckmyfl': {
      'ru': 'Время работы',
      'en': '',
      'kk': '',
    },
    'vjtl131a': {
      'ru': 'Суббота',
      'en': '',
      'kk': '',
    },
    '5x5w9t5j': {
      'ru': 'С',
      'en': '',
      'kk': '',
    },
    'ofiemnar': {
      'ru': 'Время работы',
      'en': '',
      'kk': '',
    },
    'wi2nl73z': {
      'ru': 'ДО',
      'en': '',
      'kk': '',
    },
    'ozq6bsm3': {
      'ru': 'Время работы',
      'en': '',
      'kk': '',
    },
    '1ubaf5ue': {
      'ru': 'Воскресенье',
      'en': '',
      'kk': '',
    },
    '8359503y': {
      'ru': 'С',
      'en': '',
      'kk': '',
    },
    '1e3gxjx5': {
      'ru': 'Время работы',
      'en': '',
      'kk': '',
    },
    'wb8257qu': {
      'ru': 'ДО',
      'en': '',
      'kk': '',
    },
    'fqw1yrba': {
      'ru': 'Время работы',
      'en': '',
      'kk': '',
    },
    '6r8t1w2i': {
      'ru': 'Добавить',
      'en': '',
      'kk': '',
    },
    '95v3ry9z': {
      'ru': 'Новый магазин',
      'en': '',
      'kk': '',
    },
    '5nkj0pvd': {
      'ru': 'Home',
      'en': '',
      'kk': '',
    },
  },
  // editSale
  {
    'nx47w5ev': {
      'ru': 'Загрузить логотип',
      'en': '',
      'kk': '',
    },
    '227qvdoo': {
      'ru': 'Фото',
      'en': '',
      'kk': '',
    },
    'ervjqlnu': {
      'ru': 'Наименование',
      'en': '',
      'kk': '',
    },
    '836w65gc': {
      'ru': 'Адрес',
      'en': '',
      'kk': '',
    },
    'xkl8qmg7': {
      'ru': 'Телефон',
      'en': '',
      'kk': '',
    },
    '41f6uw1i': {
      'ru': 'Ссылка на Instagram',
      'en': '',
      'kk': '',
    },
    'jh3wygqz': {
      'ru': 'Описание',
      'en': '',
      'kk': '',
    },
    'ygg67oan': {
      'ru': 'Выберите город',
      'en': '',
      'kk': '',
    },
    'q3fq0zii': {
      'ru': 'Поиск',
      'en': '',
      'kk': '',
    },
    'u8lrgyuv': {
      'ru': 'Option 1',
      'en': '',
      'kk': '',
    },
    'fmyt9b6s': {
      'ru': 'Понедельник',
      'en': '',
      'kk': '',
    },
    'jy48hcwh': {
      'ru': 'С',
      'en': '',
      'kk': '',
    },
    '8wtxmvdu': {
      'ru': 'Время работы',
      'en': '',
      'kk': '',
    },
    '6ml2pnkx': {
      'ru': 'ДО',
      'en': '',
      'kk': '',
    },
    'sbmyjnld': {
      'ru': 'Время работы',
      'en': '',
      'kk': '',
    },
    'r0xacfqz': {
      'ru': 'Вторник',
      'en': '',
      'kk': '',
    },
    '4wh3nxqh': {
      'ru': 'С',
      'en': '',
      'kk': '',
    },
    'ehaqy8ai': {
      'ru': 'Время работы',
      'en': '',
      'kk': '',
    },
    '0taf8g5o': {
      'ru': 'ДО',
      'en': '',
      'kk': '',
    },
    '5acj1lx1': {
      'ru': 'Время работы',
      'en': '',
      'kk': '',
    },
    'j4gdc5qx': {
      'ru': 'Среда',
      'en': '',
      'kk': '',
    },
    'f8ak8ttq': {
      'ru': 'С',
      'en': '',
      'kk': '',
    },
    'vfhnxmov': {
      'ru': 'Время работы',
      'en': '',
      'kk': '',
    },
    'lapzfuli': {
      'ru': 'ДО',
      'en': '',
      'kk': '',
    },
    'mvi4wh6b': {
      'ru': 'Время работы',
      'en': '',
      'kk': '',
    },
    'xgz2j5a7': {
      'ru': 'Четверг',
      'en': '',
      'kk': '',
    },
    'zztc25dw': {
      'ru': 'С',
      'en': '',
      'kk': '',
    },
    's7fcltvd': {
      'ru': 'Время работы',
      'en': '',
      'kk': '',
    },
    '0xu0oe1r': {
      'ru': 'ДО',
      'en': '',
      'kk': '',
    },
    'tcdigrpv': {
      'ru': 'Время работы',
      'en': '',
      'kk': '',
    },
    '5szoevic': {
      'ru': 'Пятница',
      'en': '',
      'kk': '',
    },
    'v4rrjk38': {
      'ru': 'С',
      'en': '',
      'kk': '',
    },
    '0zetxgjb': {
      'ru': 'Время работы',
      'en': '',
      'kk': '',
    },
    'pw9e26hq': {
      'ru': 'ДО',
      'en': '',
      'kk': '',
    },
    'do23wh3s': {
      'ru': 'Время работы',
      'en': '',
      'kk': '',
    },
    'jmkxmw4v': {
      'ru': 'Суббота',
      'en': '',
      'kk': '',
    },
    'fjwgkbc3': {
      'ru': 'С',
      'en': '',
      'kk': '',
    },
    'i9d2ra3z': {
      'ru': 'Время работы',
      'en': '',
      'kk': '',
    },
    'm7lj7ict': {
      'ru': 'ДО',
      'en': '',
      'kk': '',
    },
    'y86x183m': {
      'ru': 'Время работы',
      'en': '',
      'kk': '',
    },
    'bjcdriuy': {
      'ru': 'Воскресенье',
      'en': '',
      'kk': '',
    },
    '98o2rt86': {
      'ru': 'С',
      'en': '',
      'kk': '',
    },
    'f5b5ear6': {
      'ru': 'Время работы',
      'en': '',
      'kk': '',
    },
    'osynzms3': {
      'ru': 'ДО',
      'en': '',
      'kk': '',
    },
    'u30roc3s': {
      'ru': 'Время работы',
      'en': '',
      'kk': '',
    },
    '3hu2d38z': {
      'ru': 'Сохранить',
      'en': '',
      'kk': '',
    },
    'ag6sp8io': {
      'ru': 'Редактировать магазин',
      'en': '',
      'kk': '',
    },
    'd4nzb3hg': {
      'ru': 'Home',
      'en': '',
      'kk': '',
    },
  },
  // reg
  {
    '3d1unx5m': {
      'ru': 'Создайте аккаунт',
      'en': 'Login to your account',
      'kk': 'Тіркелгіңізге кіріңіз',
    },
    'p1ryegex': {
      'ru': 'E-mail',
      'en': '',
      'kk': '',
    },
    'xx17wtc0': {
      'ru': 'Пароль',
      'en': '',
      'kk': '',
    },
    'vxg4f0s5': {
      'ru': 'Повторите пароль',
      'en': '',
      'kk': '',
    },
    'bsxgadz1': {
      'ru': 'Наименование организации',
      'en': '',
      'kk': '',
    },
    '67c9h5dn': {
      'ru': 'Далее',
      'en': '',
      'kk': '',
    },
    'wdxtswpn': {
      'ru': 'Home',
      'en': 'Home',
      'kk': 'Үй',
    },
  },
  // ojPage
  {
    '2ox1hazv': {
      'ru': 'Ваша заявка на расмотрении',
      'en': 'Login to your account',
      'kk': 'Тіркелгіңізге кіріңіз',
    },
    'kpg40m3p': {
      'ru': 'Выйти',
      'en': '',
      'kk': '',
    },
    'gg10maf5': {
      'ru': 'Home',
      'en': 'Home',
      'kk': 'Үй',
    },
  },
  // tovari
  {
    'kyuq7gvp': {
      'ru': 'Удалить',
      'en': '',
      'kk': '',
    },
    'a0cn7lr2': {
      'ru': 'Товары',
      'en': '',
      'kk': '',
    },
    'fllkzyb8': {
      'ru': 'Home',
      'en': '',
      'kk': '',
    },
  },
  // addTovar
  {
    'jhyuikjw': {
      'ru': 'Добавьте фото',
      'en': '',
      'kk': '',
    },
    'r6b61ejy': {
      'ru': 'Наименование',
      'en': '',
      'kk': '',
    },
    'itwbo5ou': {
      'ru': 'Цена',
      'en': '',
      'kk': '',
    },
    'q5mnvhyx': {
      'ru': 'Цена со скидкой',
      'en': '',
      'kk': '',
    },
    '6kgadxjk': {
      'ru': 'Описание',
      'en': '',
      'kk': '',
    },
    '18h6cuct': {
      'ru': 'Выберите магазин',
      'en': '',
      'kk': '',
    },
    '8rbx4dsg': {
      'ru': 'Поиск',
      'en': '',
      'kk': '',
    },
    '5xsvwgb3': {
      'ru': 'Сохранить',
      'en': '',
      'kk': '',
    },
    '97cu8ejl': {
      'ru': 'Новый товар',
      'en': '',
      'kk': '',
    },
    '51v5bjt3': {
      'ru': 'Home',
      'en': '',
      'kk': '',
    },
  },
  // chat_DetailsOverlay
  {
    'jiqzhjok': {
      'ru': 'ID Чата: ',
      'en': 'Chat ID:',
      'kk': 'Чат идентификаторы:',
    },
    'jwflooc8': {
      'ru': 'Участники:',
      'en': 'Participants:',
      'kk': 'Қатысушылар:',
    },
    'imcc507x': {
      'ru': 'Закрыть',
      'en': 'Close',
      'kk': 'Жабық',
    },
  },
  // chat_ThreadComponent
  {
    '9zdxi7bp': {
      'ru': 'Ваше сообщение',
      'en': 'your message',
      'kk': 'Сіздің хабарламаңыз',
    },
    'mzdpkv5w': {
      'ru': 'You must enter a message...',
      'en': 'You must enter a message...',
      'kk': 'Хабарлама енгізу керек...',
    },
    'qwl4jypk': {
      'ru': 'Please choose an option from the dropdown',
      'en': 'Please choose an option from the dropdown',
      'kk': 'Ашылмалы тізімнен опцияны таңдаңыз',
    },
  },
  // user_ListSmall
  {
    'srfyt2k6': {
      'ru': 'Я',
      'en': 'I',
      'kk': 'I',
    },
  },
  // deleteDialog
  {
    'ckimt6qh': {
      'ru': 'Настройки',
      'en': 'Settings',
      'kk': 'Параметрлер',
    },
    'vlb3sidu': {
      'ru': 'Добавить',
      'en': 'Add',
      'kk': 'қосу',
    },
    '8o3sp6q8': {
      'ru': 'Удалить чат',
      'en': 'Delete chat',
      'kk': 'Чатты жою',
    },
    'hovg8699': {
      'ru': 'Подтверждение ',
      'en': 'Confirmation',
      'kk': 'Растау',
    },
    'o526czaf': {
      'ru': 'Вы действительно хотите удалить чат?',
      'en': 'Are you sure you want to delete the chat?',
      'kk': 'Чатты шынымен жойғыңыз келе ме?',
    },
    'ps1vyatj': {
      'ru': 'Удалить',
      'en': 'Delete',
      'kk': 'Жою',
    },
  },
  // Payment
  {
    '536447v9': {
      'ru': 'Введите сумму для вывода',
      'en': '',
      'kk': '',
    },
    '89bv2bu2': {
      'ru': 'Сумма',
      'en': '',
      'kk': '',
    },
    '3lhf5crx': {
      'ru': 'Сумма',
      'en': '',
      'kk': '',
    },
    '85mxmrcd': {
      'ru': 'Вывести',
      'en': '',
      'kk': '',
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
    'nz4k0vcw': {
      'ru': 'Для сканирования qr кодов',
      'en': 'To scan qr codes',
      'kk': 'Qr кодтарын сканерлеу үшін',
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
    'ccrb8eqg': {
      'ru': '',
      'en': '',
      'kk': '',
    },
    'tgg6gef8': {
      'ru': '',
      'en': '',
      'kk': '',
    },
    'brhi97uz': {
      'ru': 'Неверный формат',
      'en': 'Wrong format',
      'kk': 'Қате формат',
    },
    'qc55on0n': {
      'ru': 'Загрузка файла',
      'en': 'Uploading a file',
      'kk': 'Файл жүктеп салынуда',
    },
    'pcdru2wu': {
      'ru': 'Успешно',
      'en': 'Successfully',
      'kk': 'Сәтті',
    },
    '054c502n': {
      'ru': 'Ошибка загрузки файла',
      'en': 'File download error',
      'kk': 'Файлды жүктеу қатесі',
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
