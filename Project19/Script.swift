//
//  Script.swift
//  Extension
//
//  Created by Mizuo Nagayama on 2021/04/29.
//

import Foundation

class Script: Codable {
    var name: String
    var script: String

    init(name: String, script: String){
        self.name = name
        self.script = script
    }
}
