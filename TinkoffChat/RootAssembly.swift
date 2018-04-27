//
//  RootAssembly.swift
//  TinkoffChat
//
//  Created by comandante on 4/23/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation

class RootAssembly {
  private lazy var coreAssembly: ICoreAssembly = CoreAssembly()
  private lazy var serviceAssembly: IServicesAssembly = ServicesAssembly(coreAssembly: self.coreAssembly)
  lazy var presentationAssembly: IPresentationAssembly = PresentationAssembly(serviceAssembly: self.serviceAssembly)
}
