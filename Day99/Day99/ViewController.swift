//
//  ViewController.swift
//  Day99
//
//  Created by Mizuo Nagayama on 2021/06/06.
//

import UIKit

class ViewController: UIViewController {

    var cards = [UIButton]()

    var openedNumber = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground

        for _ in 0 ... 15 {
            let button = UIButton()
            button.setTitleColor(.systemGray2, for: .selected)
            button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: CGFloat.random(in: 0.5 ... 0.9))
            button.addTarget(self, action: #selector(cardTapped), for: .touchUpInside)
            button.widthAnchor.constraint(equalTo: button.heightAnchor, multiplier: 0.6).isActive = true
            button.heightAnchor.constraint(equalToConstant: 200).isActive = true
            button.translatesAutoresizingMaskIntoConstraints = false

            self.cards.append(button)
        }

        self.view.addSubviews(self.cards)

        self.cards[0].bottomAnchor.constraint(equalTo: self.cards[5].topAnchor, constant: -50).isActive = true
        for (index, card) in self.cards[1...4].enumerated() {
            card.centerYAnchor.constraint(equalTo: self.cards[0].centerYAnchor).isActive = true
            card.leadingAnchor.constraint(equalTo: self.cards[index].trailingAnchor, constant: 30).isActive = true
        }
        self.cards[2].centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        self.cards[5].centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        for (index, card) in self.cards[6...10].enumerated() {
            card.centerYAnchor.constraint(equalTo: self.cards[5].centerYAnchor).isActive = true
            card.leadingAnchor.constraint(equalTo: self.cards[index + 5].trailingAnchor, constant: 30).isActive = true
        }
        self.cards[8].leadingAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        self.cards[11].topAnchor.constraint(equalTo: self.cards[5].bottomAnchor, constant: 50).isActive = true
        for (index, card) in self.cards[12...15].enumerated() {
            card.centerYAnchor.constraint(equalTo: self.cards[11].centerYAnchor).isActive = true
            card.leadingAnchor.constraint(equalTo: self.cards[index + 11].trailingAnchor, constant: 30).isActive = true
        }
        self.cards[13].centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        self.setCardsTitle()
    }

    @objc func cardTapped(_ button: UIButton) {
        if !button.isSelected {
            button.isSelected = true
            self.openCard()
        }
    }

    func openCard() {
        self.openedNumber += 1
        if self.openedNumber == 2 {
            for card in self.cards {
                if !card.isSelected { card.isEnabled = false }
            }

            let openedCards = self.cards.filter({
                $0.isSelected == true
            })
            if openedCards.count != 2 { fatalError() }

            if openedCards[0].title(for: .selected) == openedCards[1].title(for: .selected) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    openedCards[0].isHidden = true
                    openedCards[0].isSelected = false
                    openedCards[1].isHidden = true
                    openedCards[1].isSelected = false
                    for card in self.cards {
                        card.isEnabled = true
                    }
                    self.evaluate()
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    openedCards[0].isSelected = false
                    openedCards[1].isSelected = false
                    for card in self.cards {
                        card.isEnabled = true
                    }
                }
            }
            self.openedNumber = 0
        }
    }

    func evaluate() {
        if self.cards.filter({$0.isHidden == false}).count == 0 {
            let label = UILabel()
            label.text = "YOU WIN"
            label.textColor = .systemGray
            self.view.addSubviews([label],
                                  constraints: label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                  label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor))
        }
    }

    func setCardsTitle() {
        let words = ["Bourbon", "Meiji", "Lotte", "Morinaga", "Ginbis", "Koikeya", "Riska", "YBC"]
        var titles = words + words
        titles.shuffle()
        for (index, button) in self.cards.enumerated() {
            button.setTitle(titles[index], for: .selected)
        }
    }
}

