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
        guard let image = createImageToShare()
        else {
            print("No image found")
            return
        }

        let vc = UIActivityViewController(activityItems: [image, selectedImage!], applicationActivities: [])

        let canvas = UIImageView()
        if let imageToLoad = selectedImage {
            canvas.image = UIImage(named: imageToLoad)
        }

        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

    func createImageToShare() -> UIImage? {
        guard let image = self.imageView.image else { return nil }

        let renderer = UIGraphicsImageRenderer(size: image.size)

        return renderer.image { ctx in
            image.draw(at: CGPoint(x: 0, y: 0))

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 40),
                .paragraphStyle: paragraphStyle
            ]

            let attributedString = NSAttributedString(string: "From Storm Viewer", attributes: attrs)
            attributedString.draw(with: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height), options: .usesLineFragmentOrigin, context: nil)
        }
    }
}
