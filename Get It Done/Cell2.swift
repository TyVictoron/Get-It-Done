//
//  Cell2.swift
//  Get It Done
//
//  Created by Ty Victorson on 12/2/16.
//  Copyright © 2016 Xision. All rights reserved.
//

import UIKit

// NSCoding is a protocall that allows you to save data to the disk, write and read data.
class Cell2: NSObject, NSCoding {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    // init used for loading an object of the class
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "nameTable") as! String
    }
    
    // used for saving
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "nameTable")
    }
}
