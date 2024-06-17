//
//  ModalPresentationEventsNotifiable.swift
//  
//
//  Created by Dominic Go on 6/15/24.
//

import Foundation


public protocol ModalPresentationEventsNotifiable {

  func onModalPresentationStateDidChange(
    prevState: ModalPresentationState,
    nextState: ModalPresentationState
  );
};
