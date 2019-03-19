//
//  ViewController.swift
//  iOSSender
//
//  Created by Yuki Yamamoto on 2019/03/18.
//  Copyright © 2019 Yuki Yamamoto. All rights reserved.
//

import UIKit
import MultipeerConnectivity

//class ViewController: UIViewController, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {
class ViewController: UIViewController {

    @IBOutlet weak var logLabel: UILabel!
    @IBOutlet weak var castButton: UIButton!
    
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    var mcBrowser: MCBrowserViewController!
    
    var session: MCSession!
    var advertiser: MCNearbyServiceAdvertiser!
    var browser: MCNearbyServiceBrowser!
    
    let castImage = UIImage(named: "cast-button")
    let setImage = UIImage(named: "set-button")
    
    var sessionContainer: SessionContainer = {
        return .init(displayName: Const.displayName, serviceType: Const.serviceType)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConnection()
        
        logLabel.text = ""
        castButton.setImage(setImage, for: .normal)
        
        UserDefaults.standard.set(false, forKey: "isCasting")
        
        
        /*
 
        // Initiate a Session
        let peerID = MCPeerID(displayName: "hoge")
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        
        
        // Set an Advertiser for the service
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "foobar")
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
        
        
        // Look for the service offered by nearby devices
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: "foobar")
        browser.delegate = self
        browser.startBrowsingForPeers()
        
        */
        
        
    }

    func setConnection() {
        mcBrowser = MCBrowserViewController(serviceType: Const.serviceType, session: sessionContainer.session)
        mcBrowser.delegate = self
        
        mcBrowser.minimumNumberOfPeers = kMCSessionMinimumNumberOfPeers // = 2
        mcBrowser.maximumNumberOfPeers = kMCSessionMaximumNumberOfPeers // = 8
        
        /*
        // Generating friendly UI for us
        
        // Browse
        mcBrowser = MCBrowserViewController(serviceType: "foobar", session: session)
        mcBrowser.delegate = self
        
        mcBrowser.minimumNumberOfPeers = kMCSessionMinimumNumberOfPeers // = 2
        mcBrowser.maximumNumberOfPeers = kMCSessionMaximumNumberOfPeers // = 8
        
        
        // Advertise
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "foobar", discoveryInfo: nil, session: session)
        mcAdvertiserAssistant.delegate = self
        
        */
        
        
    }
    
    @IBAction func castAction(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "isCasting") {
            logLabel.text = "Sending Image.."
            
            // Send Image to mcPeer
            sessionContainer.sendImage(UIImage(named: "try-swift-logo")!)
            
            logLabel.text = "Image Sent!"
        } else {
            self.present(self.mcBrowser, animated: true, completion: nil)
        }
    }
    
}

extension ViewController: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        print(#function)
        
        setCastButtonImageWithConnection()
        
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        print(#function)
        
        setCastButtonImageWithConnection()
        
        dismiss(animated: true, completion: nil)
    }
    
    func setCastButtonImageWithConnection() {
        if UserDefaults.standard.bool(forKey: "isCasting") {
            self.castButton.setImage(castImage, for: .normal)
        } else {
            self.castButton.setImage(setImage, for: .normal)
        }
    }
    
}
