//
//  File.swift
//  Wolfbyte 5822 Scouting
//
//  Created by Aidan Kaiser on 1/23/17.
//  Copyright © 2017 Aidan Kaiser. All rights reserved.
//

import Foundation

class PreMatchData: NSObject, NSCoding {
    var arrayToSave = NSMutableString()
    var currentPosTag = Int()
    
    init(array: NSMutableString)
    {
        self.arrayToSave = array
        currentPosTag = 1
    }
    
    required init(coder aDecoder : NSCoder) {
        self.arrayToSave = aDecoder.decodeObject(forKey: "PreMatchArray") as! NSMutableString
        self.currentPosTag = aDecoder.decodeInteger(forKey: "tag")
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(arrayToSave, forKey: "PreMatchArray")
        aCoder.encode(currentPosTag, forKey: "tag")
    }
}
