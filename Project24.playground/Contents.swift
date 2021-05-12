import UIKit

let name = "Taylor"

for letter in name {
    print("Give me a \(letter)")
}

let letter = name[name.index(name.startIndex, offsetBy: 3)]

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

let letter2 = name[3]

// hasPrefix, hasSuffix
let password = "123456"
password.hasPrefix("123")
password.hasSuffix("456")

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }

    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))

    }
}

// capitalize
let weather = "it's going to rain"
print(weather.capitalized)

extension String {
    var capitalizedFirst: String {
        guard let firstLetter = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst() // uppercased Character return String!
    }
}

print(weather.capitalizedFirst)

// contains
let input = "Swift is like Objective-C without the C"
input.contains("Swift")

let languages = ["Python", "Ruby", "Swift"]
languages.contains("Swift")

extension String {
    func containsAny(of array: [String]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        return false
    }
}

input.containsAny(of: languages) // it works but not the best

languages.contains(where: input.contains) // WOW

//
let string = "This is a test string"

let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.red,
    .font: UIFont.boldSystemFont(ofSize: 40)
]

let attributedString = NSAttributedString(string: string, attributes: attributes)

let attributedString2 = NSMutableAttributedString(string: string)
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))
// UILabel, UITextField, and more... supports attributed string!

// Challenge 1

extension String {
    func withPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) {
            return self
        } else {
            return prefix + self
        }
    }
}

let chal1test1 = "pet"
chal1test1.withPrefix("car")
let chal1test2 = "carpet"
chal1test2.withPrefix("car")

// Challenge 2

extension String {
    var isNumeric: Bool {
        if let _ = Double(self) {
            return true
        } else {
            return false
        }
    }
}

let chal2test1 = "1"
chal2test1.isNumeric
let chal2test2 = "no"
chal2test2.isNumeric

// Challenge 3

extension String {
    var lines: String {
        return self.replacingOccurrences(of: " ", with: "\n")
    }
}

input.lines
