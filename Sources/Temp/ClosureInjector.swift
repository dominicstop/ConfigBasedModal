//
//  ClosureInjector.swift
//  ConfigBasedModalExample
//
//  Created by Dominic Go on 6/10/24.
//

import Foundation

public class ClosureInjector {
  public let closure: () -> Void;
  public let handle: String;

  public init(
    attachTo targetObject: AnyObject,
    closure: @escaping () -> Void
  ) {
    self.closure = closure;
    
    let handle = "\(ObjectIdentifier(targetObject))" + arc4random().description;
    self.handle = handle;
    
    objc_setAssociatedObject(
      /* object: */ targetObject,
      /* key   : */ handle,
      /* value : */ self,
      /* policy: */ .OBJC_ASSOCIATION_RETAIN
    );
  };

  @objc
  public func invoke() {
    self.closure();
  };
};



