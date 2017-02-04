//
//  PreMatch.swift
//  Wolfbyte 5822 Scouting
//
//  Created by Aidan Kaiser on 1/21/17.
//  Copyright © 2017 Aidan Kaiser. All rights reserved.
//

import Foundation
import SpriteKit
import MultipeerConnectivity

class PreMatch : SKScene, MCSessionDelegate {
    
    var connected = false
    var childrenAdded = false
    var titleLabel = SKLabelNode()
    var enterMatchAlliance = UITextField()
    var enterTeamNumber = UITextField()
    var enterYourName = UITextField()
    var tag = 0
    var completeDataString = NSMutableString()
    var themedButton = ThemedButton()
    var controller = UIDocumentInteractionController()
    
    
    var assistant : MCAdvertiserAssistant!
    var session : MCSession!
    var peerID: MCPeerID!
    let serviceType = "SCOUTING-APP"
    
    var allianceString = ""
    var robotNumber = ""
    var nameString = ""
    
    
    var autonomousDiv = SKShapeNode()
    var teleopDiv = SKShapeNode()
    var autoLabel = SKLabelNode()
    var teleopLabel = SKLabelNode()
    var logo = SKSpriteNode()
    var logoLabel = SKLabelNode()
    var zoneKey = SKSpriteNode()
    var zoneKeyLabel  = SKLabelNode()
    var didNotMoveLabel = SKLabelNode()
    var didNotMoveBox = CheckBox(sceneWidth: 0, sceneHeight: 0, name: "")
    var crossBaseLineLabel = SKLabelNode()
    var crossBaseLineBox = CheckBox(sceneWidth: 0, sceneHeight: 0, name: "")
    var attemptGearLabel = SKLabelNode()
    var attemptGearBox = CheckBox(sceneWidth: 0, sceneHeight: 0, name: "")
    var madeGearLabel = SKLabelNode()
    var madeGearBox = CheckBox(sceneWidth: 0, sceneHeight: 0, name: "")
    var attemptShotLabel = SKLabelNode()
    var attemptShotBox = CheckBox(sceneWidth: 0, sceneHeight: 0, name: "")
    var zoneLabel = SKLabelNode()
    var zone1Label = SKLabelNode()
    var zone2Label = SKLabelNode()
    var zone3Label = SKLabelNode()
    var estimatedShotAccuracy = UITextField()
    var attemptHopperLabel = SKLabelNode()
    var attemptHopperBox = CheckBox(sceneWidth: 0, sceneHeight: 0, name: "")
    
    
    
    var actInd = UIActivityIndicatorView()
    
    func adjustLabelFontSizeToFitRect(labelNode:SKLabelNode, rect:CGRect) {
        
        // Determine the font scaling factor that should let the label text fit in the given rectangle.
        let scalingFactor = min(rect.width / labelNode.frame.width, rect.height / labelNode.frame.height)
        
        // Change the fontSize.
        labelNode.fontSize *= scalingFactor
        
        // Optionally move the SKLabelNode to the center of the rectangle.
        labelNode.position = CGPoint(x: rect.midX, y: rect.midY - labelNode.frame.height / 2.0)
    }
    
    override func didMove(to view: SKView) {
        let sceneWidth = self.frame.width
        let sceneHeight = self.frame.height
        
        let defaults = UserDefaults.standard
        if defaults.integer(forKey: "tag") < 1 {
            tag = 1
            defaults.set(tag, forKey: "tag")
            defaults.synchronize()
        }
        else {
            tag = defaults.integer(forKey: "tag")
        }
        
        backgroundColor = UIColor(netHex: 0x7A3E48)
        
        let titleLabelRect = CGRect(x: view.center.x - sceneWidth/4, y: sceneHeight - (sceneHeight/4), width: sceneWidth/2, height: sceneHeight/4)
        titleLabel.position = CGPoint(x: view.center.x - titleLabelRect.width/2, y: sceneHeight - (sceneHeight/4))
        titleLabel.text = "Pre-Match Data"
        titleLabel.fontName = "Arial"
        titleLabel.fontColor = UIColor(netHex: 0xEECD86)
        titleLabel.zPosition = 1
        adjustLabelFontSizeToFitRect(labelNode: titleLabel, rect: titleLabelRect)
        
        showActivityIndicatory(uiView: self.view!)
        
        enterMatchAlliance = UITextField(frame: CGRect(x: view.center.x - titleLabelRect.width, y: titleLabelRect.midY - (sceneHeight/1.5), width: titleLabelRect.width * 2, height: titleLabelRect.height/2))
        enterMatchAlliance.placeholder = "Enter Match Alliance"
        enterMatchAlliance.borderStyle = .roundedRect
        enterMatchAlliance.backgroundColor = UIColor(netHex: 0xEECD86)
        enterMatchAlliance.textAlignment = .center
        enterMatchAlliance.textColor = UIColor(netHex: 0x7A3E48)
        enterMatchAlliance.adjustsFontSizeToFitWidth = true
        
        enterTeamNumber = UITextField(frame: enterMatchAlliance.frame)
        enterTeamNumber.placeholder = "Enter the Robot's Number"
        enterTeamNumber.borderStyle = .roundedRect
        enterTeamNumber.backgroundColor = enterMatchAlliance.backgroundColor
        enterTeamNumber.textAlignment = .center
        enterTeamNumber.textColor = enterMatchAlliance.textColor
        enterTeamNumber.adjustsFontSizeToFitWidth = true
        
        enterYourName = UITextField(frame: enterMatchAlliance.frame)
        enterYourName.placeholder = "Enter Your Name"
        enterYourName.borderStyle = .roundedRect
        enterYourName.backgroundColor = enterMatchAlliance.backgroundColor
        enterYourName.textAlignment = .center
        enterYourName.textColor = enterMatchAlliance.textColor
        enterYourName.adjustsFontSizeToFitWidth = true
        
        themedButton = ThemedButton(size: titleLabelRect.size, x: titleLabel.position.x, y: sceneHeight/6, name: "Next")
        
        
        autonomousDiv = SKShapeNode(rectOf: CGSize(width: sceneWidth, height: sceneHeight/3))
        autonomousDiv.position = CGPoint(x: view.center.x, y: sceneHeight - (sceneHeight/3/2))
        autonomousDiv.fillColor = UIColor(netHex: 0x7A3E48)
        autonomousDiv.strokeColor = autonomousDiv.fillColor
        autonomousDiv.zPosition = 1
        
        teleopDiv = SKShapeNode(rectOf: CGSize(width: sceneWidth, height: sceneHeight - sceneHeight/3))
        teleopDiv.position = CGPoint(x: sceneWidth/2, y: sceneHeight - sceneHeight/3 - teleopDiv.frame.height/2)
        teleopDiv.fillColor = UIColor(netHex: 0xEECD86)
        teleopDiv.strokeColor = teleopDiv.fillColor
        teleopDiv.zPosition = 1
        
        logo = SKSpriteNode(imageNamed: "wolfbyteLogo")
        logo.size = CGSize(width: sceneWidth/8, height: sceneWidth/8)
        logo.position = CGPoint(x: sceneWidth - sceneHeight/10, y: sceneHeight - sceneHeight/10)
        logo.zPosition = 2
        
        let logoLabelRect = CGRect(x: sceneWidth - sceneHeight/10, y: logo.position.y - logo.size.height/2 - sceneWidth/20, width: logo.size.width, height: logo.size.height/5)
        logoLabel.text = "Wolfbyte 5822"
        logoLabel.fontColor = UIColor(netHex: 0xEECD86)
        logoLabel.fontName = "Arial"
        adjustLabelFontSizeToFitRect(labelNode: logoLabel, rect: logoLabelRect)
        logoLabel.position = CGPoint(x: logoLabelRect.minX, y: logoLabelRect.midY)
        logoLabel.zPosition = 2
        
        zoneKey = SKSpriteNode(imageNamed: "zoneKey")
        zoneKey.size = CGSize(width: sceneWidth/8, height: sceneWidth/8)
        zoneKey.position = CGPoint(x: logo.position.x - logo.size.width - sceneWidth/10, y: logo.position.y)
        zoneKey.zPosition = 2
        
        let zoneKeyLabelRect = CGRect(x: zoneKey.position.x, y: zoneKey.position.y - zoneKey.size.height/2 - sceneWidth/20, width: zoneKey.size.width, height: zoneKey.size.height/5)
        zoneKeyLabel.text = "Zone Key"
        zoneKeyLabel.fontColor = UIColor(netHex: 0xEECD86)
        zoneKeyLabel.fontName = "Arial"
        adjustLabelFontSizeToFitRect(labelNode: zoneKeyLabel, rect: zoneKeyLabelRect)
        zoneKeyLabel.position = CGPoint(x: zoneKeyLabelRect.minX, y: zoneKeyLabelRect.midY)
        zoneKeyLabel.zPosition = 2
        
        
        
        let autoLabelRect = CGRect(x: sceneWidth/10, y: sceneHeight - sceneHeight/10, width: sceneWidth/10, height: sceneHeight/10)
        autoLabel.text = "Autonomous"
        autoLabel.fontColor = UIColor(netHex: 0xEECD86)
        autoLabel.fontName = "Arial-Bold"
        adjustLabelFontSizeToFitRect(labelNode: autoLabel, rect: autoLabelRect)
        autoLabel.position = CGPoint(x: sceneWidth/10, y: sceneHeight - sceneHeight/20)
        autoLabel.zPosition = 2
        
        let didNotMoveLabelRect = CGRect(x: sceneWidth/10, y: autoLabelRect.midY - autoLabelRect.height, width: sceneWidth/10, height: sceneHeight/10)
        didNotMoveLabel.text = "Did Not Move:"
        didNotMoveLabel.fontColor = UIColor(netHex: 0xEECD86)
        didNotMoveLabel.fontName = "Arial"
        adjustLabelFontSizeToFitRect(labelNode: didNotMoveLabel, rect: didNotMoveLabelRect)
        didNotMoveLabel.position = CGPoint(x: sceneWidth/10, y: autoLabelRect.midY - autoLabelRect.height/2)
        didNotMoveLabel.zPosition = 2
        
        didNotMoveBox = CheckBox(sceneWidth: sceneWidth, sceneHeight: sceneHeight, name: "DidNotMoveBox")
        didNotMoveBox.setPosition(x: sceneWidth/10 + sceneWidth/15, y: didNotMoveLabelRect.midY + sceneWidth/200)
        didNotMoveBox.node.zPosition = 2
        didNotMoveBox.adjustSize()
        
        let crossBaseLineRect = CGRect(x: sceneWidth/10, y: didNotMoveLabelRect.midY-didNotMoveLabelRect.height, width: sceneWidth/10, height: sceneHeight/10)
        crossBaseLineLabel.text = "Crossed Base Line:"
        crossBaseLineLabel.fontName = "Arial"
        crossBaseLineLabel.fontColor = UIColor(netHex: 0xEECD86)
        adjustLabelFontSizeToFitRect(labelNode: crossBaseLineLabel, rect: crossBaseLineRect)
        crossBaseLineLabel.position = CGPoint(x: crossBaseLineRect.minX, y: crossBaseLineRect.midY)
        crossBaseLineLabel.zPosition = 2
        
        crossBaseLineBox = CheckBox(sceneWidth: sceneWidth, sceneHeight: sceneHeight, name: "CrossBaseLineBox")
        crossBaseLineBox.setPosition(x: sceneWidth/10 + sceneWidth/15, y: crossBaseLineRect.midY + sceneWidth/200)
        crossBaseLineBox.node.zPosition = 2
        crossBaseLineBox.adjustSize()
        
        let attemptGearLabelRect = CGRect(x: sceneWidth/10, y: crossBaseLineRect.midY-crossBaseLineRect.height, width: sceneWidth/10, height: sceneHeight/10)
        attemptGearLabel.text = "Attempted Gear?:"
        attemptGearLabel.fontName = "Arial"
        attemptGearLabel.fontColor = UIColor(netHex: 0xEECD86)
        adjustLabelFontSizeToFitRect(labelNode: attemptGearLabel, rect: attemptGearLabelRect)
        attemptGearLabel.position = CGPoint(x: attemptGearLabelRect.minX, y: attemptGearLabelRect.midY)
        attemptGearLabel.zPosition = 2
        
        attemptGearBox = CheckBox(sceneWidth: sceneWidth, sceneHeight: sceneHeight, name: "AttemptGearBox")
        attemptGearBox.setPosition(x: sceneWidth/10 + sceneWidth/15, y: attemptGearLabelRect.midY + sceneWidth/200)
        attemptGearBox.node.zPosition = 2
        attemptGearBox.adjustSize()
        
        let madeGearLabelRect = CGRect(x: attemptGearLabelRect.maxX + sceneWidth/20, y: attemptGearLabelRect.midY, width: sceneWidth/10, height: sceneHeight/10)
        madeGearLabel.text = "Made Gear?:"
        madeGearLabel.fontName = "Arial"
        madeGearLabel.fontColor = UIColor(netHex: 0xEECD86)
        adjustLabelFontSizeToFitRect(labelNode: madeGearLabel, rect: madeGearLabelRect)
        madeGearLabel.position = CGPoint(x: madeGearLabelRect.minX, y: madeGearLabelRect.midY - madeGearLabelRect.height/2)
        madeGearLabel.zPosition = 2
        
        madeGearBox = CheckBox(sceneWidth: sceneWidth, sceneHeight: sceneHeight, name: "MadeGearBox")
        madeGearBox.setPosition(x: madeGearLabelRect.minX + sceneWidth/15, y: madeGearLabelRect.midY - madeGearBox.node.frame.height)
        madeGearBox.node.zPosition = 2
        madeGearBox.adjustSize()
        
        let attemptShotLabelRect = CGRect(x: didNotMoveLabelRect.maxX + sceneWidth/20, y: didNotMoveLabelRect.midY, width: sceneWidth/10, height: sceneHeight/10)
        attemptShotLabel.text = "Attempt Shot?:"
        attemptShotLabel.fontName = "Arial"
        attemptShotLabel.fontColor = UIColor(netHex: 0xEECD86)
        adjustLabelFontSizeToFitRect(labelNode: attemptShotLabel, rect: attemptShotLabelRect)
        attemptShotLabel.position = CGPoint(x: attemptShotLabelRect.minX, y: attemptShotLabelRect.midY - madeGearLabelRect.height/2)
        attemptShotLabel.zPosition = 2
        
        attemptShotBox = CheckBox(sceneWidth: sceneWidth, sceneHeight: sceneHeight, name: "AttemptShotBox")
        attemptShotBox.setPosition(x: attemptShotLabelRect.minX + sceneWidth/15, y: attemptShotLabelRect.midY - attemptShotBox.node.frame.height)
        attemptShotBox.node.zPosition = 2
        attemptShotBox.adjustSize()
    
        let
        
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none)
        self.session.delegate = self
        
        self.assistant = MCAdvertiserAssistant(serviceType:serviceType,
                                               discoveryInfo:nil, session:self.session)
        self.assistant.start()
    }
    override func update(_ currentTime: TimeInterval) {
        if connected == true && childrenAdded == false {
            addChildren()
            childrenAdded = true
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        print(positionInScene)
        
        if let name = touchedNode.name
        {
            if name == "Next"
            {
                if tag == 1 {
                    allianceString = enterMatchAlliance.text!
                    enterMatchAlliance.removeFromSuperview()
                    UserDefaults.standard.set(allianceString, forKey: "AllianceString")
                    UserDefaults.standard.synchronize()
                    self.view?.addSubview(enterTeamNumber)
                    tag = 2
                    UserDefaults.standard.set(tag, forKey: "tag")
                    UserDefaults.standard.synchronize()
                }
                else if tag == 2 {
                    let aDefault = UserDefaults.standard
                    robotNumber = enterTeamNumber.text!
                    aDefault.set(robotNumber, forKey: "RobotNumber")
                    aDefault.synchronize()
                    enterTeamNumber.removeFromSuperview()
                    self.view?.addSubview(enterYourName)
                    tag = 3
                    UserDefaults.standard.set(tag, forKey: "tag")
                    UserDefaults.standard.synchronize()
                }
                else if tag == 3 {
                    let aDefault = UserDefaults.standard
                    nameString = enterYourName.text!
                    aDefault.set(nameString, forKey: "NameString")
                    aDefault.synchronize()
                    enterYourName.removeFromSuperview()
                    tag = 4
                    UserDefaults.standard.set(tag, forKey: "tag")
                    UserDefaults.standard.synchronize()
                    
                    completeDataString.append("\(allianceString), \(robotNumber), \(nameString)\n")
                    
                    let completeString = completeDataString.data(using: String.Encoding.utf8.rawValue)
                    do {
                        try self.session.send(completeString!, toPeers: self.session.connectedPeers, with: MCSessionSendDataMode.reliable)

                    }
                    catch {
                        print("ERROR")
                    }
                    
                    self.removeAllChildren()
                    self.addChild(autonomousDiv)
                    self.addChild(teleopDiv)
                    self.addChild(logo)
                    self.addChild(zoneKey)
                    self.addChild(zoneKeyLabel)
                    self.addChild(logoLabel)
                    self.addChild(autoLabel)
                    self.addChild(didNotMoveLabel)
                    self.addChild(didNotMoveBox.node)
                    self.addChild(crossBaseLineLabel)
                    self.addChild(crossBaseLineBox.node)
                    self.addChild(attemptGearLabel)
                    self.addChild(attemptGearBox.node)
                    self.addChild(madeGearLabel)
                    self.addChild(madeGearBox.node)
                    self.addChild(attemptShotLabel)
                    self.addChild(attemptShotBox.node)
                }
            }
            if name == "DidNotMoveBox" {
                didNotMoveBox.changeValue()
            }
            if name == "CrossBaseLineBox" {
                crossBaseLineBox.changeValue()
            }
            if name == "AttemptGearBox" {
                attemptGearBox.changeValue()
            }
            if name == "MadeGearBox" {
                madeGearBox.changeValue()
            }
        }

    }
    
    func addChildren() {
        actInd.removeFromSuperview()
        if tag == 1 {
            self.addChild(titleLabel)
            view?.addSubview(enterMatchAlliance)
            self.addChild(themedButton.button)
            self.addChild(themedButton.label)

        }
        else if tag == 2 {
            self.addChild(titleLabel)
            let defaults = UserDefaults.standard
            let loadedString = defaults.string(forKey: "AllianceString")
            allianceString = loadedString!
            view?.addSubview(enterTeamNumber)
            self.addChild(themedButton.button)
            self.addChild(themedButton.label)
        }
        else if tag == 3 {
            self.addChild(titleLabel)
            let defaults = UserDefaults.standard
            let loadedString = defaults.string(forKey: "RobotNumber")
            robotNumber = loadedString!
            view?.addSubview(enterYourName)
            self.addChild(themedButton.button)
            self.addChild(themedButton.label)
        }
        else if tag == 4 {
            self.addChild(autonomousDiv)
            self.addChild(teleopDiv)
            self.addChild(logo)
            self.addChild(zoneKey)
            self.addChild(zoneKeyLabel)
            self.addChild(logoLabel)
            self.addChild(autoLabel)
            self.addChild(didNotMoveLabel)
            self.addChild(didNotMoveBox.node)
            self.addChild(crossBaseLineLabel)
            self.addChild(crossBaseLineBox.node)
            self.addChild(attemptGearLabel)
            self.addChild(attemptGearBox.node)
            self.addChild(madeGearLabel)
            self.addChild(madeGearBox.node)
            self.addChild(attemptShotLabel)
            self.addChild(attemptShotBox.node)
        }
    }
    
    func showActivityIndicatory(uiView: UIView) {
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        actInd.center = uiView.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        uiView.addSubview(actInd)
        actInd.startAnimating()
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
        // Called when a connected peer changes state (for example, goes offline)
        
        if state == .connected {
            connected = true
        }
            /*
        else if state == .connecting || state == .notConnected {
            if childrenAdded == true {
                if tag == 0 {
                    enterMatchAlliance.removeFromSuperview()
                    themedButton.button.removeFromParent()
                    themedButton.label.removeFromParent()
                    showActivityIndicatory(uiView: self.view!)
                }
                else if tag == 2 {
                    enterTeamNumber.removeFromSuperview()
                    themedButton.button.removeFromParent()
                    themedButton.label.removeFromParent()
                    showActivityIndicatory(uiView: self.view!)
                }
                else if tag == 3 {
                    enterTeamNumber.removeFromSuperview()
                    themedButton.button.removeFromParent()
                    themedButton.label.removeFromParent()
                    showActivityIndicatory(uiView: self.view!)
                }
                childrenAdded = false
            }
        }
 */
    }
    func session(_ session: MCSession, didReceive data: Data,
                 fromPeer peerID: MCPeerID)  {
        // Called when a peer sends an NSData to us

    }
    
}


