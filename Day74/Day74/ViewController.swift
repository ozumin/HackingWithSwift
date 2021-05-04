//
//  ViewController.swift
//  Day74
//
//  Created by Mizuo Nagayama on 2021/05/04.
//

import UIKit

class TableViewController: UITableViewController {
    var memos = [Memo]()

    override func viewDidLoad() {
        super.viewDidLoad()

        memos = [Memo(title: "aa", body: "nnn")]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Memo", for: indexPath)
        if let titleLabel = cell.viewWithTag(1) as? UILabel {
            titleLabel.text = memos[indexPath.row].title
        }
        if let captionLabel = cell.viewWithTag(2) as? UILabel {
            captionLabel.text = memos[indexPath.row].body
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController else { return }
        vc.memo = memos[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

