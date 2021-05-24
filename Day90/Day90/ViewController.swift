//
//  ViewController.swift
//  Day90
//
//  Created by Mizuo Nagayama on 2021/05/24.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!

    var topText = ""
    var bottomText = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImage))
    }

    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    @objc func shareImage() {
        guard let image = self.imageView.image
        else {
            print("No image found")
            return
        }

        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])

        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)

        self.imageView.image = image

        self.presentFirstAC()
    }

    func presentFirstAC() {
        let ac = UIAlertController(title: "Add text", message: "Write text for top", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] action in
            guard let text = ac?.textFields?[0].text else { return }
            self?.topText = text
            self?.presentSecondAC()
        })
        present(ac, animated: true)
    }

    func presentSecondAC() {
        let ac = UIAlertController(title: "Add text", message: "Write text for bottom", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] action in
            guard let text = ac?.textFields?[0].text else { return }
            self?.bottomText = text
            self?.createImage()
        })
        present(ac, animated: true)
    }

    func createImage() {
        guard let image = self.imageView.image else { return }

        let renderer = UIGraphicsImageRenderer(size: image.size)

        let meme = renderer.image { ctx in
            image.draw(at: CGPoint(x: 0, y: 0))

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 70),
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.white,
                .strokeColor: UIColor.black,
                .strokeWidth: -3
            ]

            let attributedTopString = NSAttributedString(string: self.topText.uppercased(), attributes: attrs)
            attributedTopString.draw(with: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height), options: .usesLineFragmentOrigin, context: nil)
            let attributedBottomString = NSAttributedString(string: self.bottomText.uppercased(), attributes: attrs)
            attributedBottomString.draw(with: CGRect(x: 0, y: image.size.height - 80, width: image.size.width, height: image.size.height), options: .usesLineFragmentOrigin, context: nil)
        }

        self.imageView.image = meme
    }
}

