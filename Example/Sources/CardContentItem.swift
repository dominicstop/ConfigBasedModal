//
//  CardContentItem.swift
//  ConfigBasedModalExample
//
//  Created by Dominic Go on 6/9/24.
//

import UIKit


public enum CardContentItem {
  case button(
    title: AttributedStringConfig,
    subtitle: [AttributedStringConfig]?,
    icon: ImageConfigSystem?,
    onPressHandler: () -> Void
  );
  
  case label([AttributedStringConfig]);
  case multiLineLabel([AttributedStringConfig]);
  
  case spacer(space: CGFloat);
  
  // MARK: Functions
  // ---------------
  
  func makeContent(prevItem: UIView? = nil) -> UIView {
    switch self {
      case let .button(title, subtitle, icon, onPressHandler):
        let button = UIButton();
        
        
        return button;
        
      case let .label(configs):
        let label = UILabel();
        
        label.font = nil;
        label.textColor = nil;
        label.numberOfLines = 0
        label.attributedText = configs.makeAttributedString();
        
        label.attributedText = configs.makeAttributedString();
        return label;
        
      case let .multiLineLabel(configs):
      
        let label = UILabel();
        label.font = nil;
        label.textColor = nil;
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping;
        
        label.attributedText = configs.makeAttributedString();
        return label;
        
      case let .spacer(space):
        return UIView(frame: .init(
          origin: .zero,
          size: .init(width: 0, height: space)
        ));
    };
  };
};
