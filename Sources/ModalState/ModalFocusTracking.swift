//
//  ModalFocusNotifiable.swift
//  
//
//  Created by Dominic Go on 6/14/24.
//

import Foundation


public protocol ModalFocusTracking: AnyObject {
  
  var modalFocusState: ModalFocusState { get set };
};
