//
//  DetailViewController.swift
//  Project1
//
//  Created by Mizuo Nagayama on 2021/02/14.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var imageCount: Int?
    var imageNumber: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let number = imageNumber {
            if let count = imageCount {
                title = "Picture \(number) of \(count)"
            }
        }
        navigationItem.largeTitleDisplayMode = .never

        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
