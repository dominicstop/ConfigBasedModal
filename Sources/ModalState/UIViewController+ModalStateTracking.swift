//
//  UIViewController+ModalStateTracking.swift
//  
//
//  Created by Dominic Go on 6/15/24.
//

import UIKit

extension UIViewController {

  private enum AssociatedKeys: String {
    case modalFocusState;
    case modalPresentationState;
  };

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
        forKey: .modalPresentationState
      );
    }
    set {
      self.setInjectedValue(
        keys: AssociatedKeys.self,
        forKey: .modalPresentationState,
        value: newValue
      );
    }
  };
};
