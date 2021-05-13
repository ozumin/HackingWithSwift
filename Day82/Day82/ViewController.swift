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

        5.times {
            print("Hello!")
        }

        var test = ["a", "b", "c"]
        print(test.remove("b"))

        var test2 = [2, 5, 3, 7, 5, 1]
        print(test2.remove(5))
        print(test2.remove(8))
    }


}

private extension UIView {
    func bounceOut(duration: Double) {
        UIView.animate(withDuration: duration) {
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
}

private extension Int {
    func times(_ closure: () -> Void) {
        for _ in 0..<self {
            closure()
        }
    }
}

private extension Array where Element : Comparable {
    mutating func remove(_ item: Element) -> Array {
        if let index = self.firstIndex(of: item) {
            self.remove(at: index)
        }
        return self
    }
}
