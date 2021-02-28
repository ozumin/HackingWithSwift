//
//  ViewController.swift
//  Day23
//
//  Created by Mizuo Nagayama on 2021/02/21.
//

import UIKit

class ViewController: UITableViewController {
    var flags: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Flags"

        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        for item in items {
            if item.hasSuffix(".png") {
                flags.append(item)
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        let imageName = flags[indexPath.row]
        cell.textLabel?.text = String(imageName.prefix(imageName.count-4)).uppercased()
        cell.imageView?.image = UIImage(named: imageName)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.selectedFlag = flags[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

