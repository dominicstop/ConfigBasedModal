//
//  ModalPresentationStateMachine.swift
//  
//
//  Created by Dominic Go on 6/14/24.
//

import Foundation


public struct ModalPresentationStateMachine {

  // MARK: - Properties
  // ------------------
    
  public var prevState: ModalPresentationState?;
  public var currentState: ModalPresentationState = .initialState;
  
  public var onDismissWillCancel: (() -> Void)?;
  public var onDismissDidCancel: (() -> Void)?;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var didChange: Bool {
    self.prevState != self.currentState;
  };
  
  public var isInitialState: Bool {
    self.prevState == nil && self.currentState == .initialState;
  };
  
  public var didPresentationStateBecameKnown: Bool {
    let isPrevUnknown = self.prevState?.isPresentationTriggerUnknown ?? true;
    let isCurrentUnknown = self.currentState.isPresentationTriggerUnknown;
    
    return isPrevUnknown && !isCurrentUnknown;
  };
  
  public var didPresentationStateBecameUnknown: Bool {
    let isPrevUnknown = self.prevState?.isPresentationTriggerUnknown ?? true;
    let isCurrentUnknown = self.currentState.isPresentationTriggerUnknown;
    
    return !isPrevUnknown && isCurrentUnknown;
  };
  
  public var didChangeStateMemberName: Bool {
    self.prevState?.memberName == self.currentState.memberName;
  };
  
  public var willCancelDismissal: Bool {
       self.currentState.willCancelDismissal
    || self.prevState?.isDismissingViaGesture ?? false
    && self.currentState.isPresenting;
  };
  
  public var didCancelDismissal: Bool {
       self.currentState.didCancelDismissal
    || self.prevState?.isDismissViaGestureCancelling ?? false
    && self.prevState?.isPresenting ?? false
    && self.currentState.isPresented;
  };

  // MARK: - Computed Properties - Alias
  // -----------------------------------
  
  public var isDismissing: Bool {
    self.currentState.isDismissing;
  };
  
  public var isDismissed: Bool {
    self.currentState.isDismissed;
  };
  
  public var isPresenting: Bool {
    self.currentState.isPresenting;
  };
  
  public var isPresented: Bool {
    self.currentState.isPresented;
  };
  
  // MARK: - Init
  // ------------
  
  init(
    onDismissWillCancel: (() -> Void)? = nil,
    onDismissDidCancel: (() -> Void)? = nil
  ) {
    self.onDismissWillCancel = onDismissWillCancel;
    self.onDismissDidCancel = onDismissDidCancel;
  };
  
  init(
    prevState: ModalPresentationState? = nil,
    currentState: ModalPresentationState
  ) {
    self.prevState = prevState;
    self.currentState = currentState;
  };
  
  // MARK: - Functions
  // -----------------
  
  public mutating func set(state nextStateRaw: ModalPresentationState){
    let nextSM = ModalPresentationStateMachine(
      prevState: self.currentState,
      currentState: nextStateRaw
    );
    
    /// Do not over-write specific/"known state",
    /// with non-specific/"unknown state", e.g.:
    /// `.dismissing(trigger: .gesture)` -> `dismissed(trigger: .unknown)`
    ///
    let didStateBecameNonSpecific =
         !nextSM.didChangeStateMemberName
      && nextSM.didPresentationStateBecameUnknown;
      
    guard !didStateBecameNonSpecific,
          nextSM.didChange
    else { return };
    
    let nextState: ModalPresentationState = {
      if nextSM.willCancelDismissal {
        return .presenting(
          trigger: nextStateRaw.presentationTrigger,
          wasDismissCancelled: true
        );
        
      };
      
      if nextSM.didCancelDismissal {
        return .presented(
          trigger: nextStateRaw.presentationTrigger,
          wasDismissCancelled: true
        );
      };
      
      return nextStateRaw;
    }();
    
    self.prevState = nextSM.prevState;
    self.currentState = nextState;
    
    if self.willCancelDismissal {
      self.onDismissWillCancel?();
      
    } else if self.didCancelDismissal {
      self.onDismissDidCancel?();
    };
  };
};
