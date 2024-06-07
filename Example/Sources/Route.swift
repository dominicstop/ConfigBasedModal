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
    window.rootViewController = nextVC;
  };
};
