//
//  Scripts.swift
//  Extension
//
//  Created by Mizuo Nagayama on 2021/04/29.
//

import Foundation

class Scripts: Codable {
    var siteURLString: String
    var scripts: [Script]

    init(siteURLString: String, scripts: [Script]){
        self.siteURLString = siteURLString
        self.scripts = scripts
    }
}
