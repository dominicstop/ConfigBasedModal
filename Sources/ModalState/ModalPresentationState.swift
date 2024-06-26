//
//  ModalPresentationState.swift
//  
//
//  Created by Dominic Go on 6/14/24.
//

import Foundation


public enum ModalPresentationState: Equatable {
  
  public static let initialState: Self = .dismissed(trigger: .unknown);
  
  // MARK: - Enum Values
  // -------------------

  case dismissed(trigger: ModalPresentationTrigger = .unknown);
  case dismissing(trigger: ModalPresentationTrigger = .unknown);
  
  case presenting(
    trigger: ModalPresentationTrigger = .unknown,
    wasDismissCancelled: Bool = false
  );
  case presented(
    trigger: ModalPresentationTrigger = .unknown,
    wasDismissCancelled: Bool = false
  );
  
  // MARK: - Computed Properties - Public
  // ------------------------------------
  
  public var memberName: String {
    switch self {
      case .dismissed:
        return "dismissed";
        
      case .dismissing:
        return "dismissing";
        
      case .presenting:
        return "presenting";
        
      case .presented:
        return "presented";
    };
  };
  
  public var isDismissing: Bool {
    switch self {
      case .dismissing:
        return true;
        
      default:
        return false;
    };
  };
  
  public var isDismissed: Bool {
    switch self {
      case .dismissed:
        return true;
        
      default:
        return false;
    };
  };
  
  public var isDismissingKnown: Bool {
    switch self {
      case let .dismissing(trigger):
        return trigger != .unknown;
        
      default:
        return false;
    };
  };
  
  public var isDismissingViaGesture: Bool {
    switch self {
      case let .dismissing(trigger):
        return trigger == .gesture;
        
      default:
        return false;
    };
  };
  
  public var isDismissingProgrammatically: Bool {
    switch self {
      case let .dismissing(trigger):
        return trigger == .programmatic;
        
      default:
        return false;
    };
  };
  
  public var isPresenting: Bool {
    switch self {
      case .presenting:
        return true;
        
      default:
        return false;
    };
  };
  
  public var isPresented: Bool {
    switch self {
      case .presented:
        return true;
        
      default:
        return false;
    };
  };
  
  public var isPresentationTriggerUnknown: Bool {
    switch self {
      case let .presenting(trigger, _):
        return trigger == .unknown;
        
      case let .presented(trigger, _):
        return trigger == .unknown;
        
      case let .dismissing(trigger):
        return trigger == .unknown;
        
      case let .dismissed(trigger):
        return trigger == .unknown;
    };
  };
  
  public var isDismissViaGestureCancelling: Bool {
    switch self {
      case let .presenting(_, wasDismissCancelled):
        return wasDismissCancelled;
        
      default:
        return false;
    };
  };
  
  public var isDismissViaGestureCancelled: Bool {
    switch self {
      case let .presented(_, wasDismissCancelled):
        return wasDismissCancelled;
        
      default:
        return false;
    };
  };
  
  public var presentationTrigger: ModalPresentationTrigger {
    switch self {
      case let .dismissed(trigger):
        return trigger;
        
      case let .dismissing(trigger):
        return trigger;
        
      case let .presenting(trigger, _):
        return trigger;
        
      case let .presented(trigger, _):
        return trigger;
    };
  };
  
  public var willCancelDismissal: Bool {
    switch self {
      case let .presenting(_, wasDismissCancelled):
        return wasDismissCancelled;
        
      default:
        return false;
    }
  };
  
  public var didCancelDismissal: Bool {
    switch self {
      case let .presented(_, wasDismissCancelled):
        return wasDismissCancelled;
        
      default:
        return false;
    };
  };
  
  // MARK: - Computed Properties - Composite
  // ---------------------------------------
  
  public var isDismissedOrDismissing: Bool {
    self.isDismissed || self.isDismissing;
  };
  
  public var isPresentedOrPresenting: Bool {
    self.isPresented || self.isPresenting;
  };
};
