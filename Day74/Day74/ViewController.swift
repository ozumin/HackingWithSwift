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
        self.loadData()

        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMemo))
        toolbarItems = [space, add]

        self.navigationController?.isToolbarHidden = false
        self.navigationController?.navigationBar.tintColor = .systemYellow
        self.navigationController?.toolbar.tintColor = .systemYellow
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
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
        return self.memos.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController else { return }
        vc.memos = self.memos
        vc.index = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.toolbar.clipsToBounds = false
        self.navigationController?.toolbar.barTintColor = .systemGray
        self.navigationController?.toolbar.barTintColor = .systemGroupedBackground
        self.loadData()
    }

    func loadData() {
        let defaults = UserDefaults.standard
        if let savedMemos = defaults.object(forKey: "memos") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                self.memos = try jsonDecoder.decode([Memo].self, from: savedMemos)
            } catch {
                print("Failed to load memos.")
            }
        }
        tableView.reloadData()
    }

    @objc func addMemo() {
        guard let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController else { return }
        vc.memos = self.memos
        navigationController?.pushViewController(vc, animated: true)
    }
}
