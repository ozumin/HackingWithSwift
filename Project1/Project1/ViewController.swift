//
//  ViewController.swift
//  Project1
//
//  Created by Mizuo Nagayama on 2021/02/13.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true

        DispatchQueue.global(qos: .userInitiated).async {
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path)

            for item in items {
                if item.hasPrefix("nssl") {
                    // this is a picture to load
                    self.pictures.append(item)
                }
            }
            self.pictures = self.pictures.sorted()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.imageCount = pictures.count
            vc.imageNumber = indexPath.row
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

