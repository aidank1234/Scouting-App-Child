//
//  ThemedButton.swift
//  Wolfbyte 5822 Scouting
//
//  Created by Aidan Kaiser on 1/21/17.
//  Copyright © 2017 Aidan Kaiser. All rights reserved.
//

import Foundation
import SpriteKit

class ThemedButton{
    var button : SKShapeNode
    var label = SKLabelNode()
    var pos : CGPoint
    var tapped = false
    private var newRect = CGRect()
    
    init() {
        button = SKShapeNode()
        pos = CGPoint()
    }
    private func adjustLabelFontSizeToFitRect(labelNode:SKLabelNode, rect:CGRect) {
        
        // Determine the font scaling factor that should let the label text fit in the given rectangle.
        let scalingFactor = min(rect.width / labelNode.frame.width, rect.height / labelNode.frame.height)
        
        // Change the fontSize.
        labelNode.fontSize *= scalingFactor
        
        // Optionally move the SKLabelNode to the center of the rectangle.
        labelNode.position = CGPoint(x: rect.midX, y: rect.midY - labelNode.frame.height / 2.0)
    }
    
    init(size: CGSize, x: CGFloat, y: CGFloat, name: String) {
        tapped = false
        button = SKShapeNode(rectOf: size, cornerRadius: 7.0)
        pos = CGPoint(x: x, y: y)
        let rectPos = CGPoint(x: x-(size.width/2), y: y/2)
        button.position = pos
        button.name = name
        label.name = name
        label.text = name
        label.fontName = "Arial"
        label.position = CGPoint(x: button.frame.midX, y: button.frame.midY)
        label.fontColor = UIColor(netHex: 0x7A3E48)
        newRect = CGRect(origin: rectPos, size: size)
        label.fontSize = 20
        adjustLabelFontSizeToFitRect(labelNode: label, rect: newRect)
        label.blendMode = .replace
        button.fillColor = UIColor(netHex: 0xEECD86)
        button.strokeColor = UIColor(netHex: 0xEECD86)
        
    }
    func changeButtonName(newName : String) -> Void {
        label.name = newName
        label.text = newName
        adjustLabelFontSizeToFitRect(labelNode: label, rect: newRect)
    }
    func becomeTapped() -> Void {
        tapped = true
        button.fillColor = UIColor(netHex: 0x7A3E48)
        button.strokeColor = UIColor(netHex: 0x7A3E48)
        label.fontColor = UIColor(netHex: 0xEECD86)
    }
    func becomeUntapped() -> Void  {
        tapped = false
        button.fillColor = UIColor(netHex: 0xEECD86)
        button.strokeColor = UIColor(netHex: 0xEECD86)
        label.fontColor = UIColor(netHex: 0x7A3E48)
    }
    func isTapped() -> Bool {
        var returnValue = false
        if tapped == true {
            returnValue = true
        }
        else {
            returnValue = false
        }
        return returnValue
    }
}
