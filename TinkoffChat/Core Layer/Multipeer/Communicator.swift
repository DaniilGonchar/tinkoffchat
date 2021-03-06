//
//  Communicator.swift
//  TinkoffChat
//
//  Created by comandante on 4/3/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol ICommunicator: class {
  func sendMessage(text: String, to userId: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ()))
  var delegate: ICommunicatorDelegate? { get set }
  var online: Bool { get set }
}



class MultipeerCommunicator: NSObject, ICommunicator {
  weak var delegate: ICommunicatorDelegate?
  private let serviceType = "tinkoff-chat"
  
  private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
  private let serviceAdvertiser: MCNearbyServiceAdvertiser
  private let serviceBrowser: MCNearbyServiceBrowser
  
  var online: Bool
  
  
  override init() {
    serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: ["userName": UIDevice.current.name], serviceType: serviceType)
    serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
    online = true
    
    super.init()
    
    serviceAdvertiser.delegate = self
    serviceAdvertiser.startAdvertisingPeer()
    
    serviceBrowser.delegate = self
    serviceBrowser.startBrowsingForPeers()
  }
  
  
  deinit {
    serviceAdvertiser.stopAdvertisingPeer()
    serviceBrowser.stopBrowsingForPeers()
  }
  
  
  private lazy var session: MCSession = {
    let session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .optional)
    session.delegate = self
    return session
  }()
  
  
  func sendMessage(text: String, to userId: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())) {
    guard let index = session.connectedPeers.index(where: {
      (item) -> Bool in
      item.displayName == userId }) else { return  }
    
    let message = ["eventType": "TextMessage",
                   "text": text,
                   "messageId": Message.generateMessageId()]
    
    do {
      let json = try! JSONSerialization.data(withJSONObject: message, options: .prettyPrinted)
      try session.send(json, toPeers: [session.connectedPeers[index]], with: .reliable)
      delegate?.didSendMessage(text: text, to: userId)
      completionHandler(true, nil)
    }
    catch {
      completionHandler(false, error)
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
        delegate?.didReceiveMessage(text: text, from: peerID.displayName)
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
    guard let userName = info?["userName"] else {
      return
    }
    browser.invitePeer(peerID, to: session, withContext: nil, timeout: 60)
    delegate?.didFindUser(id: peerID.displayName, name: userName)
  }
  
  
  func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    delegate?.didLoseUser(id: peerID.displayName)
  }
}
