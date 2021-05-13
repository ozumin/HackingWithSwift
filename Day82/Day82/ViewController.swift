//
//  ViewController.swift
//  Day82
//
//  Created by Mizuo Nagayama on 2021/05/13.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.label.bounceOut(duration: 5)
    }


}

private extension UIView {
    func bounceOut(duration: Double) {
        UIView.animate(withDuration: duration) {
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
}
