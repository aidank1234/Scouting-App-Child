//
//  GameScene.swift
//  Wolfbyte 5822 Scouting
//
//  Created by Aidan Kaiser on 1/21/17.
//  Copyright © 2017 Aidan Kaiser. All rights reserved.
//

import SpriteKit
import UIKit
import MultipeerConnectivity

class GameScene: SKScene, MCSessionDelegate {
    
    
    var upperMaroonDiv = SKShapeNode()
    var upperGoldDiv = SKShapeNode()
    
    override func didMove(to view: SKView) {
        let sceneWidth = self.frame.width
        let sceneHeight = self.frame.height

        
        
        /*
        upperMaroonDiv = SKShapeNode(rectOf: CGSize(width: sceneWidth/3, height: sceneHeight/2.5))
        upperMaroonDiv.position = CGPoint(x: sceneWidth/3/2, y: sceneHeight - sceneHeight/2.5/2)
        upperMaroonDiv.fillColor = UIColor(netHex: 0x7A3E48)
        upperMaroonDiv.strokeColor = upperMaroonDiv.fillColor
        upperMaroonDiv.zPosition = 1
        self.addChild(upperMaroonDiv)
        
        upperGoldDiv = SKShapeNode(rectOf: CGSize(width: sceneWidth - sceneWidth/3, height: sceneHeight/2.5))
        upperGoldDiv.position = CGPoint(x: sceneWidth  - (upperGoldDiv.frame.width/2), y: sceneHeight - sceneHeight/2.5/2)
        upperGoldDiv.fillColor = UIColor(netHex: 0xEECD86)
        upperGoldDiv.strokeColor = upperGoldDiv.fillColor
        upperGoldDiv.zPosition = 1
        self.addChild(upperGoldDiv)
        */
        
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    // The following methods do nothing, but the MCSessionDelegate protocol
    // requires that we implement them.
    func session(_ session: MCSession,
                 didStartReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID, with progress: Progress)  {
        
        // Called when a peer starts sending a file to us
    }
    
    func session(_ session: MCSession,
                 didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 at localURL: URL, withError error: Error?)  {
        // Called when a file has finished transferring from another peer
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream,
                 withName streamName: String, fromPeer peerID: MCPeerID)  {
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID,
                 didChange state: MCSessionState)  {
       
    }
    func session(_ session: MCSession, didReceive data: Data,
                 fromPeer peerID: MCPeerID)  {
        // Called when a peer sends an NSData to us
        
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
