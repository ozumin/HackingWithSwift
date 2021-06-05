//
//  ImageViewController.swift
//  Project30
//
//  Created by TwoStraws on 20/08/2016.
//  Copyright (c) 2016 TwoStraws. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
	weak var owner: SelectionViewController?

	var image: String

    lazy var animTimer: Timer = {
        // schedule an animation that does something vaguely interesting
        let timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            // do something exciting with our image
            self.imageView.transform = CGAffineTransform.identity

            UIView.animate(withDuration: 3) {
                self.imageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
        }
        return timer
    }()

	var imageView: UIImageView = UIImageView()

    init(image: String) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func loadView() {
		super.loadView()
		
		view.backgroundColor = UIColor.black

		// create an image view that fills the screen
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.alpha = 0

		view.addSubview(imageView)

		// make the image view fill the screen
		imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
		imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = image.replacingOccurrences(of: "-Large.jpg", with: "")

        if let path = owner?.getDocumentsDirectory().appendingPathComponent(self.image),
           let original = UIImage(contentsOfFile: path.path) {

            let renderer = UIGraphicsImageRenderer(size: original.size)

            let rounded = renderer.image { ctx in
                ctx.cgContext.addEllipse(in: CGRect(origin: CGPoint.zero, size: original.size))
                ctx.cgContext.closePath()

                original.draw(at: CGPoint.zero)
            }

            imageView.image = rounded
        }
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		imageView.alpha = 0

		UIView.animate(withDuration: 3) { [unowned self] in
			self.imageView.alpha = 1
		}
	}

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animTimer.invalidate()
    }

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let defaults = UserDefaults.standard
		var currentVal = defaults.integer(forKey: image)
		currentVal += 1

		defaults.set(currentVal, forKey:image)

		// tell the parent view controller that it should refresh its table counters when we go back
        if let owner = self.owner {
            owner.dirty = true
        }
	}
}
