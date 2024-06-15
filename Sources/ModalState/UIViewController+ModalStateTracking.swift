//
//  UIViewController+ModalStateTracking.swift
//  
//
//  Created by Dominic Go on 6/15/24.
//

import UIKit

fileprivate enum AssociatedKeys: String {
  case modalFocusState;
};

extension UIViewController {

  public var modalFocusState: ModalFocusState? {
    get {
      self.getInjectedValue(
        keys: AssociatedKeys.self,
        forKey: .modalFocusState
      );
    }
    set {
      self.setInjectedValue(
        keys: AssociatedKeys.self,
        forKey: .modalFocusState,
        value: newValue
      );
    }
  };
  
  public var modalPresentationState: ModalPresentationState? {
    get {
      self.getInjectedValue(
        keys: AssociatedKeys.self,
        forKey: .modalFocusState
      );
    }
    set {
      self.setInjectedValue(
        keys: AssociatedKeys.self,
        forKey: .modalFocusState,
        value: newValue
      );
    }
  };
};
