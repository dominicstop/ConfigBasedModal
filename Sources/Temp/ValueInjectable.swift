//
//  ValueInjectable.swift
//  
//
//  Created by Dominic Go on 6/14/24.
//

import Foundation


public protocol ValueInjectable: AnyObject {
  
  typealias InjectedValuesMap = Dictionary<String, Any?>;
  
  var injectedValues: InjectedValuesMap { get set };
};

