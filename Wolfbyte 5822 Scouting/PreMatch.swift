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

class PreMatch : SKScene, MCSessionDelegate, Alerts {
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
    
    var allianceString : String!
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
    var zone1Box = CheckBox(sceneWidth: 0, sceneHeight: 0, name: "")
    var zone2Label = SKLabelNode()
    var zone2Box = CheckBox(sceneWidth: 0, sceneHeight: 0, name: "")
    var zone3Label = SKLabelNode()
    var zone3Box = CheckBox(sceneWidth: 0, sceneHeight: 0, name: "")
    var estimatedFuelMadeLabel = SKLabelNode()
    var estimatedFuelMade = UITextField()
    var madeHopperLabel = SKLabelNode()
    var madeHopperBox = CheckBox(sceneWidth: 0, sceneHeight: 0, name: "")
    var attemptLowLabel = SKLabelNode()
    var attemptLowEstimation = UITextField()
    
    var zone1FuelLabel = SKLabelNode()
    var zone1FuelAmount = UIStepper()
    var zone1FuelAmountLabel = SKLabelNode()
    var zone2FuelLabel = SKLabelNode()
    var zone2FuelAmount = UIStepper()
    var zone2FuelAmountLabel = SKLabelNode()
    var zone3FuelLabel = SKLabelNode()
    var zone3FuelAmount = UIStepper()
    var zone3FuelAmountLabel = SKLabelNode()
    var shotSpeedLabel = SKLabelNode()
    var shotSpeed = UIStepper()
    var shotSpeedAmountLabel = SKLabelNode()
    var madeGearsLabel = SKLabelNode()
    var madeGearsAmount = UIStepper()
    var madeGearsAmountLabel = SKLabelNode()
    var droppedGearsLabel = SKLabelNode()
    var droppedGearsAmount = UIStepper()
    var droppedGearsAmountLabel = SKLabelNode()
    
    var didNotMoveValue = 0
    var crossBaseLineValue = 0
    var attemptGearValue = 0
    var madeGearValue = 0
    var attemptShotValue = 0
    var zone1Value = 0
    var zone2Value = 0
    var zone3Value = 0
    var estimatedFuelValue = 0
    var madeHopperValue = 0
    var estimatedLowGoalValue = 0
    var zone1TeleopValue = 0
    var zone2TeleopValue = 0
    var zone3TeleopValue = 0
    var madeGearsValue = 0
    var missedGearsValue = 0
    var shotSpeedValue = 0
    
    var nextButton = ThemedButton()
    var previousButton = ThemedButton()
    
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
            
            defaults.set(didNotMoveValue, forKey: "didNotMove")
            defaults.set(crossBaseLineValue, forKey: "crossBaseLine")
            defaults.set(attemptGearValue, forKey: "attemptGear")
            defaults.set(madeGearValue, forKey: "madeGear")
            defaults.set(attemptShotValue, forKey: "attemptShot")
            defaults.set(zone1Value, forKey: "zone1")
            defaults.set(zone2Value, forKey: "zone2")
            defaults.set(zone3Value, forKey: "zone3")
            defaults.set(estimatedFuelValue, forKey: "estimatedFuel")
            defaults.set(madeHopperValue, forKey: "madeHopper")
            defaults.set(estimatedLowGoalValue, forKey: "estimatedLowGoal")
            defaults.set(zone1TeleopValue, forKey: "zone1Teleop")
            defaults.set(zone2TeleopValue, forKey: "zone2Teleop")
            defaults.set(zone3TeleopValue, forKey: "zone3Teleop")
            defaults.set(madeGearsValue, forKey: "madeGearsValue")
            defaults.set(missedGearsValue, forKey: "missedGearsValue")
            defaults.set(shotSpeedValue, forKey: "shotSpeedValue")
            defaults.synchronize()
        }
        else {
            tag = defaults.integer(forKey: "tag")
            didNotMoveValue = defaults.integer(forKey: "didNotMove")
            crossBaseLineValue = defaults.integer(forKey: "crossBaseLine")
            attemptGearValue = defaults.integer(forKey: "attemptGear")
            madeGearValue = defaults.integer(forKey: "madeGear")
            attemptShotValue = defaults.integer(forKey: "attemptShot")
            zone1Value = defaults.integer(forKey: "zone1")
            zone2Value = defaults.integer(forKey: "zone2")
            zone3Value = defaults.integer(forKey: "zone3")
            estimatedFuelValue = defaults.integer(forKey: "estimatedFuel")
            madeHopperValue = defaults.integer(forKey: "madeHopper")
            estimatedLowGoalValue = defaults.integer(forKey: "estimatedLowGoal")
            zone1TeleopValue = defaults.integer(forKey: "zone1Teleop")
            zone2TeleopValue = defaults.integer(forKey: "zone2Teleop")
            zone3TeleopValue = defaults.integer(forKey: "zone3Teleop")
            missedGearsValue = defaults.integer(forKey: "missedGearsValue")
            madeGearsValue = defaults.integer(forKey: "madeGearsValue")
            shotSpeedValue = defaults.integer(forKey: "shotSpeedValue")
            
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
        logo.name = "Logo"
        
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
        
        let teleopLabelRect = CGRect(x: sceneWidth/10, y: sceneHeight - sceneHeight/3 - sceneHeight/10, width: sceneWidth/10, height: sceneHeight/10)
        teleopLabel.text = "Teleop"
        teleopLabel.fontColor = enterTeamNumber.textColor
        teleopLabel.fontName = "Arial"
        adjustLabelFontSizeToFitRect(labelNode: teleopLabel, rect: teleopLabelRect)
        teleopLabel.position = CGPoint(x: teleopLabelRect.minX, y: teleopLabelRect.midY)
        teleopLabel.zPosition = 2
        
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
        didNotMoveBox.setValue(aValue: didNotMoveValue)
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
        crossBaseLineBox.setValue(aValue: crossBaseLineValue)
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
        attemptGearBox.setValue(aValue: attemptGearValue)
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
        madeGearBox.setValue(aValue: madeGearValue)
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
        attemptShotBox.setValue(aValue: attemptShotValue)
        attemptShotBox.adjustSize()
    
        let zoneLabelRect = CGRect(x: attemptShotLabelRect.maxX + sceneWidth/20, y: attemptShotLabelRect.midY, width: sceneWidth/20, height: sceneHeight/10)
        zoneLabel.text = "Zone:"
        zoneLabel.fontName = "Arial"
        zoneLabel.fontColor = UIColor(netHex: 0xEECD86)
        adjustLabelFontSizeToFitRect(labelNode: zoneLabel, rect: zoneLabelRect)
        zoneLabel.position = CGPoint(x: zoneLabelRect.minX, y: zoneLabelRect.midY - zoneLabelRect.height)
        zoneLabel.zPosition = 2
        
        let zone1Rect = CGRect(x: zoneLabelRect.midX + sceneWidth/45, y: attemptShotLabelRect.midY, width: sceneWidth/30, height: sceneHeight/10)
        zone1Label.text = "1:"
        zone1Label.fontName = "Arial"
        zone1Label.fontColor = UIColor(netHex: 0xEECD86)
        zone1Label.fontSize = attemptShotLabel.fontSize
        zone1Label.position = CGPoint(x: zone1Rect.minX, y: zone1Rect.midY - zone1Rect.height)
        zone1Label.zPosition = 2
        
        zone1Box = CheckBox(sceneWidth: sceneWidth, sceneHeight: sceneHeight, name: "Zone1Box")
        zone1Box.setPosition(x: zone1Rect.minX + sceneWidth/45, y: zone1Rect.midY - zone1Rect.height/2 - zone1Box.node.frame.height)
        zone1Box.node.zPosition = 2
        zone1Box.setValue(aValue: zone1Value)
        zone1Box.adjustSize()
        
        let zone2Rect = CGRect(x: zone1Rect.midX + sceneWidth/35, y: attemptShotLabelRect.midY, width: sceneWidth/30, height: sceneHeight/10)
        zone2Label.text = "2:"
        zone2Label.fontName = "Arial"
        zone2Label.fontColor = UIColor(netHex: 0xEECD86)
        zone2Label.fontSize = zone1Label.fontSize
        zone2Label.position = CGPoint(x: zone2Rect.minX, y: zone2Rect.midY - zone2Rect.height)
        zone2Label.zPosition = 2
        
        zone2Box = CheckBox(sceneWidth: sceneWidth, sceneHeight: sceneHeight, name: "Zone2Box")
        zone2Box.setPosition(x: zone2Rect.minX + sceneWidth/45, y: zone2Rect.midY - zone2Rect.height/2 - zone2Box.node.frame.height)
        zone2Box.node.zPosition = 2
        zone2Box.setValue(aValue: zone2Value)
        zone2Box.adjustSize()
        
        let zone3Rect = CGRect(x: zone2Rect.midX + sceneWidth/35, y: attemptShotLabelRect.midY, width: sceneWidth/30, height: sceneHeight/10)
        zone3Label.text = "3:"
        zone3Label.fontColor = UIColor(netHex: 0xEECD86)
        zone3Label.fontName = "Arial"
        zone3Label.fontSize = zone2Label.fontSize
        zone3Label.position = CGPoint(x: zone3Rect.minX, y: zone3Rect.midY - zone3Rect.height)
        zone3Label.zPosition = 2
        
        zone3Box = CheckBox(sceneWidth: sceneWidth, sceneHeight: sceneHeight, name: "Zone3Box")
        zone3Box.setPosition(x: zone3Rect.minX + sceneWidth/45, y: zone3Rect.midY - zone3Rect.height/2 - zone3Box.node.frame.height)
        zone3Box.node.zPosition = 2
        zone3Box.setValue(aValue: zone3Value)
        zone3Box.adjustSize()
        
        let estimatedFuelMadeRect = CGRect(x: zoneLabelRect.midX, y: crossBaseLineRect.midY - sceneHeight/10, width: sceneWidth/7, height: sceneHeight/10)
        estimatedFuelMadeLabel.text = "Estimated Fuel Made (High):"
        estimatedFuelMadeLabel.fontColor = UIColor(netHex: 0xEECD86)
        estimatedFuelMadeLabel.fontName = "Arial"
        adjustLabelFontSizeToFitRect(labelNode: estimatedFuelMadeLabel, rect: estimatedFuelMadeRect)
        estimatedFuelMadeLabel.position = CGPoint(x: estimatedFuelMadeRect.minX, y: estimatedFuelMadeRect.midY)
        estimatedFuelMadeLabel.zPosition = 2
        
        estimatedFuelMade = UITextField(frame: CGRect(x: view.center.x + zoneLabelRect.width/3, y: sceneHeight - (estimatedFuelMadeRect.maxY), width: zoneLabelRect.width * 2, height: zoneLabelRect.height/2))
        estimatedFuelMade.placeholder = "#"
        estimatedFuelMade.borderStyle = .roundedRect
        estimatedFuelMade.backgroundColor = UIColor(netHex: 0xEECD86)
        estimatedFuelMade.textAlignment = .center
        estimatedFuelMade.textColor = enterMatchAlliance.textColor
        estimatedFuelMade.text = "\(estimatedFuelValue)"
        estimatedFuelMade.adjustsFontSizeToFitWidth = true
        
        let madeHopperRect = CGRect(x: sceneWidth/10, y: attemptGearLabelRect.midY - attemptGearLabelRect.height, width: sceneWidth/10, height: sceneHeight/10)
        madeHopperLabel.text = "Made Hopper?:"
        madeHopperLabel.fontColor = UIColor(netHex: 0xEECD86)
        madeHopperLabel.fontName = "Arial"
        adjustLabelFontSizeToFitRect(labelNode: madeHopperLabel, rect: madeHopperRect)
        madeHopperLabel.position = CGPoint(x: madeHopperRect.minX, y: madeHopperRect.midY)
        madeHopperLabel.zPosition = 2
        
        madeHopperBox = CheckBox(sceneWidth: sceneWidth, sceneHeight: sceneHeight, name: "MadeHopperBox")
        madeHopperBox.setPosition(x: sceneWidth/10 + sceneWidth/15, y: madeHopperRect.midY + sceneWidth/200)
        madeHopperBox.node.zPosition = 2
        madeHopperBox.setValue(aValue: madeHopperValue)
        madeHopperBox.adjustSize()
        
        let attemptLowLabelRect = CGRect(x: sceneWidth/10, y: madeHopperRect.midY - madeHopperRect.height, width: sceneWidth/10, height: sceneHeight/10)
        attemptLowLabel.text = "Estimated Fuel Low:"
        attemptLowLabel.fontColor = UIColor(netHex: 0xEECD86)
        attemptLowLabel.fontName = "Arial"
        adjustLabelFontSizeToFitRect(labelNode: attemptLowLabel, rect: attemptLowLabelRect)
        attemptLowLabel.position = CGPoint(x: attemptLowLabelRect.minX, y: attemptLowLabelRect.midY)
        attemptLowLabel.zPosition = 2
            
        attemptLowEstimation = UITextField(frame: CGRect(x: view.center.x - sceneWidth/3, y: view.center.y - sceneHeight/4.25, width: zoneLabelRect.width * 2, height: zoneLabelRect.height/2))
        attemptLowEstimation.placeholder = "#"
        attemptLowEstimation.borderStyle = .roundedRect
        attemptLowEstimation.backgroundColor = UIColor(netHex: 0xEECD86)
        attemptLowEstimation.textAlignment = .center
        attemptLowEstimation.textColor = enterMatchAlliance.textColor
        attemptLowEstimation.text = "\(estimatedLowGoalValue)"
        attemptLowEstimation.adjustsFontSizeToFitWidth = true
        
        
        let zone1FuelLabelRect = CGRect(x: sceneWidth/10, y: teleopLabelRect.midY - teleopLabelRect.height, width: sceneWidth/10, height: sceneHeight/10)
        zone1FuelLabel.text = "Fuel Made Zone 1:"
        zone1FuelLabel.fontColor = teleopLabel.fontColor
        zone1FuelLabel.fontName = "Arial"
        adjustLabelFontSizeToFitRect(labelNode: zone1FuelLabel, rect: zone1FuelLabelRect)
        zone1FuelLabel.position = CGPoint(x: zone1FuelLabelRect.minX, y: zone1FuelLabelRect.midY)
        zone1FuelLabel.zPosition = 2
        
        zone1FuelAmount = UIStepper(frame: CGRect(x: attemptLowEstimation.frame.minX, y: sceneHeight/2.5, width: zoneLabelRect.width * 2, height: zoneLabelRect.height/2))
        zone1FuelAmount.autorepeat = true
        zone1FuelAmount.minimumValue = 0
        zone1FuelAmount.stepValue = 1
        zone1FuelAmount.value = 0
        zone1FuelAmount.addTarget(self, action: #selector(zone1StepperChanged), for: .valueChanged)
        
        let zone1FuelAmountLabelRect = CGRect(x: zone1FuelAmount.frame.maxX + sceneWidth/30, y: zone1FuelAmount.frame.midY + zone1FuelAmount.frame.height * 2, width: sceneWidth/10, height: sceneWidth/10)
        zone1FuelAmountLabel.text = "\(zone1TeleopValue)"
        zone1FuelAmountLabel.fontColor = teleopLabel.fontColor
        zone1FuelAmountLabel.fontName = "Arial"
        zone1FuelAmountLabel.fontSize = teleopLabel.fontSize
        zone1FuelAmountLabel.position = CGPoint(x: zone1FuelAmountLabelRect.minX, y: zone1FuelAmountLabelRect.midY)
        zone1FuelAmountLabel.zPosition = 2
        
        let zone2FuelLabelRect = CGRect(x: zone1FuelAmountLabelRect.maxX + sceneWidth/30, y: zone1FuelLabelRect.minY, width: sceneWidth/10, height: sceneHeight/10)
        zone2FuelLabel.text = "Fuel Made Zone 2:"
        zone2FuelLabel.fontColor = teleopLabel.fontColor
        zone2FuelLabel.fontName = "Arial"
        adjustLabelFontSizeToFitRect(labelNode: zone2FuelLabel, rect: zone2FuelLabelRect)
        zone2FuelLabel.position = CGPoint(x: zone2FuelLabelRect.minX, y: zone2FuelLabelRect.midY)
        zone2FuelLabel.zPosition = 2
        
        zone2FuelAmount = UIStepper(frame: CGRect(x: zone2FuelLabelRect.minX + sceneWidth/15, y: zone1FuelAmount.frame.minY, width: zone1FuelAmount.frame.width, height: zone1FuelAmount.frame.height))
        zone2FuelAmount.autorepeat = true
        zone2FuelAmount.minimumValue = 0
        zone2FuelAmount.stepValue = 1
        zone2FuelAmount.value = 0
        zone2FuelAmount.addTarget(self, action: #selector(zone2StepperChanged), for: .valueChanged)
        
        let zone2FuelAmountLabelRect = CGRect(x: zone2FuelAmount.frame.maxX + sceneWidth/30, y: zone2FuelAmount.frame.midY + zone2FuelAmount.frame.height * 2, width: sceneWidth/10, height: sceneWidth/10)
        zone2FuelAmountLabel.text = "\(zone2TeleopValue)"
        zone2FuelAmountLabel.fontColor = teleopLabel.fontColor
        zone2FuelAmountLabel.fontName = "Arial"
        zone2FuelAmountLabel.fontSize = teleopLabel.fontSize
        zone2FuelAmountLabel.position = CGPoint(x: zone2FuelAmountLabelRect.minX, y: zone2FuelAmountLabelRect.midY)
        zone2FuelAmountLabel.zPosition = 2
        
        let zone3FuelLabelRect = CGRect(x: zone2FuelAmountLabelRect.maxX + sceneWidth/30, y: zone2FuelLabelRect.minY, width: sceneWidth/10, height: sceneHeight/10)
        zone3FuelLabel.text = "Fuel Made Zone 3:"
        zone3FuelLabel.fontColor = teleopLabel.fontColor
        zone3FuelLabel.fontName = "Arial"
        adjustLabelFontSizeToFitRect(labelNode: zone3FuelLabel, rect: zone3FuelLabelRect)
        zone3FuelLabel.position = CGPoint(x: zone3FuelLabelRect.minX, y: zone3FuelLabelRect.midY)
        zone3FuelLabel.zPosition = 2
        
        zone3FuelAmount = UIStepper(frame: CGRect(x: zone3FuelLabelRect.minX + sceneWidth/15, y: zone2FuelAmount.frame.minY, width: zone2FuelAmount.frame.width, height: zone2FuelAmount.frame.height))
        zone3FuelAmount.autorepeat = true
        zone3FuelAmount.minimumValue = 0
        zone3FuelAmount.stepValue = 1
        zone3FuelAmount.value = 0
        zone3FuelAmount.addTarget(self, action: #selector(zone3StepperChanged), for: .valueChanged)
        
        let zone3FuelAmountLabelRect = CGRect(x: zone3FuelAmount.frame.maxX + sceneWidth/30, y: zone2FuelAmount.frame.midY + zone2FuelAmount.frame.height * 2, width: sceneWidth/10, height: sceneWidth/10)
        zone3FuelAmountLabel.text = "\(zone3TeleopValue)"
        zone3FuelAmountLabel.fontColor = teleopLabel.fontColor
        zone3FuelAmountLabel.fontName = "Arial"
        zone3FuelAmountLabel.fontSize = teleopLabel.fontSize
        zone3FuelAmountLabel.position = CGPoint(x: zone3FuelAmountLabelRect.minX, y: zone3FuelAmountLabelRect.midY)
        zone3FuelAmountLabel.zPosition = 2
        
        let madeGearsLabelRect = CGRect(x: sceneWidth/10, y: zone1FuelLabelRect.midY - zone1FuelLabelRect.height, width: sceneWidth/10, height: sceneHeight/10)
        madeGearsLabel.text = "Made Gears:"
        madeGearsLabel.fontColor = teleopLabel.fontColor
        madeGearsLabel.fontName = "Arial"
        adjustLabelFontSizeToFitRect(labelNode: madeGearsLabel, rect: madeGearsLabelRect)
        madeGearsLabel.position = CGPoint(x: madeGearsLabelRect.minX, y: madeGearsLabelRect.midY)
        madeGearsLabel.zPosition = 2
        
        madeGearsAmount = UIStepper(frame: CGRect(x: attemptLowEstimation.frame.minX, y: zone1FuelAmount.frame.midY + zone1FuelAmount.frame.height, width: zone1FuelAmount.frame.width, height: zone1FuelAmount.frame.height))
        madeGearsAmount.autorepeat = true
        madeGearsAmount.minimumValue = 0
        madeGearsAmount.stepValue = 1
        madeGearsAmount.value = 0
        madeGearsAmount.addTarget(self, action: #selector(madeGearsChanged), for: .valueChanged)
        
        let madeGearsAmountLabelRect = CGRect(x: madeGearsAmount.frame.maxX + sceneWidth/30, y: madeGearsAmount.frame.minY, width: sceneWidth/10, height: sceneHeight/10)
        madeGearsAmountLabel.text = "\(madeGearsValue)"
        madeGearsAmountLabel.fontColor = teleopLabel.fontColor
        madeGearsAmountLabel.fontName = "Arial"
        madeGearsAmountLabel.fontSize = teleopLabel.fontSize
        madeGearsAmountLabel.position = CGPoint(x: madeGearsAmountLabelRect.minX, y: madeGearsAmountLabelRect.midY)
        madeGearsAmountLabel.zPosition = 2
        
        let missedGearsLabelRect = CGRect(x: madeGearsAmountLabelRect.maxX + sceneWidth/30, y: madeGearsLabelRect.minY, width: sceneWidth/10, height: sceneHeight/10)
        droppedGearsLabel.text = "Dropped Gears:"
        droppedGearsLabel.fontColor = teleopLabel.fontColor
        droppedGearsLabel.fontName = "Arial"
        adjustLabelFontSizeToFitRect(labelNode: droppedGearsLabel, rect: missedGearsLabelRect)
        droppedGearsLabel.position = CGPoint(x: missedGearsLabelRect.minX, y: missedGearsLabelRect.midY)
        droppedGearsLabel.zPosition = 2
        
        droppedGearsAmount = UIStepper(frame: CGRect(x: missedGearsLabelRect.minX + sceneWidth/15, y: madeGearsAmount.frame.minY, width: madeGearsAmount.frame.width, height: madeGearsAmount.frame.height))
        droppedGearsAmount.autorepeat = true
        droppedGearsAmount.minimumValue = 0
        droppedGearsAmount.stepValue = 1
        droppedGearsAmount.value = 0
        droppedGearsAmount.addTarget(self, action: #selector(missedGearsChanged), for: .valueChanged)
        
        let droppedGearsAmountLabelRect = CGRect(x: droppedGearsAmount.frame.maxX + sceneWidth/30, y: droppedGearsAmount.frame.minY, width: sceneWidth/10, height: sceneHeight/10)
        droppedGearsAmountLabel.text = "\(missedGearsValue)"
        droppedGearsAmountLabel.fontColor = teleopLabel.fontColor
        droppedGearsAmountLabel.fontName = "Arial"
        droppedGearsAmountLabel.fontSize = teleopLabel.fontSize
        droppedGearsAmountLabel.position = CGPoint(x: droppedGearsAmountLabelRect.minX, y: droppedGearsAmountLabelRect.midY)
        droppedGearsAmountLabel.zPosition = 2
        
        let shotSpeedLabelRect = CGRect(x: sceneWidth/10, y: missedGearsLabelRect.midY - missedGearsLabelRect.height, width: sceneWidth/10, height: sceneHeight/10)
        shotSpeedLabel.text = "Shot Speed (1-5):"
        shotSpeedLabel.fontColor = teleopLabel.fontColor
        shotSpeedLabel.fontName = "Arial"
        adjustLabelFontSizeToFitRect(labelNode: shotSpeedLabel, rect: shotSpeedLabelRect)
        shotSpeedLabel.position = CGPoint(x: shotSpeedLabelRect.minX, y: shotSpeedLabelRect.midY)
        shotSpeedLabel.zPosition = 2
        
        shotSpeed = UIStepper(frame: CGRect(x: attemptLowEstimation.frame.minX, y: madeGearsAmount.frame.midY + madeGearsAmount.frame.height, width: madeGearsAmount.frame.width, height: madeGearsAmount.frame.height))
        shotSpeed.autorepeat = true
        shotSpeed.minimumValue = 0
        shotSpeed.maximumValue = 5
        shotSpeed.stepValue = 1
        shotSpeed.value = 0
        shotSpeed.addTarget(self, action: #selector(shotSpeedChanged), for: .valueChanged)
        
        let shotSpeedAmountLabelRect = CGRect(x: shotSpeed.frame.maxX + sceneWidth/30, y: shotSpeed.frame.minY - shotSpeed.frame.height * 3, width: sceneWidth/10, height: sceneHeight/10)
        shotSpeedAmountLabel.text = "\(shotSpeedValue)"
        shotSpeedAmountLabel.fontColor = teleopLabel.fontColor
        shotSpeedAmountLabel.fontName = "Arial"
        shotSpeedAmountLabel.fontSize = teleopLabel.fontSize
        shotSpeedAmountLabel.position = CGPoint(x: shotSpeedAmountLabelRect.minX, y: shotSpeedAmountLabelRect.midY)
        shotSpeedAmountLabel.zPosition = 2
        print(shotSpeedAmountLabel.position)
        
        nextButton = ThemedButton(size: CGSize(width: sceneWidth/10, height: sceneHeight/10), x: sceneWidth - sceneWidth/10, y: sceneHeight/10, name: "Finish")
        nextButton.button.fillColor = teleopLabel.fontColor!
        nextButton.button.strokeColor = nextButton.button.fillColor
        nextButton.label.fontColor = autoLabel.fontColor
        nextButton.button.zPosition = 2
        nextButton.label.zPosition = 2
        
        previousButton = ThemedButton(size: CGSize(width: sceneWidth/10, height: sceneHeight/10), x: sceneWidth/10, y: sceneHeight/10, name: "Previous")
        previousButton.button.fillColor = teleopLabel.fontColor!
        previousButton.button.strokeColor = previousButton.button.fillColor
        previousButton.label.fontColor = autoLabel.fontColor
        previousButton.button.zPosition = 2
        previousButton.label.zPosition = 2
        
        
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
        zone1FuelAmountLabel.text = "\(zone1TeleopValue)"
        zone2FuelAmountLabel.text = "\(zone2TeleopValue)"
        zone3FuelAmountLabel.text = "\(zone3TeleopValue)"
        madeGearsAmountLabel.text = "\(madeGearsValue)"
        droppedGearsAmountLabel.text = "\(missedGearsValue)"
        shotSpeedAmountLabel.text = "\(shotSpeedValue)"
    }
    func zone1StepperChanged(sender: UIStepper!) {
        zone1TeleopValue = Int(sender.value)
    }
    func zone2StepperChanged(sender: UIStepper!) {
        zone2TeleopValue = Int(sender.value)
    }
    func zone3StepperChanged(sender: UIStepper!) {
        zone3TeleopValue = Int(sender.value)
    }
    func madeGearsChanged(sender: UIStepper!) {
        madeGearsValue = Int(sender.value)
    }
    func missedGearsChanged(sender: UIStepper!) {
        missedGearsValue = Int(sender.value)
    }
    func shotSpeedChanged(sender: UIStepper!) {
        shotSpeedValue = Int(sender.value)
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
                    self.addChild(zoneLabel)
                    self.addChild(zone1Label)
                    self.addChild(zone1Box.node)
                    self.addChild(zone2Label)
                    self.addChild(zone2Box.node)
                    self.addChild(zone3Label)
                    self.addChild(zone3Box.node)
                    self.addChild(estimatedFuelMadeLabel)
                    view?.addSubview(estimatedFuelMade)
                    self.addChild(madeHopperLabel)
                    self.addChild(madeHopperBox.node)
                    self.addChild(attemptLowLabel)
                    view?.addSubview(attemptLowEstimation)
                    self.addChild(teleopLabel)
                    self.addChild(zone1FuelLabel)
                    view?.addSubview(zone1FuelAmount)
                    self.addChild(zone1FuelAmountLabel)
                    self.addChild(zone2FuelLabel)
                    self.addChild(zone2FuelAmountLabel)
                    view?.addSubview(zone2FuelAmount)
                    self.addChild(zone3FuelLabel)
                    self.addChild(zone3FuelAmountLabel)
                    view?.addSubview(zone3FuelAmount)
                    self.addChild(madeGearsLabel)
                    self.addChild(madeGearsAmountLabel)
                    view?.addSubview(madeGearsAmount)
                    self.addChild(droppedGearsLabel)
                    self.addChild(droppedGearsAmountLabel)
                    view?.addSubview(droppedGearsAmount)
                    self.addChild(shotSpeedLabel)
                    self.addChild(shotSpeedAmountLabel)
                    view?.addSubview(shotSpeed)
                    self.addChild(nextButton.button)
                    self.addChild(nextButton.label)
                    self.addChild(previousButton.button)
                    self.addChild(previousButton.label)
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
            if name == "AttemptShotBox" {
                attemptShotBox.changeValue()
            }
            if name == "Zone1Box" {
                zone1Box.changeValue()
            }
            if name == "Zone2Box" {
                zone2Box.changeValue()
            }
            if name == "Zone3Box" {
                zone3Box.changeValue()
            }
            if name == "MadeHopperBox" {
                madeHopperBox.changeValue()
            }
            if name == "Finish" {
                if tag == 4 {
                    estimatedFuelValue = Int(estimatedFuelMade.text!)!
                    estimatedLowGoalValue = Int(attemptLowEstimation.text!)!
                    
                    completeDataString.append("\(allianceString!), \(robotNumber), \(nameString), \(didNotMoveBox.value!), \(crossBaseLineBox.value!), \(attemptGearBox.value!), \(madeGearBox.value!), \(attemptShotBox.value!), \(zone1Box.value!), \(zone2Box.value!), \(zone3Box.value!), \(estimatedFuelValue), \(madeHopperBox.value!), \(estimatedLowGoalValue), \(zone1TeleopValue), \(zone2TeleopValue), \(zone3TeleopValue), \(madeGearsValue), \(missedGearsValue), \(shotSpeedValue)\n")
                    
                    let completeString = completeDataString.data(using: String.Encoding.utf8.rawValue)
                    do {
                        try self.session.send(completeString!, toPeers: self.session.connectedPeers, with: MCSessionSendDataMode.reliable)
                        
                        showAlert(title: "Complete", message: "The data has been sent! ;) #Robots")
                        tag = 1
                        self.removeAllChildren()
                        estimatedFuelMade.removeFromSuperview()
                        attemptLowEstimation.removeFromSuperview()
                        zone1FuelAmount.removeFromSuperview()
                        zone2FuelAmount.removeFromSuperview()
                        zone3FuelAmount.removeFromSuperview()
                        madeGearsAmount.removeFromSuperview()
                        droppedGearsAmount.removeFromSuperview()
                        shotSpeed.removeFromSuperview()
                        
                        titleLabel.text = "Pre Match Data"
                        self.addChild(titleLabel)
                        enterMatchAlliance.text = ""
                        enterTeamNumber.text = ""
                        enterYourName.text = ""
                        view?.addSubview(enterMatchAlliance)
                        self.addChild(themedButton.button)
                        self.addChild(themedButton.label)

                    }
                    catch {
                        print("ERROR")
                        
                        showAlert(title: "Failed", message: "The data failed to send...please tell someone")
 
                    }

                    
                    /*
                    tag = 5
                    removeAllChildren()
                    titleLabel.text = "Finish"
                    self.addChild(titleLabel)
                    estimatedFuelMade.removeFromSuperview()
                    attemptLowEstimation.removeFromSuperview()
                    zone1FuelAmount.removeFromSuperview()
                    zone2FuelAmount.removeFromSuperview()
                    zone3FuelAmount.removeFromSuperview()
                    madeGearsAmount.removeFromSuperview()
                    droppedGearsAmount.removeFromSuperview()
                    shotSpeed.removeFromSuperview()
                    enterTeamNumber.placeholder = "Please enter any comments"
                    view?.addSubview(enterTeamNumber)
                    */
                }
            }
            if name == "Previous" {
                if tag == 4 {
                    tag = 1
                    removeAllChildren()
                    estimatedFuelMade.removeFromSuperview()
                    attemptLowEstimation.removeFromSuperview()
                    zone1FuelAmount.removeFromSuperview()
                    zone2FuelAmount.removeFromSuperview()
                    zone3FuelAmount.removeFromSuperview()
                    madeGearsAmount.removeFromSuperview()
                    droppedGearsAmount.removeFromSuperview()
                    shotSpeed.removeFromSuperview()
                    
                    titleLabel.text = "Pre Match Data"
                    self.addChild(titleLabel)
                    view?.addSubview(enterMatchAlliance)
                    self.addChild(themedButton.button)
                    self.addChild(themedButton.label)
                }
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
            let loadedString2 = defaults.string(forKey: "AllianceString")
            allianceString = loadedString2!
            view?.addSubview(enterYourName)
            self.addChild(themedButton.button)
            self.addChild(themedButton.label)
        }
        else if tag == 4 {
            let defaults = UserDefaults.standard
            let loadedString = defaults.string(forKey: "RobotNumber")
            robotNumber = loadedString!
            enterTeamNumber.text = loadedString!
            let loadedString2 = defaults.string(forKey: "AllianceString")
            allianceString = loadedString2!
            enterMatchAlliance.text = loadedString2!
            let loadedString3 = defaults.string(forKey: "NameString")
            nameString = loadedString3!
            enterYourName.text = loadedString3!
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
            self.addChild(zoneLabel)
            self.addChild(zone1Label)
            self.addChild(zone1Box.node)
            self.addChild(zone2Label)
            self.addChild(zone2Box.node)
            self.addChild(zone3Label)
            self.addChild(zone3Box.node)
            self.addChild(estimatedFuelMadeLabel)
            view?.addSubview(estimatedFuelMade)
            self.addChild(madeHopperLabel)
            self.addChild(madeHopperBox.node)
            self.addChild(attemptLowLabel)
            view?.addSubview(attemptLowEstimation)
            self.addChild(teleopLabel)
            self.addChild(zone1FuelLabel)
            view?.addSubview(zone1FuelAmount)
            self.addChild(zone1FuelAmountLabel)
            self.addChild(zone2FuelLabel)
            self.addChild(zone2FuelAmountLabel)
            view?.addSubview(zone2FuelAmount)
            self.addChild(zone3FuelLabel)
            self.addChild(zone3FuelAmountLabel)
            view?.addSubview(zone3FuelAmount)
            self.addChild(madeGearsLabel)
            self.addChild(madeGearsAmountLabel)
            view?.addSubview(madeGearsAmount)
            self.addChild(droppedGearsLabel)
            self.addChild(droppedGearsAmountLabel)
            view?.addSubview(droppedGearsAmount)
            self.addChild(shotSpeedLabel)
            self.addChild(shotSpeedAmountLabel)
            view?.addSubview(shotSpeed)
            self.addChild(nextButton.button)
            self.addChild(nextButton.label)
            self.addChild(previousButton.button)
            self.addChild(previousButton.label)
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
    }
    func session(_ session: MCSession, didReceive data: Data,
                 fromPeer peerID: MCPeerID)  {
        // Called when a peer sends an NSData to us

    }
    
}


