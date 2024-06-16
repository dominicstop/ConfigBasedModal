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
    
    return match;
  };
  
  // MARK: - Helpers
  // ---------------
  
  public var modalRootScrollViewGestureRecognizer: UIPanGestureRecognizer? {
    guard let scrollView = self.view.recursivelyFindSubview(whereType: UIScrollView.self),
          let scrollViewGestures = scrollView.gestureRecognizers
    else {
      return nil;
    };
    
    return scrollViewGestures.first(
      whereType: UIPanGestureRecognizer.self
    );
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
  
  public var isModalGestureRecognizerActive: Bool {
    guard let modalGesture = self.modalGestureRecognizer else {
      return false;
    };
    
    if modalGesture.state.isActive {
      return true;
    };
    
    let isModalGestureFailed =
         modalGesture.state == .cancelled
      || modalGesture.state == .failed;
    
    if isModalGestureFailed,
       let scrollViewGesture = self.modalRootScrollViewGestureRecognizer,
       scrollViewGesture.state.isActive {
       
      return true;
    };
    
    return false;
  };
};
