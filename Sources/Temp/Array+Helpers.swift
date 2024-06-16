//
//  Array+Helpers.swift
//  
//
//  Created by Dominic Go on 6/16/24.
//

import Foundation

public extension Array {
  
  func first<T>(whereType type: T.Type) -> T? {
    let match = self.first {
      $0 is T;
    };
    
    return match as? T;
  };
};
