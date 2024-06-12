//
//  UIViewController+Helpers.swift
//
//
//  Created by Dominic Go on 6/11/24.
//

import UIKit

public extension UIViewController {

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
  
};
