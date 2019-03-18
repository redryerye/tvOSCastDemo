//
//  ViewController.swift
//  iOSSender
//
//  Created by Yuki Yamamoto on 2019/03/18.
//  Copyright © 2019 Yuki Yamamoto. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController {
    
    @IBOutlet weak var logLabel: UILabel!
    @IBOutlet weak var castButton: UIButton!
    
    var session: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    var mcBrowser: MCBrowserViewController!
    
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
    }

    func setConnection() {
        self.mcBrowser = MCBrowserViewController(serviceType: Const.serviceType, session: sessionContainer.session)
        self.mcBrowser.delegate = self
        self.mcBrowser.minimumNumberOfPeers = kMCSessionMinimumNumberOfPeers
        self.mcBrowser.maximumNumberOfPeers = kMCSessionMaximumNumberOfPeers
        
    }
    
    @IBAction func castAction(_ sender: Any) {
        
        
        
        if UserDefaults.standard.bool(forKey: "isCasting") {
            print("\n\n\nSEND!!!\n")
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
