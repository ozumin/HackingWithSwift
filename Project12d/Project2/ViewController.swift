//
//  ViewController.swift
//  Project2
//
//  Created by Mizuo Nagayama on 2021/02/16.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!

    var highestScore: Int?
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questions = 0

    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]

        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1

        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor

        askQustion()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .plain, target: self, action: #selector(scoreButtonTapped))

        highestScore = defaults.object(forKey: "score") as? Int ?? nil
    }

    func askQustion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)

        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)

        title = "\(countries[correctAnswer].uppercased()) score:\(score)"
    }


    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        var wrong: Bool = false

        questions += 1
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            wrong = true
            title = "Wrong"
            score -= 1
        }

        let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
        if wrong {
            ac.message = "The correct answer is \(countries[correctAnswer].uppercased()). " + ac.message!
        }
        if questions == 10 {
            ac.message! += ". You've done 10 questions."
            ac.addAction(UIAlertAction(title: "Start from beggining", style: .default, handler: askQustion))

            if let highestScore = highestScore {
                if score > highestScore {
                    defaults.set(score, forKey: "score")
                    ac.message! += " You got highest socre!🎉"
                }
            } else {
                defaults.set(score, forKey: "score")
            }

            questions = 0
            score = 0
        } else {
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQustion))
        }

        present(ac, animated: true)
    }

    @objc func scoreButtonTapped() {
        let ac = UIAlertController(title: "Your score is \(score)", message: "", preferredStyle: .alert)
        present(ac, animated: true, completion: {
            ac.view.superview?.isUserInteractionEnabled = true
            ac.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
        })
    }

    @objc func dismissOnTapOutside(){
       self.dismiss(animated: true, completion: nil)
    }
}

