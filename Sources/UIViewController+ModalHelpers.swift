//
//  UIViewController+ModalHelpers.swift
//
//
//  Created by Dominic Go on 6/12/24.
//

import UIKit


extension UIViewController {
  
  public var isPresentedAsModal: Bool {
    /// This view controller instance is inside the navigation stack of a
    /// navigation controller
    if let navController = self.navigationController,
       let index = navController.viewControllers.firstIndex(of: self),
       index > 0 {
       
      return false;
    };
    
    /// A parent view controller has presented this view controller instance
    /// (or one of it's parent) as a modal
    block:
    if self.presentingViewController != nil {
      let hasParentNavController = self.parent is UINavigationController;
      let hasParentTabBarController = self.parent is UITabBarController;
    
      return !(hasParentNavController || hasParentTabBarController);
    };
    
    /// This view controller instance is inside a navigation controller,
    /// and that navigation controller is being presented as a modal
    if let navController = self.navigationController,
       let presentingVC = navController.presentingViewController,
       let presentedVC = presentingVC.presentedViewController,
       presentedVC == self.navigationController {
        
      return true;
    };
    
    /// This view controller instance is inside a tab bar controller,
    /// and that tab bar controller is being presented as a modal
    if let tabBarController = self.tabBarController,
       tabBarController.presentingViewController is UITabBarController {
      
      return true;
    };
    
    return false;
  };
  
  public var isTopMostModal: Bool {
    let presentedVCList = self.recursivelyGetAllPresentedViewControllers;
    
    // not a modal
    guard presentedVCList.count > 0 else {
      return false;
    };
    
    return presentedVCList.last === self;
  };
  
  public var recursivelyGetPresentingViewControllers: [UIViewController] {
    guard self.isPresentedAsModal,
          let presentingVC = self.presentingViewController
    else {
      return [];
    };
    
    var vcList = [presentingVC];
    
    while let currentPresentingVC = vcList.last,
          let nextPresentingVC = currentPresentingVC.presentingViewController,
          nextPresentingVC !== currentPresentingVC {
      
      vcList.append(nextPresentingVC);
    };
    
    return vcList;
  };
  
  public var rootPresentingViewController: UIViewController? {
    self.recursivelyGetPresentingViewControllers.last;
  };
  
  public var recursivelyGetPresentedViewControllers: [UIViewController] {
    guard let presentedVC = self.presentedViewController else {
      return [];
    };
    
    var vcList = [presentedVC];
    
    while let currentPresentedVC = vcList.last,
          let nextPresentedVC = currentPresentedVC.presentedViewController,
          nextPresentedVC !== currentPresentedVC {
      
      vcList.append(nextPresentedVC);
    };
    
    return vcList;
  };
  
  public var recursivelyGetTopMostPresentedViewController: UIViewController? {
    self.recursivelyGetPresentedViewControllers.last;
  };
  
  public var recursivelyGetAllPresentedViewControllers: [UIViewController] {
    guard let rootPresentingVC = self.rootPresentingViewController else {
      return [];
    };
    
    return rootPresentingVC.recursivelyGetPresentedViewControllers;
  };
  
  public var modalLevel: Int? {
    let presentedVCList = self.recursivelyGetAllPresentedViewControllers;
    
    guard presentedVCList.count > 0 else {
      return nil;
    };
    
    let match = presentedVCList.enumerated().first {
      $0.element === self;
    };
    
    guard let match = match else {
      return nil;
    };
    
    return match.offset;
  };
};
