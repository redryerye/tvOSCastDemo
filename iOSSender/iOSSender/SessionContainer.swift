//
//  SessionContainer.swift
//  iOSSender
//
//  Created by Yuki Yamamoto on 2019/03/18.
//  Copyright © 2019 Yuki Yamamoto. All rights reserved.
//

import MultipeerConnectivity

class SessionContainer: NSObject {
    
    let session: MCSession
    private let displayName: String
    
    init(displayName: String, serviceType: String) {
        
        
        self.displayName = displayName
        
        let peerID = MCPeerID(displayName: displayName)
        session = MCSession(peer: peerID)
        
        super.init()
        
        session.delegate = self
    }
    
    deinit {
        session.disconnect()
    }
    
    func sendImage(_ image: UIImage) {
        let data = image.pngData()
        try? self.session.send(data!, toPeers: self.session.connectedPeers, with: .reliable)
    }
}

extension SessionContainer: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print(#function)
        
        switch state {
            
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            
            UserDefaults.standard.set(true, forKey: "isCasting")
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
            
            UserDefaults.standard.set(false, forKey: "isCasting")
            
            DispatchQueue.main.async {
                if let topVC = UIApplication.shared.keyWindow!.rootViewController!.topMostViewController() as? ViewController {
                    topVC.castButton.setImage(topVC.setImage, for: .normal)

                    topVC.logLabel.text = "MCSession Not Connected"
                }
            }
            
            
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print(#function)
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
