//
//  ModalPresentationStateTracking.swift
//  
//
//  Created by Dominic Go on 6/15/24.
//

import Foundation

public protocol ModalPresentationStateTracking: AnyObject {

  var modalPresentationState: ModalPresentationStateMachine { get set };
};
