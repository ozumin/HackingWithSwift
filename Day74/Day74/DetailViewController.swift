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

        let deleteItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteMemo))
        toolbarItems = [deleteItem]
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
