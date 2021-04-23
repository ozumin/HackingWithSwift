//
//  ViewController.swift
//  Project18
//
//  Created by Mizuo Nagayama on 2021/04/19.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("I'm in viewDidLoad", terminator: "")
        print(1, 2, 3, 4, 5, separator: "-")

        assert(1 == 1, "Failure")

        for i in 1...100 {
            print("Got number \(i)")
        }
    }


}

