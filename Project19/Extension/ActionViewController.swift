//
//  ActionViewController.swift
//  Extension
//
//  Created by Mizuo Nagayama on 2021/04/25.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    @IBOutlet var script: UITextView!

    var pageTitle = ""
    var pageURL = ""

    let scripts = [#"alert("Alert1");"#, #"alert("Alert2");"#]
    let defaults = UserDefaults.standard
    var savedScripts = Scripts(siteURLString: "", scripts: [])

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Choose", style: .plain, target: self, action: #selector(chooseScript))

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)

        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""

                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                        self?.decodeScripts()
                    }
                }
            }
        }
    }

    func decodeScripts() {
        let decoder = JSONDecoder()
        if let json = defaults.data(forKey: self.pageURL),
           let savedScripts = try? decoder.decode(Scripts.self, from: json) {
            self.savedScripts = savedScripts
        }
    }

    @IBAction func done() {

        self.decodeScripts()

        let ac = UIAlertController(title: "Name", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let saveAction = UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] action in
            guard let word = ac?.textFields?[0].text else { return }
            self?.saveScript(word)
            self?.moveToTableView()
        }
        ac.addAction(saveAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel){ [weak self] _ in
            self?.moveToTableView()
        })
        present(ac, animated: true)
    }

    func saveScript(_ name: String) {
        do {
            if let text = self.script.text {
                self.savedScripts.scripts.append(Script(name: name, script: text))
                let encoder = JSONEncoder()
                let json = try encoder.encode(self.savedScripts)
                defaults.set(json, forKey: self.pageURL)
            }
        } catch {
            return
        }
    }

    func moveToTableView() {
        if let vc = storyboard?.instantiateViewController(identifier: "Table") as? TableViewController {
            vc.scripts = self.savedScripts
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        script.scrollIndicatorInsets = script.contentInset

        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }

    @objc func chooseScript() {
        let ac = UIAlertController(title: "Choose script", message: "", preferredStyle: .alert)
        for i in 0..<self.scripts.count {
            ac.addAction(UIAlertAction(title: String(i), style: .default){ [unowned self] _ in
                let item = NSExtensionItem()
                let argument: NSDictionary = ["customJavaScript": scripts[i]]
                let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
                let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
                item.attachments = [customJavaScript]
                extensionContext?.completeRequest(returningItems: [item])
            })
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
}
