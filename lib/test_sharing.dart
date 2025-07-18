import 'package:flutter/material.dart';
import '/services/sharing_service.dart';
import '/screens/share_screen.dart';

/// 🧪 Arquivo de teste para demonstrar o sistema de compartilhamento
/// Este arquivo pode ser usado para testar rapidamente as funcionalidades
/// 
/// COMO USAR:
/// 1. Importe este arquivo onde precisar
/// 2. Use os métodos estáticos para testar
/// 3. Remova este arquivo na versão de produção

class SharingTestHelper {
  
  /// Simula recebimento de link compartilhado
  /// Útil para testar sem precisar de outro app
  static void simulateSharedLink({
    String url = 'https://www.amazon.com.br/produto-exemplo/dp/B08N5WRWNW',
  }) {
    SharingService.instance.simulateSharedLink(url);
    print('🧪 Link simulado: $url');
  }
  
  /// Navega diretamente para a ShareScreen com uma URL de teste
  static void openShareScreenWithTestURL(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShareScreen(
          sharedUrl: 'https://www.mercadolivre.com.br/produto-teste/p/MLB123456',
          title: 'Teste - Link Compartilhado',
        ),
      ),
    );
  }
  
  /// Widget de teste que pode ser adicionado a qualquer tela
  /// para facilitar testes durante desenvolvimento
  static Widget buildTestButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🧪 Testes de Compartilhamento',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade800,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => simulateSharedLink(),
                  icon: const Icon(Icons.share, size: 16),
                  label: const Text('Simular Link'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => openShareScreenWithTestURL(context),
                  icon: const Icon(Icons.screen_share, size: 16),
                  label: const Text('ShareScreen'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _testMultipleLinks(),
                  icon: const Icon(Icons.multiple_stop, size: 16),
                  label: const Text('Múltiplos Links'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _testInvalidLinks(),
                  icon: const Icon(Icons.error, size: 16),
                  label: const Text('Links Inválidos'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// Testa múltiplos links em sequência
  static void _testMultipleLinks() {
    final testUrls = [
      'https://www.amazon.com.br/produto1',
      'https://www.mercadolivre.com.br/produto2',
      'https://shopee.com.br/produto3',
      'https://www.magazineluiza.com.br/produto4',
    ];
    
    for (int i = 0; i < testUrls.length; i++) {
      Future.delayed(Duration(seconds: i * 2), () {
        simulateSharedLink(url: testUrls[i]);
      });
    }
    
    print('🧪 Testando ${testUrls.length} links em sequência...');
  }
  
  /// Testa links inválidos para verificar validação
  static void _testInvalidLinks() {
    final invalidUrls = [
      'texto sem url',
      'ftp://arquivo.com/teste',
      'invalid-url',
      '',
      'www.sem-protocolo.com',
    ];
    
    for (String invalidUrl in invalidUrls) {
      SharingService.instance.simulateSharedLink(invalidUrl);
    }
    
    print('🧪 Testando ${invalidUrls.length} links inválidos...');
  }
  
  /// Demonstra como escutar links compartilhados
  /// Exemplo de implementação para qualquer widget
  static void setupSharingListener(void Function(String url) onLinkReceived) {
    SharingService.instance.sharedLinkStream.listen(
      (String url) {
        print('📱 Link recebido: $url');
        onLinkReceived(url);
      },
      onError: (error) {
        print('❌ Erro ao receber link: $error');
      },
    );
  }
}

/// 🎯 Widget de exemplo mostrando como integrar o sistema de compartilhamento
/// em qualquer tela do app
class SharingIntegrationExample extends StatefulWidget {
  const SharingIntegrationExample({super.key});

  @override
  State<SharingIntegrationExample> createState() => _SharingIntegrationExampleState();
}

class _SharingIntegrationExampleState extends State<SharingIntegrationExample> {
  String? _lastSharedUrl;
  List<String> _receivedUrls = [];

  @override
  void initState() {
    super.initState();
    _setupSharingListener();
  }

  void _setupSharingListener() {
    SharingTestHelper.setupSharingListener((url) {
      setState(() {
        _lastSharedUrl = url;
        _receivedUrls.insert(0, url);
        // Mantém apenas os últimos 10 links
        if (_receivedUrls.length > 10) {
          _receivedUrls.removeLast();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧪 Teste de Compartilhamento'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Botões de teste
            SharingTestHelper.buildTestButtons(context),
            
            const SizedBox(height: 24),
            
            // Último link recebido
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.link, color: Colors.blue),
                        const SizedBox(width: 8),
                        const Text(
                          'Último Link Recebido:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _lastSharedUrl ?? 'Nenhum link recebido ainda...',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          color: _lastSharedUrl != null ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Lista de links recebidos
            const Text(
              'Histórico de Links:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            
            Expanded(
              child: _receivedUrls.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum link recebido ainda.\nUse os botões acima para testar!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _receivedUrls.length,
                      itemBuilder: (context, index) {
                        final url = _receivedUrls[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text('${index + 1}'),
                            ),
                            title: Text(
                              url,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.open_in_new),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShareScreen(sharedUrl: url),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
🧪 COMO USAR ESTE ARQUIVO DE TESTE:

1. IMPORTAR EM QUALQUER TELA:
   ```dart
   import '/test_sharing.dart';
   ```

2. ADICIONAR BOTÕES DE TESTE:
   ```dart
   // Em qualquer build method:
   if (kDebugMode) 
     SharingTestHelper.buildTestButtons(context)
   ```

3. SIMULAR LINKS:
   ```dart
   SharingTestHelper.simulateSharedLink();
   ```

4. NAVEGAR PARA TELA DE EXEMPLO:
   ```dart
   Navigator.push(context, MaterialPageRoute(
     builder: (context) => SharingIntegrationExample()
   ));
   ```

5. ESCUTAR LINKS EM QUALQUER WIDGET:
   ```dart
   SharingTestHelper.setupSharingListener((url) {
     print('Novo link: $url');
     // Fazer algo com o link...
   });
   ```

⚠️ IMPORTANTE: 
- Este arquivo é apenas para desenvolvimento/teste
- Remova na versão de produção
- Use apenas em modo debug (kDebugMode)
*/