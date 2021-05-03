//
//  ViewController.swift
//  Project2
//
//  Created by Mizuo Nagayama on 2021/02/16.
//

import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!

    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questions = 0

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

        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("yay")
            } else {
                print("D'oh!")
            }
        }
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

        UIView.animate(withDuration: 0.3){
            sender.transform = CGAffineTransform(translationX: 0, y: -10)
        }
        UIView.animate(withDuration: 0.3, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 5){
            sender.transform = .identity
        }

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

    func scheduleLocal() {
        registerCategories()

        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()

        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default

        var dateComponents = DateComponents()
        let today = Calendar.current.dateComponents([], from: Date())
        for i in 1...6 {
            dateComponents.day = today.day ?? 0 + i
            dateComponents.hour = 10
            dateComponents.minute = 30
    //        let trigger =  UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5 + Double(i), repeats: false) // This code is to check

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
    }

    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self // after the notification we come back to this viewcontroller

        let show = UNNotificationAction(identifier: "show", title: "Play now", options: .foreground) // foreground: launch app

        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [], options: [])

        center.setNotificationCategories([category])
    }
}

