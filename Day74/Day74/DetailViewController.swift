//
//  DetailViewController.swift
//  Day74
//
//  Created by Mizuo Nagayama on 2021/05/04.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var body: UITextView!
    var memos: [Memo]?
    var index: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        if let index = self.index,
           let validMemo = self.memos?[index] {
            self.body.text = "\(validMemo.title)\n\(validMemo.body)"
        }

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)

        let deleteItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteMemo))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let shareItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        toolbarItems = [deleteItem, space, shareItem]

        self.navigationController?.toolbar.clipsToBounds = true
        self.navigationController?.toolbar.barTintColor = .systemBackground
        self.navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
    }

    @objc func shareTapped() {
        if let memos = self.memos,
           let index = self.index {
            let text = "\(memos[index].title)\n\(memos[index].body)"
            let vc = UIActivityViewController(activityItems: [text], applicationActivities: [])
            present(vc, animated: true)
        }
    }

    @objc func deleteMemo() {
        if let index = self.index {
            self.memos?.remove(at: index)
        }
        self.save()
        _ = navigationController?.popViewController(animated: true)
    }

    @objc func done() {
        view.endEditing(true)
        if let index = self.index {
            if let lineBreak = self.body.text.firstIndex(of: "\n"){
                self.memos?[index].title = String(self.body.text[self.body.text.startIndex...self.body.text.index(before: lineBreak)])
                self.memos?[index].body = String(self.body.text[self.body.text.index(after: lineBreak)..<self.body.text.endIndex])
            } else {
                self.memos?[index].title = self.body.text
            }
        } else {
            var memo = Memo(title: "", body: "")
            if let lineBreak = self.body.text.firstIndex(of: "\n"){
                memo.title = String(self.body.text[self.body.text.startIndex...self.body.text.index(before: lineBreak)])
                memo.body = String(self.body.text[self.body.text.index(after: lineBreak)..<self.body.text.endIndex])
            } else {
                memo.title = self.body.text
            }
            self.memos?.append(memo)
        }
        self.save()
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            body.contentInset = .zero
        } else {
            body.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        body.scrollIndicatorInsets = body.contentInset

        let selectedRange = body.selectedRange
        body.scrollRangeToVisible(selectedRange)
    }

    func save() {
        let jsonEncoder = JSONEncoder()
        if let saveMemos = try? jsonEncoder.encode(self.memos) {
            let defaults = UserDefaults.standard
            defaults.set(saveMemos, forKey: "memos")
        } else {
            print("Failed to save memos.")
        }
    }
}
