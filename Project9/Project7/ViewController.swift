//
//  ViewController.swift
//  Project7
//
//  Created by Mizuo Nagayama on 2021/03/07.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "?", style: .plain, target: self, action: #selector(showCredits))

        navigationItem.rightBarButtonItems?.append(UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchPetitions)))

        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }

    @objc func fetchJSON(url: String) {
        let urlString: String

        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }

    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
        
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Data came from We The People API of the Whitehouse", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    @objc func searchPetitions() {
        let ac = UIAlertController(title: "Enter search word", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let filterAction = UIAlertAction(title: "Search", style: .default) { [weak self, weak ac] action in
            guard let word = ac?.textFields?[0].text else { return }
            self?.filterPetitions(word.lowercased())
        }

        ac.addAction(filterAction)

        present(ac, animated: true)
    }

    func filterPetitions(_ word: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            if word.isEmpty {
                self.filteredPetitions = self.petitions
            } else {
                self.filteredPetitions = self.petitions.filter {
                    $0.body.lowercased().contains(word) || $0.title.lowercased().contains(word)
                }
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

}

