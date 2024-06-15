//
//  ModalFocusEventsNotifiable.swift
//
//
//  Created by Dominic Go on 6/15/24.
//

import Foundation

public protocol ModalFocusEventsNotifiable {

  func notifyForModalFocusStateChange(
    prevState: ModalFocusState,
    nextState: ModalFocusState
  );
};
