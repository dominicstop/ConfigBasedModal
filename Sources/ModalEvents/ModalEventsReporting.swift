//
//  ModalEventsReporting.swift
//  
//
//  Created by Dominic Go on 6/16/24.
//

import UIKit


public protocol ModalEventsReporting {
  
  var doesReportModalEvents: Bool { get };
  
  var modalGestureRecognizer: UIPanGestureRecognizer? { get };
  
  var modalPositionAnimator: CAAnimation? { get };
};

public extension ModalEventsReporting {
  
  var doesSupportModalGestures: Bool {
    self.modalGestureRecognizer != nil;
  };
};

