//
//  ViewController.swift
//  Day59
//
//  Created by Mizuo Nagayama on 2021/04/11.
//

import UIKit

class ViewController: UITableViewController {
    var countries = [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let jsonData = readData() else { return }
        let decoder = JSONDecoder()
        if let parsedData = try? decoder.decode(Countries.self, from: jsonData) {
            countries = parsedData.countries
        } else {
            print("Could not decode json data.")
        }
    }

    func readData() -> Data? {
        if let filepath = Bundle.main.path(forResource: "countries", ofType: "json") {
            let jsonData = try? String(contentsOfFile: filepath).data(using: .utf8)
            return jsonData
        } else {
            print("File not found.")
        }
        return nil
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        cell.textLabel?.text = countries[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.country = countries[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

