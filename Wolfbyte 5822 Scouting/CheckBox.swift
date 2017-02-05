//
//  CheckBox.swift
//  Wolfbyte 5822 Scouting
//
//  Created by Aidan Kaiser on 1/28/17.
//  Copyright © 2017 Aidan Kaiser. All rights reserved.
//

import Foundation
import SpriteKit

class CheckBox {
    var node = SKSpriteNode()
    var sceneWidth : CGFloat!
    var sceneHeight : CGFloat!
    var value : Int!
    var name : String!
    private var uncheckedTexture = SKTexture(image: #imageLiteral(resourceName: "unChecked"))
    private var checkedTexture = SKTexture(image: #imageLiteral(resourceName: "checked"))
    
    init(sceneWidth: CGFloat, sceneHeight: CGFloat, name : String) {
        self.sceneWidth = sceneWidth
        self.sceneHeight = sceneHeight
        self.name = name
        value = 0
        
        node = SKSpriteNode(texture: uncheckedTexture)
        node.name = name
        node.size = CGSize(width: sceneWidth/35, height: sceneWidth/35)
    }
    
    func setPosition(x : CGFloat, y: CGFloat) -> Void {
        node.position = CGPoint(x: x, y: y)
    }
    
    func changeValue() -> Void {
        let defaults = UserDefaults.standard
        
        if value == 0 {
            node.texture = checkedTexture
            if name == "DidNotMoveBox" {
                defaults.set(5, forKey: "didNotMove")
            }
            else if name == "CrossBaseLineBox" {
                defaults.set(5, forKey: "crossBaseLine")
            }
            else if name == "AttemptGearBox" {
                defaults.set(5, forKey: "attemptGear")
            }
            else if name == "MadeGearBox" {
                defaults.set(5, forKey: "madeGear")
            }
            else if name == "AttemptShotBox" {
                defaults.set(5, forKey: "attemptShot")
            }
            else if name == "Zone1Box" {
                defaults.set(5, forKey: "zone1")
            }
            else if name == "Zone2Box" {
                defaults.set(5, forKey: "zone2")
            }
            else if name == "Zone3Box" {
                defaults.set(5, forKey: "zone3")
            }
            value = 5
        }
        else if value == 5 {
            node.texture = uncheckedTexture
            if name == "DidNotMoveBox" {
                defaults.set(0, forKey: "didNotMove")
            }
            else if name == "CrossBaseLineBox" {
                defaults.set(0, forKey: "crossBaseLine")
            }
            else if name == "AttemptGearBox" {
                defaults.set(0, forKey: "attemptGear")
            }
            else if name == "MadeGearBox" {
                defaults.set(0, forKey: "madeGear")
            }
            else if name == "AttemptShotBox" {
                defaults.set(0, forKey: "attemptShot")
            }
            else if name == "Zone1Box" {
                defaults.set(0, forKey: "zone1")
            }
            else if name == "Zone2Box" {
                defaults.set(0, forKey: "zone2")
            }
            else if name == "Zone3Box" {
                defaults.set(0, forKey: "zone3")
            }
            value = 0
        }
        defaults.synchronize()
    }
    func setValue(aValue : Int) -> Void {
        if aValue == 0 {
            value = 0
            node.texture = uncheckedTexture
        }
        else if aValue == 5 {
            value = 5
            node.texture = checkedTexture
        }
        else {
            print("ERROR")
        }
    }
    
    func adjustSize() -> Void {
        node.size = CGSize(width: sceneWidth/40, height: sceneWidth/40)
    }
    
}
