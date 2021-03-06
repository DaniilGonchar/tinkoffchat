//
//  ConversationsListModel.swift
//  TinkoffChat
//
//  Created by comandante on 4/23/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation
import UIKit

protocol IConversationListModel: class {
  var communicationService: ICommunicatorDelegate { get }
  var frcService: IFRCService { get }
  var dataSourcer: ConversationsDataSource? { get set }
  
  func restoreThemeSettings()
  func saveSettings(for theme: UIColor)
}




class ConversationsListModel: IConversationListModel {
  var dataSourcer: ConversationsDataSource?
  
  var communicationService: ICommunicatorDelegate
  
  var frcService: IFRCService
  
  private let themesService: IThemesService
  
  
  init(communicationService: ICommunicatorDelegate,
       themesService: IThemesService,
       frcService: IFRCService) {
    self.communicationService = communicationService
    self.themesService = themesService
    self.frcService = frcService
  }
  
  
  func restoreThemeSettings() {
    themesService.load()
  }
  
  
  func saveSettings(for theme: UIColor) {
    themesService.save(theme)
  }
  
}
