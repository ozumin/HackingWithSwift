//
//  Picture.swift
//  Day50
//
//  Created by Mizuo Nagayama on 2021/03/31.
//

import UIKit

class Picture: NSObject, Codable {
    var caption: String
    var image: String

    init(caption: String, image: String){
        self.caption = caption
        self.image = image
    }
}
