//
//  ShareViewController.swift
//  Gimie ShareExtension
//
//  Created by Luiza Silva on 30/07/25.
//

import Cocoa
import Social


 /*class ShareViewController: NSViewController {

    override var nibName: NSNib.Name? {
        return NSNib.Name("ShareViewController")
    }

    override func loadView() {
        super.loadView()
    
        // Insert code here to customize the view
        let item = self.extensionContext!.inputItems[0] as! NSExtensionItem
        if let attachments = item.attachments {
            NSLog("Attachments = %@", attachments as NSArray)
        } else {
            NSLog("No Attachments")
        }
    }

    @IBAction func send(_ sender: AnyObject?) {
        let outputItem = NSExtensionItem()
        // Complete implementation by setting the appropriate value on the output item
    
        let outputItems = [outputItem]
        self.extensionContext!.completeRequest(returningItems: outputItems, completionHandler: nil)
}

    @IBAction func cancel(_ sender: AnyObject?) {
        let cancelError = NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil)
        self.extensionContext!.cancelRequest(withError: cancelError)
    }

}
*/

class ShareViewController: SLComposeServiceViewController {
    
    override func isContentValid() -> Bool { true }
    
    override func didSelectPost() {
        if let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem {
            for attachment in extensionItem.attachments ?? [] {
                if attachment.hasItemConformingToTypeIdentifier("public.url") {
                    attachment.loadItem(forTypeIdentifier: "public.url", options: nil) { (data, error) in
                        if let url = data as? URL {
                            // Aqui você salva no UserDefaults (App Group) ou envia para o app
                            let defaults = UserDefaults(suiteName: "group.com.suaempresa.seuprojeto")
                            defaults?.set(url.absoluteString, forKey: "sharedURL")
                            defaults?.synchronize()
                        }
                    }
                }
            }
        }
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}

