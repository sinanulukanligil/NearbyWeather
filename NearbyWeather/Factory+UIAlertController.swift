//
//  Factory+UIAlertController.swift
//  NearbyWeather
//
//  Created by Erik Maximilian Martens on 09.02.20.
//  Copyright © 2020 Erik Maximilian Martens. All rights reserved.
//

import UIKit.UIAlertController
import MapKit

extension Factory {
  
  struct AlertController: FactoryFunction {
    
    enum AlertControllerType {
      case weatherListType(currentListType: ListType, completionHandler: ((ListType) -> Void))
      case weatherMapType(currentMapType: MKMapType, completionHandler: ((MKMapType) -> Void))
    }
    
    typealias InputType = AlertControllerType
    typealias ResultType = UIAlertController
    
    static func make(fromType type: InputType) -> ResultType {
      switch type {
      case let .weatherListType(currentListType, completionHandler):
        let actions = ListType.allCases.map { listType -> UIAlertAction in
          let action = UIAlertAction(title: listType.title, style: .default, handler: { _ in
            completionHandler(listType)
          })
          if listType == currentListType { action.setValue(true, forKey: Constants.Keys.KVOKeys.kChecked) }
          return action
        }
        return UIAlertController(
          title: R.string.localizable.select_list_type().capitalized,
          actions: actions,
          canceable: true
        )
      case let .weatherMapType(currentMapType, completionHandler):
        let actions = MKMapType.supportedCases.map { mapType -> UIAlertAction in
          let action = UIAlertAction(title: mapType.title, style: .default, handler: { _ in
            completionHandler(mapType)
          })
          if mapType == currentMapType { action.setValue(true, forKey: Constants.Keys.KVOKeys.kChecked) }
          return action
        }
        
        return UIAlertController(
          title: R.string.localizable.select_map_type().capitalized,
          actions: actions,
          canceable: true
        )
      }
    }
  }
}

private extension UIAlertController {
  
  convenience init(title: String? = nil, message: String? = nil, style: UIAlertController.Style = .alert, actions: [UIAlertAction] = [], tintColor: UIColor = .blue, canceable: Bool = false) {
    self.init(title: title, message: message, preferredStyle: style)
    
    actions.forEach { addAction($0) }
    
    if canceable {
      addAction(
        UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler: nil)
      )
    }
    
    view.tintColor = tintColor
  }
}
