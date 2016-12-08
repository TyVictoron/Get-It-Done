//
//  Cell.swift
//  Get It Done
//
//  Created by Ty Victorson on 11/16/16.
//  Copyright © 2016 Xision. All rights reserved.
//

import UIKit

// NSCoding is a protocall that allows you to save data to the disk, write and read data.
class Cell: NSObject, NSCoding {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    // init used for loading an object of the class
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        image = aDecoder.decodeObject(forKey: "image") as! String
    }
    
    // used for saving
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
    }
}
