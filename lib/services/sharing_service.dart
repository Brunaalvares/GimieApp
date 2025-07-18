import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Serviço responsável por gerenciar o compartilhamento de links
/// Suporta Android (via Intent) e iOS (via Share Extension)
class SharingService {
  static SharingService? _instance;
  static SharingService get instance => _instance ??= SharingService._();
  SharingService._();

  // Stream controllers para notificar sobre novos links compartilhados
  final StreamController<String> _sharedLinkController = StreamController<String>.broadcast();
  
  // Getters públicos
  Stream<String> get sharedLinkStream => _sharedLinkController.stream;
  
  // Subscriptions para gerenciar os listeners
  StreamSubscription? _intentDataStreamSubscription;
  
  /// Inicializa o serviço de compartilhamento
  /// Deve ser chamado no main() ou initState() do app principal
  Future<void> initialize() async {
    try {
      if (kDebugMode) {
        debugPrint('🔗 Inicializando SharingService...');
      }
      
      // Verifica se há link compartilhado quando o app é aberto (Android/iOS)
      await _checkInitialSharedLink();
      
      // Configura listener para links compartilhados enquanto app está rodando (Android)
      _setupAndroidSharingListener();
      
      // Configura verificação periódica para iOS Share Extension
      if (Platform.isIOS) {
        _setupiOSSharingCheck();
      }
      
      if (kDebugMode) {
        debugPrint('✅ SharingService inicializado com sucesso');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Erro ao inicializar SharingService: $e');
      }
    }
  }
  
  /// Verifica se há um link compartilhado no momento da abertura do app
  Future<void> _checkInitialSharedLink() async {
    try {
      // Android: Verifica intent inicial
      if (Platform.isAndroid) {
        final List<SharedMediaFile> sharedFiles = await ReceiveSharingIntent.getInitialMedia();
        final String? sharedText = await ReceiveSharingIntent.getInitialText();
        
        if (sharedText != null && sharedText.isNotEmpty) {
          if (kDebugMode) {
            debugPrint('📱 Android - Link compartilhado encontrado: $sharedText');
          }
          _handleSharedLink(sharedText);
        }
      }
      
      // iOS: Verifica UserDefaults/App Groups
      if (Platform.isIOS) {
        final String? sharedLink = await _checkiOSSharedLink();
        if (sharedLink != null && sharedLink.isNotEmpty) {
          if (kDebugMode) {
            debugPrint('🍎 iOS - Link compartilhado encontrado: $sharedLink');
          }
          _handleSharedLink(sharedLink);
          // Limpa o link após processar
          await _cleariOSSharedLink();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Erro ao verificar link inicial: $e');
      }
    }
  }
  
  /// Configura listener para Android (Intent streams)
  void _setupAndroidSharingListener() {
    if (!Platform.isAndroid) return;
    
    try {
      // Listener para texto compartilhado enquanto app está rodando
      _intentDataStreamSubscription = ReceiveSharingIntent.getTextStream().listen(
        (String sharedText) {
          if (kDebugMode) {
            debugPrint('📱 Android - Novo link recebido via stream: $sharedText');
          }
          _handleSharedLink(sharedText);
        },
        onError: (err) {
          if (kDebugMode) {
            debugPrint('❌ Erro no stream do Android: $err');
          }
        },
      );
      
      if (kDebugMode) {
        debugPrint('✅ Listener do Android configurado');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Erro ao configurar listener do Android: $e');
      }
    }
  }
  
  /// Configura verificação periódica para iOS Share Extension
  void _setupiOSSharingCheck() {
    if (!Platform.isIOS) return;
    
    // Verifica a cada 2 segundos se há novo link compartilhado
    // Isso é necessário porque o iOS Share Extension é um processo separado
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      try {
        final String? sharedLink = await _checkiOSSharedLink();
        if (sharedLink != null && sharedLink.isNotEmpty) {
          if (kDebugMode) {
            debugPrint('🍎 iOS - Novo link encontrado via polling: $sharedLink');
          }
          _handleSharedLink(sharedLink);
          await _cleariOSSharedLink();
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('❌ Erro na verificação iOS: $e');
        }
      }
    });
    
    if (kDebugMode) {
      debugPrint('✅ Polling do iOS configurado (2s intervalo)');
    }
  }
  
  /// Verifica se há link compartilhado no iOS via UserDefaults
  /// Esta função trabalha em conjunto com a Share Extension
  Future<String?> _checkiOSSharedLink() async {
    try {
      // Usando SharedPreferences que no iOS mapeia para UserDefaults
      final prefs = await SharedPreferences.getInstance();
      final String? sharedLink = prefs.getString('shared_url');
      return sharedLink;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Erro ao verificar link iOS: $e');
      }
      return null;
    }
  }
  
  /// Limpa o link compartilhado no iOS após processamento
  Future<void> _cleariOSSharedLink() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('shared_url');
      if (kDebugMode) {
        debugPrint('🧹 Link iOS limpo');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Erro ao limpar link iOS: $e');
      }
    }
  }
  
  /// Processa o link compartilhado e notifica os listeners
  void _handleSharedLink(String link) {
    if (link.trim().isEmpty) return;
    
    // Valida se é uma URL válida
    if (_isValidURL(link)) {
      if (kDebugMode) {
        debugPrint('✅ Link válido processado: $link');
      }
      
      // Notifica todos os listeners
      _sharedLinkController.add(link.trim());
    } else {
      if (kDebugMode) {
        debugPrint('⚠️ Link inválido ignorado: $link');
      }
    }
  }
  
  /// Valida se a string é uma URL válida
  bool _isValidURL(String url) {
    try {
      final uri = Uri.parse(url.trim());
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
  
  /// Limpa todos os recursos e subscriptions
  void dispose() {
    _intentDataStreamSubscription?.cancel();
    _sharedLinkController.close();
    if (kDebugMode) {
      debugPrint('🧹 SharingService disposed');
    }
  }
  
  /// Método utilitário para testar o compartilhamento
  /// Útil durante desenvolvimento
  void simulateSharedLink(String testUrl) {
    if (kDebugMode) {
      debugPrint('🧪 Simulando link compartilhado: $testUrl');
      _handleSharedLink(testUrl);
    }
  }
}