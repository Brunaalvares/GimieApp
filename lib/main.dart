import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:app_links/app_links.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'auth/firebase_auth/firebase_user_provider.dart';
import 'auth/firebase_auth/auth_util.dart';

import 'backend/firebase/firebase_config.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  await initFirebase();

  await FlutterFlowTheme.initialize();

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();

  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  StreamSubscription<List<SharedMediaFile>>? _intentDataStreamSubscription;
  
  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e))
          .toList();
  late Stream<BaseAuthUser> userStream;

  final authUserSub = authenticatedUserStream.listen((_) {});

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    userStream = gimieAppFirebaseUserStream()
      ..listen((user) {
        _appStateNotifier.update(user);
      });
    jwtTokenStream.listen((_) {});
    Future.delayed(
      Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
    
    // Initialize deep linking
    _initDeepLinks();
    
    // Listen for shared content (when app receives shared URLs from other apps)
    _intentDataStreamSubscription = ReceiveSharingIntent.instance.getMediaStream()
        .listen(_handleSharedFiles, onError: (err) {
      debugPrint("Error receiving shared files: $err");
    });

    // Get initial shared content (when app is opened from a share intent)
    ReceiveSharingIntent.instance.getInitialMedia().then(_handleSharedFiles);
    
    // Listen for shared text (URLs shared as text)
    ReceiveSharingIntent.instance.getTextStream().listen(_handleSharedText, onError: (err) {
      debugPrint("Error receiving shared text: $err");
    });
    
    // Get initial shared text
    ReceiveSharingIntent.instance.getInitialText().then(_handleSharedText);
  }
  
  void _initDeepLinks() async {
    _appLinks = AppLinks();
    
    // Handle incoming links when app is already started
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    }, onError: (err) {
      debugPrint('Deep link error: $err');
    });

    // Handle the initial link if the app was started via a deep link
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      debugPrint('Failed to get initial deep link: $e');
    }
  }
  
  void _handleDeepLink(Uri uri) {
    debugPrint('Received deep link: $uri');
    // Extract URL from deep link query parameters or path
    // Example: gimieapp://gimie.tech?url=https://example.com/product
    final url = uri.queryParameters['url'] ?? uri.path.replaceFirst('/', '');
    if (url.isNotEmpty) {
      // Update app state with the received URL
      FFAppState().update(() {
        FFAppState().link = url;
      });
      debugPrint('Deep link URL saved to app state: $url');
    }
  }
  
  void _handleSharedFiles(List<SharedMediaFile> files) {
    if (files.isEmpty) return;
    
    // If a file path contains a URL, extract it
    for (var file in files) {
      if (file.path.startsWith('http')) {
        FFAppState().update(() {
          FFAppState().link = file.path;
        });
        debugPrint('Shared file URL saved: ${file.path}');
        break;
      }
    }
  }
  
  void _handleSharedText(String? text) {
    if (text == null || text.isEmpty) return;
    
    // Check if the shared text is a URL
    if (text.startsWith('http://') || text.startsWith('https://')) {
      FFAppState().update(() {
        FFAppState().link = text;
      });
      debugPrint('Shared URL saved: $text');
    }
  }

  @override
  void dispose() {
    authUserSub.cancel();
    _linkSubscription?.cancel();
    _intentDataStreamSubscription?.cancel();

    super.dispose();
  }

  void setLocale(String language) {
    safeSetState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Gimie app',
      localizationsDelegates: [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FallbackMaterialLocalizationDelegate(),
        FallbackCupertinoLocalizationDelegate(),
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('pt'),
        Locale('en'),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

class NavBarPage extends StatefulWidget {
  NavBarPage({
    Key? key,
    this.initialPage,
    this.page,
    this.disableResizeToAvoidBottomInset = false,
  }) : super(key: key);

  final String? initialPage;
  final Widget? page;
  final bool disableResizeToAvoidBottomInset;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'LoggedInPage';
  late Widget? _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'LoggedInPage': LoggedInPageWidget(),
      'explorar': ExplorarWidget(),
      'Paginadeperfil': PaginadeperfilWidget(),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    return Scaffold(
      resizeToAvoidBottomInset: !widget.disableResizeToAvoidBottomInset,
      body: _currentPage ?? tabs[_currentPageName],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => safeSetState(() {
          _currentPage = null;
          _currentPageName = tabs.keys.toList()[i];
        }),
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        selectedItemColor: FlutterFlowTheme.of(context).primary,
        unselectedItemColor: FlutterFlowTheme.of(context).secondaryText,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.tag,
            ),
            label: FFLocalizations.of(context).getText(
              'qnqmxqym' /* Home */,
            ),
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.search,
              size: 24.0,
            ),
            label: FFLocalizations.of(context).getText(
              'dftakzpv' /* Explorar */,
            ),
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle_outlined,
              size: 24.0,
            ),
            activeIcon: Icon(
              Icons.account_circle_sharp,
              size: 24.0,
            ),
            label: FFLocalizations.of(context).getText(
              'bmima0pd' /* Perfil */,
            ),
            tooltip: '',
          )
        ],
      ),
    );
  }
}
