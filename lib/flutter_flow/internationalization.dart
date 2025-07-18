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

  static List<String> languages() => ['pt', 'en'];

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
    String? ptText = '',
    String? enText = '',
  }) =>
      [ptText, enText][languageIndex] ?? '';

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
  // HomePage
  {
    'z9byms54': {
      'pt': 'Gimie',
      'en': '',
    },
    'agd531d1': {
      'pt': 'Entrar',
      'en': '',
    },
    'cmejlzrc': {
      'pt': 'Cadastre-se',
      'en': '',
    },
    'ydnqz977': {
      'pt': 'Home',
      'en': '',
    },
  },
  // Login
  {
    'lynjji55': {
      'pt': 'Gimie',
      'en': '',
    },
    '4az4deoa': {
      'pt': 'Log In',
      'en': '',
    },
    'x331zzt3': {
      'pt': 'Email',
      'en': '',
    },
    'hq6c5j7s': {
      'pt': 'Senha',
      'en': '',
    },
    '3cefxbm1': {
      'pt': 'Entrar',
      'en': '',
    },
    's38rukfr': {
      'pt': 'Esqueceu sua senha?',
      'en': '',
    },
    '2cpt4fjz': {
      'pt': 'Home',
      'en': '',
    },
  },
  // Cadastrese
  {
    '47sckrp8': {
      'pt': 'Gimie',
      'en': '',
    },
    'pkg3ady9': {
      'pt': 'Criar Conta',
      'en': '',
    },
    '2sz2u9i6': {
      'pt': 'TextField',
      'en': '',
    },
    'tlmzw8x2': {
      'pt': 'Data de  Nascimento',
      'en': '',
    },
    'd6tm88ye': {
      'pt': 'Email',
      'en': '',
    },
    'eyhd8fip': {
      'pt': 'Senha',
      'en': '',
    },
    'on82wbmi': {
      'pt': 'Criar',
      'en': '',
    },
    'ihnzz2y6': {
      'pt': 'Home',
      'en': '',
    },
  },
  // Esqueceusenha
  {
    'dyfnrhus': {
      'pt': 'Back',
      'en': '',
    },
    'btk81028': {
      'pt': 'Esqueci minha senha',
      'en': '',
    },
    'rlv5qhpg': {
      'pt': 'Enviaremos para o seu e-mail um link para redefinir sua senha. ',
      'en': '',
    },
    'c4pofttp': {
      'pt': 'Seu endereço de e-mail',
      'en': '',
    },
    'sk3rgn6a': {
      'pt': 'Insira seu e-mail',
      'en': '',
    },
    'jr278iuh': {
      'pt': 'Enviar link',
      'en': '',
    },
    'us6osckg': {
      'pt': 'Home',
      'en': '',
    },
  },
  // Paginadeperfil
  {
    'pbv017ui': {
      'pt': 'Switch to Light Mode',
      'en': '',
    },
    'bduj21ib': {
      'pt': 'Configurações',
      'en': '',
    },
    '1s74gxpc': {
      'pt': 'Alterar senha',
      'en': '',
    },
    'oq9radle': {
      'pt': 'Alterar e-mail',
      'en': '',
    },
    'dw3vzya4': {
      'pt': 'Log Out',
      'en': '',
    },
    'zvdmnygt': {
      'pt': 'Perfil',
      'en': '',
    },
    'bmima0pd': {
      'pt': 'Perfil',
      'en': '',
    },
  },
  // LoggedInPage
  {
    'a7cfgot9': {
      'pt': 'Smartphone Galaxy Pro',
      'en': '',
    },
    'zqjb88ah': {
      'pt': 'R\$ 1.299,99',
      'en': '',
    },
    'o5ddxaay': {
      'pt': 'Compre agora',
      'en': '',
    },
    '78wl9qsv': {
      'pt': 'Notebook Gamer Ultra',
      'en': '',
    },
    't44dk6e9': {
      'pt': 'R\$ 3.499,99',
      'en': '',
    },
    'pxn63xut': {
      'pt': 'Compre agora',
      'en': '',
    },
    'e5uz8z5o': {
      'pt': 'Smartwatch Fitness',
      'en': '',
    },
    '50inlq8p': {
      'pt': 'R\$ 599,99',
      'en': '',
    },
    'tvux51c7': {
      'pt': 'Compre agora',
      'en': '',
    },
    'xbxyp4hx': {
      'pt': 'Câmera Digital 4K',
      'en': '',
    },
    'qd6rf4ko': {
      'pt': 'R\$ 2.199,99',
      'en': '',
    },
    'fwgsdx4c': {
      'pt': 'Compre agora',
      'en': '',
    },
    'qn5qw4ij': {
      'pt': 'Tablet Pro 12 polegadas',
      'en': '',
    },
    '6w1nnhue': {
      'pt': 'R\$ 1.899,99',
      'en': '',
    },
    'f43i7tcp': {
      'pt': 'Compre agora',
      'en': '',
    },
    'bjpv5q73': {
      'pt': 'Meus produtos',
      'en': '',
    },
    'qnqmxqym': {
      'pt': 'Home',
      'en': '',
    },
  },
  // explorar
  {
    'c8sasiu6': {
      'pt': 'Explorar',
      'en': '',
    },
    'dftakzpv': {
      'pt': 'Explorar',
      'en': '',
    },
  },
  // alteraremail
  {
    'yak1i8d0': {
      'pt': 'Alterar E-mail',
      'en': '',
    },
    '9amvdffd': {
      'pt': 'Alteração de E-mail',
      'en': '',
    },
    '47yem8c9': {
      'pt':
          'Você receberá um código de verificação no novo e-mail para confirmar a alteração.',
      'en': '',
    },
    '1bsf2oqm': {
      'pt': 'E-mail atual',
      'en': '',
    },
    'tla7600p': {
      'pt': 'usuario@exemplo.com',
      'en': '',
    },
    '0ddld0cm': {
      'pt': 'Novo e-mail',
      'en': '',
    },
    'prqr6d84': {
      'pt': 'Digite seu novo e-mail',
      'en': '',
    },
    '4hhisxk8': {
      'pt': 'Confirmar novo e-mail',
      'en': '',
    },
    'wjxov4yl': {
      'pt': 'Confirme seu novo e-mail',
      'en': '',
    },
    'wr0k4n7q': {
      'pt': 'Segurança',
      'en': '',
    },
    'o4rki1z9': {
      'pt':
          '• Você será desconectado de todos os dispositivos após a alteração',
      'en': '',
    },
    'w1cy7nes': {
      'pt': '• Um código de verificação será enviado para o novo e-mail',
      'en': '',
    },
    '3ii2tqot': {
      'pt': '• A alteração só será efetivada após a confirmação',
      'en': '',
    },
    'pdq2xayz': {
      'pt': 'Alterar E-mail',
      'en': '',
    },
  },
  // alterarsenhaup
  {
    'zc8g6nv9': {
      'pt': 'Alterar Senha',
      'en': '',
    },
    '4npi0zbl': {
      'pt': 'Segurança da Conta',
      'en': '',
    },
    '4f42mw4y': {
      'pt': 'Mantenha sua conta segura com uma senha forte',
      'en': '',
    },
    'ynsdvz52': {
      'pt': 'Senha Atual',
      'en': '',
    },
    'm7h9zqsn': {
      'pt': 'Digite sua senha atual',
      'en': '',
    },
    '9odutujr': {
      'pt': 'Nova Senha',
      'en': '',
    },
    'g0t9oulb': {
      'pt': 'Digite sua nova senha',
      'en': '',
    },
    '37w92duz': {
      'pt': 'Confirmar Nova Senha',
      'en': '',
    },
    'klokyybu': {
      'pt': 'Confirme sua nova senha',
      'en': '',
    },
    'erk1lx3t': {
      'pt': 'Requisitos da Senha',
      'en': '',
    },
    'vjekq6jf': {
      'pt': 'Mínimo de 8 caracteres',
      'en': '',
    },
    '9q2b1bi6': {
      'pt': 'Pelo menos uma letra maiúscula',
      'en': '',
    },
    '99cwe8gl': {
      'pt': 'Pelo menos um número',
      'en': '',
    },
    'smc35paa': {
      'pt': 'Alterar Senha',
      'en': '',
    },
    'p8gq9os7': {
      'pt':
          'Após alterar sua senha, você será desconectado de todos os dispositivos por segurança.',
      'en': '',
    },
  },
  // Nome_create
  {
    'cp11c1oy': {
      'pt': 'TextField',
      'en': '',
    },
    'ajqmmgt7': {
      'pt': 'Nome',
      'en': '',
    },
  },
  // card_produto
  {
    '3mxdqx0s': {
      'pt': ' 299,99',
      'en': '',
    },
  },
  // Add_link
  {
    'eubta4ig': {
      'pt': 'Adicione novo link',
      'en': '',
    },
    'epzfzvkh': {
      'pt': 'Enter your text here',
      'en': '',
    },
    '80xsetnc': {
      'pt': 'Salvar',
      'en': '',
    },
  },
  // navbar
  {
    'bdu2adhp': {
      'pt': 'Home',
      'en': '',
    },
    'h5ajqihi': {
      'pt': 'Profile',
      'en': '',
    },
  },
  // Miscellaneous
  {
    'pmo8m07j': {
      'pt': '',
      'en': '',
    },
    'qyabr44o': {
      'pt': '',
      'en': '',
    },
    '7h99xxop': {
      'pt': '',
      'en': '',
    },
    'clii64et': {
      'pt': '',
      'en': '',
    },
    'kshrd1o4': {
      'pt': '',
      'en': '',
    },
    'ttf71tbq': {
      'pt': '',
      'en': '',
    },
    'kc9iy4it': {
      'pt': '',
      'en': '',
    },
    'dpxw6yrr': {
      'pt': '',
      'en': '',
    },
    '22otrou6': {
      'pt': '',
      'en': '',
    },
    '72l09csn': {
      'pt': '',
      'en': '',
    },
    'w74hxkh1': {
      'pt': '',
      'en': '',
    },
    'uzy7y3qv': {
      'pt': '',
      'en': '',
    },
    'oadsxghm': {
      'pt': '',
      'en': '',
    },
    'g1iz65tg': {
      'pt': '',
      'en': '',
    },
    'b8i2c62f': {
      'pt': '',
      'en': '',
    },
    't301kpxp': {
      'pt': '',
      'en': '',
    },
    '3zd8g4cf': {
      'pt': '',
      'en': '',
    },
    'aaiy18n6': {
      'pt': '',
      'en': '',
    },
    'vv180yx2': {
      'pt': '',
      'en': '',
    },
    '35sd5gpn': {
      'pt': '',
      'en': '',
    },
    '6w4mgw3i': {
      'pt': '',
      'en': '',
    },
    'x7gwx6or': {
      'pt': '',
      'en': '',
    },
    'iet6by9v': {
      'pt': '',
      'en': '',
    },
    'toe9s8lb': {
      'pt': '',
      'en': '',
    },
    'eu6gxs3s': {
      'pt': '',
      'en': '',
    },
  },
].reduce((a, b) => a..addAll(b));
