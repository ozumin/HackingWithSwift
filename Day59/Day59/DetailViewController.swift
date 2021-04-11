//
//  DetailViewController.swift
//  Day59
//
//  Created by Mizuo Nagayama on 2021/04/11.
//
import UIKit

class DetailViewController: UIViewController {
    var country: Country?
    @IBOutlet weak var population: UILabel! {
        didSet {
            population.text = "\(country!.population)"
        }
    }
    @IBOutlet weak var area: UILabel! {
        didSet {
            area.text = "\(country!.area)"
        }
    }

    override func viewDidLoad() {
        guard let country = country else { return }
        title = country.name
    }
}
