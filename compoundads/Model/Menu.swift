//
//  Menu.swift
//  compoundads
//
//  Created by Carl Henningsson on 1/6/19.
//  Copyright © 2019 Carl Henningsson. All rights reserved.
//

import Foundation

class Menu: NSObject {
    let imageName: String
    let titel: String
    
    init(imageName: String, titel: String) {
        self.imageName = imageName
        self.titel = titel
    }
}
