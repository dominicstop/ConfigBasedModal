//
//  ValueInjectable+Default.swift
//  
//
//  Created by Dominic Go on 6/14/24.
//

import Foundation

fileprivate struct AssociatedKeys {
  static var injectedKeys: UInt = 0;
};

extension NSObject: ValueInjectable {
  // no-op
};

public extension ValueInjectable {
  var injectedValues: InjectedValuesMap {
    set {
      self.setAssociatedObject(
        value: newValue,
        associativeKey: &AssociatedKeys.injectedKeys,
        policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC
      );
    }
    get {
      let match: InjectedValuesMap? = self.getAssociatedObject(
        associativeKey: &AssociatedKeys.injectedKeys
      );
      
      if match == nil {
        self.injectedValues = [:];
      };
      
      return match ?? [:];
    }
  };
  
  func setAssociatedObject<T>(
    value: T?,
    associativeKey key: UnsafeRawPointer,
    policy: objc_AssociationPolicy
  ) {
    objc_setAssociatedObject(self, key, value, policy);
  };
  
  func getAssociatedObject<T>(associativeKey: UnsafeRawPointer) -> T? {
    return objc_getAssociatedObject(self, associativeKey) as? T;
  };
};


