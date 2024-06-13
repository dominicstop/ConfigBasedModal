//
//  TestRoutes.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/22/23.
//

import UIKit

enum Route: CaseIterable {
  static let rootRoute: Self = .Test01;

  case Test01;
  
  var viewController: UIViewController {
    switch self {
      case .Test01:
        return Test01ViewController();
    };
  };
};

class RouteManager {
  static let sharedInstance = RouteManager();
  
  weak var window: UIWindow?;
  
  var shouldUseNavigationController = true;
  var navController: UINavigationController?;
  
  var routes: [Route] = [
    .Test01,
  ];
  
  var routeCounter = 0;
  
  var currentRouteIndex: Int {
    self.routeCounter % self.routes.count;
  };
  
  var currentRoute: Route {
    self.routes[self.currentRouteIndex];
  };
  
  func applyCurrentRoute(){
    guard let window = self.window else { return };
  
    let nextVC = self.currentRoute.viewController;
    
    let navVC: UINavigationController? = {
      guard self.shouldUseNavigationController else {
        return nil;
      };
      
      if let navController = self.navController {
        return navController;
      };
      
      let navVC = UINavigationController(
        rootViewController: self.currentRoute.viewController
      );
      
      self.navController = navController;
      return navVC;
    }();
    
    let isFirstSetupForNavVC = window.rootViewController !== navVC;
    
    if isFirstSetupForNavVC {
      window.rootViewController = navController;
    };
    
    if self.shouldUseNavigationController,
       !isFirstSetupForNavVC {
      
      navVC?.pushViewController(nextVC, animated: true);
    
    } else {
      window.rootViewController = nextVC;
    };
  };
};
