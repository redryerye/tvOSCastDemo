//
//  ViewController.swift
//  tvOSReceiver
//
//  Created by Yuki Yamamoto on 2019/03/18.
//  Copyright © 2019 Yuki Yamamoto. All rights reserved.
//

import UIKit
import MultipeerConnectivity

enum Const {
    static let serviceType: String = "tvOSCastDemo"
    static let displayName: String = UIDevice.current.name
}

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resetButton: UIButton!
    
    var displayName: String!
    var peerID: MCPeerID!
    var session: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConnectivity()

        
        resetButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        session.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.mcAdvertiserAssistant == nil {
            // Host MCSession
            hostSession()
        }
    }
    
    func setConnectivity() {
        print(#function)
        
        peerID = MCPeerID(displayName: Const.displayName)
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
    }
    
    func hostSession() {
        print("Host with \(Const.serviceType)")
        
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: Const.serviceType, discoveryInfo: nil, session: self.session)
        mcAdvertiserAssistant.start()
        
    }
    
    func stopSession() {
        self.mcAdvertiserAssistant.stop()
    }
    
    @IBAction func resetAction(_ sender: Any) {
        imageView.image = UIImage(named: "waiting-meme")
        
        resetButton.isHidden = true
    }
}

extension ViewController: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print(#function)
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print(#function)
        
        if let image = UIImage(data: data) {
            
            print("Got the Image!!")
            
            DispatchQueue.main.async {
                self.imageView.image = image
                self.resetButton.isHidden = false
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print(#function)
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print(#function)
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print(#function)
    }
    
    
}
