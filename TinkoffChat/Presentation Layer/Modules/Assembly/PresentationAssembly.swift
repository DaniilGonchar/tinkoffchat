//
//  PresentationAssembly.swift
//  TinkoffChat
//
//  Created by comandante on 4/23/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation
import UIKit

protocol IPresentationAssembly {
  func themesViewController(_ closure: @escaping ColorAlias) -> ThemesViewController
  
  func profileViewController() -> ProfileViewController
  
  func conversationsListViewController() -> ConversationsListViewController
  
  func conversationViewController(model: ConversationModel) -> ConversationViewController
  
  func picturesViewController() -> PicturesViewController
}



class PresentationAssembly: IPresentationAssembly {
  
  private let serviceAssembly: IServicesAssembly
  
  init(serviceAssembly: IServicesAssembly) {
    self.serviceAssembly = serviceAssembly
  }
  
  
  func themesViewController(_ closure: @escaping ColorAlias) -> ThemesViewController {
    return ThemesViewController(model: themesModel(closure))
  }
  
  
  private func themesModel(_ closure: @escaping ColorAlias) -> IThemesModel {
    return ThemesModel(theme1: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), theme2: #colorLiteral(red: 0.2941176471, green: 0.2941176471, blue: 0.294, alpha: 1), theme3: #colorLiteral(red: 0.773, green: 0.702, blue: 0.345, alpha: 1), closure: closure)
  }
  
  
  func profileViewController() -> ProfileViewController {
    return ProfileViewController(model: profileModel(), presentationAssembly: self)
  }
  
  
  private func profileModel() -> IAppUserModel {
    return ProfileModel(dataService: CoreDataManager())
  }
  
  
  func picturesViewController() -> PicturesViewController {
    return PicturesViewController(model: picturesModel())
  }
  
  
  private func picturesModel() -> IPicturesModel {
    return PicturesModel(picturesService: serviceAssembly.picturesService)
  }
  
  
  func conversationViewController(model: ConversationModel) -> ConversationViewController {
    return ConversationViewController(model: model)
  }
  
  
  func conversationsListViewController() -> ConversationsListViewController {
    return ConversationsListViewController(model: conversationsListModel(),
                                           presentationAssembly: self)
  }
  
  
  private func conversationsListModel() -> IConversationListModel {
    return ConversationsListModel(communicationService: serviceAssembly.communicationService,
                                  themesService: serviceAssembly.themesService,
                                  frcService: serviceAssembly.frcService)
  }
  
}
