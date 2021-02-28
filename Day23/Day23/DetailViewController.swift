//
//  DetailViewController.swift
//  Day23
//
//  Created by Mizuo Nagayama on 2021/02/21.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedFlag: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let imageToLoad = selectedFlag {
            title = String(imageToLoad.prefix(imageToLoad.count-4)).uppercased()
            imageView.image = UIImage(named: imageToLoad)

            imageView.layer.borderWidth = 1
            imageView.layer.borderColor = UIColor.lightGray.cgColor
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }

    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8)
        else {
            print("No image found")
            return
        }
        let vc = UIActivityViewController(activityItems: [image, selectedFlag!], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
