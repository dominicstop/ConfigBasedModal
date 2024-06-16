//
//  UIViewController+Helpers.swift
//
//
//  Created by Dominic Go on 6/11/24.
//

import UIKit

public extension UIViewController {

  // MARK: - Child/Parent Related
  // ----------------------------

  var recursivelyGetAllParentViewControllers: [UIViewController] {
    var parentVC: [UIViewController] = [];
    var currentVC = self;
    
    while true {
      guard let currentParentVC = currentVC.parent else {
        return parentVC;
      };
      
      parentVC.append(currentParentVC);
      currentVC = currentParentVC;
    };
  };
  
  var recursivelyGetAllChildViewControllers: [UIViewController] {
    var vcItems: [UIViewController] = [];
    
    for childVC in self.children {
      vcItems.append(childVC);
      vcItems += childVC.recursivelyGetAllChildViewControllers;
    };
    
    return vcItems;
  };

  func recursivelyFindParentViewController(
    where predicate: (UIViewController) -> Bool
  ) -> UIViewController? {
    var currentVC = self;
    
    while true {
      if currentVC !== self && predicate(currentVC) {
        return currentVC;
      };

      guard let parentVC = currentVC.parent else { return nil };
      currentVC = parentVC;
    };
  };
  
  func recursivelyFindParentViewController<T>(whereType type: T.Type) -> T? {
    let match = self.recursivelyFindParentViewController(where: {
      $0 is T;
    })
    
    guard let match = match else { return nil };
    return match as? T;
  };
  
  func recursivelyFindChildViewController(
    where predicate: (UIViewController) -> Bool
  ) -> UIViewController? {
  
    for childVC in self.children {
      if predicate(childVC) {
        return childVC;
      };
      
      if let match =
          childVC.recursivelyFindChildViewController(where: predicate) {
        return match;
      };
    };
    
    return nil;
  };
  
  func recursivelyFindChildViewController<T>(whereType type: T.Type) -> T? {
    let match = self.recursivelyFindChildViewController(where: {
      $0 is T;
    })
    
    guard let match = match else { return nil };
    return match as? T;
  };
  
  // MARK: - Modal-Related
  // ---------------------
  
  var isPresentedAsModal: Bool {
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
  };

  var isTopMostModal: Bool {
    let presentedVCList = self.recursivelyGetAllPresentedViewControllers;

    // not a modal
    guard presentedVCList.count > 0 else {
      return false;
    };

    return presentedVCList.last === self;
  };

  var recursivelyGetPresentingViewControllers: [UIViewController] {
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

  var rootPresentingViewController: UIViewController? {
    self.recursivelyGetPresentingViewControllers.last;
  };

  var recursivelyGetPresentedViewControllers: [UIViewController] {
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

  var recursivelyGetTopMostPresentedViewController: UIViewController? {
    self.recursivelyGetPresentedViewControllers.last;
  };

  var recursivelyGetAllPresentedViewControllers: [UIViewController] {
    guard let rootPresentingVC = self.rootPresentingViewController else {
      return [];
    };

    return rootPresentingVC.recursivelyGetPresentedViewControllers;
    };

    var modalLevel: Int? {
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

