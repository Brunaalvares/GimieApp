import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/components/add_link_widget.dart';
import '/services/sharing_service.dart';

/// Tela responsável por exibir e processar links compartilhados
/// Pode ser chamada diretamente ou através de navegação quando um link é recebido
class ShareScreen extends StatefulWidget {
  const ShareScreen({
    super.key,
    this.sharedUrl,
    this.title = 'Link Compartilhado',
  });

  /// URL compartilhada (opcional - pode vir via parâmetro ou stream)
  final String? sharedUrl;
  
  /// Título da tela
  final String title;
  
  /// Rota para navegação
  static const String routeName = 'ShareScreen';
  static const String routePath = '/share';

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  String? _currentSharedUrl;
  bool _isProcessing = false;
  String _statusMessage = '';
  
  @override
  void initState() {
    super.initState();
    
    // Se recebeu URL via parâmetro, usa ela
    if (widget.sharedUrl != null) {
      _currentSharedUrl = widget.sharedUrl;
      _statusMessage = 'Link recebido via compartilhamento';
    }
    
    // Escuta por novos links compartilhados
    _listenToSharedLinks();
  }
  
  /// Configura listener para novos links compartilhados
  void _listenToSharedLinks() {
    SharingService.instance.sharedLinkStream.listen(
      (String sharedUrl) {
        if (mounted) {
          setState(() {
            _currentSharedUrl = sharedUrl;
            _statusMessage = 'Novo link recebido!';
            _isProcessing = false;
          });
          
          // Mostra notificação visual
          _showSnackBar('Link compartilhado recebido!', isSuccess: true);
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _statusMessage = 'Erro ao receber link: $error';
          });
          _showSnackBar('Erro ao processar link compartilhado', isSuccess: false);
        }
      },
    );
  }
  
  /// Exibe mensagem para o usuário
  void _showSnackBar(String message, {required bool isSuccess}) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isSuccess 
            ? Colors.green 
            : Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  /// Copia o link para o clipboard
  Future<void> _copyToClipboard() async {
    if (_currentSharedUrl == null) return;
    
    try {
      await Clipboard.setData(ClipboardData(text: _currentSharedUrl!));
      _showSnackBar('Link copiado para área de transferência!', isSuccess: true);
    } catch (e) {
      _showSnackBar('Erro ao copiar link', isSuccess: false);
    }
  }
  
  /// Abre o modal para adicionar o link
  void _openAddLinkModal() {
    if (_currentSharedUrl == null) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddLinkWidget(),
      ),
    );
  }
  
  /// Simula recebimento de link (para teste)
  void _simulateSharedLink() {
    const testUrl = 'https://www.example.com/produto/123';
    SharingService.instance.simulateSharedLink(testUrl);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        automaticallyImplyLeading: true,
        title: Text(
          widget.title,
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                color: Colors.white,
                fontSize: 22.0,
              ),
        ),
        actions: [
          if (_currentSharedUrl != null)
            IconButton(
              icon: const Icon(Icons.copy, color: Colors.white),
              onPressed: _copyToClipboard,
              tooltip: 'Copiar link',
            ),
        ],
        centerTitle: true,
        elevation: 2.0,
      ),
      body: SafeArea(
        top: true,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header com informações
              _buildHeader(),
              
              const SizedBox(height: 24),
              
              // Card com o link compartilhado
              _buildLinkCard(),
              
              const SizedBox(height: 24),
              
              // Botões de ação
              _buildActionButtons(),
              
              const Spacer(),
              
              // Botão de teste (apenas em debug)
              if (kDebugMode) _buildDebugSection(),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Constrói o header com informações
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: const Color(0x1A000000),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.share,
                color: FlutterFlowTheme.of(context).primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Gimie - Compartilhamento',
                style: FlutterFlowTheme.of(context).headlineSmall,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _statusMessage.isNotEmpty 
                ? _statusMessage 
                : 'Aguardando link compartilhado...',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
          ),
        ],
      ),
    );
  }
  
  /// Constrói o card com o link
  Widget _buildLinkCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _currentSharedUrl != null 
              ? FlutterFlowTheme.of(context).primary 
              : FlutterFlowTheme.of(context).alternate,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.link,
                color: _currentSharedUrl != null 
                    ? FlutterFlowTheme.of(context).primary 
                    : FlutterFlowTheme.of(context).secondaryText,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Link Compartilhado:',
                style: FlutterFlowTheme.of(context).labelLarge,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: FlutterFlowTheme.of(context).alternate,
                width: 1,
              ),
            ),
            child: _currentSharedUrl != null
                ? SelectableText(
                    _currentSharedUrl!,
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                          color: FlutterFlowTheme.of(context).primary,
                          fontFamily: 'Roboto Mono',
                        ),
                  )
                : Text(
                    'Nenhum link compartilhado ainda...',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
          ),
        ],
      ),
    );
  }
  
  /// Constrói os botões de ação
  Widget _buildActionButtons() {
    return Column(
      children: [
        // Botão principal - Processar Link
        SizedBox(
          width: double.infinity,
          child: FFButtonWidget(
            onPressed: _currentSharedUrl != null ? _openAddLinkModal : null,
            text: _isProcessing ? 'Processando...' : 'Processar Link',
            icon: _isProcessing 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.add_shopping_cart, size: 20),
            options: FFButtonOptions(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              iconPadding: EdgeInsets.zero,
              color: _currentSharedUrl != null 
                  ? FlutterFlowTheme.of(context).primary 
                  : FlutterFlowTheme.of(context).secondaryText,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    color: Colors.white,
                  ),
              elevation: 3,
              borderSide: const BorderSide(
                color: Colors.transparent,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Botão secundário - Copiar
        if (_currentSharedUrl != null)
          SizedBox(
            width: double.infinity,
            child: FFButtonWidget(
              onPressed: _copyToClipboard,
              text: 'Copiar Link',
              icon: const Icon(Icons.copy, size: 18),
              options: FFButtonOptions(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                iconPadding: EdgeInsets.zero,
                color: FlutterFlowTheme.of(context).secondaryBackground,
                textStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                elevation: 0,
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).primary,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
      ],
    );
  }
  
  /// Seção de debug (apenas visível em modo debug)
  Widget _buildDebugSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bug_report, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Text(
                'Modo Debug',
                style: FlutterFlowTheme.of(context).labelLarge.override(
                      color: Colors.orange.shade800,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FFButtonWidget(
              onPressed: _simulateSharedLink,
              text: 'Simular Link Compartilhado',
              options: FFButtonOptions(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                iconPadding: EdgeInsets.zero,
                color: Colors.orange,
                textStyle: FlutterFlowTheme.of(context).bodySmall.override(
                      color: Colors.white,
                    ),
                elevation: 0,
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}