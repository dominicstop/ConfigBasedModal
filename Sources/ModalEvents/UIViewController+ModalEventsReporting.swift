//
//  UIViewController+ModalEventsReporting.swift
//
//
//  Created by Dominic Go on 6/12/24.
//

import UIKit
import DGSwiftUtilities

extension UIViewController: ModalEventsReporting {

  public var doesReportModalEvents: Bool {
    return false;
  }
  
  public var modalGestureRecognizer: UIPanGestureRecognizer? {
    guard let presentationController = self.presentationController,
          let presentedView = presentationController.presentedView,
          let gestureRecognizers = presentedView.gestureRecognizers
    else {
      return nil;
    };
    
    let match = gestureRecognizers.first {
      $0 is UIPanGestureRecognizer
    };
    
    guard let match = match as? UIPanGestureRecognizer else {
      return nil;
    };
    
    if let scrollView = self.view.recursivelyFindSubview(whereType: UIScrollView.self),
       let scrollViewGestures = scrollView.gestureRecognizers {
      
      scrollViewGestures.forEach {
        $0.require(toFail: match)
      };
    };
    
    return match;
  };
  
  public var modalPositionAnimator: CAAnimation? {
    guard self.isPresentedAsModal,
          let presentationController = self.presentationController,
          let presentedView = presentationController.presentedView
    else {
      return nil;
    };
    
    return presentedView.layer.animation(forKey: "position");
  };
};
