//
//  ModalConfigManager.swift
//
//
//  Created by Dominic Go on 6/10/24.
//

import UIKit
import DGSwiftUtilities


public class ModalConfigManager {

  // MARK: - Properties
  // ------------------

  var _presentingVC: UIViewController? = nil;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var window: UIWindow? {
    if let presentingVC = self._presentingVC,
       let window = presentingVC.view.window {
       
      return window;
    };
    
    if let activeWindow = UIApplication.shared.activeWindow {
      return activeWindow;
    };
    
    return UIApplication.shared.allWindows.first {
      $0.isKeyWindow;
    };
  };
  
  public var presentingVC: UIViewController? {
    if let presentingVC = self._presentingVC {
      return presentingVC;
    };
    
    guard let window = self.window else {
      return nil;
    };
    
    return window.topmostPresentedViewController;
  };
  
  // MARK: - Init
  // ------------
  
  public init(
    presentingViewController presentingVC: UIViewController? = nil
  ){
    self._presentingVC = presentingVC;
    ModalEventsManager.shared.swizzleIfNeeded();
  };
  
  // MARK: - Methods
  // ---------------
  
  public func presentModal(
    viewControllerToPresent presentedVC: UIViewController,
    presentingViewController presentingVC: UIViewController? = nil
  ){
    guard let presentingVC = presentingVC ?? self.presentingVC else {
      return;
    };
  
    presentingVC.present(
      presentedVC,
      animated: true,
      completion: {
        // no-op
      }
    );
  };
};
