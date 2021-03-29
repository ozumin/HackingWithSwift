//
//  Person.swift
//  Project10
//
//  Created by Mizuo Nagayama on 2021/03/20.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String

    init(name: String, image: String){
        self.name = name
        self.image = image
    }
}
