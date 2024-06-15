//
//  CardLabelValueDisplayConfig.swift
//  ConfigBasedModalExample
//
//  Created by Dominic Go on 6/15/24.
//

import UIKit
import ConfigBasedModal


public struct CardLabelValueDisplayConfig {
  
  public var items: [CardLabelValueDisplayItemConfig];
  public var colorThemeConfig: ColorThemeConfig;
  
  func createView() -> UIView {
    let rootVStack = {
      let stack = UIStackView();
      
      stack.axis = .vertical;
      stack.distribution = .fill;
      stack.alignment = .fill;
      
      stack.backgroundColor = self.colorThemeConfig.colorBgLight;
      
      stack.clipsToBounds = true;
      stack.layer.cornerRadius = 8;
      stack.layer.maskedCorners = .allCorners;
      
      stack.isLayoutMarginsRelativeArrangement = true;
      stack.layoutMargins = UIEdgeInsets(
        top: 8,
        left: 8,
        bottom: 8,
        right: 8
      );
                
      return stack;
    }();
    
    for itemConfig in self.items {
      let itemView =
        itemConfig.createView(colorThemeConfig: self.colorThemeConfig);
        
      rootVStack.addArrangedSubview(itemView);
    };
    
    return rootVStack;
  };
};
