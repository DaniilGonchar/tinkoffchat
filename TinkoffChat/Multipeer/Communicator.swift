//
//  Communicator.swift
//  TinkoffChat
//
//  Created by comandante on 4/3/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation
import MultipeerConnectivity


protocol Communicator {
  func sendMessage(string: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?)
  var delegate: CommunicatorDelegate? {get set}
  var online: Bool {get set}
}



class MultipeerCommunicator: NSObject, Communicator {
  weak var delegate: CommunicatorDelegate?
  private let serviceType = "tinkoff-chat"
  
  private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
  private let serviceAdvertiser: MCNearbyServiceAdvertiser
  private let serviceBrowser: MCNearbyServiceBrowser
  
  var online = false
  
  
  private func generateMessageId() -> String {
    return "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)".data(using: .utf8)!.base64EncodedString()
  }
  
  
  override init() {
    serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: ["userName": UIDevice.current.name], serviceType: serviceType)
    serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
    super.init()
    
    serviceAdvertiser.delegate = self
    serviceAdvertiser.startAdvertisingPeer()
    online = true
    
    serviceBrowser.delegate = self
    serviceBrowser.startBrowsingForPeers()
  }
  
  
  deinit {
    serviceAdvertiser.stopAdvertisingPeer()
    serviceBrowser.stopBrowsingForPeers()
    online = false
  }
  
  
  private lazy var session: MCSession = {
    let session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .optional)
    session.delegate = self
    return session
  }()
  
  
  func sendMessage(string: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?) {
    if let index = session.connectedPeers.index(where: { (item) -> Bool in item.displayName == userID }) {
      do {
        var message = [String: String]()
        message["eventType"] = "TextMessage"
        message["text"] = string
        message["messageId"] = generateMessageId()
        
        let myJson = try! JSONSerialization.data(withJSONObject: message, options: .prettyPrinted)
        try self.session.send(myJson, toPeers: [session.connectedPeers[index]], with: .reliable)
        completionHandler?(true, nil)
      } catch let error {
        completionHandler?(false, error)
      }
    }
  }
}



// MARK: - MCNearbyServiceAdvertiserDelegate
extension MultipeerCommunicator: MCNearbyServiceAdvertiserDelegate {
  
  func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
    delegate?.failedToStartAdvertising(error: error)
  }
  
  func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
    invitationHandler(true, session)
  }
}



// MARK: - MCSessionDelegate
extension MultipeerCommunicator: MCSessionDelegate {
  
  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    if (state == .connected) {
      print("State changed: connected")
    }
  }
  
  
  func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    do {
      let myJson = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! Dictionary<String, String>
      
      if let text = myJson["text"] {
        delegate?.didReceiveMessage(text: text, fromUser: peerID.displayName, toUser: myPeerId.displayName)
      }
    } catch {
      print("Can't parse responce.")
    }
  }
  
  
  func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
    certificateHandler(true)
  }
  
  
  func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { }
  
  
  func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
  
  
  func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) { }
  
}



// MARK: - MCNearbyServiceBrowserDelegate
extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate {
  
  func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
    delegate?.failedToStartBrowsingForUsers(error: error)
  }
  
  
  func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
    if let info = info {
      delegate?.didFoundUser(userID: peerID.displayName, userName: info["userName"])
    }
    browser.invitePeer(peerID, to: session, withContext: nil, timeout: 60)
  }
  
  
  func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    delegate?.didLostUser(userID: peerID.displayName)
  }
}
