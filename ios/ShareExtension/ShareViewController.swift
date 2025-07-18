import UIKit
import Social
import UniformTypeIdentifiers

/// Share Extension para iOS - Captura links compartilhados de outros apps
/// e os transfere para o app principal Gimie via UserDefaults
class ShareViewController: SLComposeServiceViewController {
    
    /// Identificador do App Group (deve ser configurado no projeto)
    /// ⚠️ IMPORTANTE: Substitua pelo seu App Group ID
    private let appGroupIdentifier = "group.com.mycompany.gimieapp.sharing"
    
    override func isContentValid() -> Bool {
        // Sempre permite o compartilhamento de URLs
        return true
    }

    override func didSelectPost() {
        // Processa o conteúdo compartilhado quando o usuário confirma
        processSharedContent()
    }

    override func configurationItems() -> [Any]! {
        // Retorna itens de configuração (pode ser vazio para implementação simples)
        return []
    }
    
    /// Processa o conteúdo compartilhado e o envia para o app principal
    private func processSharedContent() {
        guard let extensionContext = extensionContext else {
            completeRequest()
            return
        }
        
        // Processa os itens compartilhados
        for item in extensionContext.inputItems as? [NSExtensionItem] ?? [] {
            for provider in item.attachments ?? [] {
                
                // Verifica se é uma URL
                if provider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                    provider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { [weak self] (item, error) in
                        
                        if let url = item as? URL {
                            self?.handleSharedURL(url.absoluteString)
                        }
                    }
                }
                // Verifica se é texto (que pode conter URL)
                else if provider.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) {
                    provider.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { [weak self] (item, error) in
                        
                        if let text = item as? String {
                            // Verifica se o texto é uma URL válida
                            if self?.isValidURL(text) == true {
                                self?.handleSharedURL(text)
                            } else {
                                // Se não é URL, procura por URLs no texto
                                if let extractedURL = self?.extractURLFromText(text) {
                                    self?.handleSharedURL(extractedURL)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// Manipula a URL compartilhada, salvando-a para o app principal
    /// - Parameter urlString: A URL compartilhada como string
    private func handleSharedURL(_ urlString: String) {
        print("📱 iOS Share Extension - URL recebida: \(urlString)")
        
        // Salva a URL no UserDefaults compartilhado
        if let userDefaults = UserDefaults(suiteName: appGroupIdentifier) {
            userDefaults.set(urlString, forKey: "shared_url")
            userDefaults.set(Date(), forKey: "shared_url_timestamp")
            userDefaults.synchronize()
            
            print("✅ URL salva no UserDefaults compartilhado")
        } else {
            print("❌ Erro: Não foi possível acessar UserDefaults do App Group")
            print("⚠️  Verifique se o App Group '\(appGroupIdentifier)' está configurado corretamente")
        }
        
        // Abre o app principal (opcional)
        openMainApp()
        
        // Finaliza a extensão
        completeRequest()
    }
    
    /// Valida se uma string é uma URL válida
    /// - Parameter string: String para validar
    /// - Returns: true se for uma URL válida
    private func isValidURL(_ string: String) -> Bool {
        guard let url = URL(string: string.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            return false
        }
        
        return url.scheme == "http" || url.scheme == "https"
    }
    
    /// Extrai URLs de um texto que pode conter múltiplas informações
    /// - Parameter text: Texto para analisar
    /// - Returns: Primeira URL encontrada ou nil
    private func extractURLFromText(_ text: String) -> String? {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector?.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        
        for match in matches ?? [] {
            if let range = Range(match.range, in: text) {
                let urlString = String(text[range])
                if isValidURL(urlString) {
                    return urlString
                }
            }
        }
        
        return nil
    }
    
    /// Tenta abrir o app principal
    private func openMainApp() {
        // URL scheme do app principal
        let appURLScheme = "gimieapp://share"
        
        if let url = URL(string: appURLScheme) {
            var responder: UIResponder? = self
            while responder != nil {
                if responder?.responds(to: #selector(openURL(_:))) == true {
                    responder?.perform(#selector(openURL(_:)), with: url)
                    break
                }
                responder = responder?.next
            }
        }
    }
    
    /// Finaliza a requisição da extensão
    private func completeRequest() {
        DispatchQueue.main.async {
            self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        }
    }
}

// MARK: - Objective-C Selector Support
extension NSObject {
    @objc func openURL(_ url: URL) {
        // Implementação será resolvida em runtime
    }
}

/*
 🍎 CONFIGURAÇÃO NECESSÁRIA PARA iOS:
 
 1. CRIAR SHARE EXTENSION NO XCODE:
    - Abra o projeto iOS no Xcode
    - File > New > Target > Share Extension
    - Nome: "ShareExtension"
    - Bundle ID: "com.mycompany.gimieapp.ShareExtension"
 
 2. CONFIGURAR APP GROUPS:
    - No target principal (Runner):
      * Capabilities > App Groups > Enable
      * Adicione: "group.com.mycompany.gimieapp.sharing"
    
    - No target da Share Extension:
      * Capabilities > App Groups > Enable
      * Adicione o mesmo: "group.com.mycompany.gimieapp.sharing"
 
 3. EDITAR Info.plist DA SHARE EXTENSION:
    Adicione estas configurações para aceitar URLs:
    
    <key>NSExtension</key>
    <dict>
        <key>NSExtensionMainStoryboard</key>
        <string>MainInterface</string>
        <key>NSExtensionPointIdentifier</key>
        <string>com.apple.share-services</string>
        <key>NSExtensionAttributes</key>
        <dict>
            <key>NSExtensionActivationRule</key>
            <dict>
                <key>NSExtensionActivationSupportsText</key>
                <true/>
                <key>NSExtensionActivationSupportsWebURLWithMaxCount</key>
                <integer>1</integer>
                <key>NSExtensionActivationSupportsWebPageWithMaxCount</key>
                <integer>1</integer>
            </dict>
        </dict>
    </dict>
 
 4. ADICIONAR URL SCHEME NO APP PRINCIPAL:
    No Info.plist do app principal (ios/Runner/Info.plist):
    
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleURLName</key>
            <string>gimieapp.sharing</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>gimieapp</string>
            </array>
        </dict>
    </array>
 
 5. SUBSTITUIR O CÓDIGO:
    - Substitua o conteúdo de ShareViewController.swift por este código
    - Atualize o appGroupIdentifier com seu App Group real
 
 6. BUILD E TESTE:
    - Faça build do projeto completo
    - Teste compartilhando uma URL de outro app (Safari, Chrome, etc.)
    - O Gimie deve aparecer no menu de compartilhamento
 
 ⚠️ TROUBLESHOOTING:
 - Se o app não aparecer no menu de compartilhamento, verifique os App Groups
 - Se os dados não chegarem ao app, verifique o appGroupIdentifier
 - Para debug, use Xcode Console para ver os prints
*/