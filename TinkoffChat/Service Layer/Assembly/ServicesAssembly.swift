//
//  ServicesAssembly.swift
//  TinkoffChat
//
//  Created by comandante on 4/23/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation

protocol IServicesAssembly {
  var frcService: IFRCService { get }
  var themesService: IThemesService { get }
  var communicationService: ICommunicatorDelegate { get }
  var picturesService: IPicturesService { get }
}

class ServicesAssembly: IServicesAssembly {
  
  private let coreAssembly: ICoreAssembly
  
  init(coreAssembly: ICoreAssembly) {
    self.coreAssembly = coreAssembly
  }
  
  lazy var frcService: IFRCService = FRCService(stack: coreAssembly.coreDataStub)
  lazy var communicationService: ICommunicatorDelegate = CommunicationService(dataManager: coreAssembly.dataManager, communicator: coreAssembly.multipeerCommunicator)
  lazy var themesService: IThemesService = ThemesService(themesManager: coreAssembly.themesManager)
  lazy var picturesService: IPicturesService = PicturesService(requestSender: coreAssembly.requestSender)
  
}
