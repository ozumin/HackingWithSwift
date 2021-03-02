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

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

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

    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8)
        else {
            print("No image found")
            return
        }
        let vc = UIActivityViewController(activityItems: [image, selectedImage!], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
