//
//  ViewController.swift
//  Project27
//
//  Created by Mizuo Nagayama on 2021/05/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!

    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.drawRectangle()
    }

    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        if currentDrawType > 7 {
            currentDrawType = 0
        }

        switch currentDrawType {
        case 0:
            self.drawRectangle()
        case 1:
            self.drawCircle()
        case 2:
            self.drawCheckerboard()
        case 3:
            self.drawRotatedSquares()
        case 4:
            self.drawLines()
        case 5:
            self.drawImagesAndText()
        case 6:
            self.drawEmoji()
        case 7:
            self.drawTWIN()
        default:
            break
        }
    }

    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)

            ctx.cgContext.setFillColor(UIColor.systemRed.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)

            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }

        self.imageView.image = image
    }

    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)

            ctx.cgContext.setFillColor(UIColor.systemRed.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)

            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }

        self.imageView.image = image
    }

    func drawCheckerboard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)

            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col) % 2 == 0 {
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }

        self.imageView.image = image
    }

    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)

            let rotation = 16
            let amount = Double.pi / Double(rotation)

            for _ in 0 ..< rotation {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }

            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }

        self.imageView.image = image
    }

    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)

            var first = true
            var length: CGFloat = 256

            for _ in 0 ..< 256 {
                ctx.cgContext.rotate(by: .pi / 2)

                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }

                length *= 0.99
            }

            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }

        self.imageView.image = image
    }

    func drawImagesAndText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]

            let string = "The best-laid schemes o'\nmice an' men gang aftagley"

            let attributedString = NSAttributedString(string: string, attributes: attrs)
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)

            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }

        self.imageView.image = image
    }

    func drawEmoji() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            let circle = CGRect(x: 0, y: 0, width: 200, height: 200)

            ctx.cgContext.setFillColor(UIColor.systemYellow.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(2)

            ctx.cgContext.addEllipse(in: circle)
            ctx.cgContext.drawPath(using: .fillStroke)


            let eyes = [CGRect(x: 50, y: 50, width: 30, height: 40), CGRect(x: 125, y: 50, width: 30, height: 40)]

            ctx.cgContext.setFillColor(UIColor.brown.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.brown.cgColor)

            for eye in eyes {
                ctx.cgContext.addEllipse(in: eye)
                ctx.cgContext.drawPath(using: .fillStroke)
            }

            ctx.cgContext.move(to: CGPoint(x: 50, y: 140))
            ctx.cgContext.setStrokeColor(UIColor.brown.cgColor)
            ctx.cgContext.addLine(to: CGPoint(x: 150, y: 140))
            ctx.cgContext.setLineWidth(10)
            ctx.cgContext.strokePath()
        }

        self.imageView.image = image
    }

    func drawTWIN() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = renderer.image { ctx in
            ctx.cgContext.setLineWidth(10)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)

            ctx.cgContext.move(to: CGPoint(x: 0, y: 100))
            ctx.cgContext.addLine(to: CGPoint(x: 50, y: 100))
            ctx.cgContext.move(to: CGPoint(x: 25, y: 100))
            ctx.cgContext.addLine(to: CGPoint(x: 25, y: 150))
            ctx.cgContext.move(to: CGPoint(x: 60, y: 100))
            ctx.cgContext.addLine(to: CGPoint(x: 72, y: 150))
            ctx.cgContext.move(to: CGPoint(x: 72, y: 150))
            ctx.cgContext.addLine(to: CGPoint(x: 84, y: 100))
            ctx.cgContext.move(to: CGPoint(x: 84, y: 100))
            ctx.cgContext.addLine(to: CGPoint(x: 96, y: 150))
            ctx.cgContext.move(to: CGPoint(x: 96, y: 150))
            ctx.cgContext.addLine(to: CGPoint(x: 108, y: 100))
            ctx.cgContext.move(to: CGPoint(x: 128, y: 100))
            ctx.cgContext.addLine(to: CGPoint(x: 128, y: 150))
            ctx.cgContext.move(to: CGPoint(x: 148, y: 100))
            ctx.cgContext.addLine(to: CGPoint(x: 148, y: 150))
            ctx.cgContext.move(to: CGPoint(x: 148, y: 100))
            ctx.cgContext.addLine(to: CGPoint(x: 178, y: 150))
            ctx.cgContext.move(to: CGPoint(x: 178, y: 150))
            ctx.cgContext.addLine(to: CGPoint(x: 178, y: 100))

            ctx.cgContext.strokePath()
        }

        self.imageView.image = image
    }
}

