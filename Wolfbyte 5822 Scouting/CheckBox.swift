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
    private var uncheckedTexture = SKTexture(image: #imageLiteral(resourceName: "unChecked"))
    private var checkedTexture = SKTexture(image: #imageLiteral(resourceName: "checked"))
    
    init(sceneWidth: CGFloat, sceneHeight: CGFloat, name : String) {
        self.sceneWidth = sceneWidth
        self.sceneHeight = sceneHeight
        value = 0
        
        node = SKSpriteNode(texture: uncheckedTexture)
        node.name = name
        node.size = CGSize(width: sceneWidth/35, height: sceneWidth/35)
    }
    
    func setPosition(x : CGFloat, y: CGFloat) -> Void {
        node.position = CGPoint(x: x, y: y)
    }
    
    func changeValue() -> Void {
        if value == 0 {
            node.texture = checkedTexture
            value = 5
        }
        else if value == 5 {
            node.texture = uncheckedTexture
            value = 0
        }
        
    }
    
    func adjustSize() -> Void {
        node.size = CGSize(width: sceneWidth/40, height: sceneWidth/40)
    }
    
}
