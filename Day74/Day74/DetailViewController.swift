//
//  DetailViewController.swift
//  Day74
//
//  Created by Mizuo Nagayama on 2021/05/04.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var body: UITextView!
    var memo: Memo?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        if let validMemo = self.memo {
            self.body.text = "\(validMemo.title)\n\(validMemo.body)"
        }
    }

    @objc func done() {
        view.endEditing(true)
    }
}
