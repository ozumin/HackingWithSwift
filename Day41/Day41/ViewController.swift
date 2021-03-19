//
//  ViewController.swift
//  Day41
//
//  Created by Mizuo Nagayama on 2021/03/15.
//

import UIKit

class ViewController: UIViewController {
    var answer: String = ""
    var currentAnswer: UITextField!
    var level = 0
    var words = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        if let fileURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let contents = try? String(contentsOf: fileURL) {
                words = contents.components(separatedBy: "\n")
            }
        }
        answer = words[0]
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white

        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 30)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)

        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("INPUT", for: .normal)
        submit.addTarget(self, action: #selector(enterCharacter), for: .touchUpInside)
        view.addSubview(submit)

        NSLayoutConstraint.activate([
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 100)
        ])

        currentAnswer.text = String(repeating: "?", count: answer.count)
    }

    func loadWord() {
        answer = words[level]
        level += 1
    }

    @objc func enterCharacter() {
        let ac = UIAlertController(title: "Enter search word", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let enterAction = UIAlertAction(title: "GO", style: .default) { [weak self, weak ac] action in
            guard let word = ac?.textFields?[0].text else { return }
            self?.evaluate(word)
        }

        ac.addAction(enterAction)
        present(ac, animated: true)
    }

    func evaluate(_ word: String) {
        currentAnswer.text = word
    }

}

