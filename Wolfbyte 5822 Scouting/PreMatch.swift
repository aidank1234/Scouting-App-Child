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
    var data = [PreMatchData]()
    
    var filePath : String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return url!.appendingPathComponent("Data").path
    }
    private func loadData() {
        if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [PreMatchData] {
            data = ourData
        }
    }
    private func saveData(preMatchData: PreMatchData) {
        data.removeAll()
        data.append(preMatchData)
        NSKeyedArchiver.archiveRootObject(data, toFile: filePath)
    }
    
    
    
    
    
    var connected = false
    var childrenAdded = false
    var titleLabel = SKLabelNode()
    var enterMatchAlliance = UITextField()
    var enterTeamNumber = UITextField()
    var enterYourName = UITextField()
    var tag = 0
    var currentData : PreMatchData?
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
        let sceneWidth = self.frame.height
        let sceneHeight = self.frame.height
        
        loadData()
        if data.isEmpty == false {
            currentData = data[0]
            tag = (currentData?.currentPosTag)!
            completeDataString = (currentData?.arrayToSave)!
        }
        else {
            tag = 1
            completeDataString.append("Alliance Color, Robot #, Scout Name\n")
            currentData = PreMatchData(array: completeDataString)
            currentData?.currentPosTag = tag
        }
        
        backgroundColor = UIColor(netHex: 0x7A3E48)
        
        let titleLabelRect = CGRect(x: view.center.x - sceneWidth/4, y: sceneHeight - (sceneHeight/4), width: sceneWidth/2, height: sceneHeight/4)
        titleLabel.position = CGPoint(x: view.center.x - titleLabelRect.width/2, y: sceneHeight - (sceneHeight/4))
        titleLabel.text = "Pre-Match Data"
        titleLabel.fontName = "Arial"
        titleLabel.fontColor = UIColor(netHex: 0xEECD86)
        titleLabel.zPosition = 1
        adjustLabelFontSizeToFitRect(labelNode: titleLabel, rect: titleLabelRect)
        self.addChild(titleLabel)
        
        showActivityIndicatory(uiView: self.view!)
        
        enterMatchAlliance = UITextField(frame: CGRect(x: view.center.x - titleLabelRect.width, y: titleLabelRect.midY - (sceneWidth/1.5), width: titleLabelRect.width * 2, height: titleLabelRect.height/2))
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
            var sendingString = Data()
            if name == "Next"
            {
                if tag == 1 {
                    sendingString = (self.enterMatchAlliance.text?.data(using: String.Encoding.utf8,
                                                                        allowLossyConversion: false))!
                    allianceString = enterMatchAlliance.text!
                    enterMatchAlliance.removeFromSuperview()
                    self.view?.addSubview(enterTeamNumber)
                    tag = 2
                    currentData?.currentPosTag = tag
                }
                else if tag == 2 {
                    sendingString = (self.enterTeamNumber.text?.data(using: String.Encoding.utf8,
                                                                     allowLossyConversion: false))!
                    robotNumber = enterTeamNumber.text!
                    enterTeamNumber.removeFromSuperview()
                    self.view?.addSubview(enterYourName)
                    tag = 3
                    currentData?.currentPosTag = tag
                }
                else if tag == 3 {
                    sendingString = (self.enterYourName.text?.data(using: String.Encoding.utf8, allowLossyConversion: false))!
                    nameString = enterYourName.text!
                    enterYourName.removeFromSuperview()
                    tag = 4
                    currentData?.currentPosTag = tag
                }
                else if tag == 4 {
                    completeDataString.append("\(allianceString), \(robotNumber), \(nameString)\n")
                    let file = "File.csv"
                    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        
                        let path = dir.appendingPathComponent(file)
                        
                        //writing
                        do {
                            try completeDataString.write(to: path, atomically: false, encoding: String.Encoding.utf8.rawValue)
                        }
                        catch {/* error handling here */}
                        controller = UIDocumentInteractionController(url: path)
                    controller.presentOpenInMenu(from: CGRect(x:0,y:0,width:400,height:400), in: self.view!, animated: true)
                    }
                }
                do {
                    try self.session.send(sendingString, toPeers: self.session.connectedPeers, with: MCSessionSendDataMode.reliable)
                    
                    saveData(preMatchData: currentData!)
                    
                }
                catch {
                    print("ERROR")
                }

            }
        }

    }
    
    func addChildren() {
        actInd.removeFromSuperview()
        if tag == 1 {
            view?.addSubview(enterMatchAlliance)
        }
        else if tag == 2 {
            view?.addSubview(enterTeamNumber)
        }
        else if tag == 3 {
            view?.addSubview(enterYourName)
        }
        self.addChild(themedButton.button)
        self.addChild(themedButton.label)
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
    }
    func session(_ session: MCSession, didReceive data: Data,
                 fromPeer peerID: MCPeerID)  {
        // Called when a peer sends an NSData to us

    }
    func proceedToMain() -> Void {
        
    }
    
}


