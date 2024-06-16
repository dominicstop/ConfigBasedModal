//
//  ModalEventsManager.swift
//  
//
//  Created by Dominic Go on 6/11/24.
//

import UIKit
import DGSwiftUtilities


public final class ModalEventsManager {

  public typealias `Self` = ModalEventsManager;

  public static var isSwizzled = false;
  public static var shouldSwizzle = true;

  public static let shared: Self = .init();
  
  var modalDelegates: MulticastDelegate<UIViewController> = .init();
  
  init(){
    self.swizzleIfNeeded();
  };
  
  func registerModal(_ modalVC: UIViewController){
    let isRegistered = self.modalDelegates.delegates.contains {
      $0 === modalVC;
    };
    
    guard !isRegistered else { return };
    self.modalDelegates.add(modalVC);
  };
  
  func swizzleIfNeeded(){
    guard Self.shouldSwizzle,
          !Self.isSwizzled
    else { return };
    
    Self.isSwizzled = true;
    self._swizzlePresent();
    self._swizzleDismiss();
  };
  
  func _swizzlePresent(){
    SwizzlingHelpers.swizzlePresent() { originalImp, selector in
      return { _self, vcToPresent, animated, completion in
        
        let currentWindow = _self.view.window ?? vcToPresent.view.window;
        self._notifyOnModalWillShow(
          forViewController: vcToPresent,
          targetWindow: currentWindow
        );
        
        // Call the original implementation.
        originalImp(_self, selector, vcToPresent, animated){
          self._notifyOnModalDidShow(
            forViewController: vcToPresent,
            targetWindow: currentWindow
          );
          completion?();
        };
      };
    };
  };
  
  func _swizzleDismiss(){
    SwizzlingHelpers.swizzleDismiss() { originalImp, selector in
      return { _self, animated, completion in

        let currentWindow =
          _self.view.window ?? _self.presentingViewController?.view.window;
        
        let modalVC = _self.presentedViewController!;
        self._notifyOnModalWillHide(
          forViewController: modalVC,
          targetWindow: currentWindow
        );
        
        // Call the original implementation.
        originalImp(_self, selector, animated){
          self._notifyOnModalDidHide(
            forViewController: modalVC,
            targetWindow: currentWindow
          );
          completion?();
        };
      };
    };
  };
  
  func _notifyOnModalWillShow(
    forViewController modalVC: UIViewController,
    targetWindow: UIWindow?
  ){
    self.registerModal(modalVC);
    
    self.notifyForFocusChange(
      forModal: modalVC,
      nextState: .focusing,
      targetWindow: targetWindow
    );
  };
  
  func _notifyOnModalDidShow(
    forViewController modalVC: UIViewController,
    targetWindow: UIWindow?
  ){
    
    self.notifyForFocusChange(
      forModal: modalVC,
      nextState: .focused,
      targetWindow: targetWindow
    );
  };
  
  func _notifyOnModalWillHide(
    forViewController modalVC: UIViewController,
    targetWindow: UIWindow?
  ){
    
    self.notifyForFocusChange(
      forModal: modalVC,
      nextState: .blurring,
      targetWindow: targetWindow
    );
  };
  
  func _notifyOnModalDidHide(
    forViewController modalVC: UIViewController,
    targetWindow: UIWindow?
  ){
    let wasDismissCancelled = modalVC.isPresentedAsModal;
    
    self.notifyForFocusChange(
      forModal: modalVC,
      nextState: wasDismissCancelled ? .focused : .blurred,
      targetWindow: targetWindow
    );
  };
  
  func notifyForFocusChange(
    forModal modalVC: UIViewController,
    nextState: ModalFocusState,
    targetWindow: UIWindow?
  ){
    
    guard let targetWindow = targetWindow ?? UIApplication.shared.activeWindow,
          let rootVC = targetWindow.rootViewController
    else { return };
    
    let siblingModals = self.modalDelegates.delegates.filter {
      $0.view.window === targetWindow;
    };
    
    let allPresentedModals = rootVC.recursivelyGetPresentedViewControllers;
    var prevModal: UIViewController?;
    var topMostModal: UIViewController?;
    
    switch nextState {
      case .focusing, .focused:
        topMostModal = modalVC;
        prevModal = allPresentedModals.last {
          $0 !== modalVC;
        };
        
      case .blurring, .blurred:
        prevModal = modalVC;
        topMostModal = allPresentedModals.last {
          $0 !== modalVC;
        };
    };
    
    let otherModals = allPresentedModals.filter { presentedModal in
      if presentedModal === prevModal {
        return false;
      };
      
      if presentedModal === topMostModal {
        return false;
      };
      
      return siblingModals.contains {
        $0 === presentedModal;
      };
    };
    
    switch nextState {
      case .blurred:
        topMostModal?.setModalFocusState(.focused);
        prevModal?.setModalFocusState(.blurred);
        
      case .blurring:
        topMostModal?.setModalFocusState(.focusing);
        prevModal?.setModalFocusState(.blurring);
      
      case .focused:
        topMostModal?.setModalFocusState(.focused);
        prevModal?.setModalFocusState(.blurred);
        
      case .focusing:
        topMostModal?.setModalFocusState(.focusing);
        prevModal?.setModalFocusState(.blurring);
    };
    
    otherModals.forEach {
      $0.setModalFocusState(.blurred);
    };
  };
};

fileprivate extension UIViewController {

  func setModalFocusState(_ nextState: ModalFocusState){
    guard self.modalFocusState != nextState else { return };
    let eventDelegate = self as? ModalFocusEventsNotifiable;
    let prevState = self.modalFocusState ?? .blurred;
    
    self.modalFocusState = nextState;
    eventDelegate?.notifyForModalFocusStateChange(
      prevState: prevState,
      nextState: nextState
    );
  };
};
